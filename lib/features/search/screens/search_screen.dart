import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import '../widgets/search_text_field.dart';
import '../widgets/recent_searches.dart';
import '../widgets/search_region_item.dart';
import '../widgets/search_course_item.dart';
import '../widgets/recent_viewed_courses_section.dart';
import '../widgets/popular_courses_section.dart';
import 'package:plogo/core/api/api_client.dart';
import 'package:plogo/features/mypage/services/mypage_service.dart';
import 'package:plogo/features/search/services/search_service.dart';
import 'package:plogo/features/search/services/search_api_service.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _debounceTimer;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<List<Map<String, dynamic>>>? _recentCoursesFuture;
  Future<List<String>>? _recentKeywordsFuture;
  Future<List<Map<String, dynamic>>>? _regionResultsFuture;
  Future<List<Map<String, dynamic>>>? _courseResultsFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _recentCoursesFuture = MyPageService(apiClient.dio).getRecentCourses();
    _recentKeywordsFuture = SearchService(apiClient.dio).getRecentKeywords();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 검색화면이 다시 보일 때마다 최근 코스 Future 갱신
    _recentCoursesFuture = MyPageService(apiClient.dio).getRecentCourses();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _deleteKeyword(String keyword) async {
    final service = SearchService(apiClient.dio);
    final success = await service.deleteKeyword(keyword);
    if (success) {
      setState(() {
        _recentKeywordsFuture = service.getRecentKeywords();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('검색어 삭제에 실패했습니다')),
      );
    }
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      final query = value.trim();
      if (query.isEmpty) {
        setState(() {
          _regionResultsFuture = null;
          _courseResultsFuture = null;
          _recentKeywordsFuture = SearchService(apiClient.dio).getRecentKeywords();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('뒤로가기 호출됨, 검색어: \'${_searchController.text}\'');
        if (_searchController.text.isNotEmpty) {
          setState(() {
            _searchController.clear();
            _regionResultsFuture = null;
            _courseResultsFuture = null;
            _recentKeywordsFuture = SearchService(apiClient.dio).getRecentKeywords();
          });
          Future.delayed(const Duration(milliseconds: 100), () {
            _focusNode.requestFocus();
          });
          return false;
        }
        print('pop 허용');
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              SearchTextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: () => _onSearchChanged(_searchController.text),
              ),
              Expanded(
                child: _searchController.text.isEmpty
                    ? _buildRecentSearches()
                    : _buildSearchResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<String>>(
            future: _recentKeywordsFuture,
            builder: (context, snapshot) {
              if (_recentKeywordsFuture == null || snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('최근 검색어 불러오기 실패', style: TextStyle(color: Colors.red)),
                );
              }
              final keywords = snapshot.data ?? [];
              return RecentSearches(
                keywords: keywords,
                onDelete: _deleteKeyword,
                onTap: (keyword) {
                  _searchController.text = keyword;
                  _onSearchChanged(keyword);
                  _focusNode.unfocus();
                },
              );
            },
          ),
          const SizedBox(height: 32),
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
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('최근 확인한 코스 불러오기 실패', style: TextStyle(color: Colors.red)),
                );
              }
              final items = snapshot.data ?? <Map<String, dynamic>>[];
              return RecentViewedCoursesSection(
                items: items,
                onCardTap: (courseId, name) async {
                  await context.push('/home/detail/$courseId', extra: name);
                  setState(() {
                    _recentCoursesFuture = MyPageService(apiClient.dio).getRecentCourses();
                  });
                },
              );
            },
          ),
          const SizedBox(height: 32),
          const PopularCoursesSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView(
      padding: const EdgeInsets.only(top: 0, bottom: 12, left: 12, right: 12),
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
                    style: const TextStyle(
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
