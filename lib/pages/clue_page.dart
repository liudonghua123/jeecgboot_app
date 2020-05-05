import 'package:flutter/material.dart';
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
        title: Text('线索'),
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
                  Container(
                      child: ListView.builder(
                    itemCount: clueList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = clueList[index];
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Card(
                          child: ListTile(
                            title: Text(
                              item.xsbt,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              item.xsxq,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                  )),
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
                        )),
                  )
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
}
