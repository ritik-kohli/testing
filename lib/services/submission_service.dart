import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/submission.dart';
import 'local_storage_service.dart';

class SubmissionService {
  final LocalStorageService _localStorageService = LocalStorageService();

  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> submitData(Submission submission) async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getStringList('storedData') ?? [];

    storedData.add(json.encode(submission.toJson()));
    await prefs.setStringList('storedData', storedData);

    if (await isConnected()) {
      print('connected');
      for (var data in storedData) {
        await FirebaseFirestore.instance.collection('user_details').add(json.decode(data));
      }
      // Clear local storage if sync is successful
      await prefs.setStringList('storedData', []);
      
      // Update the submission's isSynced status and save it again
      submission.isSynced = true;
      await _localStorageService.addSubmissionToLocalList(submission);
    }else{
      print('not contected');
      await _localStorageService.addSubmissionToLocalList(submission);
    }
  }
}
