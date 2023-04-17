import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customCupertinoActivityIndicator(bool isLight) {
  return Center(
    child: Theme(
      data: ThemeData(
        cupertinoOverrideTheme: CupertinoThemeData(
            brightness: isLight ? Brightness.light : Brightness.dark),
      ),
      child: const CupertinoActivityIndicator(
        radius: 40,
      ),
    ),
  );
}

String loading = "Loading";
void onLoading(BuildContext context, {String? label}) {
  final alert = AlertDialog(
      content: Container(
    padding: const EdgeInsets.symmetric(horizontal: (8)),
    margin: const EdgeInsets.symmetric(horizontal: 8),
    height: 40,
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          width: 20,
        ),
        Text(
          label ?? loading,
        ),
      ],
    ),
  ));
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
