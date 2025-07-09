import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura/core/common/app_colors.dart';
import 'package:neura/core/storage/shared_prefs.dart';
import 'package:neura/features/auth/controller/user_update_GB_provider.dart';

void showGenderAndDOBPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const GenderAndDOBDialog(),
  );
}

class GenderAndDOBDialog extends ConsumerStatefulWidget {
  const GenderAndDOBDialog({super.key});

  @override
  ConsumerState<GenderAndDOBDialog> createState() => _GenderAndDOBDialogState();
}

class _GenderAndDOBDialogState extends ConsumerState<GenderAndDOBDialog> {
  final PageController _controller = PageController();
  int currentPage = 0;
  String? selectedGender;
  DateTime selectedDate = DateTime(2000, 1, 1);
  final String userId = SharedPrefs.id;

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(userUpdateProvider);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 400,
        width: 300,
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => currentPage = index),
              children: [
                _buildGenderStep(),
                _buildDOBStep(updateState),
              ],
            ),
            if (updateState.isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _stepIndicator("1/2"),
          const SizedBox(height: 10),
          const Text("What's your gender?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _genderTile("Male"),
          const SizedBox(height: 16),
          _genderTile("Female"),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: selectedGender != null ? Colors.blue : Colors.grey,
              ),
              onPressed: selectedGender != null
                  ? () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDOBStep(AsyncValue<void> updateState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.all(8), child: _stepIndicator("2/2")),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("What's your date of birth?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Transform.scale(
            scale: 0.85,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              onDateTimeChanged: (date) {
                setState(() => selectedDate = date);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text("Back"),
                onPressed: () => _controller.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: updateState.isLoading
                    ? null
                    : () async {
                  final gender = selectedGender!.toLowerCase();
                  final birthDate = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";

                  await ref
                      .read(userUpdateProvider.notifier)
                      .updateGenderAndBirthDate(
                    userId: userId,
                    gender: gender,
                    birthDate: birthDate,
                  );

                  if (ref.read(userUpdateProvider).hasError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to save. Please try again.')),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepIndicator(String text) {
    return Align(
      alignment: Alignment.topRight,
      child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Widget _genderTile(String gender) {
    final isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(gender == "Male" ? Icons.person : Icons.woman, color: isSelected ? Colors.blue : Colors.grey, size: 35),
            const SizedBox(width: 8),
            Text(gender, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
