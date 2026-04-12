import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/common/theme.dart';
import 'package:ridesharing/feature/trips/trips_provider.dart';

class TripsWidget extends ConsumerWidget {
  const TripsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(tripsProvider);

    return Scaffold(
      backgroundColor: CustomTheme.lightColor,
      appBar: AppBar(
        title: const Text('Trips'),
        backgroundColor: CustomTheme.appColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter trips
            },
          ),
        ],
      ),
      body: tripsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : tripsState.trips.isEmpty
          ? const Center(child: Text('No trips yet'))
          : ListView.builder(
              itemCount: tripsState.trips.length,
              itemBuilder: (context, index) {
                final trip = tripsState.trips[index];
                final isSelected = tripsState.selectedTripId == trip['id'];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: isSelected ? 4 : 1,
                  child: ListTile(
                    selected: isSelected,
                    selectedTileColor: CustomTheme.appColor.withOpacity(0.1),
                    leading: CircleAvatar(
                      backgroundColor: CustomTheme.appColor,
                      child: Icon(
                        trip['type'] == 'ride'
                            ? Icons.directions_car
                            : Icons.local_shipping,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      trip['type'] == 'ride'
                          ? 'Ride to ${trip['destination']}'
                          : 'Delivery to ${trip['destination']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${trip['date']} • ${trip['time']}'),
                        Text(
                          '\$${trip['fare'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomTheme.appColor,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: isSelected ? CustomTheme.appColor : Colors.grey,
                    ),
                    onTap: () {
                      if (isSelected) {
                        ref.read(tripsProvider.notifier).deselectTrip();
                      } else {
                        ref
                            .read(tripsProvider.notifier)
                            .selectTrip(trip['id'] ?? '');
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add sample trip for demo
          ref.read(tripsProvider.notifier).addTrip({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'type': 'ride',
            'destination': 'Downtown',
            'date': 'Today',
            'time': '2:30 PM',
            'fare': 15.50,
          });
        },
        backgroundColor: CustomTheme.appColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
