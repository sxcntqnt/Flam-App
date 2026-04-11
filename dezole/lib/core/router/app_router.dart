import 'package:flutter/material.dart';
import 'package:dezole/feature/onbaording/splash_screen.dart';
import 'package:dezole/feature/onbaording/onboarding_screen.dart';
import 'package:dezole/feature/auth/welcomeScreen/screen/welcome_page.dart';
import 'package:dezole/feature/auth/login/login_page.dart';
import 'package:dezole/feature/auth/register/screen/signup_page.dart';
import 'package:dezole/feature/auth/permission_screen.dart';
import 'package:dezole/feature/dashboard/dashboard_widget.dart';

enum AppRoute {
  splash,
  onboarding,
  welcome,
  login,
  signup,
  permission,
  dashboard,
  home,
  feed,
  chat,
  profile,
  wallet,
  addMoney,
  offer,
  favourite,
  selectTransport,
  availableRide,
  history,
  complain,
  referral,
  aboutUs,
  settings,
  helpSupport,
  changePassword,
  privacyPolicy,
  deleteAccount,
  contactUs,
  track,
  subscribe,
  calendar,
  geofences,
  race,
  reserve,
  routes,
  selectPlan,
  weather,
  notification,
}

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String permission = '/permission';
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String feed = '/feed';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String wallet = '/wallet';
  static const String addMoney = '/wallet/add-money';
  static const String offer = '/offer';
  static const String favourite = '/favourite';
  static const String selectTransport = '/ride/select-transport';
  static const String availableRide = '/ride/available';
  static const String history = '/history';
  static const String complain = '/complain';
  static const String referral = '/referral';
  static const String aboutUs = '/about-us';
  static const String settings = '/settings';
  static const String helpSupport = '/help-support';
  static const String changePassword = '/settings/change-password';
  static const String privacyPolicy = '/settings/privacy-policy';
  static const String deleteAccount = '/settings/delete-account';
  static const String contactUs = '/settings/contact-us';
  static const String notification = '/notification';
  static const String track = '/track';
  static const String subscribe = '/subscribe';
  static const String calendar = '/calendar';
  static const String geofences = '/geofences';
  static const String race = '/race';
  static const String reserve = '/reserve';
  static const String routes = '/routes';
  static const String selectPlan = '/select-plan';
  static const String weather = '/weather';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashWidget(),
          settings: settings,
        );
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnBoardingPage(),
          settings: settings,
        );
      case welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomePage(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginWidget(),
          settings: settings,
        );
      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignUpPage(),
          settings: settings,
        );
      case permission:
        return MaterialPageRoute(
          builder: (_) => const PermissionPage(),
          settings: settings,
        );
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardWidget(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
