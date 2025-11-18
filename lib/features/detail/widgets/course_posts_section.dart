import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursePostsSection extends StatelessWidget {
  final List<Map<String, dynamic>> coursePosts;
  final String courseName;
  const CoursePostsSection({super.key, required this.coursePosts, required this.courseName});

  @override
  Widget build(BuildContext context) {
    if (coursePosts.isEmpty) return SizedBox.shrink();

    String formatDate(String? date) {
      if (date == null || date.isEmpty) return '';
      final cleaned = date.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleaned.length >= 8) {
        final y = cleaned.substring(0, 4);
        final m = cleaned.substring(4, 6);
        final d = cleaned.substring(6, 8);
        return '$y.$m.$d';
      }
      return date;
    }

    Widget buildTitle(String title) {
      if (courseName.isNotEmpty && title.contains(courseName)) {
        final parts = title.split(courseName);
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(text: parts[0], style: TextStyle(fontSize: 15, color: AppColors.black, fontWeight: FontWeight.bold)),
              TextSpan(text: courseName, style: TextStyle(fontSize: 15, color: AppColors.primary, fontWeight: FontWeight.bold)),
              if (parts.length > 1)
                TextSpan(text: parts[1], style: TextStyle(fontSize: 15, color: AppColors.black, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      } else {
        return Text(
          title,
          style: TextStyle(fontSize: 15, color: AppColors.primary, fontWeight: FontWeight.bold),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 24.0, right: 24.0),
          child: Text(
            '관련 포스팅',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        ...coursePosts.map((post) {
          return Container(
            margin: const EdgeInsets.only(bottom: 0),
            padding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        post['blog_name'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(' | ', style: TextStyle(fontSize: 12, color: AppColors.grey)),
                    Text(
                      formatDate(post['post_date']),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final url = post['link'] ?? '';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    }
                  },
                  child: buildTitle(post['title'] ?? ''),
                ),
                SizedBox(height: 8),
                Text(
                  post['summary'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Divider(thickness: 1, color: AppColors.greyLight),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}