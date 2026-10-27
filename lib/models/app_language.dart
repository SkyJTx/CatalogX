enum AppLanguage {
  th('th'),
  en('en');

  const AppLanguage(this.code);
  final String code;

  static AppLanguage fromCode(String? rawCode) {
    if (rawCode == en.code) {
      return AppLanguage.en;
    }
    return AppLanguage.th;
  }
}
