import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../models/catalog_filter.dart';
import '../repo/local_storage_repository.dart';
import '../ui/localization/app_strings.dart';

class LocaleNotifier extends Notifier<AppLanguage> {
  @override
  AppLanguage build() {
    if (GetIt.I.isRegistered<LocalStorageRepository>()) {
      return GetIt.I<LocalStorageRepository>().getLanguage();
    }
    return AppLanguage.th;
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (state == language) return;
    state = language;
    if (GetIt.I.isRegistered<LocalStorageRepository>()) {
      await GetIt.I<LocalStorageRepository>().setLanguage(language);
    }
  }

  Future<void> toggleLanguage() async {
    final next = state == AppLanguage.th ? AppLanguage.en : AppLanguage.th;
    await setLanguage(next);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, AppLanguage>(
  LocaleNotifier.new,
);

final appStringsProvider = Provider<AppStrings>((ref) {
  final language = ref.watch(localeProvider);
  return AppStrings(language);
});