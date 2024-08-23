import 'package:get/get.dart';
import 'package:formtask/models/submission.dart';
import 'package:formtask/services/local_storage_service.dart';

class LocalSubmissionsController extends GetxController {
  final LocalStorageService _localStorageService = LocalStorageService();
  var localSubmissions = <Submission>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocalSubmissions();
  }

  Future<void> _loadLocalSubmissions() async {
    final submissions = await _localStorageService.loadLocalSubmissions();
    localSubmissions.assignAll(submissions);
  }

  // Public method to refresh submissions
  Future<void> refreshSubmissions() async {
    await _loadLocalSubmissions();
  }
}
