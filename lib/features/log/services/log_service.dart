import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';

class CompletedCourse {
  // 빈 객체 반환용 생성자
  factory CompletedCourse.empty() =>
      CompletedCourse(logId: -1, address: '', name: '');
  final int logId;
  final String address;
  final String name;

  CompletedCourse({
    required this.logId,
    required this.address,
    required this.name,
  });

  factory CompletedCourse.fromJson(Map<String, dynamic> json) {
    return CompletedCourse(
      logId: json['logId'] ?? 0,
      address: json['address'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class LogService {
  final Dio _dio = apiClient.dio;

  // 완주한 코스 리스트 조회
  Future<List<CompletedCourse>> getCompletedCourses() async {
    try {
      final response = await _dio.get('/log/completedList');
      if (response.data['isSuccess'] == true && response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((e) => CompletedCourse.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 로그 기록 조회
  Future<Map<String, dynamic>?> getLogDetail(int logId) async {
    try {
      print('[LogService] getLogDetail 요청: logId=$logId');
      final response = await _dio.get('/log/detail/$logId');
      print('[LogService] getLogDetail 응답: ${response.data}');
      return response.data;
    } catch (e) {
      print('[LogService] getLogDetail 에러: $e');
      return null;
    }
  }

  // 로그 기록/사진 업데이트
  Future<Map<String, dynamic>?> updateLog(
    int logId,
    String logContent,
    List<String> existingUrls,
    List<dynamic> newImages, // XFile or File
  ) async {
    try {
      print(
          '[LogService] updateLog 요청: logId=$logId, logContent=$logContent, existingUrls=$existingUrls, newImages=${newImages.length}');
      final formData = FormData();
      formData.fields
        ..add(MapEntry('logContent', logContent))
        ..addAll(existingUrls.map((url) => MapEntry('existingUrls', url)));
      for (var img in newImages) {
        formData.files.add(
          MapEntry(
            'newImages',
            await MultipartFile.fromFile(img.path,
                filename: img.path.split('/').last),
          ),
        );
      }
      final response = await _dio.patch(
        '/log/update/$logId',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      print('[LogService] updateLog 응답: ${response.data}');
      return response.data;
    } catch (e) {
      print('[LogService] updateLog 에러: $e');
      return null;
    }
  }
}
