import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura/core/common/app_colors.dart';
import 'package:neura/core/common/background_screen.dart';
import 'package:neura/core/common/routes.dart';
import '../controller/signup_controller.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController userNameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController phoneNumberController;

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signupController = ref.watch(signupControllerProvider.notifier);
    final signupState = ref.watch(signupControllerProvider);

    return Scaffold(
      body: BackgroundScreen(
        child: Padding(
          padding: const EdgeInsets.only(top: 40,left:25 ,right: 25),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('Sign up', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          validator: (value) => value!.isEmpty ? 'Enter first name' : null,
                          decoration: const InputDecoration(hintText: 'First Name'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          validator: (value) => value!.isEmpty ? 'Enter last name' : null,
                          decoration: const InputDecoration(hintText: 'Last Name'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: userNameController,
                    validator: (value) => value!.isEmpty ? 'Enter user name' : null,
                    decoration: const InputDecoration(hintText: 'User Name'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    validator: (value) => value!.isEmpty ? 'Enter email' : null,
                    decoration: const InputDecoration(hintText: 'Email Address'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneNumberController,
                    validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: 'Phone Number'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    validator: (value) => value!.length < 6 ? 'Password must be 6+ characters' : null,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => showPassword = !showPassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !showConfirmPassword,
                    validator: (value) => value != passwordController.text ? 'Passwords do not match' : null,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => showConfirmPassword = !showConfirmPassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  signupState.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await signupController.register(
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          userName: userNameController.text.trim(),
                          email: emailController.text.trim(),
                          phoneNumber: phoneNumberController.text.trim(),
                          password: passwordController.text,
                          confirmPassword: confirmPasswordController.text,
                          context: context,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Sign up', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("Or Continue with"),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.g_mobiledata),
                          label: const Text('Google'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.apple),
                          label: const Text('Apple'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                    child: const Text("Already have an account? Log in"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
