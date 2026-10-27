import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '/interfaces/local_storage_repository.dart';
import '/models/app_language.dart';
import '/ui/localization/app_strings.dart';

class LocaleNotifier extends Notifier<AppLanguage> {
  final LocalStorageRepository _storageRepository;

  LocaleNotifier({required this._storageRepository});

  @override
  AppLanguage build() {
    return _storageRepository.getLanguage();
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (state == language) {
      return;
    }
    state = language;
    await _storageRepository.setLanguage(language);
  }

  Future<void> toggleLanguage() async {
    final next = state == AppLanguage.th ? AppLanguage.en : AppLanguage.th;
    await setLanguage(next);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, AppLanguage>(
  () => LocaleNotifier(
    storageRepository: GetIt.I<LocalStorageRepository>(),
  ),
);

final appStringsProvider = Provider<AppLocalization>((ref) {
  final language = ref.watch(localeProvider);
  return resolveAppLocalization(language);
});
