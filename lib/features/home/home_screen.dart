import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neura/core/common/api_constants.dart';
import 'package:neura/core/common/app_colors.dart';
import 'package:neura/core/common/app_images.dart';
import 'package:neura/core/network/dio_helper.dart';
import 'package:neura/features/auth/screens/showGenderAndDOBPopup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _diagnosisResult;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      await _uploadImage(File(image.path));
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _isLoading = true;
      _diagnosisResult = null;
    });

    try {
      final response = await DioHelper.uploadScan(
        url: '/scan/upload',
        file: imageFile,
        type: 'ct',
      );

      final data = response.data['data'];
      final result =
          'Label: ${data['label']}\nProbability: ${data['probability']}';
      setState(() {
        _diagnosisResult = result;
      });
    } catch (e) {
      setState(() {
        _diagnosisResult = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (isCameFromRegister) {
      Future.microtask(() {
        showGenderAndDOBPopup(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 140,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            AppImages.homeLogo,
            height: 32,
            width: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diagnosis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Upload or capture an X-ray image for diagnosis.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera, color: Colors.white),
                    label: const Text(
                      'Take photo',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.file_upload_outlined,
                        color: Colors.white),
                    label: const Text(
                      'Upload photo',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Diagnosis Result',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                      _diagnosisResult ??
                          'No Diagnosis Available. Please Upload Or Capture An X-Ray.',
                      style: const TextStyle(fontSize: 14),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
