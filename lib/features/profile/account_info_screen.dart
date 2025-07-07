import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura/core/common/app_colors.dart';
import 'package:neura/features/auth/data/auth_model.dart';
import 'package:neura/features/profile/controller/account_info_controller.dart';

import '../../core/storage/shared_prefs.dart';

class AccountInfoScreen extends ConsumerStatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  ConsumerState<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends ConsumerState<AccountInfoScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    // Refresh profile data every time screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(profileControllerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);
    final updateState = ref.watch(accountInfoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Account info',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: profileAsync.when(
        data: (profile) {
          // Init controllers with latest data
          firstNameController = TextEditingController(text: profile.firstName);
          lastNameController = TextEditingController(text: profile.lastName);
          emailController = TextEditingController(text: profile.email);

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First name',
                    filled: true,
                    fillColor: Color(0xFFF2F2FF),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last name',
                    filled: true,
                    fillColor: Color(0xFFF2F2FF),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Color(0xFFF2F2FF),
                    border: InputBorder.none,
                  ),
                ),
                const Spacer(),
                updateState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          final token = await SharedPrefs.userTokenAsync;
                          final controller =
                              ref.read(accountInfoControllerProvider.notifier);

                          try {
                            await controller.updateName(
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim(),
                              token: token,
                            );

                            // Update cache after successful save
                            await SharedPrefs.saveUser(AuthModel(
                              token: token,
                              userName:
                                  '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
                              email: emailController.text.trim(),
                            ));

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Profile updated successfully')),
                            );

                            // Refresh profile to get latest from server if needed
                            ref.refresh(profileControllerProvider);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Update failed: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Save',
                            style: TextStyle(color: Colors.white)),
                      ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
