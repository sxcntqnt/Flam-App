import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dezole/common/widget/common_container.dart';
import 'package:dezole/feature/rideFlow/availableRide/avaliable_ride_design.dart';
import 'package:dezole/feature/rideFlow/providers/available_rides_provider.dart';

class AvailableRideWidget extends ConsumerWidget {
  const AvailableRideWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideState = ref.watch(availableRidesProvider);

    return CommonContainer(
      appBarTitle: "Available Ride",
      body: Column(
        children: [
          if (rideState.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (rideState.hasError)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Error: ${rideState.error}'),
            )
          else
            ListView.builder(
              itemCount: rideState.rides.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  AvailableRideBoxDesign(ride: rideState.rides[index]),
            ),
        ],
      ),
    );
  }
}
