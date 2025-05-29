import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'login/signIn_screen.dart';
import 'login/signUp_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffFCFCFC),
        child: Column(
          children: [
            Flexible(
              flex: 6,
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildPage(
                    image: "assets/images/welcome/image1.png",
                    title: "Book a Car in Minutes",
                    description:
                        "Choose your ride, pick your time, and reserve — all from your phone. Fast and hassle-free booking at your fingertips.",
                  ),
                  _buildPage(
                    image: "assets/images/welcome/image2.png",
                    title: "Transparent Rental Process",
                    description:
                        "View car details, compare prices, and pay securely. What you see is what you get — no surprises.",
                  ),
                  _buildPage(
                    image: "assets/images/welcome/image3.png",
                    title: "Drive Anywhere, Anytime",
                    description:
                        "Enjoy the freedom to explore. Rent a car on-demand and travel on your own schedule.",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: ExpandingDotsEffect(
                  activeDotColor: Color(0xFF1976D2),
                  dotColor: Color(0xffDDDFE2),
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              child: _currentPage !=2 ?
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(2); 
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Color(0xff808183),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Color(0xff1976D2),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              )
              : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      height: 46,
                      width: 182,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            )
                          );
                        },
                        child: Text(
                          'Sign Up',
                          textAlign: TextAlign.center, // Căn giữa văn bản
                          style: const TextStyle(
                            color: Color(0xFFF7F7F8),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?',
                          style: TextStyle(
                          color: const Color(0xFF555658),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                        ),
                        TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            )
                          );
                        },
                        child: Text(
                        'Sign In',
                          style: TextStyle(
                            color: Color(0xFF1976D2),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.22,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF1976D2),
                          ),
                        )
                      )
                      ],
                    )
                  ],
                ),
              )
            )
          ],
        )
      ),
    );
  }
}

Widget _buildPage({required String image, required String title, required String description}) {
  return Container(
    margin: const EdgeInsets.only(left: 21, right: 21),
    decoration: BoxDecoration(
      color: Colors.transparent,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(image,
          width: 300,
          height: 300,
        ),
        const SizedBox(height: 16),
        Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w600
          ),
        ),
        const SizedBox(height: 8),
        Text(description,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff808183),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    ),
  );
}