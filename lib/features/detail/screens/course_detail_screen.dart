import 'package:flutter/material.dart';
import 'package:plogo/features/detail/models/course_detail_model.dart';
import 'package:plogo/features/detail/services/course_detail_service.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/features/detail/widgets/course_posts_section.dart';
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
  List<Map<String, dynamic>> coursePosts = [];

  Future<void> _fetchCoursePosts() async {
    try {
      final response =
          await CourseDetailService().getCoursePosts(widget.courseId);
      if (response != null &&
          response['isSuccess'] == true &&
          response['data'] is List) {
        setState(() {
          coursePosts = List<Map<String, dynamic>>.from(response['data']);
        });
      } else {
        setState(() {
          coursePosts = [];
        });
      }
    } catch (e) {
      setState(() {
        coursePosts = [];
      });
    }
  }

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
    _fetchCoursePosts();
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(68),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.black),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                context.pop();
              } else {
                // 하단바 경로로 이동
                context.go('/home'); // 수정 가능
              }
            },
          ),
          // 제목
          title: Text(widget.title ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: IconButton(
                icon: Icon(
                  isSave ? Icons.bookmark : Icons.bookmark_border,
                  color: AppColors.primary,
                  size: 28,
                ),
                onPressed: () async {
                  final response = await CourseDetailService()
                      .toggleSaveCourse(widget.courseId);
                  if (response != null &&
                      response['isSuccess'] == true &&
                      response['data'] != null) {
                    setState(() {
                      isSave = response['data']['isSave'] ?? false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
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
                                Stack(
                                  children: [
                                    detail!.image.isNotEmpty
                                        ? Image.network(
                                            detail!.image,
                                            width: double.infinity,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/no_image.png',
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
                                          color: Colors.black.withOpacity(0.5),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 20,
                                          bottom: 24,
                                          left: 24,
                                          right: 24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildSummary(detail!.summary),
                                          SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/icons/detail_location.png',
                                                width: 15,
                                                height: 15,
                                                color: AppColors.grey,
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  detail!.address.isNotEmpty
                                                      ? detail!.address
                                                      : '-',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColors.grey),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/icons/detail_price.png',
                                                  width: 14,
                                                  height: 14,
                                                  color: AppColors.grey,
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    detail!.charge.isNotEmpty
                                                        ? detail!.charge
                                                        : '-',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColors.grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/icons/detail_time.png',
                                                  width: 14,
                                                  height: 14,
                                                  color: AppColors.grey,
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    '-',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColors.grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/icons/detail_contact.png',
                                                  width: 18,
                                                  height: 18,
                                                  color: AppColors.black,
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    detail!.tel.isNotEmpty
                                                        ? detail!.tel
                                                        : '-',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColors.grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/icons/detail_homepage.png',
                                                  width: 14,
                                                  height: 12,
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      final url =
                                                          detail!.homepage;
                                                      if (url.isNotEmpty &&
                                                          await canLaunchUrl(
                                                              Uri.parse(url))) {
                                                        await launchUrl(
                                                            Uri.parse(url));
                                                      }
                                                    },
                                                    child: Text(
                                                      detail!.homepage
                                                              .isNotEmpty
                                                          ? detail!.homepage
                                                          : '-',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColors.grey,
                                                      ),
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
                                    // 구분선 (양옆 여백 없이 Container)
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 8,
                                      color: AppColors.greyLight,
                                    ),
                                    // 관련 포스팅 영역
                                    CoursePostsSection(
                                        coursePosts: coursePosts,
                                        courseName: detail?.name ?? ''),
                                  ],
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
