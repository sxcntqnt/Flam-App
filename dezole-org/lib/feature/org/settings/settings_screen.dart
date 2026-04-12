import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class SettingsScreen extends ConsumerWidget {
  final String orgId;

  const SettingsScreen({Key? key, required this.orgId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings - $orgId')),
      body: const Center(child: Text('Settings Screen Content')),
    );
  }
}
