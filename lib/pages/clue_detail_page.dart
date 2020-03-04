import 'package:flutter/material.dart';
import '../model/clue.dart';
import '../model/clue_attachment.dart';
import '../utils.dart';

class ClueDetailPage extends StatelessWidget {
  ClueDetailPage({Key key, @required this.clue, @required this.clueFjList})
      : super(key: key);
  static String tag = 'clue-detail-page';
  final Clue clue;
  final List<ClueAttachment> clueFjList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(clue.xsbt),
        actions: <Widget>[],
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: clueFjList?.length ?? 0,
            itemBuilder: (context, index) {
              final item = clueFjList[index];
              return Card(
                  child: ListTile(
                      leading: getLeadingIcon(item.wjlj),
                      title: Text(item.fjmc ?? ''),
                      subtitle: Text(item.scsbbm?? '') ,
                      onTap: () {
                        Widget content = getDialogContent(context, item.wjlj);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MultiMediaDialog(
                                content: content,
                              );
                            });
                      }));
            },
          )),
    );
  }
}
