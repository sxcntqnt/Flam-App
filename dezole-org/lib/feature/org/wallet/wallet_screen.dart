import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class WalletScreen extends ConsumerWidget {
  final String orgId;

  const WalletScreen({Key? key, required this.orgId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Wallet - $orgId')),
      body: const Center(child: Text('Wallet Screen Content')),
    );
  }
}
