import '/interfaces/app_localization.dart';
import '/models/app_language.dart';
import '/ui/localization/en_app_localization.dart';
import '/ui/localization/th_app_localization.dart';

export '/interfaces/app_localization.dart';

typedef AppStrings = AppLocalization;

AppLocalization resolveAppLocalization(AppLanguage language) {
  return switch (language) {
    AppLanguage.th => const ThAppLocalization(),
    AppLanguage.en => const EnAppLocalization(),
  };
}
