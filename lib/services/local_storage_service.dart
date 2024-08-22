// lib/services/local_storage_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/submission.dart';

class LocalStorageService {
  Future<List<Submission>> loadLocalSubmissions() async {
    final prefs = await SharedPreferences.getInstance();
    final submissionsJson = prefs.getString('local_submissions');
    if (submissionsJson != null) {
      final List<dynamic> submissionsList = json.decode(submissionsJson);
      return submissionsList.map((json) => Submission.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveLocalSubmissions(List<Submission> submissions) async {
    final prefs = await SharedPreferences.getInstance();
    final submissionsJson = json.encode(submissions.map((submission) => submission.toJson()).toList());
    await prefs.setString('local_submissions', submissionsJson);
  }

  Future<void> addSubmissionToLocalList(Submission submission) async {
    final submissions = await loadLocalSubmissions();
    submissions.add(submission);
    await saveLocalSubmissions(submissions);
  }
}
