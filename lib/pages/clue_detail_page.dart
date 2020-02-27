import 'package:flutter/material.dart';

class ClueDetailPage extends StatefulWidget {
  ClueDetailPage({Key key, @required Map this.clue}) : super(key: key);
  static String tag = 'clue-detail-page';
  final Map clue;

  @override
  _ClueDetailPageState createState() => _ClueDetailPageState();
}

class _ClueDetailPageState extends State<ClueDetailPage> {
  @override
  Widget build(BuildContext context) {
    Map clue = widget.clue;
    return Scaffold(
        appBar: AppBar(
          title: Text(clue['xsbt']),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(clue['xsxq']),
        ));
  }
}
