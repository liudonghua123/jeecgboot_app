import 'dart:async';

import 'package:flutter/material.dart';
import '../net/api.dart';
import './clue_detail_page.dart';

class ClueFragment extends StatefulWidget {
  ClueFragment({Key key}) : super(key: key);
  static String tag = 'clue-fragment';

  @override
  _ClueFragmentState createState() => _ClueFragmentState();
}

class _ClueFragmentState extends State<ClueFragment> {
  List clueList = [];
  bool _loading;

  @override
  void initState() {
    _loading = true;
    // Timer(Duration(milliseconds: 3000), () {
    // });
    API.instance.getXsList(1, 1000).then((_clueList) {
      debugPrint('getXsList: $clueList');
      setState(() {
        _loading = false;
        clueList = _clueList;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: _loading
          // ? LinearProgressIndicator()
          ? new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 75,
                  width: 75,
                  child: CircularProgressIndicator(),
                ),
                Padding(padding: EdgeInsets.all(20)),
                Text(
                  "正在加载中...",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.6)),
                )
              ],
            )
          : ListView.builder(
              itemCount: clueList?.length ?? 0,
              itemBuilder: (context, index) {
                final item = clueList[index];
                return Card(
                  child: ListTile(
                    title: Text(item['xsbt']),
                    subtitle: Text(item['xsxq']),
                    onTap: () {
                      // navigate to the ClueDetailPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClueDetailPage(clue: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
