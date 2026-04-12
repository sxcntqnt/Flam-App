import 'package:flutter/material.dart';
import 'package:ridesharing/feature/dashboard/dashboard_widget.dart';
import 'package:ridesharing/feature/onbaording/splash_screen.dart';
import 'package:ridesharing/feature/login/login_screen.dart';
import 'package:ridesharing/feature/org/org_dashboard.dart';
import 'package:ridesharing/feature/org/devices/devices_screen.dart';
import 'package:ridesharing/feature/org/compliance/compliance_screen.dart';
import 'package:ridesharing/feature/org/contracts/contracts_screen.dart';
import 'package:ridesharing/feature/org/create/create_screen.dart';
import 'package:ridesharing/feature/org/dashboard/org_dashboard.dart';
import 'package:ridesharing/feature/org/drivers/drivers_screen.dart';
import 'package:ridesharing/feature/org/finance/finance_screen.dart';
import 'package:ridesharing/feature/org/fleet/fleet_screen.dart';
import 'package:ridesharing/feature/org/hyperledger_map/hyperledger_map_screen.dart';
import 'package:ridesharing/feature/org/news/news_screen.dart';
import 'package:ridesharing/feature/org/settings/settings_screen.dart';
import 'package:ridesharing/feature/org/track/track_screen.dart';
import 'package:ridesharing/feature/org/vehicles/vehicles_screen.dart';
import 'package:ridesharing/feature/org/wallet/wallet_screen.dart';
import 'package:ridesharing/feature/join_sacco/join_sacco_screen.dart';
import 'package:ridesharing/feature/join_success/join_success_screen.dart';
import 'package:ridesharing/feature/select/select_screen.dart';
import 'package:ridesharing/common/route/routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.root:
        return MaterialPageRoute(builder: (_) => const SplashWidget());
      case Routes.loginPage:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardWidget());

      // Organization routes with orgId parameter
      case '/org/:orgId/dashboard':
        return MaterialPageRoute(
          builder: (_) => OrgDashboard(orgId: args as String),
        );
      case '/org/:orgId/devices':
        return MaterialPageRoute(
          builder: (_) => DevicesScreen(orgId: args as String),
        );
      case '/org/:orgId/compliance':
        return MaterialPageRoute(
          builder: (_) => ComplianceScreen(orgId: args as String),
        );
      case '/org/:orgId/contracts':
        return MaterialPageRoute(
          builder: (_) => ContractsScreen(orgId: args as String),
        );
      case '/org/:orgId/create':
        return MaterialPageRoute(
          builder: (_) => CreateScreen(orgId: args as String),
        );
      case '/org/:orgId/drivers':
        return MaterialPageRoute(
          builder: (_) => DriversScreen(orgId: args as String),
        );
      case '/org/:orgId/finance':
        return MaterialPageRoute(
          builder: (_) => FinanceScreen(orgId: args as String),
        );
      case '/org/:orgId/fleet':
        return MaterialPageRoute(
          builder: (_) => FleetScreen(orgId: args as String),
        );
      case '/org/:orgId/hyperledger/map':
        return MaterialPageRoute(
          builder: (_) => HyperledgerMapScreen(orgId: args as String),
        );
      case '/org/:orgId/news':
        return MaterialPageRoute(
          builder: (_) => NewsScreen(orgId: args as String),
        );
      case '/org/:orgId/settings':
        return MaterialPageRoute(
          builder: (_) => SettingsScreen(orgId: args as String),
        );
      case '/org/:orgId/track':
        return MaterialPageRoute(
          builder: (_) => TrackScreen(orgId: args as String),
        );
      case '/org/:orgId/vehicles':
        return MaterialPageRoute(
          builder: (_) => VehiclesScreen(orgId: args as String),
        );
      case '/org/:orgId/wallet':
        return MaterialPageRoute(
          builder: (_) => WalletScreen(orgId: args as String),
        );

      // Other routes
      case '/join-sacco':
        return MaterialPageRoute(builder: (_) => const JoinSaccoScreen());
      case '/join-success':
        return MaterialPageRoute(builder: (_) => const JoinSuccessScreen());
      case '/select':
        return MaterialPageRoute(builder: (_) => const SelectScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('No route defined'))),
        );
    }
  }
}
