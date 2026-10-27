import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:material_ui/material_ui.dart';

import '/interfaces/local_storage_repository.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  final LocalStorageRepository _storageRepository;

  ThemeModeNotifier({required this._storageRepository});

  @override
  ThemeMode build() {
    return _storageRepository.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) {
      return;
    }
    state = mode;
    await _storageRepository.setThemeMode(mode);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  () => ThemeModeNotifier(
    storageRepository: GetIt.I<LocalStorageRepository>(),
  ),
);
