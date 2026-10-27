import '/models/app_language.dart';

class AppException implements Exception {
  final String messageTh;
  final String messageEn;
  final int? statusCode;
  final bool isCancelled;

  const AppException({
    required this.messageTh,
    required this.messageEn,
    this.statusCode,
    this.isCancelled = false,
  });

  String localizedMessage(AppLanguage language) {
    return language == AppLanguage.th ? messageTh : messageEn;
  }

  @override
  String toString() => messageEn;
}
