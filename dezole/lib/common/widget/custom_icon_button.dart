import 'package:dezole/common/theme.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;
  final double borderRadius;
  final Color backgroundColor;
  final Color iconColor;
  final double verticalPadding;
  final double horizontalPadding;
  final double iconSize;
  final bool shadow;
  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.borderRadius = 50,
    this.backgroundColor = CustomTheme.lightGray,
    this.iconColor = CustomTheme.darkGray,
    this.horizontalPadding = 12,
    this.verticalPadding = 12,
    this.iconSize = 18,
    this.shadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          if (shadow)
            const BoxShadow(
              color: CustomTheme.shadowColor,
              offset: Offset(0, -1),
              blurRadius: 10,
            ),
        ],
      ),
      child: Material(
        color: backgroundColor,
        elevation: 0,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
        ),
      ),
    );
  }
}
