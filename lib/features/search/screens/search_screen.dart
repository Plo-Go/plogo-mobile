import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import '../widgets/search_text_field.dart';
import '../widgets/search_recent_section.dart';
import '../widgets/search_results_section.dart';
import 'package:plogo/features/search/providers/search_provider.dart';
import 'package:plogo/features/search/services/search_service.dart';
import 'package:plogo/core/api/api_client.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(WidgetRef ref) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      final keyword = _searchController.text.trim();
      print('[디바운스 후 검색어] $keyword');
      ref.read(searchQueryProvider.notifier).state = keyword;
      if (keyword.isEmpty) {
        _focusNode.requestFocus();
      } else {
        ref.refresh(recentKeywordsProvider); // 검색 시 최근 검색어 강제 갱신
        ref.refresh(regionResultsProvider(keyword)); // 검색 시 시군구 리스트 강제 갱신
        ref.refresh(courseResultsProvider(keyword)); // 검색 시 코스 조회 강제 갱신
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final query = ref.watch(searchQueryProvider);
        return WillPopScope(
          onWillPop: () async {
            if (_searchController.text.isNotEmpty) {
              _searchController.clear();
              ref.read(searchQueryProvider.notifier).state = '';
              ref.refresh(recentKeywordsProvider);
              Future.delayed(const Duration(milliseconds: 100), () {
                _focusNode.requestFocus();
              });
              return false;
            }
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
                    onChanged: () => _onSearchChanged(ref),
                  ),
                  Expanded(
                    child: _searchController.text.isEmpty
                        ? SearchRecentSection(
                            key:
                                ValueKey(DateTime.now().millisecondsSinceEpoch),
                            focusNode: _focusNode,
                            searchController: _searchController,
                          )
                        : Builder(
                            builder: (context) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                final ref = ProviderScope.containerOf(context,
                                    listen: false);
                                ref.refresh(recentKeywordsProvider);
                              });
                              return SearchResultsSection(
                                  query: _searchController.text);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
