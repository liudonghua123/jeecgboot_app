import 'package:flutter/material.dart';

LoadingDialog({String loadingText = 'Loading...'}) => AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(loadingText,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left),
          )
        ],
      ),
    );

MessageDialog({String title = 'Message', @required String content}) =>
    AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Text(title),
      content: Text(content),
    );
