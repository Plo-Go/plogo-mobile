import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursePostsSection extends StatelessWidget {
  final List<Map<String, dynamic>> coursePosts;
  const CoursePostsSection({super.key, required this.coursePosts});

  @override
  Widget build(BuildContext context) {
    if (coursePosts.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...coursePosts.map((post) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((post['blog_name'] ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    post['blog_name'],
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Row(
                children: [
                  Text(
                    post['post_date'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              GestureDetector(
                onTap: () async {
                  final url = post['link'] ?? '';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                },
                child: Text(
                  post['title'] ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 6),
              Text(
                post['summary'] ?? '',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Divider(thickness: 1, color: AppColors.grey.withOpacity(0.2)),
              ),
            ],
          ),
        )),
      ],
    );
  }
}