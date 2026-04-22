import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dezole/app/text_style.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/utils/size_utils.dart';
import 'package:dezole/common/widget/page_wrapper.dart';
import 'package:dezole/feature/auth/permission_screen.dart';
import 'package:dezole/feature/onbaording/providers/onboarding_provider.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _setOnboardingDone();
  }

  Future<void> _setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = OnboardingNotifier.defaultPages;

    return PageWrapper(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: _navigateToPermission,
                child: Text(
                  "Skip",
                  style: PoppinsTextStyles.subheadLargeRegular,
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() => _currentPage = index);
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return _buildPage(
                    imageAsset: page.imageAsset,
                    title: page.title,
                    description: page.description,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: _onIndicatorTap,
              child: _buildCircularIndicator(pages.length),
            ),
          ],
        ),
      ),
    );
  }

  void _onIndicatorTap() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToPermission();
    }
  }

  void _navigateToPermission() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PermissionPage()),
    );
  }

  Widget _buildPage({
    required String imageAsset,
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(imageAsset),
        Padding(
          padding: const EdgeInsets.all(56.0),
          child: Column(
            children: [
              Text(
                title,
                style: PoppinsTextStyles.titleMediumRegular.copyWith(
                  color: CustomTheme.darkerBlack,
                ),
              ),
              SizedBox(height: 10.hp),
              Text(
                description,
                style: PoppinsTextStyles.subheadSmallRegular,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircularIndicator(int pageCount) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 50.wp,
        height: 50.hp,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: (_currentPage + 1) / pageCount,
              strokeWidth: 5.0,
              backgroundColor: Colors.grey,
              valueColor: const AlwaysStoppedAnimation<Color>(
                CustomTheme.appColor,
              ),
            ),
            Center(
              child: Icon(
                Icons.arrow_forward,
                size: 30,
                color: CustomTheme.appColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
