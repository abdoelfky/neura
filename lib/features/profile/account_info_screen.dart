import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura/core/common/app_colors.dart';
import 'package:neura/features/auth/controller/user_update_GB_provider.dart';
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
  late TextEditingController birthDateController;
  String? selectedGender;
  String? originalGender;
  String? originalBirthDate;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    birthDateController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(profileControllerProvider);
      ref.watch(profileControllerProvider);
      ref.watch(accountInfoControllerProvider);
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formatted = "${picked.day}/${picked.month}/${picked.year}";
      // setState(() {
        birthDateController.text = formatted;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.read(profileControllerProvider);
    final updateState = ref.read(accountInfoControllerProvider);
    final userUpdate = ref.read(userUpdateProvider.notifier);

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
          firstNameController.text = profile.firstName;
          lastNameController.text = profile.lastName;
          emailController.text = profile.email;
          birthDateController.text =
              "${DateTime.parse(profile.birthDate).day}/${DateTime.parse(profile.birthDate).month}/${DateTime.parse(profile.birthDate).year}";
          originalGender = profile.gender;
          selectedGender ??= profile.gender;
          originalBirthDate = profile.birthDate;

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
                const SizedBox(height: 12),
                TextField(
                  controller: birthDateController,
                  readOnly: true,
                  onTap: () => _pickDate(context),
                  decoration: const InputDecoration(
                    labelText: 'Birth Date',
                    filled: true,
                    fillColor: Color(0xFFF2F2FF),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                const Text("Gender",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("Male"),
                        value: "male",
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() => selectedGender = value);
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("Female"),
                        value: "female",
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() => selectedGender = value);
                        },
                      ),
                    ),
                  ],
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

                            final userId = SharedPrefs.id;
                            final hasGenderChanged = selectedGender != null &&
                                selectedGender != originalGender;
                            final hasBirthDateChanged = birthDateController
                                    .text.isNotEmpty &&
                                birthDateController.text != originalBirthDate;

                            if (hasGenderChanged || hasBirthDateChanged) {
                              await userUpdate.updateGenderAndBirthDate(
                                userId: userId,
                                gender: selectedGender ?? '',
                                birthDate: birthDateController.text,
                              );
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Profile updated successfully')),
                            );

                            ref.refresh(profileControllerProvider);

                            final user = AuthModel(
                              id: SharedPrefs.id,
                              token: token,
                              userName: SharedPrefs.userName,
                              email: emailController.text.trim(),
                            );
                            await SharedPrefs.saveUser(user);
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
