import 'package:flutter/material.dart';

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isError ? cs.onError : cs.onSurface,
          ),
        ),
        backgroundColor: isError ? cs.error : cs.surfaceContainerHighest,
      ),
    );
  }
}
