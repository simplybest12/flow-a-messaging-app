
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/model.dart';
import '../themes/dark_mode.dart';
import '../themes/light_mode.dart';

class GetController extends GetxController {
  RxBool isDarkMode = false.obs;
  RxBool isSearch = false.obs;
  RxList<ChatUser> dataList = <ChatUser>[].obs;
  RxMap<dynamic, dynamic> userData = {}.obs;

  ThemeData get theme => isDarkMode.value ? darkMode : lightMode;
  Rx<User?> currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);

  void setUser(User user) {
    currentUser.value = user;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
  void toggleSearch() {
    isSearch.value = !isSearch.value;
  }

  void addData(Map<String, dynamic> myData) {
    userData.assignAll(myData);

  }
}
