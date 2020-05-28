import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import './clue_detail_page.dart';
import './clue_form_page.dart';
import '../model/clue.dart';
import '../net/api.dart';
import '../utils.dart';

class CluePage extends StatefulWidget {
  CluePage({Key key, String this.rwid}) : super(key: key);
  static String tag = 'clue-fragment';
  final String rwid;

  @override
  _CluePageState createState() => _CluePageState();
}

class _CluePageState extends State<CluePage>
    with AutomaticKeepAliveClientMixin {
  List<Clue> clueList = [];
  bool _loading;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (clueList == null || clueList.length == 0) {
      loadData();
    }
  }

  void loadData() async {
    setState(() {
      _loading = true;
    });
    try {
      List<Clue> _clueList = [];
      String rwid = widget.rwid;
      if (rwid == null) {
        _clueList = await API.instance.getXsList(context, 1, 1000);
      } else {
        _clueList = await API.instance.getXsListByRwid(context, rwid, 1, 1000);
      }
      debugPrint('getXsList: $clueList');
      setState(() {
        _loading = false;
        clueList = _clueList;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('线索采集'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: _loading
            // ? LinearProgressIndicator()
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: 75,
                      width: 75,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  Text(
                    "正在加载中...",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ],
              )
            : Stack(
                children: <Widget>[
                  (clueList?.length ?? 0) != 0
                      ? Container(
                          child: ListView.builder(
                            itemCount: clueList?.length,
                            itemBuilder: (context, index) {
                              final item = clueList[index];
                              return Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: Card(
                                  child: ListTile(
                                    trailing: item.fmmtlj != null
                                        ? ClipRRect(
                                            child: Image.network(
                                              '${API.getStaticFilePath(item.fmmtlj)}',
                                              width: 72,
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          )
                                        : null,
                                    title: Text(
                                      item.xsbt == null
                                          ? ""
                                          : (index + 1).toString() +
                                              "．" +
                                              item.xsbt,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.keyboard_arrow_right,
                                                color: Colors.blue),
                                            SizedBox(width: 5),
                                            Text(
                                              '${item.cjsj != null ? DateFormat("yyyy-MM-dd HH:mm").format(item.cjsj) : ''}',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black45),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.rv_hookup,
                                                color: Colors.blueGrey),
                                            Text(
                                              '${item.htbdbj == "Y" ? "已进行智能比对" : "未进行智能比对"}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                        item.htbdbj == "Y"
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.notifications,
                                                      color: Colors.orange),
                                                  buildWxdjText(
                                                      context, item.wxdj),
                                                ],
                                              )
                                            : Icon(Icons.block,
                                                color: Colors.white),
                                      ],
                                    ),
                                    // subtitle: Text(
                                    //   item.xsxq == null ? "" : item.xsxq,
                                    //   maxLines: 1,
                                    //   overflow: TextOverflow.ellipsis,
                                    // ),
                                    onTap: () {
                                      _handleDetail(context, item);
                                    },
                                  ),
                                ),
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: '编辑',
                                    color: Colors.blue,
                                    icon: Icons.edit,
                                    onTap: () => {_handleEdit(context, item)},
                                  ),
                                  IconSlideAction(
                                    caption: '删除',
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () => {_handleDelete(context, item)},
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: Text('线索列表为空'),
                        ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: 'refresh',
                            child: Icon(Icons.refresh),
                            onPressed: () {
                              _handleRefresh(context);
                            },
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          FloatingActionButton(
                            heroTag: 'add',
                            child: Icon(Icons.add),
                            onPressed: () {
                              _handleAdd(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _handleRefresh(BuildContext context) async {
    await loadData();
  }

  void _handleDetail(BuildContext context, Clue item) async {
    // got the detail info
    List clueFjList = await API.instance.getXsFj(context, item.id);
    debugPrint('getXsFj: $clueFjList');
    // navigate to the ClueDetailPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ClueDetailPage(clue: item, clueFjList: clueFjList),
      ),
    );
  }

  void _handleAdd(BuildContext context) async {
    Clue data = Clue();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClueFormPage(data: data)),
    );
    await loadData();
    // Scaffold.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text("$result")));
  }

  void _handleEdit(BuildContext context, Clue item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClueFormPage(data: item)),
    );
    await loadData();
    // Scaffold.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text("$result")));
  }

  void _handleDelete(BuildContext context, Clue item) async {
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        context,
        title: '删除',
        content: '确定删除这一项？',
        onOkButtonPressed: () async {
          // 执行删除操作
          await API.instance.deleteXs(context, item.id);
          // 重新加载列表数据
          await loadData();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget buildWxdjText(BuildContext context, String wxdj) {
    Widget widget;
    switch (wxdj) {
      case 'wxdj_g':
        widget = Text(
          '危险等级: 高',
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              backgroundColor: Colors.red),
        );
        break;
      case 'wxdj_z':
        widget = Text(
          '危险等级: 中',
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              backgroundColor: Colors.yellow),
        );
        break;
      case 'wxdj_d':
        widget = Text(
          '危险等级: 低',
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              backgroundColor: Colors.green),
        );
        break;
      default:
        widget = Text(
          '危险等级: 未知',
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: widget,
    );
  }
}
