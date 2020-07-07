import 'package:get/get.dart';

double calculateWidth(double percent) {
  return ((percent/100) * Get.width);
}

double calculateHeight(double percent) {
  return ((percent/100) * Get.height);
}

