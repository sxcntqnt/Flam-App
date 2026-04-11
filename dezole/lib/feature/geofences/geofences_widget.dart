import 'package:flutter/material.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/widget/page_wrapper.dart';

class GeofencesWidget extends StatelessWidget {
  const GeofencesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: true,
      appbarTitle: 'Geofences',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CustomTheme.appColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CustomTheme.appColor),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CustomTheme.appColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.location_on, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Active Geofences',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '3 zones monitored',
                          style: TextStyle(
                            color: CustomTheme.gray,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Geofences',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _GeofenceCard(
              name: 'CBD Zone',
              description: 'Downtown Nairobi boundary',
              status: 'Active',
              vehicles: 12,
            ),
            _GeofenceCard(
              name: 'Westlands Area',
              description: 'Westlands商业区',
              status: 'Active',
              vehicles: 8,
            ),
            _GeofenceCard(
              name: 'Kasarani Stadium',
              description: 'Kasarani区域监控',
              status: 'Paused',
              vehicles: 0,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Create New Geofence'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomTheme.appColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeofenceCard extends StatelessWidget {
  final String name;
  final String description;
  final String status;
  final int vehicles;

  const _GeofenceCard({
    required this.name,
    required this.description,
    required this.status,
    required this.vehicles,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'Active';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomTheme.lightGray),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CustomTheme.secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.hexagon, color: CustomTheme.appColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: CustomTheme.gray, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? CustomTheme.secondaryColor
                            : CustomTheme.lightGray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          color: isActive
                              ? CustomTheme.appColor
                              : CustomTheme.gray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.directions_bus,
                      size: 14,
                      color: CustomTheme.gray,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$vehicles vehicles',
                      style: TextStyle(fontSize: 11, color: CustomTheme.gray),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: CustomTheme.gray),
        ],
      ),
    );
  }
}
