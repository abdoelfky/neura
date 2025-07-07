import 'package:flutter/material.dart';
import 'package:neura/core/common/app_images.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hasRecords = false; // Replace with actual logic

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          if (hasRecords)
            TextButton(
              onPressed: () {},
              child: const Text('Clear all'),
            ),
        ],
      ),
      body: hasRecords
          ? ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('X-ray Record ${index + 1}',
                      style:
                      const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Date: 2023-10-10'),
                  const SizedBox(height: 4),
                  const Text(
                    'This record shows a detailed analysis of the chest X ray taken on the specified date.',
                  ),
                ],
              ),
            ),
          );
        },
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.notificationIcon, height: 180),
              const SizedBox(height: 24),
              const Text('No Notifications Yet',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              const Text(
                'Your notification will appear here once you\'ve received them.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
