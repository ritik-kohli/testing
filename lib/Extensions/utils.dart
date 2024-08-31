import 'package:flutter/material.dart';
import 'package:get/get.dart';

launchProgress() async {
  Get.dialog(const Center(
      child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
  )));
}

disposeProgress() {
  Get.back();
}