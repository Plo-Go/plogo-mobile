import 'package:flutter/material.dart';

class UploadErrorToast extends StatelessWidget {
  final String message;
  const UploadErrorToast({
    Key? key,
    this.message = '업로드에 실패하였습니다.\n파일 확장자를 확인 후 다시 시도해 주세요.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}
