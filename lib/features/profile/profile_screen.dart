import 'package:flutter/material.dart';
import 'package:neura/core/common/app_colors.dart';
import 'package:neura/core/common/app_images.dart';
import 'package:neura/core/common/routes.dart';
import 'package:neura/core/storage/shared_prefs.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(AppImages.profile),
            ),
            const SizedBox(height: 12),
            Text(
              SharedPrefs.userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              SharedPrefs.userEmail,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.folder, color: AppColors.primary),
              title: const Text('Your Records'),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings, color: AppColors.primary),
              title: const Text('Settings'),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: AppColors.primary),
              title: const Text('About app'),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: AppColors.primary),
              title: const Text('Notification'),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.notifications);

              },
            ),
            ListTile(
              leading: Icon(Icons.dark_mode, color: AppColors.primary),
              title: const Text('Dark'),
              trailing: Switch(
                inactiveThumbColor: AppColors.primary,
                value: false,
                onChanged: (value) {},
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
