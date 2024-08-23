import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:formtask/Controllers/local_submission_controller.dart';
import 'package:formtask/services/local_storage_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> checkConnectivityAndSync() async {
  final LocalSubmissionsController controller = Get.put(LocalSubmissionsController());

  Connectivity().onConnectivityChanged.listen((result) async {
    if (result != ConnectivityResult.none) {
      final prefs = await SharedPreferences.getInstance();
      final storedData = prefs.getStringList('storedData') ?? [];

      if (storedData.isNotEmpty) {
        for (var data in storedData) {
          await FirebaseFirestore.instance.collection('user_details').add(json.decode(data));
        }
        await prefs.setStringList('storedData', []);

        // Update sync status for local submissions
        final localSubmissions = await LocalStorageService().loadLocalSubmissions();
        for (var submission in localSubmissions) {
          submission.isSynced = true; // Mark as synced
        }
        await LocalStorageService().saveLocalSubmissions(localSubmissions);
        controller.refreshSubmissions();
      }
      
    }
  });
}
