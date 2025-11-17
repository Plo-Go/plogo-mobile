class CourseRecommendResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final List<CourseRecommendItem> data;

  CourseRecommendResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CourseRecommendResponse.fromJson(Map<String, dynamic> json) {
    return CourseRecommendResponse(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => CourseRecommendItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CourseRecommendItem {
  final int courseId;
  final String image;
  final String area;
  final String name;
  final bool isSave;

  CourseRecommendItem({
    required this.courseId,
    required this.image,
    required this.area,
    required this.name,
    required this.isSave,
  });

  factory CourseRecommendItem.fromJson(Map<String, dynamic> json) {
    return CourseRecommendItem(
      courseId: json['course_id'] ?? 0,
      image: json['image'] ?? '',
      area: json['area'] ?? '',
      name: json['name'] ?? '',
      isSave: json['isSave'] ?? false,
    );
  }
}
