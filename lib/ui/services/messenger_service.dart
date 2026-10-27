import 'package:material_ui/material_ui.dart';

class MessengerService {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;

  MessengerService({required this._scaffoldMessengerKey});

  bool get isMessengerAvailable {
    return _scaffoldMessengerKey.currentState != null;
  }

  ScaffoldMessengerState get messenger {
    if (!isMessengerAvailable) {
      throw Exception('ScaffoldMessenger is not available');
    }
    return _scaffoldMessengerKey.currentState!;
  }

  void showMessage(SnackBar content, {AnimationStyle? snackBarAnimationStyle}) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      content,
    );
  }
}