import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/common/theme.dart';
import 'package:ridesharing/feature/onbaording/splash_screen.dart';
import 'package:ridesharing/core/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return MaterialApp(
      theme: CustomTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashWidget(),
    );
  }
}