import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshmesh/core/localization/language_selector_widget.dart';
import 'package:noshmesh/l10n/l10n.dart';

/// Screen for language selection settings
class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('language_settings'))),
      body: const LanguageSelectorWidget(),
    );
  }
}
