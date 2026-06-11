import 'package:flutter/material.dart';
import 'package:inventflow/views/auth/login_screen.dart';
import 'package:inventflow/views/onboard_screen.dart';

class OnboardViewModel extends StatefulWidget {
  const OnboardViewModel({super.key});

  @override
  State<OnboardViewModel> createState() => _OnboardViewModelState();
}

class _OnboardViewModelState extends State<OnboardViewModel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Map<String, dynamic>> pages = [
    {
      "title": "Welcome to InventFlow",
      "description":
          "The best way to manage your inventory and track your stock.",
      "image": 'images/ivent1.png',
    },
    {
      "title": "Track Everything",
      "description":
          "Keep an eye on your items in real-time, right from your pocket.",
      "image": 'images/ivent1.png',
    },
    {
      "title": "Get Started",
      "description": "Let's set up your first workspace and add some items.",
      "image": 'images/ivent1.png',
    },
  ];

  void _nextPage() {
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
    }
  }

  void _onSkip() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemBuilder: (context, index) => OnbaordingScreen(
                  title: pages[index]['title'],
                  description: pages[index]['description'],
                  imag: pages[index]['image'],
                  onNext: _nextPage,
                  onSkip: _onSkip,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
