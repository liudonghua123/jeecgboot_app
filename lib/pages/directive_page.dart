import 'package:flutter/material.dart';
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
        title: Text('指令'),
        actions: <Widget>[
          RaisedButton(
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
            child: Text('全部签收'),
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
                        color: item.rwzt == '待签收'
                            ? Colors.redAccent.withOpacity(0.5)
                            : Colors.white,
                        child: ListTile(
                          title: Text(item.rwbt),
                          subtitle: Text(item.rwzt),
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
