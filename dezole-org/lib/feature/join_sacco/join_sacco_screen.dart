import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class JoinSaccoScreen extends ConsumerWidget {
  const JoinSaccoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join SACCO')),
      body: const Center(child: Text('Join SACCO Screen Content')),
    );
  }
}
