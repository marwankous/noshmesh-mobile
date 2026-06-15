import 'package:flutter/material.dart';
import 'package:noshmesh/core/constants/app_constants.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.accessibilityTouchTargetMinSize,
      height: AppConstants.accessibilityTouchTargetMinSize,
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
