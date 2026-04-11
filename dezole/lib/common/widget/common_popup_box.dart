import 'package:flutter/material.dart';
import 'package:dezole/app/text_style.dart';
import 'package:dezole/common/constant/assets.dart';
import 'package:dezole/common/utils/size_utils.dart';
import 'package:dezole/common/widget/common_image.dart';
import 'package:dezole/common/widget/custom_button.dart';

showCommonPopUpDialog({
  required BuildContext context,
  required String message,
  required String title,
  Function()? onDisablePressed,
  required Function() onEnablePressed,
  required String imageUrl,
  String disableButtonName = "",
  required String enableButtonName,
  String? buttonText,
}) {
  showGeneralDialog(
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: PopUpDialogWidget(
            description: message,
            title: title,
            disableButtonName: disableButtonName,
            enableButtonName: enableButtonName,
            onDisablePressed: onDisablePressed,
            onEnablePressed: onEnablePressed,
            imageUrl: imageUrl,
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierDismissible: false,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, anim11, anim2) {
      return Container();
    },
  );
}

class PopUpDialogWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String enableButtonName;
  final String disableButtonName;
  final VoidCallback? onEnablePressed;
  final VoidCallback? onDisablePressed;

  const PopUpDialogWidget({
    super.key,
    this.imageUrl = Assets.locationImage,
    this.title = "",
    this.description = "",
    this.enableButtonName = "",
    this.disableButtonName = "",
    this.onEnablePressed,
    this.onDisablePressed,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30.hp, horizontal: 15.hp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonImage(imageUrl: imageUrl, height: 100.hp),
              SizedBox(height: 40.hp),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: PoppinsTextStyles.titleMediumRegular,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.hp),
                    Text(
                      description,
                      style: PoppinsTextStyles.subheadSmallRegular,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.hp),
              if (enableButtonName.isNotEmpty)
                CustomRoundedButtom(
                  onPressed: () {
                    Navigator.pop(context);
                    onEnablePressed!.call();
                  },
                  title: enableButtonName,
                ),
              if (disableButtonName.isNotEmpty)
                CustomRoundedButtom(
                  color: Colors.transparent,
                  onPressed: () {
                    Navigator.pop(context);
                    onDisablePressed!.call();
                  },
                  title: disableButtonName,
                  textColor: Colors.black26,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
