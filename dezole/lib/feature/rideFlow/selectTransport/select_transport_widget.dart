import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dezole/common/constant/assets.dart';
import 'package:dezole/common/widget/common_container.dart';
import 'package:dezole/common/widget/common_gridview_container.dart';
import 'package:dezole/feature/rideFlow/availableRide/available_ride_widget.dart';
import 'package:dezole/feature/rideFlow/providers/ride_flow_provider.dart';

class SelectTransportWidget extends ConsumerWidget {
  const SelectTransportWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonContainer(
      appBarTitle: "Select transport",
      body: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return CommonGridViewContainer(
            onContainerPress: () {
              final mode = dataList[index]["mode"] as TransportMode;
              ref.read(selectedTransportModeProvider.notifier).state = mode;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AvailableRideWidget(),
                ),
              );
            },
            imageUrl: dataList[index]["image"] as String,
            title: dataList[index]["title"] as String,
          );
        },
      ),
    );
  }

  static const List<Map<String, dynamic>> dataList = [
    {"image": Assets.carImage, "title": "Car", "mode": TransportMode.car},
    {"image": Assets.bikeImage, "title": "Bike", "mode": TransportMode.bike},
    {"image": Assets.cycleImage, "title": "Cycle", "mode": TransportMode.cycle},
    {"image": Assets.taxiImage, "title": "Taxi", "mode": TransportMode.taxi},
  ];
}
