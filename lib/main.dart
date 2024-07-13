import 'package:chat_app/Get/controller.dart';
import 'package:chat_app/auth/listener.dart';
import 'package:chat_app/components/mytabbar.dart';
import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/account.dart';
import 'package:chat_app/pages/helppage.dart';
import 'package:chat_app/pages/onboarding.dart';
import 'package:chat_app/pages/profile_image.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/settings.dart';
import 'package:chat_app/pages/signup_page.dart';
import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'pages/homepage.dart';
import 'pages/login_page.dart';
import 'theme_pages/theme_change.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GetController controller = Get.put(GetController());
    return Obx(() => GetMaterialApp(
          title: 'Flutter Demo',
          theme: controller.isDarkMode != true ?lightMode:darkMode,
          initialRoute: '/auth',
          routes: {
            '/': (context) => OnBoardingScreens(),
            '/home': (context) => HomePage(),
            '/login': (context) => LoginPage(),
            '/signup': (context) => SignupPage(),
            '/imageprofile': (context) => ImageUsername(),
            '/tabbar': (context) => MyTabBar(),
            '/theme': (context) => Themes(),
            '/profile':(context)=>ProfilePage(),
            '/account':(context)=>AccountPage(),
            '/auth':(context)=>Auth(),
            '/help':(context)=>HelpPage(),
            // '/settings':(context)=> Settings(user: UserData(),)
          },
        ));
  }
}
