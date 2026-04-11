import 'package:flutter/material.dart';
import 'package:dezole/app/text_style.dart';
import 'package:dezole/common/theme.dart';

class CommonGridViewContainer extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Function()? onContainerPress;
  final EdgeInsets? margin;
  final double? height;
  final double? width;

  const CommonGridViewContainer({
    super.key,
    required this.imageUrl,
    this.margin = const EdgeInsets.all(8),
    required this.title,
    this.onContainerPress,
    this.height,
    this.width,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onContainerPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: margin,
        decoration: BoxDecoration(
          border: Border.all(color: CustomTheme.appColor),
          borderRadius: BorderRadius.circular(12),
          color: theme.primaryColor.withValues(alpha: 0.08),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Image.asset(imageUrl),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: PoppinsTextStyles.subheadSmallRegular.copyWith(
                fontWeight: FontWeight.w600,
                color: CustomTheme.darkColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
