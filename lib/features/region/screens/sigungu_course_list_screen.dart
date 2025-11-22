import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/features/region/services/sigungu_course_service.dart';
import 'package:plogo/features/home/models/course_models.dart';
import 'package:plogo/shared/widgets/course_list_view.dart';
import 'package:plogo/features/detail/screens/course_detail_screen.dart';

class SigunguCourseListScreen extends StatefulWidget {
  final String regionName;
  final int sigunguId;
  const SigunguCourseListScreen({super.key, required this.regionName, required this.sigunguId});

  @override
  State<SigunguCourseListScreen> createState() => _SigunguCourseListScreenState();
}

class _SigunguCourseListScreenState extends State<SigunguCourseListScreen> {
  late Future<CourseRecommendResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = SigunguCourseService().getCoursesBySigungu(widget.sigunguId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.regionName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 4,
      ),
      body: FutureBuilder<CourseRecommendResponse>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('코스 불러오기 실패'));
          }
          final courses = snapshot.data?.data ?? [];
          if (courses.isEmpty) {
            return const Center(child: Text('해당 지역의 코스가 없습니다.'));
          }
          return CourseListView(
            title: widget.regionName,
            courses: courses,
            onCardTap: (courseId, name) async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(
                    courseId: courseId,
                    title: name,
                  ),
                ),
              );
              setState(() {
                _future = SigunguCourseService().getCoursesBySigungu(widget.sigunguId);
              });
            },
          );
        },
      ),
    );
  }
}
