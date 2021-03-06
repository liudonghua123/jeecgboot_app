import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';

import '../model/clue.dart';
import '../model/clue_attachment.dart';
import '../utils.dart';

class ClueDetailPage extends StatelessWidget {
  ClueDetailPage({Key key, @required this.clue, @required this.clueFjList})
      : super(key: key);
  static String tag = 'clue-detail-page';
  final Clue clue;
  final List<ClueAttachment> clueFjList;

  Iterable<Widget> buildExtra(BuildContext context, Clue clue) {
    var bdbj = clue.htbdbj == 'Y';
    var widgets = <Widget>[
      Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('智能比对:'),
              SizedBox(width: 5),
              bdbj
                  ? Icon(
                      Icons.check_circle,
                      size: 30.0,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.cancel,
                      size: 30.0,
                      color: Colors.blueGrey,
                    ),
            ],
          ),
          SizedBox(width: 30),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('危险等级:'),
              SizedBox(width: 5),
              buildWxdjAvatar(context, clue.wxdj),
            ],
          ),
        ],
      ),
    ];
    if (clue.htbdbj == "Y") {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Text(
          '比对详情: \n${clue.tsxq}',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ));
    }
    return widgets;
  }

  Widget buildContent(BuildContext context, Clue item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
            '地点: ${item.xsddmc ?? '-'}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                '采集时间: ${item.cjsj != null ? DateFormat("yyyy-MM-dd HH:mm").format(item.cjsj) : '-'}',
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
          buildXsxqHtmlText(context, item),
          // Text(
          //   item.xsxq ?? '',
          //   style: TextStyle(
          //     fontSize: 20,
          //   ),
          // ),
          SizedBox(height: 10),
          ...buildExtra(context, item),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('更多详情...'),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                child: buildContent(context, clue),
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

  buildXsxqHtmlText(BuildContext context, Clue item) {
    return HtmlWidget(item.xsxq ?? '', webView: true);
  }
}
