import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura/core/common/app_images.dart';
import '../controller/verification_controller.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final bool isResetPassword;

  const VerificationScreen({
    super.key,
    required this.email,
    required this.isResetPassword,
  });
  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(verificationControllerProvider.notifier);
    final state = ref.watch(verificationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset(AppImages.newPassword, height: 160),
              const SizedBox(height: 24),
              const Text(
                'Please check your email',
                style: TextStyle(
                  color: Color(0xFF6A5AE0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'We have sent a reset code to your email. Enter the 6-digit code mentioned in the email.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: 'Enter 6-digit code',
                  counterText: '',
                  filled: true,
                  fillColor: Color(0xFFF2F2FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              state.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        await controller.verifyCode(
                          isResetPassword: widget.isResetPassword,
                          email: widget.email,
                          context: context,
                          code: codeController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A5AE0),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Verification',
                          style: TextStyle(color: Colors.white)),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () =>
                    controller.resendCode(context, email: widget.email),
                child: const Text.rich(
                  TextSpan(
                    text: 'Haven’t got the email yet? ',
                    children: [
                      TextSpan(
                        text: 'Resend code',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
