import 'package:flutter/material.dart';
import '../net/api.dart';
import '../utils.dart';
import '../widgets/audio_widget.dart';
import '../widgets/video_widget.dart';

class ClueDetailPage extends StatefulWidget {
  ClueDetailPage({Key key, @required this.clue}) : super(key: key);
  static String tag = 'clue-detail-page';
  final Map clue;

  @override
  _ClueDetailPageState createState() => _ClueDetailPageState();
}

class _ClueDetailPageState extends State<ClueDetailPage> {
  List clueFjList = [];
  bool _loading;

  @override
  void initState() {
    _loading = true;
    // Timer(Duration(milliseconds: 3000), () {
    // });
    API.instance.getXsFj(widget.clue['id']).then((_clueFjList) {
      debugPrint('getXsFj: $clueFjList');
      setState(() {
        _loading = false;
        clueFjList = _clueFjList;
      });
    });
    super.initState();
  }


  Widget getDialogContent(String fileName) {
    MEDIA_TYPE fileType = guessFileType(fileName);
    Widget content;
    String fileUrl = API.getStaticFilePath(fileName);
    switch (fileType) {
      case MEDIA_TYPE.video:
        content = VideoWidget(source: fileUrl);
        break;
      case MEDIA_TYPE.audio:
        content = AudioWidget(source: fileUrl);
        break;
      case MEDIA_TYPE.picture:
        content = Container(
            width: 300,
            height: 300,
            child: Image.network(
              fileUrl,
              fit: BoxFit.cover,
            ));
        break;
      default:
        content = Container(
          width: 300,
          child: FlatButton(
            child: Text(fileName),
            onPressed: () {},
          ),
        );
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    Map clue = widget.clue;
    return Scaffold(
        appBar: AppBar(
          title: Text(clue['xsbt']),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.videocam),
              onPressed: null,
            ),
          ],
        ),
        body: Container(
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
                  itemCount: clueFjList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = clueFjList[index];
                    return Card(
                        child: ListTile(
                            leading: getLeadingIcon(item['wjlj']),
                            title: Text(item['fjmc']),
                            subtitle: Text(item['scsbbm']),
                            onTap: () {
                              Widget content = getDialogContent(item['wjlj']);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MultiMediaDialog(
                                      content: content,
                                    );
                                  });
                            }));
                  },
                ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.play_arrow), onPressed: () async {}));
  }
}
