import 'package:chat_app/pages/intro_pages/intro_page1.dart';
import 'package:chat_app/pages/intro_pages/intro_page2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'intro_pages/intro_page3.dart';

class OnBoardingScreens extends StatefulWidget {
  const OnBoardingScreens({super.key});

  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     if (FirebaseAuth.instance.currentUser != null) {
  //       Navigator.pushNamedAndRemoveUntil(context, '/tabbar', (route) => false);
  //     }
  //   });
  // }

  final PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              print(index);
              setState(() {
                (onLastPage = (index == 2));
              });
            },
            controller: _controller,
            children: [
              const IntroPage1(),
              const IntroPage2(),
              const IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                onLastPage
                    ? Container(
                        height: 55,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _controller.jumpToPage(2);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 25, top: 15),
                              child: Container(
                                height: 40,
                                width: 65,
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    "Skip",
                                    style: GoogleFonts.titilliumWeb(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 650,
                ),
                SmoothPageIndicator(
                  effect: const JumpingDotEffect(
                      activeDotColor: Colors.blue,
                      offset: 1.5,
                      dotHeight: 10,
                      dotColor: Colors.grey),
                  controller: _controller,
                  count: 3,
                ),
                const SizedBox(
                  height: 20,
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          print("Start");
                          Get.dialog(Center(
                              child: Lottie.asset(
                            'assets/animations/going.json',
                            height: 200,
                          )));
      
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          });
                          print("end");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                "GET STARTED",
                                style: GoogleFonts.titilliumWeb(
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeIn);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                "NEXT",
                                style: GoogleFonts.titilliumWeb(
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
