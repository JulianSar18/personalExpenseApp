import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FunctionDart {
    void transparentStatusBar() {
    SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
    void portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}