import 'package:flutter/foundation.dart';

enum AppMode {
  home,
  search,
  anime,
  manga,
  library,
  downloads,
  player,
  reader,
  settings,
}

class AppState extends ChangeNotifier {
  AppMode _mode = AppMode.home;

  AppMode get mode => _mode;

  void setMode(AppMode mode) {
    if (_mode == mode) {
      return;
    }

    _mode = mode;
    notifyListeners();
  }
}