import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura/core/common/app_images.dart';
import 'package:neura/features/auth/controller/forgot_password_controller.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(forgetResetControllerProvider.notifier);
    final state = ref.watch(forgetResetControllerProvider);
    final email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), elevation: 0, backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset(AppImages.newPassword, height: 160),
            const SizedBox(height: 24),
            const Text('Create New Password',
                style: TextStyle(color: Color(0xFF6A5AE0), fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'This password should be different from the previous password',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'New password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Confirm password'),
            ),
            const SizedBox(height: 20),
            state.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                final newPass = newPasswordController.text.trim();
                final confirmPass = confirmPasswordController.text.trim();
                if (newPass.isEmpty || confirmPass.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields.')),
                  );
                  return;
                }
                await controller.resetPassword(
                  email: email,
                  newPassword: newPass,
                  confirmPassword: confirmPass,
                  context: context,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5AE0),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Reset Password', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
