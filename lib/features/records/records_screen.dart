import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:neura/core/common/api_constants.dart';
import 'package:neura/core/network/dio_helper.dart';
import 'package:neura/core/common/app_images.dart';
import 'package:neura/core/storage/shared_prefs.dart';

import '../../core/common/app_colors.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  List<dynamic> records = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await DioHelper.getData(
        url: ApiConstants.myScans,
        token: SharedPrefs.userToken,
      );
      records = response.data['data'];
    } catch (e) {
      error = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void exportPdf(String scanId) async {
    final url = 'http://127.0.0.1:5000/api/scan/export/$scanId';
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open PDF: $e')),
      );
    }
  }

  void deleteRecord(String scanId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await DioHelper.deleteData(
        url: '${ApiConstants.deleteScan}/$scanId',
        token: SharedPrefs.userToken,
      );
      setState(() {
        records.removeWhere((r) => r['_id'] == scanId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record deleted successfully')),
      );
      fetchRecords();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting record: $e')),
      );
    }
  }

  Widget buildRecordItem(Map<String, dynamic> record, int index) {
    final imageUrl = '${ApiConstants.baseUrl}/${record['image_path']}';
    final label = record['label'];
    final probability = record['probability'];
    final createdAt = record['createdAt'].split('T').first;
    final scanId = record['_id'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  AppImages.homeLogo,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                );
              },
            ),
            title: Text('Record ${index + 1} - $label',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: $createdAt'),
                Text('Probability: $probability'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => exportPdf(scanId),
                  icon: const Icon(
                    Icons.picture_as_pdf,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text('Export PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => deleteRecord(scanId),
                  icon: const Icon(
                    Icons.delete,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Records',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          if (records.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  records.clear();
                });
              },
              child: const Text('Clear all'),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : records.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AppImages.emptyRecords, height: 180),
                            const SizedBox(height: 24),
                            const Text('No Records Found',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 8),
                            const Text(
                              'Try to add a new data to see it here',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchRecords,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: records.length,
                        itemBuilder: (context, index) =>
                            buildRecordItem(records[index], index),
                      ),
                    ),
    );
  }
}
