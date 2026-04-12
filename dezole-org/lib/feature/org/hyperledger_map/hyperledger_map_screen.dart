import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class HyperledgerMapScreen extends ConsumerWidget {
  final String orgId;

  const HyperledgerMapScreen({Key? key, required this.orgId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Hyperledger Map - $orgId')),
      body: const Center(child: Text('Hyperledger Map Screen Content')),
    );
  }
}
