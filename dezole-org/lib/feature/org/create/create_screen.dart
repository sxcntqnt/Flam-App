import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class CreateScreen extends ConsumerWidget {
  final String orgId;

  const CreateScreen({Key? key, required this.orgId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Create - $orgId')),
      body: const Center(child: Text('Create Screen Content')),
    );
  }
}
