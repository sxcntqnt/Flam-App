import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dezole/app/text_style.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/utils/size_utils.dart';
import 'package:dezole/common/widget/common_container.dart';
import 'package:dezole/common/widget/common_dropdown_box.dart';
import 'package:dezole/common/widget/custom_button.dart';
import 'package:dezole/common/widget/custom_text_field.dart';
import 'package:dezole/core/providers/auth_provider.dart';
import 'package:dezole/core/models/user_model.dart';
import 'package:dezole/core/router/app_router.dart';

class ProfileWidget extends ConsumerStatefulWidget {
  const ProfileWidget({super.key});

  @override
  ConsumerState<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final genderList = ["Male", "Female", "Other"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProvider);
      if (user != null) {
        nameController.text = user.name;
        emailController.text = user.email;
        phoneNumberController.text = user.phone;
        genderController.text = user.gender.isNotEmpty
            ? user.gender
            : genderList.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return CommonContainer(
      appBarTitle: "Profile",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CustomTheme.secondaryColor,
            ),
            height: 130.hp,
          ),
          Text(
            user?.name ?? "Guest User",
            style: PoppinsTextStyles.titleMediumRegular.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          ReusableTextField(controller: emailController, hintText: "Email"),
          ReusableTextField(
            controller: phoneNumberController,
            hintText: "Mobile Number",
          ),
          ReusableTextField(
            suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
            controller: genderController,
            hintText: "Gender",
            readOnly: true,
            onTap: () {
              showPopUpMenuWithItems(
                context: context,
                title: "Select",
                onItemPressed: (p0) {
                  genderController.text = p0;
                },
                dataItems: genderList,
              );
            },
          ),
          ReusableTextField(hintText: "Address"),
          CustomRoundedButtom(
            title: "Logout",
            color: Colors.transparent,
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.login,
                (route) => false,
              );
            },
            textColor: CustomTheme.appColor,
            borderColor: CustomTheme.appColor,
          ),
        ],
      ),
    );
  }
}
