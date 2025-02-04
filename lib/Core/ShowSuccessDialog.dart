import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void ShowSuccessDialog(BuildContext context, String title, String body, Function? callback)
{
  showDialog(
      context: context,
      builder: (BuildContext context)
  {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        TextButton(onPressed: () {
          Navigator.of(context).pop();
          if (callback != null) {
            callback();
          }
        },
          child: const Text('OK'),
        ),
      ],

    );

  },
  );
}