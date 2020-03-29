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

  Widget buildContent(Clue item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            item.xsbt,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          '地点: ${item.xsddmc ?? ''}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '采集时间: ${item.cjsj != null ? item.cjsj.toString() : ''}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 10),
            Text(
              item.xslx != null ? '类型: ${item.xslx}' : '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Text(
          item.xsxq ?? '',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('线索详情'),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                child: buildContent(clue),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: clueFjList?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = clueFjList[index];
                  return Card(
                      child: ListTile(
                    leading: getLeadingIcon(item.wjlj),
                    title: Text(item.fjmc ?? ''),
                    subtitle: Text(item.scsbbm ?? ''),
                    onTap: () {
                      Widget content = getDialogContent(context, item.wjlj);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MultiMediaDialog(
                            content: content,
                          );
                        },
                      );
                    },
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
