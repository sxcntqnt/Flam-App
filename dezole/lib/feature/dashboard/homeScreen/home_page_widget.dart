import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dezole/app/app_drawer.dart';
import 'package:dezole/common/constant/assets.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/widget/common_dialogue_box.dart';
import 'package:dezole/common/widget/custom_button.dart';
import 'package:dezole/common/widget/custom_text_field.dart';
import 'package:dezole/common/widget/page_wrapper.dart';
import 'package:dezole/feature/dashboard/homeScreen/widget/home_page_topbar.dart';
import 'package:dezole/feature/rideFlow/providers/ride_flow_provider.dart';
import 'package:dezole/feature/rideFlow/selectTransport/select_transport_widget.dart';

class HomePageWidget extends ConsumerWidget {
  const HomePageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideType = ref.watch(rideSearchProvider).rideType;
    final isTransport = rideType == RideType.transport;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return PageWrapper(
      padding: EdgeInsets.zero,
      body: SafeArea(
        child: Scaffold(
          drawer: CustomDrawer(),
          backgroundColor: Colors.transparent,
          key: scaffoldKey,
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(top: 18),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.mapImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  HomePageTopBar(
                    onTap: () {
                      if (scaffoldKey.currentState!.isDrawerOpen == false) {
                        scaffoldKey.currentState!.openDrawer();
                      } else {
                        scaffoldKey.currentState!.openEndDrawer();
                      }
                    },
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: CustomTheme.appColor),
                            color: CustomTheme.appColor.withValues(alpha: 0.3),
                          ),
                          child: Column(
                            children: [
                              CustomRoundedButtom(
                                icon: Icons.search_sharp,
                                iconColor: CustomTheme.darkColor,
                                title: "Where would you go?",
                                onPressed: () {
                                  showPopUpDialog(
                                    barrierDismissible: false,
                                    buttonName: "Proceed",
                                    buttonCallback: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SelectTransportWidget(),
                                        ),
                                      );
                                    },
                                    context: context,
                                    title: "Select Address",
                                    body: Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        ReusableTextField(hintText: "Form"),
                                        ReusableTextField(hintText: "To"),
                                      ],
                                    ),
                                  );
                                },
                                textColor: CustomTheme.darkColor.withValues(
                                  alpha: 0.4,
                                ),
                                color: CustomTheme.lightColor.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: CustomTheme.lightColor,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomRoundedButtom(
                                        verticalMargin: 0,
                                        textColor: isTransport
                                            ? CustomTheme.lightColor
                                            : CustomTheme.darkColor,
                                        title: "Transport",
                                        onPressed: () {
                                          ref
                                              .read(rideSearchProvider.notifier)
                                              .setRideType(RideType.transport);
                                        },
                                        color: isTransport
                                            ? CustomTheme.appColor
                                            : CustomTheme.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomRoundedButtom(
                                        verticalMargin: 0,
                                        textColor: !isTransport
                                            ? CustomTheme.lightColor
                                            : CustomTheme.darkColor,
                                        title: "Delivery",
                                        onPressed: () {
                                          ref
                                              .read(rideSearchProvider.notifier)
                                              .setRideType(RideType.delivery);
                                        },
                                        color: !isTransport
                                            ? CustomTheme.appColor
                                            : CustomTheme.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
