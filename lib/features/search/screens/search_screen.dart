import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import '../widgets/search_text_field.dart';
import '../widgets/recent_searches.dart';
import '../widgets/search_region_item.dart';
import '../widgets/search_course_item.dart';
import '../widgets/recent_viewed_courses_section.dart';
import '../widgets/popular_courses_section.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 자동으로 키보드 포커스
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
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
              onChanged: () => setState(() {}),
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

  Widget _buildRecentSearches() {
    // TODO: 실제 데이터 연동
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 최근 검색어
          RecentSearches(
            keywords: const ['국립공원', '남양주 공원', '인천', '인천'],
            onDelete: (keyword) {
              // TODO: 최근 검색어 삭제 로직
            },
          ),
          
          const SizedBox(height: 32),
          
          const RecentViewedCoursesSection(),
          
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
    final query = _searchController.text.toLowerCase();
    
    // 샘플 데이터
    final regions = [
      {'name': '문경', 'fullName': '경상북도 문경시'},
      {'name': '대전', 'fullName': '대전광역시'},
      {'name': '세종', 'fullName': '세종특별자치시'},
      {'name': '서울', 'fullName': '서울특별시'},
    ];
    
    final courses = [
      {'name': '문경새재 도립공원', 'address': '경상북도 문경시 문경읍 새재로 932'},
      {'name': '문경 용추계곡', 'address': '경상북도 문경시 가은읍 완장리'},
      {'name': '세종호수공원', 'address': '세종특별자치시 연기면'},
      {'name': '서울숲', 'address': '서울특별시 성동구 뚝섬로'},
    ];
    
    // 검색어로 필터링
    final filteredRegions = regions.where((r) => 
      r['name']!.toLowerCase().contains(query)
    ).toList();
    
    final filteredCourses = courses.where((c) => 
      c['name']!.toLowerCase().contains(query) || 
      c['address']!.toLowerCase().contains(query)
    ).toList();
    
    // 결과가 없을 때
    if (filteredRegions.isEmpty && filteredCourses.isEmpty) {
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
    
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // 지역 결과
        ...filteredRegions.map((region) => SearchRegionItem(
          query: _searchController.text,
          name: region['name']!,
          fullName: region['fullName']!,
        )),

        if (filteredCourses.isNotEmpty) const SizedBox(height: 20),
        
        // 코스 결과
        ...filteredCourses.map((course) => SearchCourseItem(
          query: _searchController.text,
          name: course['name']!,
          address: course['address']!,
          iconPath: 'assets/images/sample.png',
        )),
      ],
    );
  }
}
