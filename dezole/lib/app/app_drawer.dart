import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dezole/app/text_style.dart';
import 'package:dezole/common/constant/assets.dart';
import 'package:dezole/common/utils/size_utils.dart';
import 'package:dezole/common/widget/common_popup_box.dart';
import 'package:dezole/core/providers/auth_provider.dart';
import 'package:dezole/core/router/app_router.dart';
import 'package:dezole/feature/drawer/aboutUs/about_us_widget.dart';
import 'package:dezole/feature/drawer/complain/complain_widget.dart';
import 'package:dezole/feature/drawer/helpSupport/help_support_widget.dart';
import 'package:dezole/feature/drawer/history/history_widget.dart';
import 'package:dezole/feature/drawer/referral/referral_widget.dart';
import 'package:dezole/feature/drawer/settings/setting_widget.dart';

import '../common/theme.dart';

class CustomDrawer extends ConsumerWidget {
  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: SizeUtils.width / 1.5,
      shape: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h),
          Container(
            margin: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.profileImage),
                fit: BoxFit.contain,
              ),
              shape: BoxShape.circle,
              color: CustomTheme.secondaryColor,
            ),
            width: 80.wp,
            height: 80.hp,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Nate Samson",
              style: PoppinsTextStyles.titleMediumRegular.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: drawerItems.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.pop(context);
                  if (index == 6) {
                    showCommonPopUpDialog(
                      context: context,
                      message: "Are you sure you want to logout?",
                      title: "Alert",
                      onEnablePressed: () {
                        ref.read(authProvider.notifier).logout();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRouter.login,
                          (route) => false,
                        );
                      },
                      imageUrl: Assets.successAlertImage,
                      disableButtonName: "Cancel",
                      onDisablePressed: () {
                        Navigator.of(context).pop();
                      },
                      enableButtonName: "Logout",
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => screens[index]),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomTheme.darkColor.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(drawerItemIcons[index], height: 25.hp),
                      SizedBox(width: 10.wp),
                      Text(
                        drawerItems[index],
                        style: PoppinsTextStyles.labelMediumRegular.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List drawerItems = [
    "History",
    "Complain",
    "Referral",
    "About Us",
    "Settings",
    "Help & Support",
    "Logout",
  ];
  final List drawerItemIcons = [
    Assets.historyIcon,
    Assets.complainIcon,
    Assets.referralIcon,
    Assets.aboutUsIcon,
    Assets.settingsIcon,
    Assets.helpAndSupportIcon,
    Assets.logoutIcon,
  ];
  final List<Widget> screens = [
    const HistoryWidget(),
    const ComplainWidget(),
    ReferralWidget(),
    const AboutUsWidget(),
    SettingWidget(),
    const HelpSupportWidget(),
  ];
}
