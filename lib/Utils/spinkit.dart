import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future dialogLoader(BuildContext context, String msg) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitCircle(color: Color(0xFF1D4380), size: 75),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(msg,
                    style:
                        const TextStyle(color: Color(0xFFFFFFFF), fontSize: 13)
                            .copyWith(decoration: TextDecoration.none)),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void dialogClose(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    // Navigator.pop(context);
    Navigator.of(context).pop();
  }
}
