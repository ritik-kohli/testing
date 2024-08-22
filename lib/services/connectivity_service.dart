// lib/services/connectivity_service.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> checkConnectivityAndSync() async {
  Connectivity().onConnectivityChanged.listen((result) async {
    if (result != ConnectivityResult.none) {
      final prefs = await SharedPreferences.getInstance();
      final storedData = prefs.getStringList('storedData') ?? [];

      if (storedData.isNotEmpty) {
        for (var data in storedData) {
          await FirebaseFirestore.instance.collection('user_details').add(json.decode(data));
        }
        await prefs.setStringList('storedData', []);
      }
    }
  });
}
