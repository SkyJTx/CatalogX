import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:material_ui/material_ui.dart';

import '/interfaces/local_storage_repository.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    if (GetIt.I.isRegistered<LocalStorageRepository>()) {
      return GetIt.I<LocalStorageRepository>().getThemeMode();
    }
    return ThemeMode.light;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;
    state = mode;
    if (GetIt.I.isRegistered<LocalStorageRepository>()) {
      await GetIt.I<LocalStorageRepository>().setThemeMode(mode);
    }
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);