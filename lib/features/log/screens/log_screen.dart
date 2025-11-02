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

  final List<Marker> _markers = [
    Marker(
      markerId: 'plogging_course_1',
      latLng: LatLng(36.3, 127.8),
      infoWindowContent: '플로깅 코스 A',
    ),
  ];

  void _onMapCreated(KakaoMapController controller) async {
    mapController = controller;
    await controller.setLevel(12); // 줌 레벨 설정
    // 초기 중심/레벨 재적용하여 타일 렌더 강제 트리거
    await controller.setCenter(LatLng(36.3, 127.8));
    // 약간의 지연 후 마커 추가 (하드코딩된 확인용 마커)
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
              child: _mapLoadFailed
                  ? _buildFallbackMap()
                  : _buildKakaoMap(),
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
          // KakaoMap이 WebView 기반이라 컨테이너의 명확한 크기가 필요할 수 있음
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: KakaoMap(
              onMapCreated: _onMapCreated,
              center: LatLng(37.5665, 126.9780), // 중심 좌표 (서울시청)
              markers: _markers, // 여기서 항상 현재 상태의 마커 렌더링
              // 현재 시그니처: (markerId, LatLng, int)
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
