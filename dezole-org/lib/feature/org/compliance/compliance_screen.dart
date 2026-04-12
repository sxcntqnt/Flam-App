import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class ComplianceScreen extends ConsumerWidget {
  final String orgId;

  const ComplianceScreen({Key? key, required this.orgId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Compliance - $orgId')),
      body: const Center(child: Text('Compliance Screen Content')),
    );
  }
}
