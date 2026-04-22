import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dezole/common/constant/assets.dart';
import 'package:dezole/common/widget/common_container.dart';
import 'package:dezole/common/widget/common_list_tile.dart';
import 'package:dezole/common/widget/common_popup_box.dart';
import 'package:dezole/core/providers/auth_provider.dart';
import 'package:dezole/core/router/app_router.dart';
import 'package:dezole/feature/drawer/settings/change_password_widget.dart';
import 'package:dezole/feature/drawer/settings/contact_us_widget.dart';
import 'package:dezole/feature/drawer/settings/delete_account_widget.dart';
import 'package:dezole/feature/drawer/settings/privacy_policy_widget.dart';

class SettingWidget extends ConsumerWidget {
  const SettingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingItems = items(context, ref);
    return CommonContainer(
      appBarTitle: "Settings",
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: settingItems.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => CustomListTile(
          trailing: SvgPicture.asset(Assets.rightArrowIcon),
          onTap: () => settingItems[index].onTap(context),
          title: settingItems[index].title,
        ),
      ),
    );
  }

  List<SettingItem> items(BuildContext context, WidgetRef ref) => [
    SettingItem(
      title: "Change Password",
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangePasswordWidget()),
        );
      },
    ),
    SettingItem(
      title: "Privacy Policy",
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrivacyPolicyWidget()),
        );
      },
    ),
    SettingItem(
      title: "Contact Us",
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactUsWidget()),
        );
      },
    ),
    SettingItem(
      title: "Delete Account",
      onTap: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DeleteAccountWidget()),
        );
      },
    ),
    SettingItem(
      title: "Logout",
      onTap: (BuildContext context) {
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
      },
    ),
  ];
}

class SettingItem {
  final String title;
  final Function onTap;

  SettingItem({required this.title, required this.onTap});
}
