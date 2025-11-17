import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:plogo/shared/widgets/top_bar.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  KakaoMapController? mapController;
  bool _mapLoadFailed = false;
  bool _mapReady = false;
  String? _markerImageDataUri;

  static final LatLng _centerPosition = LatLng(36.5, 127.5);
  static final LatLng _markerPosition = LatLng(37.5665, 126.9780); // 서울

  List<Marker> get _markers {
    // 커스텀 이미지가 로드되면 적용, 아니면 기본 마커
    final marker = Marker(
      markerId: 'plogging_course_1',
      latLng: _markerPosition,
      infoWindowContent: '플로깅 코스 A',
      width: 24,
      height: 24,
    );

    // Base64 이미지가 준비되면 커스텀 이미지 적용
    if (_markerImageDataUri != null) {
      return [
        Marker(
          markerId: marker.markerId,
          latLng: marker.latLng,
          infoWindowContent: marker.infoWindowContent,
          markerImageSrc: _markerImageDataUri!,
          width: marker.width,
          height: marker.height,
        ),
      ];
    }

    return [marker]; // 기본 마커
  }

  @override
  void initState() {
    super.initState();
    _loadMarkerImage();
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
