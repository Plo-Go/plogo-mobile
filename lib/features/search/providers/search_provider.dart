import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plogo/features/search/services/search_service.dart';
import 'package:plogo/features/search/services/search_api_service.dart';
import 'package:plogo/features/mypage/services/mypage_service.dart';
import 'package:plogo/core/api/api_client.dart';
// 전체 지역 리스트 Provider (앱 시작/검색 화면 진입 시 1회 호출)
final allRegionsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return SearchApiService(apiClient.dio).getSigunguList();
});

// 전체 코스 리스트 Provider (areaCode가 0 또는 1일 때 1회 호출)
final allCoursesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  // areaCode 0: 전체
  return SearchApiService(apiClient.dio).getCoursesByArea(0);
});

// 프론트에서 지역명으로 필터링하는 Provider
final filteredRegionProvider = Provider.family<List<Map<String, dynamic>>, String>((ref, query) {
  final regions = ref.watch(allRegionsProvider).maybeWhen(data: (data) => data, orElse: () => []);
  if (query.isEmpty) return [];
  return regions.where((r) => r['sigunguName']?.toString().contains(query) ?? false).toList().cast<Map<String, dynamic>>();
});

// 프론트에서 코스명으로 필터링하는 Provider
final filteredCourseProvider = Provider.family<List<Map<String, dynamic>>, String>((ref, query) {
  final courses = ref.watch(allCoursesProvider).maybeWhen(data: (data) => data, orElse: () => []);
  if (query.isEmpty) return [];
  return courses.where((c) => c['name']?.toString().contains(query) ?? false).toList().cast<Map<String, dynamic>>();
});

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
