import 'package:flutter/material.dart';
import 'package:ridesharing/common/theme.dart';

class TipjarWidget extends StatelessWidget {
  const TipjarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Tipjar Screen',
      button: true,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: double.infinity,
            minHeight: double.infinity,
          ),
          child: Text(
            'Tipjar Screen',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
