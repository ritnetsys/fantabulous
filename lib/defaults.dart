import 'package:get/get.dart';

bool isPotrait = Get.height > Get.width;

double calculateWidth(double percent) {
  if (isPotrait) {
    double actual = ((percent / 100) * 500);
    double req = (actual * 100) / Get.width;
    return (req / 100) * Get.width;
  } else {
    return (percent / 100) * Get.width;
  }
}

double calculateHeight(double percent) {
  double actual = ((percent / 100) * 900);
  double req = (actual * 100) / Get.height;
  return (req / 100) * Get.height;
}
