import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jeecgboot_app/model/directive.dart';
import 'package:jeecgboot_app/net/api.dart';

import 'directive_detail_page.dart';

class DirectivePage extends StatefulWidget {
  DirectivePage({Key key}) : super(key: key);

  @override
  _DirectivePageState createState() => _DirectivePageState();
}

class _DirectivePageState extends State<DirectivePage>
    with AutomaticKeepAliveClientMixin {
  List<Directive> directiveList = [];
  bool _loading;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (directiveList == null || directiveList.length == 0) {
      loadData();
    }
  }

  void loadData() async {
    setState(() {
      _loading = true;
    });
    try {
      List<Directive> _directiveList =
          await API.instance.getDirectiveList(context, 1, 1000);
      debugPrint('getDirectiveList: $directiveList');
      setState(() {
        _loading = false;
        directiveList = _directiveList;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('指令办理'),
        centerTitle: true,
        actions: <Widget>[
          RaisedButton.icon(
            onPressed: () async {
              try {
                var result = await API.instance.acceptDirective(context);
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(result),
                ));
              } catch (e) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(e.toString()),
                ));
              }
            },
            icon: Icon(Icons.select_all),
            label: Text('全部签收'),
            color: Theme.of(context).primaryColorDark,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: _loading
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
                    itemCount: directiveList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = directiveList[index];
                      return Card(
                        child: ListTile(
                          leading: ClipRRect(
                            child: Image.asset(
                              'assets/ling.jpg',
                              width: 50,
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.rwbt,
                                  style: TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.keyboard_arrow_right,
                                      color: Colors.blue),
                                  SizedBox(width: 5),
                                  Text(
                                    '${item.fqsj != null ? DateFormat("yyyy-MM-dd HH:mm").format(item.fqsj) : ''}',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black45),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.check, color: Colors.green),
                                  SizedBox(width: 5),
                                  Text(
                                    '${item.jssj != null ? DateFormat("yyyy-MM-dd HH:mm").format(item.jssj) : ''}',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black45),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Text(
                            item.rwzt,
                            style: TextStyle(
                              color: item.rwzt == '待签收'
                                  ? Colors.redAccent.withOpacity(0.5)
                                  : Colors.white,
                            ),
                          ),
                          onTap: () {
                            _handleDetail(context, item);
                          },
                        ),
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
                              child: Icon(Icons.refresh),
                              onPressed: () {
                                _handleRefresh(context);
                              },
                            ),
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

  void _handleDetail(BuildContext context, Directive item) async {
    // navigate to the DirectiveDetailPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DirectiveDetailPage(directive: item),
      ),
    );
  }
}
