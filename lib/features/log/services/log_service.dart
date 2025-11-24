import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';

class CompletedCourse {
  // 빈 객체 반환용 생성자
  factory CompletedCourse.empty() => CompletedCourse(logId: -1, address: '', name: '');
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
}
