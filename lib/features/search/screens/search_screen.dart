import 'package:plogo/features/search/services/search_api_service.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import '../widgets/search_text_field.dart';
import '../widgets/recent_searches.dart';
import '../widgets/search_region_item.dart';
import '../widgets/search_course_item.dart';
import '../widgets/recent_viewed_courses_section.dart';
import 'package:plogo/core/api/api_client.dart';
import 'package:plogo/features/mypage/services/mypage_service.dart';
import '../widgets/popular_courses_section.dart';
import 'package:plogo/features/search/services/search_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _debounceTimer;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<List<Map<String, dynamic>>>? _recentCoursesFuture;
  Future<List<String>>? _recentKeywordsFuture;
  // 최근 검색어 삭제 함수
  Future<void> _deleteKeyword(String keyword) async {
    final service = SearchService(apiClient.dio);
    final success = await service.deleteKeyword(keyword);
    if (success) {
      setState(() {
        // 삭제 후 최근 검색어 목록 새로고침
        _recentKeywordsFuture = service.getRecentKeywords();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색어 삭제에 실패했습니다')),
      );
    }
  }
  Future<List<Map<String, dynamic>>>? _regionResultsFuture;
  Future<List<Map<String, dynamic>>>? _courseResultsFuture;

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 자동으로 키보드 포커스
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  _recentCoursesFuture = MyPageService(apiClient.dio).getRecentCourses();
  _recentKeywordsFuture = SearchService(apiClient.dio).getRecentKeywords();
  }

  @override
  void dispose() {
  _debounceTimer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 검색바
            SearchTextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: () => _onSearchChanged(_searchController.text),
            ),
            // 검색 결과 영역
            Expanded(
              child: _searchController.text.isEmpty
                  ? _buildRecentSearches()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      final query = value.trim();
      if (query.isEmpty) {
        setState(() {
          _regionResultsFuture = null;
          _courseResultsFuture = null;
        });
        return;
      }
      final api = SearchApiService(apiClient.dio);
      setState(() {
        _regionResultsFuture = api.getSigunguList().then((regions) =>
          regions.where((r) => r['sigunguName']?.toString().contains(query) ?? false).toList()
        );
        _courseResultsFuture = api.searchCourses(query);
      });
    });
  }

  Widget _buildRecentSearches() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 최근 검색어
          FutureBuilder<List<String>>(
            future: _recentKeywordsFuture,
            builder: (context, snapshot) {
              if (_recentKeywordsFuture == null || snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('최근 검색어 불러오기 실패', style: TextStyle(color: Colors.red)),
                );
              }
              final keywords = snapshot.data ?? [];
              return RecentSearches(
                keywords: keywords,
                onDelete: _deleteKeyword,
              );
            },
          ),

          const SizedBox(height: 32),

          // 최근 확인한 코스
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _recentCoursesFuture,
            builder: (context, snapshot) {
              if (_recentCoursesFuture == null || snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 128,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('최근 확인한 코스 불러오기 실패', style: TextStyle(color: Colors.red)),
                );
              }
              final items = snapshot.data ?? [];
              return RecentViewedCoursesSection(items: items);
            },
          ),

          const SizedBox(height: 32),

          const PopularCoursesSection(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCourseCard(String name, String location, String imagePath) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.greyLight,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.border,
                child: const Icon(
                  Icons.image,
                  size: 40,
                  color: AppColors.grey,
                ),
              ),
            ),
          ),
          // 하단 그라데이션
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // 북마크 아이콘
          const Positioned(
            top: 8,
            right: 8,
            child: Icon(
              Icons.bookmark_border,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCourseItem(int rank, String name, int? rightRank) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // 왼쪽 랭킹 + 이름
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // 오른쪽 랭킹 + 이름 (있는 경우)
          if (rightRank != null) ...[
            const SizedBox(width: 24),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Text(
                      '$rightRank',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _getPopularCourseName(rightRank),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getPopularCourseName(int rank) {
    const names = {
      6: '안양천 생태아이가든',
      7: '한려해상 국립공원',
      8: '경안천 습지생태공원',
      9: '목포시 특장자생식물원',
      10: '낙동강 하구명소',
    };
    return names[rank] ?? '';
  }

  Widget _buildSearchResults() {
    return ListView(
      padding: const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 20),
      children: [
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _regionResultsFuture,
          builder: (context, snapshot) {
            if (_regionResultsFuture == null) return const SizedBox();
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final regions = snapshot.data ?? [];
            if (regions.isEmpty) return const SizedBox();
            return Column(
              children: regions.map((region) => SearchRegionItem(
                query: _searchController.text,
                name: region['sigunguName'] ?? '',
                fullName: region['withArea'] ?? '',
              )).toList(),
            );
          },
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _courseResultsFuture,
          builder: (context, snapshot) {
            if (_courseResultsFuture == null) return const SizedBox();
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final courses = snapshot.data ?? [];
            if (courses.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    '검색 결과가 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: courses.map((course) => SearchCourseItem(
                query: _searchController.text,
                name: course['name'] ?? '',
                address: course['area'] ?? '',
                iconPath: course['image'] ?? 'assets/images/sample.png',
              )).toList(),
            );
          },
        ),
      ],
    );
  }
}
