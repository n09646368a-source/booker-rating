import 'package:booker/screen/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController controller = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      // نستخدم onPageChanged بدل controller.page لتفادي الاكسبشن
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (currentPage == 0) //  زر Skip يظهر فقط بالصفحة الأولى
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                onTap: () {
                  controller.animateToPage(
                    2, // ينتقل مباشرة لآخر صفحة
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.ease,
                  );
                },
                child: Container(
                  width: 57,
                  height: 32,
                  decoration: BoxDecoration(
                    color:  Color.fromRGBO(127, 86, 217, 1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color:   Color.fromRGBO(127, 86, 217, 1),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            currentPage = index; //  نخزن رقم الصفحة الحالية
          });
        },
     children: [
          Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 231,
                    height: 298,
                    margin: EdgeInsets.only(left: 72, right: 72, top: 24),
                    child: Image.asset('assets/on_boarding_1.png'),
                  ),
                  Container(
                    width: 259,
                    height: 64,
                    margin: EdgeInsets.only(top: 52, left: 14, right: 14),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Find the",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                              color: Color.fromRGBO(31, 42, 55, 1),
                            ),
                          ),
                          TextSpan(text: " "),
                          TextSpan(
                            text: "perfect place",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              color: Color.fromRGBO(31, 42, 55, 1),
                            ),
                          ),
                          TextSpan(text: "    "),
                          TextSpan(
                            text: " for your future house",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                              color: Color.fromRGBO(31, 42, 55, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 259,
                    height: 36,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "find the best place for your dream house with\n",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(157, 164, 174, 1),
                            ),
                          ),
                          TextSpan(text: "             "),
                          TextSpan(
                            text: "your family and loved ones",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(157, 164, 174, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      dotColor: Colors.grey,
                      activeDotColor: const Color.fromRGBO(127, 86, 217, 1),
                    ),
                    onDotClicked: (index) {},
                  ),
                  SizedBox(height: 54),
                  InkWell(
                    onTap: () {
                      controller.animateToPage(
                        1,
                        duration: Duration(seconds: 1),
                        curve: Curves.linear,
                      );
                    },
                    child: Container(
                      width: 327,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromRGBO(127, 86, 217, 1),
                      ),
                      child: Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                            color: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 231,
                    height: 298,
                    margin: EdgeInsets.only(left: 72, right: 72, top: 24),
                    child: Image.asset('assets/on_boarding_2.png'),
                  ),
                  Container(
                    width: 259,
                    height: 64,
                    margin: EdgeInsets.only(top: 52, left: 14, right: 14),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Fast sell your property\n",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                              color: Color.fromRGBO(31, 42, 55, 1),
                            ),
                          ),
                          TextSpan(text: "             "),
                          TextSpan(
                            text: "in just",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                              color: Color.fromRGBO(31, 42, 55, 1),
                            ),
                          ),
                          TextSpan(text: " "),
                          TextSpan(
                            text: "one click",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              color: Color.fromRGBO(31, 42, 55, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 259,
                    height: 36,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "Simplify the property sales process with just \n",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(157, 164, 174, 1),
                            ),
                          ),
                          TextSpan(text: "                        "),
                          TextSpan(
                            text: "your smartphone",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(157, 164, 174, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      dotColor: Colors.grey,
                      activeDotColor: const Color.fromRGBO(127, 86, 217, 1),
                    ),
                    onDotClicked: (index) {},
                  ),
                  SizedBox(height: 54),
                  InkWell(
                    onTap: () {
                     
                      controller.animateToPage(
                        2,
                        duration: Duration(seconds: 1),
                        curve: Curves.linear,
                      );
                    },
                    child: Container(
                      width: 327,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromRGBO(127, 86, 217, 1),
                      ),
                      child: Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                            color: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 231,
                    height: 298,
                    margin: EdgeInsets.only(left: 72, right: 72, top: 24),
                    child: Image.asset('assets/on_boarding_3.png'),
                  ),
                  Container(
                    width: 259,
                    height: 64,
                    margin: EdgeInsets.only(top: 52, left: 14, right: 14),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "find your",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                              color: Color.fromRGBO(31, 42, 55, 1),
                            ),
                          ),
                          TextSpan(text: " "),
                          TextSpan(
                            text: "dream home\n",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              color: Color.fromRGBO(31, 42, 55, 1),
                            ),
                          ),
                          TextSpan(text: "                        "),
                          TextSpan(
                            text: " with us",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                              color: Color.fromRGBO(31, 42, 55, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 259,
                    height: 36,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "Just search and select your favorite property\n",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(157, 164, 174, 1),
                            ),
                          ),
                          TextSpan(text: "                    "),
                          TextSpan(
                            text: "you want to locate",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(157, 164, 174, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      dotColor: Colors.grey,
                      activeDotColor: const Color.fromRGBO(127, 86, 217, 1),
                    ),
                    onDotClicked: (index) {},
                  ),
                  SizedBox(height: 54),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Sign_up()),
                      );
                    },
                    child: Container(
                      width: 327,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromRGBO(127, 86, 217, 1),
                      ),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                            color: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}