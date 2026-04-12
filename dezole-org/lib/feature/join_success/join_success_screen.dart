import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class JoinSuccessScreen extends ConsumerWidget {
  const JoinSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Success')),
      body: const Center(child: Text('Join Success Screen Content')),
    );
  }
}
