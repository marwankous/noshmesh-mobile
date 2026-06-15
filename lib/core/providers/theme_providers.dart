import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshmesh/core/providers/storage_providers.dart';

const _kThemeModeKey = 'theme_mode';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final stored = prefs.getString(_kThemeModeKey);
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark'  => ThemeMode.dark,
      _       => ThemeMode.system,
    };
  }

  void toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    ref.read(sharedPreferencesProvider)
        .setString(_kThemeModeKey, next == ThemeMode.dark ? 'dark' : 'light');
  }

  void set(ThemeMode mode) {
    state = mode;
    ref.read(sharedPreferencesProvider)
        .setString(_kThemeModeKey, switch (mode) {
          ThemeMode.light  => 'light',
          ThemeMode.dark   => 'dark',
          ThemeMode.system => 'system',
        });
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
