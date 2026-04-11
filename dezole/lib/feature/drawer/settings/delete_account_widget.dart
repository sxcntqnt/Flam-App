import 'package:flutter/material.dart';
import 'package:dezole/app/text_style.dart';
import 'package:dezole/common/constant/assets.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/utils/size_utils.dart';
import 'package:dezole/common/widget/common_container.dart';
import 'package:dezole/common/widget/common_popup_box.dart';
import 'package:dezole/common/widget/custom_button.dart';
import 'package:dezole/feature/auth/login/login_page.dart';

class DeleteAccountWidget extends StatelessWidget {
  const DeleteAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      appBarTitle: "Delete Account",
      body: Column(
        children: [
          Text(
            "Are you sure you want to delete your account? Please read how account deletion will affect. \nDeleting your account removes personal information our database. Tour email becomes permanently reserved and same email cannot be re-use to register a new account.",
            style: PoppinsTextStyles.bodyMediumRegular,
            textAlign: TextAlign.justify,
          ),
          SizedBox(
            height: 20.hp,
          ),
          CustomRoundedButtom(
              title: "Delete",
              color: CustomTheme.googleColor,
              onPressed: () {
                showCommonPopUpDialog(
                    imageUrl: Assets.successAlertImage,
                    context: context,
                    title: "Success",
                    message:
                        "Your account has been deleted. Please contact office for any information.",
                    enableButtonName: "Done",
                    onEnablePressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginWidget(),
                        ),
                        (route) => false,
                      );
                    });
              })
        ],
      ),
    );
  }
}
