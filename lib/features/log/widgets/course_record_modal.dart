import 'package:flutter/material.dart';
import 'package:plogo/features/log/services/log_service.dart';
import 'upload_error_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'dart:io';

class CourseRecordModal extends StatefulWidget {
  final CompletedCourse course;
  const CourseRecordModal({required this.course, Key? key}) : super(key: key);

  @override
  State<CourseRecordModal> createState() => _CourseRecordModalState();
}

class _CourseRecordModalState extends State<CourseRecordModal> {
  void _showUploadErrorToast(BuildContext context) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;
    final entry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: IgnorePointer(
          child: Container(
            alignment: Alignment.center,
            child: const UploadErrorToast(),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }
  final TextEditingController _recordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  List<String> _existingPhotoUrls = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogDetail();
  }

  Future<void> _fetchLogDetail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final logId = widget.course.logId;
      final response = await LogService().getLogDetail(logId);
      if (response != null && response['isSuccess'] == true) {
        final data = response['data'];
        _recordController.text = data['logContent'] ?? '';
        _existingPhotoUrls = List<String>.from(data['photos'] ?? []);
      }
    } catch (e) {}
    setState(() {
      _isLoading = false;
    });
  }

  
  Future<void> _updateLog() async {
    final logId = widget.course.logId;
    final logContent = _recordController.text;
    final existingUrls = _existingPhotoUrls;
    final newImages = _images;
    try {
      final response = await LogService().updateLog(logId, logContent, existingUrls, newImages);
      if (response == null || response['isSuccess'] != true) {
        _showUploadErrorToast(context);
        return;
      }
      Navigator.of(context).pop();
    } catch (e) {
      _showUploadErrorToast(context);
    }
  }

  Future<void> _pickImages() async {
    if (_images.length >= 3) return;
    final picked = await _picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      setState(() {
        final remain = 3 - _images.length;
        _images.addAll(picked.take(remain));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, 24, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.course.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Image.asset(
                            'assets/icons/modal_close.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _recordController,
                      decoration: const InputDecoration(
                        hintText: '나만의 기록을 남겨 보세요.',
                        hintStyle:
                            TextStyle(color: AppColors.grey, fontSize: 14),
                        filled: true,
                        fillColor: AppColors.greyLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(3, (index) {
                        if (index < _existingPhotoUrls.length) {
                          final url = _existingPhotoUrls[index];
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  url,
                                  width: 104,
                                  height: 104,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _existingPhotoUrls.removeAt(index);
                                    });
                                  },
                                  child: Image.asset(
                                    'assets/icons/image_delete.png',
                                    width: 12,
                                    height: 12,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        // 새로 추가한 사진 표시
                        else if (index - _existingPhotoUrls.length <
                            _images.length) {
                          final img =
                              _images[index - _existingPhotoUrls.length];
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(img.path),
                                  width: 104,
                                  height: 104,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _images.removeAt(
                                          index - _existingPhotoUrls.length);
                                    });
                                  },
                                  child: Image.asset(
                                    'assets/icons/image_delete.png',
                                    width: 12,
                                    height: 12,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        // 추가 버튼
                        else if (_existingPhotoUrls.length + _images.length <
                                3 &&
                            index ==
                                _existingPhotoUrls.length + _images.length) {
                          return GestureDetector(
                            onTap: _pickImages,
                            child: Container(
                              width: 104,
                              height: 104,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(
                                    color: AppColors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/icons/add.png',
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            width: 104,
                            height: 104,
                            color: Colors.transparent,
                          );
                        }
                      }),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _updateLog,
                        child: const Text('완료',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
    );
  }
}
