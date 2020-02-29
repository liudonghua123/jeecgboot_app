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

enum MEDIA_TYPE {
  video,
  audio,
  picture,
  file,
}

MEDIA_TYPE guessFileType(String fileName) {
  RegExp videoRegExp = new RegExp(r".(mp4|avi)$");
  RegExp audioRegExp = new RegExp(r".(mp3|wma|wav)$");
  RegExp pictureRegExp = new RegExp(r".(png|jpg|jpeg|gif|bmp)$");
  if (videoRegExp.hasMatch(fileName)) {
    return MEDIA_TYPE.video;
  } else if (audioRegExp.hasMatch(fileName)) {
    return MEDIA_TYPE.audio;
  } else if (pictureRegExp.hasMatch(fileName)) {
    return MEDIA_TYPE.picture;
  } else {
    return MEDIA_TYPE.file;
  }
}

Widget getLeadingIcon(String fileName) {
  MEDIA_TYPE fileType = guessFileType(fileName);
  Icon icon;
  switch (fileType) {
    case MEDIA_TYPE.video:
      icon = Icon(
        Icons.music_video,
        color: Colors.blue,
        size: 30.0,
      );
      break;
    case MEDIA_TYPE.audio:
      icon = Icon(
        Icons.audiotrack,
        color: Colors.green,
        size: 30.0,
      );
      break;
    case MEDIA_TYPE.picture:
      icon = Icon(
        Icons.photo,
        color: Colors.yellow,
        size: 30.0,
      );
      break;
    default:
      icon = Icon(
        Icons.insert_drive_file,
        color: Colors.grey,
        size: 30.0,
      );
  }
  return icon;
}

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
