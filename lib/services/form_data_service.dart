// lib/services/form_data_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class FormDataService {
  Future<void> saveFormData({
    required String firstName,
    required String lastName,
    required String email,
    required String message,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', firstName);
    await prefs.setString('last_name', lastName);
    await prefs.setString('email', email);
    await prefs.setString('message', message);
  }

  Future<Map<String, String>> loadFormData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'first_name': prefs.getString('first_name') ?? '',
      'last_name': prefs.getString('last_name') ?? '',
      'email': prefs.getString('email') ?? '',
      'message': prefs.getString('message') ?? '',
    };
  }

  Future<void> clearFormData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('first_name');
    await prefs.remove('last_name');
    await prefs.remove('email');
    await prefs.remove('message');
  }
}
