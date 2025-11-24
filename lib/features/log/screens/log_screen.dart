import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:plogo/shared/widgets/top_bar.dart';
import 'package:plogo/features/log/services/log_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plogo/features/log/services/geocoding_service.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final GeocodingService _geocodingService = GeocodingService();
  Map<int, LatLng> courseLatLngMap = {};
  KakaoMapController? mapController;
  bool _mapLoadFailed = false;
  bool _mapReady = false;
  String? _markerImageDataUri;

  LatLng _centerPosition = LatLng(36.5, 127.5);

  List<CompletedCourse> completedCourses = [];

  @override
  void initState() {
    super.initState();
  dotenv.load();
  _loadMarkerImage();
  _fetchCompletedCourses();
  }

  // 주소 파싱 강화: 전체 주소, 코스명, 시/도 중심까지 시도
  Future<LatLng?> _tryParseAddress(String address, String name) async {
    // 1. 전체 주소로 시도
    LatLng? latLng = await _geocodingService.getLatLngFromAddress(address);
    if (latLng != null) return latLng;

    // 2. 코스명으로 시도
    latLng = await _geocodingService.getLatLngFromAddress(name);
    if (latLng != null) return latLng;

    // 3. 주소에서 시/도만 추출해서 시도
    final regExp = RegExp(r'([가-힣]+도|서울특별시|부산광역시|대구광역시|인천광역시|광주광역시|대전광역시|울산광역시|세종특별자치시)');
    final match = regExp.firstMatch(address);
    if (match != null) {
      final region = match.group(0);
      if (region != null) {
        latLng = await _geocodingService.getLatLngFromAddress(region);
        if (latLng != null) return latLng;
      }
    }
    // 4. 그래도 안 되면 null 반환 (제주도 중심 좌표 사용 X)
    return null;
  }

  Future<void> _fetchCompletedCourses() async {
    final list = await LogService().getCompletedCourses();
    print('[완주 코스 리스트]');
    for (var course in list) {
      print('logId: \u001b[32m${course.logId}\u001b[0m, address: ${course.address}, name: ${course.name}');
    }
    // 각 코스 address를 좌표로 변환 (파싱 강화)
    for (var course in list) {
      LatLng? latLng = await _tryParseAddress(course.address, course.name);
      if (latLng != null) {
        courseLatLngMap[course.logId] = latLng;
        print('[지오코딩] logId: ${course.logId}, lat: ${latLng.latitude}, lng: ${latLng.longitude}');
      } else {
        print('[지오코딩 실패] logId: ${course.logId}, address: ${course.address}, name: ${course.name}');
        // 위치 미상 마커 등으로 처리 가능 (지도에 표시 X 또는 특수 마커)
      }
    }
    // 모든 마커 좌표가 세팅된 후, 중심 좌표 계산
    if (courseLatLngMap.isNotEmpty) {
      final latLngs = courseLatLngMap.values.toList();
      final avgLat = latLngs.map((e) => e.latitude).reduce((a, b) => a + b) / latLngs.length;
      final avgLng = latLngs.map((e) => e.longitude).reduce((a, b) => a + b) / latLngs.length;
      setState(() {
        _centerPosition = LatLng(avgLat, avgLng);
      });
      print('[지도 중심] lat: $avgLat, lng: $avgLng');
    }
    print('[마커 개수] ${courseLatLngMap.length}');
    if (mounted) setState(() => completedCourses = list);
  }

  List<Marker> get _markers {
    // 기존 완주 코스 마커들
    final markers = <Marker>[];
    for (var course in completedCourses) {
      final latLng = courseLatLngMap[course.logId] ?? _centerPosition;
      // 마커 생성 위치, 주소, 코스명 로그 출력
      debugPrint('[마커 생성] logId: ${course.logId}, name: ${course.name}, address: ${course.address}, lat: ${latLng.latitude}, lng: ${latLng.longitude}');
      markers.add(Marker(
        markerId: 'completed_${course.logId}',
        latLng: latLng,
        infoWindowContent: course.name,
        markerImageSrc: _markerImageDataUri ?? '',
        width: 28,
        height: 28,
      ));
    }
    return markers;
  }

  /// 마커 이미지 URL 설정
  Future<void> _loadMarkerImage() async {
    // kakao_map_plugin은 웹 URL만 지원 (Base64 data URI 불가)
    const markerUrl =
        'https://raw.githubusercontent.com/Plo-Go/plogo-mobile/develop/assets/icons/marker.png';

    setState(() {
      _markerImageDataUri = markerUrl;
    });

    debugPrint('커스텀 마커 URL 설정: $markerUrl');
  }

  void _onMapCreated(KakaoMapController controller) async {
    mapController = controller;
    await controller.setLevel(12);
    await controller.setCenter(_centerPosition);
    // 약간의 지연 후 상태 업데이트
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _mapReady = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TopBar(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _mapLoadFailed ? _buildFallbackMap() : _buildKakaoMap(),
            ),
          ],
        ),
      ),
    );
  }

  /// 카카오 지도 위젯
  Widget _buildKakaoMap() {
    try {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: KakaoMap(
              onMapCreated: _onMapCreated,
              center: _centerPosition,
              markers: _markers,
              onMarkerTap: (String markerId, LatLng latLng, int index) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        '마커 $markerId 클릭됨\n'
                        '(${latLng.latitude}, ${latLng.longitude})',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('카카오맵 예외 발생: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _mapLoadFailed = true);
      });
      return _buildFallbackMap();
    }
  }

  /// 지도 로딩 실패 시 대체 UI
  Widget _buildFallbackMap() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: const Center(
        child: Text(
          '카카오 맵 로딩 실패',
          style: TextStyle(color: Colors.grey, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
