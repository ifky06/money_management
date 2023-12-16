
import 'package:flutter/material.dart';
import 'package:money_management/theme/theme_constants.dart';

class ActionButton extends StatelessWidget {
  final void Function() onClick;
  final IconData iconData;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? labelText;

  const ActionButton({
    super.key,
    required this.iconData,
    required this.onClick,
    this.iconSize = 24,
    this.backgroundColor,
    this.iconColor,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          borderRadius: BorderRadius.circular(50),
          clipBehavior: Clip.hardEdge,
          elevation: 8,
          color: backgroundColor ?? ThemeConstants.primaryBlue,
          child: InkWell(
            onTap: onClick,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                iconData,
                color: iconColor ?? Colors.white,
                size: iconSize,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        (labelText != null)
            ? Text(
                labelText!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : const SizedBox(),
      ],
    );
  }
}