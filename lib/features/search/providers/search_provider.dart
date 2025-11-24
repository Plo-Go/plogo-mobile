import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plogo/features/search/services/search_service.dart';
import 'package:plogo/features/search/services/search_api_service.dart';
import 'package:plogo/features/mypage/services/mypage_service.dart';
import 'package:plogo/core/api/api_client.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final recentKeywordsProvider = FutureProvider<List<String>>((ref) async {
  return SearchService(apiClient.dio).getRecentKeywords();
});

final recentCoursesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return MyPageService(apiClient.dio).getRecentCourses();
});

final regionResultsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, query) async {
  if (query.isEmpty) return [];
  final regions = await SearchApiService(apiClient.dio).getSigunguList();
  return regions
      .where((r) => r['sigunguName']?.toString().contains(query) ?? false)
      .toList();
});

final courseResultsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, query) async {
  if (query.isEmpty) return [];
  return SearchApiService(apiClient.dio).searchCourses(query);
});
