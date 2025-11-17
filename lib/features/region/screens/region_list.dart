import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/shared/widgets/app_bottom_nav_bar.dart';
import 'package:plogo/features/region/services/area_course_service.dart';
import 'package:plogo/features/home/models/course_models.dart';

class RegionListScreen extends StatefulWidget {
	final String regionName;
	final int areaCode;

	const RegionListScreen({
		super.key,
		required this.regionName,
		required this.areaCode,
	});

	@override
	State<RegionListScreen> createState() => _RegionListScreenState();
}

class _RegionListScreenState extends State<RegionListScreen> {
	int _navIndex = 1; // 로그 탭 기본 선택

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: AppColors.white,
			appBar: AppBar(
				leading: IconButton(
					icon: const Icon(Icons.arrow_back_ios_new, size: 28),
					onPressed: () => Navigator.of(context).pop(),
				),
				title: Text(widget.regionName, style: const TextStyle(fontWeight: FontWeight.bold)),
				centerTitle: false,
				backgroundColor: AppColors.white,
				elevation: 0,
                scrolledUnderElevation: 0,
			),
			body: FutureBuilder<CourseRecommendResponse>(
				future: AreaCourseService().getCoursesByArea(widget.areaCode),
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
					return ListView.separated(
						padding: const EdgeInsets.symmetric(vertical: 8),
						itemCount: courses.length,
						separatorBuilder: (_, __) => Column(
							children: [
								const SizedBox(height: 20),
								Container(
									width: double.infinity,
									height: 8,
									color: AppColors.greyLight,
								),
							],
						),
						itemBuilder: (context, i) {
							final course = courses[i];
							return Padding(
								padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Row(
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												Expanded(
													child: Column(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
                                                            const SizedBox(height: 18),
															Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
															const SizedBox(height: 4),
															Text(course.area, style: const TextStyle(fontSize: 12, color: AppColors.grey)),
														],
													),
												),
												Icon(
													course.isSave ? Icons.bookmark : Icons.bookmark_border,
													color: AppColors.primary,
												),
											],
										),
										const SizedBox(height: 20),
										ClipRRect(
											borderRadius: BorderRadius.circular(12),
											child: course.image.isNotEmpty
												? Image.network(
													course.image,
													height: 160,
													width: double.infinity,
													fit: BoxFit.cover,
												)
												: Container(
													height: 120,
													color: AppColors.greyLight,
													child: const Center(child: Icon(Icons.image, color: AppColors.grey, size: 40)),
												),
										),
									],
								),
							);
						},
					);
				},
			),
		);
	}
}