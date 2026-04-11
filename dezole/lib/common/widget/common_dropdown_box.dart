import 'package:flutter/material.dart';
import 'package:dezole/app/text_style.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/utils/size_utils.dart';

showPopUpMenuWithItems({
  required BuildContext context,
  required String title,
  required Function(String) onItemPressed,
  required List<String> dataItems,
}) {
  showGeneralDialog(
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonDropDownBox(
                title: title,
                dataItems: dataItems,
                onItemPressed: onItemPressed,
              ),
            ],
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Container();
    },
  );
}

class CommonDropDownBox extends StatelessWidget {
  final String title;
  final List<String> dataItems;
  final Function(String)? onItemPressed;

  const CommonDropDownBox({
    super.key,
    this.title = "Title",
    required this.dataItems,
    this.onItemPressed,
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
            children: [
              Text(title, style: PoppinsTextStyles.titleMediumRegular),
              ListView.builder(
                shrinkWrap: true,
                itemCount: dataItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      dataItems[index],
                      style: const TextStyle(color: CustomTheme.darkColor),
                    ),
                    onTap: () {
                      if (onItemPressed != null) {
                        onItemPressed!(dataItems[index]);
                      }
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
