import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

navigate(BuildContext context, Widget screen) async {
  return await Navigator.push(
      context, CupertinoPageRoute(builder: (_) => screen));
}

navigateReplacement(BuildContext context, Widget screen) async {
  return await Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (_) => screen));
}

navigateAndRemoveAll(BuildContext context, Widget screen) {
  return Navigator.pushAndRemoveUntil(
    context,
    CupertinoPageRoute(builder: (_) => screen),
    (Route<dynamic> route) => false,
  );
}
