import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  var currentPage = 0.obs;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  void changePage(int index) {
    currentPage.value = index;
  }
}

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminDashboardController());
    Get.lazyPut<AdminDashboardController>(() => AdminDashboardController());
  }
}
