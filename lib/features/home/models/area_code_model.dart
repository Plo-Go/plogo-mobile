class AreaCode {
  final int areaCode;
  final String areaName;

  AreaCode({required this.areaCode, required this.areaName});

  factory AreaCode.fromJson(Map<String, dynamic> json) {
    return AreaCode(
      areaCode: json['areaCode'] as int,
      areaName: json['areaName'] as String,
    );
  }
}
