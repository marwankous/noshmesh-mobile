import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.size = 20, this.fullScreen = false});

  final double size;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: fullScreen ? 32 : size,
      height: fullScreen ? 32 : size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
    return fullScreen ? Center(child: indicator) : indicator;
  }
}
