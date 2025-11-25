import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import '../widgets/search_text_field.dart';
import '../widgets/search_recent_section.dart';
import '../widgets/search_results_section.dart';
import 'package:plogo/features/search/screens/search_course_list_screen.dart';
import 'package:plogo/features/search/providers/search_provider.dart';
import 'package:plogo/core/api/api_client.dart';
import 'package:plogo/features/auth/providers/auth_controller.dart';
import 'package:go_router/go_router.dart';

final isSearchConfirmedProvider = StateProvider<bool>((ref) => false);

class SearchScreen extends StatefulWidget {
  final String? initialKeyword;
  const SearchScreen({Key? key, this.initialKeyword}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: widget.initialKeyword ?? '');
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
        ref.refresh(recentKeywordsProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isLoggedIn = ref.watch(authProvider.select((s) => s.isLoggedIn));
        final query = ref.watch(searchQueryProvider);
        final isSearchConfirmed = ref.watch(isSearchConfirmedProvider);
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
                    onChanged: () {
                      _onSearchChanged(ref);
                      ref.read(isSearchConfirmedProvider.notifier).state =
                          false;
                    },
                    onSubmitted: (value) {
                      final keyword = value.trim();
                      ref.read(isSearchConfirmedProvider.notifier).state = true;
                      ref.refresh(regionResultsProvider(keyword));
                      ref.refresh(courseResultsProvider(keyword));
                    },
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
                              if (isSearchConfirmed) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => SearchCourseListScreen(
                                        keyword: _searchController.text,
                                      ),
                                    ),
                                  );
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  ref.invalidate(recentKeywordsProvider);
                                  ref
                                      .read(isSearchConfirmedProvider.notifier)
                                      .state = false;
                                });
                                return const SizedBox();
                              } else {
                                return SearchResultsSection(
                                  query: _searchController.text,
                                  isSearchConfirmed: false,
                                  onRegionTap: (regionName) {
                                    _searchController.text = regionName;
                                    ref
                                        .read(searchQueryProvider.notifier)
                                        .state = regionName;
                                    ref
                                        .read(
                                            isSearchConfirmedProvider.notifier)
                                        .state = true;
                                  },
                                );
                              }
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
