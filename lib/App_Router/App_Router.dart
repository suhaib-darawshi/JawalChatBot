import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();
  static AppRouter router = AppRouter._();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  push(Widget name) {
    navigatorKey.currentState!.push(MaterialPageRoute(
      builder: (context) => name,
    ));
  }

  pushReplace(Widget name) {
    navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
      builder: (context) => name,
    ));
  }

  pop() {
    navigatorKey.currentState!.pop();
  }

  warining(String title, String content, List<Widget> actions) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions,
    );
  }
  // popUntil(String name) {
  //   navigatorKey.currentState!.popUntil(ModalRoute.withName(name));
  // }
}
