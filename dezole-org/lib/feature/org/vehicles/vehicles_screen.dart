import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class VehiclesScreen extends ConsumerWidget {
  final String orgId;

  const VehiclesScreen({Key? key, required this.orgId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Vehicles - $orgId')),
      body: const Center(child: Text('Vehicles Screen Content')),
    );
  }
}
