import 'package:noshmesh/core/ui/buttons/app_button.dart';
import 'package:flutter/material.dart';

class AppDialog {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String content,
    required String primaryLabel,
    required VoidCallback onPrimary,
    String? secondaryLabel,
    VoidCallback? onSecondary,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        title: Text(title),
        content: Text(content),
        actionsAlignment: MainAxisAlignment.end,
        actionsOverflowAlignment: OverflowBarAlignment.end,
        actions: [
          if (secondaryLabel != null)
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                onSecondary?.call();
              },
              child: Text(secondaryLabel),
            ),
          SizedBox(
            width: 120,
            child: AppButton(
              label: primaryLabel,
              onPressed: () {
                Navigator.of(ctx).pop();
                onPrimary();
              },
            ),
          ),
        ],
      ),
    );
  }
}
