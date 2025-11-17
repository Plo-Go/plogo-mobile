import 'package:flutter/material.dart';
import 'package:plogo/features/detail/models/course_detail_model.dart';
import 'package:plogo/features/detail/services/course_detail_service.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;
  final String? title;
  const CourseDetailScreen({super.key, required this.courseId, this.title});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
    bool _showFullSummary = false;
    Widget _buildSummary(String summary) {
      const int maxLines = 5;
      final int lineCount = summary.split('\n').length;
      final bool isLong = lineCount > maxLines || summary.length > 120;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !_showFullSummary && isLong
            ? Text(
                summary,
                style: TextStyle(fontSize: 14, color: Colors.black),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                summary,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
        if (isLong)
          GestureDetector(
            onTap: () => setState(() => _showFullSummary = !_showFullSummary),
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                _showFullSummary ? '접기' : '더보기',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool isSave = false;
  CourseDetail? detail;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final response =
          await CourseDetailService().getCourseDetail(widget.courseId);
      setState(() {
        detail = response.data;
        isSave = response.data.isSave ?? false;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = '코스 상세 불러오기 실패';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.black),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(widget.title ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Icon(
            isSave ? Icons.bookmark : Icons.bookmark_border,
            color: AppColors.primary,
            size: 28,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : detail == null
                  ? const Center(child: Text('상세 정보가 없습니다.'))
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (detail!.image.isNotEmpty)
                                  Stack(
                                    children: [
                                      Image.network(
                                        detail!.image,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        right: 16,
                                        bottom: 16,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text('1/1',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12)),
                                        ),
                                      ),
                                    ],
                                  ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSummary(detail!.summary),
                                      SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_outlined,
                                              size: 15, color: AppColors.grey),
                                          SizedBox(width: 6),
                                          Expanded(
                                              child: Text(detail!.address,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColors.grey))),
                                        ],
                                      ),
                                      if (detail!.charge.isNotEmpty)
                                        Padding(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Row(
                                            children: [
                                              Icon(Icons.wallet_outlined,
                                                  size: 15,
                                                  color: AppColors.grey),
                                              SizedBox(width: 6),
                                              Expanded(
                                                  child: Text(detail!.charge,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .grey))),
                                            ],
                                          ),
                                        ),
                                      if (detail!.tel.isNotEmpty)
                                        Padding(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Row(
                                            children: [
                                              Icon(Icons.phone_outlined,
                                                  size: 15,
                                                  color: AppColors.grey),
                                              SizedBox(width: 6),
                                              Expanded(
                                                  child: Text(detail!.tel,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .grey))),
                                            ],
                                          ),
                                        ),
                                      if (detail!.homepage.isNotEmpty)
                                        Padding(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Row(
                                            children: [
                                              Icon(Icons.open_in_new,
                                                  size: 15,
                                                  color: AppColors.grey),
                                              SizedBox(width: 6),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    final url =
                                                        detail!.homepage;
                                                    if (await canLaunchUrl(
                                                        Uri.parse(url))) {
                                                      await launchUrl(
                                                          Uri.parse(url));
                                                    }
                                                  },
                                                  child: Text(
                                                    detail!.homepage,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColors.grey,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          color: AppColors.white,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text('완주하기',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white)),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
