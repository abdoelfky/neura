import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura/core/common/app_colors.dart';
import 'package:neura/core/common/app_images.dart';
import 'package:neura/core/common/routes.dart';
import 'package:neura/core/storage/shared_prefs.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
            buildMenuItem(
              icon: Icons.folder,
              title: 'Your Records',
              onTap: () => Navigator.pushNamed(context, AppRoutes.records),
            ),
            buildMenuItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
            buildMenuItem(
              icon: Icons.info,
              title: 'About app',
              onTap: () {},
            ),
            buildMenuItem(
              icon: Icons.notifications,
              title: 'Notification',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.notifications),
            ),
            Container(
              decoration: tileDecoration,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Icon(Icons.dark_mode, color: AppColors.primary),
                title: const Text('Dark',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Switch(
                  inactiveThumbColor: AppColors.primary,
                  value: false,
                  onChanged: (value) {},
                ),
                onTap: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}

final tileDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
);

Widget buildMenuItem(
    {required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap}) {
  return Container(
    decoration: tileDecoration,
    margin: const EdgeInsets.symmetric(vertical: 4), // spacing between tiles
    child: ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: trailing ?? const Icon(Icons.keyboard_arrow_right, size: 30),
      onTap: onTap,
    ),
  );
}
