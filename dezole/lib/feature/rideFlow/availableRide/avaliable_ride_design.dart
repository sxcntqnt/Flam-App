import 'package:flutter/material.dart';
import 'package:dezole/app/text_style.dart';
import 'package:dezole/common/constant/assets.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/utils/size_utils.dart';
import 'package:dezole/common/widget/common_popup_box.dart';
import 'package:dezole/common/widget/custom_button.dart';
import 'package:dezole/feature/dashboard/dashboard_widget.dart';
import 'package:dezole/feature/rideFlow/providers/available_rides_provider.dart';

class AvailableRideBoxDesign extends StatelessWidget {
  final AvailableRide ride;

  const AvailableRideBoxDesign({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomTheme.appColor),
        color: CustomTheme.appColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.vehicleName,
                      style: PoppinsTextStyles.subheadLargeRegular.copyWith(
                        color: CustomTheme.darkColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Automatic   |   ${ride.seats} seats   |   Rating ${ride.rating}",
                      style: PoppinsTextStyles.bodySmallRegular.copyWith(
                        color: CustomTheme.darkColor.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      "${ride.distance} (${ride.eta} away)",
                      style: PoppinsTextStyles.labelMediumRegular.copyWith(
                        color: CustomTheme.darkColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "\$${ride.price.toStringAsFixed(0)}",
                      style: PoppinsTextStyles.subheadLargeRegular.copyWith(
                        color: CustomTheme.appColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Image.asset(Assets.carImage)),
            ],
          ),
          SizedBox(height: 10.hp),
          CustomRoundedButtom(
            color: Colors.transparent,
            borderColor: CustomTheme.appColor,
            title: "Book",
            textColor: CustomTheme.appColor,
            onPressed: () {
              showCommonPopUpDialog(
                imageUrl: Assets.successAlertImage,
                title: "Booking Success",
                context: context,
                enableButtonName: "Done",
                onEnablePressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardWidget(),
                    ),
                    (route) => false,
                  );
                },
                message:
                    "Thank you for your time. Please wait for call from our rider.",
              );
            },
          ),
        ],
      ),
    );
  }
}
