import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import '../widgets/search_text_field.dart';
import '../widgets/recent_searches.dart';
import '../widgets/search_region_item.dart';
import '../widgets/search_course_item.dart';

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
    // TODO: 실제 최근 검색어 데이터 연동
    return RecentSearches(
      keywords: const ['국립공원', '남양주 공원', '인천', '인천'],
      onDelete: (keyword) {
        // TODO: 최근 검색어 삭제 로직
      },
    );
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
