import 'package:flutter/material.dart';
import 'package:neura/core/common/app_images.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> onboardingData = [
    OnboardingItem(
      imagePath: AppImages.onboarding1,
      title: 'Revolutionizing Healthcare with AI',
      description: 'Our AI-powered platform analyzes X-ray images with precision, enabling early detection of diseases for better patient outcomes.',
    ),
    OnboardingItem(
      imagePath: AppImages.onboarding2,
      title: 'Accurate and Fast Diagnoses',
      description: 'Leverage cutting-edge deep learning algorithms to get accurate diagnoses in seconds, saving time and improving care.',
    ),
    OnboardingItem(
      imagePath: AppImages.onboarding3,
      title: 'Empowering Patients and Doctors',
      description: 'Our app bridges the gap between technology and healthcare, providing tools for both patients and medical professionals.',
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(onboardingData[index].imagePath, height: 250),
                      const SizedBox(height: 20),
                      Text(
                        onboardingData[index].title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A5AE0),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        onboardingData[index].description,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(onboardingData.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? const Color(0xFF6A5AE0) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: _completeOnboarding,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5AE0),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Get Started',style: TextStyle(color: Colors.white),),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
class OnboardingItem {
  final String imagePath;
  final String title;
  final String description;

  OnboardingItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
