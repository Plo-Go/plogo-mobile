class CourseDetailResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final CourseDetail data;

  CourseDetailResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CourseDetailResponse.fromJson(Map<String, dynamic> json) {
    return CourseDetailResponse(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: CourseDetail.fromJson(json['data'] ?? {}),
    );
  }
}

class CourseDetail {
  final int courseId;
  final String name;
  final String image;
  final String summary;
  final String address;
  final String tel;
  final String telName;
  final String charge;
  final String homepage;
  final bool isSave;
  final bool isComplete;

  CourseDetail({
    required this.courseId,
    required this.name,
    required this.image,
    required this.summary,
    required this.address,
    required this.tel,
    required this.telName,
    required this.charge,
    required this.homepage,
    required this.isSave,
    required this.isComplete,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      courseId: json['course_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      summary: json['summary'] ?? '',
      address: json['address'] ?? '',
      tel: json['tel'] ?? '',
      telName: json['telName'] ?? '',
      charge: json['charge'] ?? '',
      homepage: json['homepage'] ?? '',
      isSave: json['isSave'] ?? false,
      isComplete: json['isComplete'] ?? false,
    );
  }
}
