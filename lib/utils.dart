import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:path_provider/path_provider.dart';

import './net/api.dart';
import 'widgets/audio_widget.dart';
import 'widgets/video_widget.dart';

LoadingDialog({String loadingText = 'Loading...'}) => AlertDialog(
      contentPadding: const EdgeInsets.all(5),
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
      contentPadding: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Text(title),
      content: Text(content),
    );

MultiMediaDialog({String title = 'MultiMedia', @required Widget content}) =>
    AlertDialog(
      contentPadding: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Text(title),
      content: content,
    );

ConfirmDialog(BuildContext context,
        {String title = '操作',
        @required String content,
        Function onOkButtonPressed}) =>
    FlareGiffyDialog(
      flarePath: 'assets/space_demo.flr',
      flareAnimation: 'loading',
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      entryAnimation: EntryAnimation.DEFAULT,
      description: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
      ),
      buttonOkText: Text('确定'),
      buttonCancelText: Text('取消'),
      onOkButtonPressed: onOkButtonPressed,
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

Widget getDialogContent(BuildContext context, String fileName) {
  MEDIA_TYPE fileType = guessFileType(fileName);
  Widget content;
  String fileUrl = API.getStaticFilePath(fileName);
  Widget downloadButton = RaisedButton(
    color: Colors.blueAccent,
    child: Text('下载 $fileName'),
    onPressed: () async {
      // Downloader.download(fileUrl, fileName, '.$fileType');
      var _saveDir = await _findLocalPath(context);
      final taskId = await FlutterDownloader.enqueue(
        url: fileUrl,
        savedDir: _saveDir,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
      print('_saveDir: $_saveDir, taskId: $taskId');
      final tasks = await FlutterDownloader.loadTasks();
      print('tasks: $tasks');
      Navigator.of(context).pop();
    },
  );
  switch (fileType) {
    case MEDIA_TYPE.video:
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
      VideoWidget(
        source: fileUrl,
        width: 300,
        height: 250,
      ),
      Row(
        children: <Widget>[Expanded(child: downloadButton)],
      )
        ],
      );
      break;
    case MEDIA_TYPE.audio:
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
      AudioWidget(
        source: fileUrl,
        width: 300,
        height: 150,
      ),
      Row(
        children: <Widget>[Expanded(child: downloadButton)],
      )
        ],
      );
      break;
    case MEDIA_TYPE.picture:
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
      Image.network(
        fileUrl,
        fit: BoxFit.cover,
        width: 300,
        height: 200,
      ),
      Row(
        children: <Widget>[Expanded(child: downloadButton)],
      )
        ],
      );
      break;
    default:
      content = downloadButton;
  }
  return content;
}

Future<String> _findLocalPath(BuildContext context) async {
  final directory = Theme.of(context).platform == TargetPlatform.android
      ? (await getExternalStorageDirectories(
          type: StorageDirectory.downloads))[0]
      : await getApplicationDocumentsDirectory();
  return directory.path;
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

class ValueStyle {
  final String value;
  final TextStyle style;

  ValueStyle(this.value, this.style);
}
