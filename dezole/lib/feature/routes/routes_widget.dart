import 'package:flutter/material.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/widget/page_wrapper.dart';

class RoutesWidget extends StatelessWidget {
  const RoutesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: true,
      appbarTitle: 'Routes',
      body: ListView(
        children: [
          _RouteCard(
            name: 'CBD - Westlands',
            stops: 5,
            fare: 'KSh 50',
            time: '25 min',
          ),
          _RouteCard(
            name: 'CBD - Kasarani',
            stops: 8,
            fare: 'KSh 70',
            time: '35 min',
          ),
          _RouteCard(
            name: 'CBD - Karen',
            stops: 10,
            fare: 'KSh 100',
            time: '45 min',
          ),
          _RouteCard(
            name: 'CBD - Embakasi',
            stops: 12,
            fare: 'KSh 120',
            time: '50 min',
          ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final String name;
  final int stops;
  final String fare;
  final String time;

  const _RouteCard({
    required this.name,
    required this.stops,
    required this.fare,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomTheme.lightGray),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CustomTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.route, color: CustomTheme.appColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$stops stops',
                      style: TextStyle(color: CustomTheme.gray, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    fare,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.appColor,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(color: CustomTheme.gray, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
