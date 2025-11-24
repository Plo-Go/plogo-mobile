import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onChanged;
  final ValueChanged<String>? onSubmitted;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 18),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                size: 28, color: AppColors.black),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                controller.clear();
                onChanged();
                focusNode.requestFocus();
              } else {
                context.pop();
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '코스를 검색해 보세요!',
                        hintStyle: TextStyle(
                          color: AppColors.grey,
                          fontSize: 16,
                        ),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      onChanged: (_) => onChanged(),
                      onSubmitted: onSubmitted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      onSubmitted?.call(controller.text);
                    },
                    child: Image.asset(
                      'assets/images/search.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.search,
                        color: AppColors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
