import 'package:flutter/material.dart';
import 'package:neura/core/common/app_images.dart';

import '../../core/common/app_colors.dart';
import 'chatBotWebView.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 80.0, left: 15.0, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the AI Medical Assistant!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A5AE0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Hi! I'm here to help with general medical questions.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 32),
            Image.asset(AppImages.chatbotAi, height: 180),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatWebViewScreen()),
                );
              },              icon: const Icon(
                Icons.wechat_sharp,
                size: 25,
                color: Colors.white,
              ),
              label: const Text('Start Chat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5AE0),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text.rich(
              TextSpan(
                text: 'Note: ',
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text:
                        'I provide general information, not medical advice. Always consult a doctor for proper diagnosis and treatment.',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
