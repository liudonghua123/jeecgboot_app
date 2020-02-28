import 'package:flutter/material.dart';
import './main.dart';

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

MultiMediaDialog({String title = 'MultiMedia', @required Widget content}) =>
    AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Text(title),
      content: content,
    );


class TimeUtils {
  static String getCurrentPosition(int seconds) {
    String hours = '00';
    int timeHours = (seconds / (60 * 60)).toInt();
    int timeMinutes = (seconds / 60).toInt() - (timeHours * 60);
    int timeSeconds = seconds - (timeHours * 60 * 60) - (timeMinutes * 60);

    if (timeHours > 9) {
      hours = '$timeHours';
    } else if (timeHours > 0 && timeHours < 10) {
      hours = '0${timeHours}';
    } else {
      hours = '00';
    }
    String minutes = '00';
    if (timeMinutes > 9) {
      minutes = '${timeMinutes}';
    } else if (timeMinutes > 0 && timeMinutes < 10) {
      minutes = '0${timeMinutes}';
    } else {
      minutes = '00';
    }
    String second = '00';
    if (timeSeconds > 9) {
      second = '${timeSeconds}';
    } else if (timeSeconds > 0 && timeSeconds < 10) {
      second = '0${timeSeconds}';
    } else {
      second = '00';
    }
    return '${hours}:${minutes}:${second}';
  }

  static double getProgress(int seconds, int duration) {
    return seconds / duration;
  }
}