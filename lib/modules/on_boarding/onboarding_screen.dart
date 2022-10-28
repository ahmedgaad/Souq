// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, dead_code, unused_element, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../login/shop_login_screen.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  List<BoardingModel> boarding = [
    BoardingModel(
        image: 'assets/images/onboard_2.png',
        title: 'On Boarding 1 Title',
        body: 'On Boarding 1 Body'),
    BoardingModel(
        image: 'assets/images/onboard_2.png',
        title: 'On Boarding 2 Title',
        body: 'On Boarding 2 Body'),
    BoardingModel(
        image: 'assets/images/onboard_2.png',
        title: 'On Boarding 3 Title',
        body: 'On Boarding 3 Body'),
  ];

  bool isLast = false;

  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      navigateAndFinish(context, ShopLoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding:  EdgeInsets.all(8.0.sp),
                    child: TextButton(
                        onPressed: submit,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 20.0.sp,
                          ),
                        )),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (int index) {
                      if (index == boarding.length - 1) {
                        setState(() {
                          isLast = true;
                        });
                      } else {
                        setState(() {
                          isLast = false;
                        });
                      }
                    },
                    controller: _pageController,
                    itemBuilder: (context, index) =>
                        buildBoardingItem(boarding[index]),
                    itemCount: boarding.length,
                  ),
                ),
                SizedBox(
                  height: 30.0.h,
                ),
                Padding(
                  padding:  EdgeInsets.all(15.0.sp),
                  child: Row(
                    children: [
                      SmoothPageIndicator(
                          controller: _pageController,
                          effect: ExpandingDotsEffect(
                            dotColor: Colors.grey,
                            activeDotColor: defaultColor,
                            dotHeight: 10.0.h,
                            dotWidth: 30.0.w,
                            expansionFactor: 2.0.sp,
                            spacing: 5.0.sp,
                          ),
                          count: boarding.length),
                      Spacer(),
                      FloatingActionButton(
                        onPressed: () {
                          if (isLast) {
                            submit();
                          }
                          _pageController.nextPage(
                            duration: Duration(
                              milliseconds: 750,
                            ),
                            curve: Curves.fastLinearToSlowEaseIn,
                          );
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
          image: AssetImage(model.image),
        ),
      ),
      SizedBox(
        height: 30.0.h,
      ),
      Text(
        model.title,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 20.0.h,
      ),
      Text(
        model.body,
        style: TextStyle(
          fontSize: 14.0.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 30.0.h,
      ),
    ],
  );
}
