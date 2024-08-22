// lib/services/submission_service.dart

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/submission.dart';
import 'local_storage_service.dart';

class SubmissionService {
  final LocalStorageService _localStorageService = LocalStorageService();

  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> submitData(Submission submission) async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getStringList('storedData') ?? [];

    storedData.add(json.encode(submission.toJson()));
    await prefs.setStringList('storedData', storedData);

    if (await isConnected()) {
      for (var data in storedData) {
        await FirebaseFirestore.instance.collection('user_details').add(json.decode(data));
      }
      await prefs.setStringList('storedData', []);
    }
  }
}
