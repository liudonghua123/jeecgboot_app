import 'package:flutter/material.dart';

import '../model/directive.dart';
import '../utils.dart';
import 'clue_page.dart';

class DirectiveDetailPage extends StatelessWidget {
  DirectiveDetailPage({Key key, @required this.directive}) : super(key: key);
  static String tag = 'directive-detail-page';
  final Directive directive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('指令详情'),
        actions: <Widget>[
          RaisedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CluePage(rwid: directive.id),
                ),
              );
            },
            child: Text('查看相关线索'),
            color: Theme.of(context).primaryColorDark,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ...buildContent(directive),
          ],
        ),
      ),
    );
  }

  Iterable<Widget> buildContent(Directive item) {
    var commonStyle = TextStyle(fontWeight: FontWeight.w500);
    var importantStyle =
        TextStyle(fontWeight: FontWeight.w500, color: Colors.red);
    var lessImportantStyle =
        TextStyle(fontWeight: FontWeight.w500, color: Colors.red);
    var data = <String, ValueStyle>{
      '任务标题': ValueStyle(item.rwbt ?? '', commonStyle),
      '任务状态': ValueStyle(item.rwzt ?? '', commonStyle),
      '发起时间': ValueStyle(
          item.fqsj != null ? item.fqsj.toString() : '', commonStyle),
      '接收时间': ValueStyle(
          item.jssj != null ? item.jssj.toString() : '', commonStyle),
      '处理结果': ValueStyle(item.cljg ?? '', commonStyle),
      '反馈截止时间': ValueStyle(
          item.fkjzsj != null ? item.fkjzsj.toString() : '', importantStyle),
      '实际反馈时间': ValueStyle(item.sjfksj != null ? item.sjfksj.toString() : '',
          lessImportantStyle),
      '指令参数': ValueStyle(item.fqcs.toString(), commonStyle),
      '发送意见': ValueStyle(item.fsyj ?? '', commonStyle),
    };
    return data.entries.map((_item) => Row(
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Text(
                _item.key,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                _item.value.value,
                style: _item.value.style,
              ),
            ),
          ],
        ));
  }
}
