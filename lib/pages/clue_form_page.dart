import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../model/clue.dart';
import '../model/clue_attachment.dart';
import '../net/api.dart';
import '../utils.dart';
import './clue_attachment_page.dart';

class ClueFormPage extends StatefulWidget {
  ClueFormPage({Key key, this.data}) : super(key: key);
  Clue data;

  @override
  _ClueFormPageState createState() => _ClueFormPageState();
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});
  String title;
  IconData icon;
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: '添加视频', icon: Icons.music_video),
  CustomPopupMenu(title: '添加音频', icon: Icons.audiotrack),
  CustomPopupMenu(title: '添加图片', icon: Icons.photo),
  CustomPopupMenu(title: '添加文件', icon: Icons.insert_drive_file),
];

class _ClueFormPageState extends State<ClueFormPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<ClueAttachment> clueFjList = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    if (widget.data.id != null) {
      List<ClueAttachment> result = await API.instance.getXsFj(context, widget.data.id);
      setState(() {
        clueFjList = result;
      });
    }
  }

  void _onPopMenuTapped(CustomPopupMenu choice) async {
    print('select $choice');
    setState(() async {
      FileType fileType = FileType.ANY;
      switch (choice.title) {
        case '添加视频':
          fileType = FileType.VIDEO;
          break;
        case '添加音频':
          fileType = FileType.AUDIO;
          break;
        case '添加图片':
          fileType = FileType.IMAGE;
          break;
        default:
      }
      final result = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) {
        return ClueAttachmentPage(
          fileType: fileType,
        );
      }));
      if (result != null) {
        setState(() {
          clueFjList.add(result);
        });
      }
    });
  }

  _saveClue(BuildContext context) async {
    if (_fbKey.currentState.saveAndValidate()) {
      Map data = _fbKey.currentState.value;
      data['qbSwxszbfjList'] = clueFjList;
      var result;
      // 处理时间日期字符串
      if (data['cjsj'] != null) {
        data['cjsj'] = DateFormat('yyyy-MM-dd').format(data['cjsj']);
      }
      if (data['scsj'] != null) {
        data['scsj'] = DateFormat('yyyy-MM-dd').format(data['scsj']);
      }
      if (widget.data.id != null) {
        data['id'] = widget.data.id;
        result = await API.instance.editXs(context, data);
      } else {
        result = await API.instance.addXs(context, data);
      }
      Navigator.of(context).pop({'result': result});
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.data;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.id != null ? '编辑' : '添加'),
        actions: <Widget>[
          PopupMenuButton<CustomPopupMenu>(
            tooltip: '请选择添加文件类型',
            onSelected: _onPopMenuTapped,
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: FlatButton.icon(
                    label: Text(choice.title),
                    icon: Icon(choice.icon),
                    onPressed: null,
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: <Widget>[
            Text('线索信息',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
            FormBuilder(
              key: _fbKey,
              autovalidate: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FormBuilderTextField(
                    attribute: "xsbt",
                    decoration: InputDecoration(labelText: "线索标题"),
                    initialValue: item.xsbt ?? '',
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.min(5),
                    ],
                  ),
                  FormBuilderTextField(
                    attribute: "xsxq",
                    decoration: InputDecoration(labelText: "线索详情"),
                    initialValue: item.xsxq ?? '',
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.min(5),
                    ],
                  ),
                  FormBuilderDropdown(
                    attribute: "xslx",
                    decoration: InputDecoration(labelText: "线索类型"),
                    initialValue: item.xslx ?? '一般',
                    hint: Text('选择线索类型'),
                    validators: [FormBuilderValidators.required()],
                    items: ['非常重要', '重要', '一般']
                        .map((item) =>
                            DropdownMenuItem(value: item, child: Text("$item")))
                        .toList(),
                  ),
                  ExpansionTile(
                    title: Text('线索详细信息'),
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: "xsddbh",
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "地址编号"),
                        initialValue: item.xsddbh ?? '',
                      ),
                      FormBuilderTextField(
                        attribute: "xsddmc",
                        decoration: InputDecoration(labelText: "地址名称"),
                        initialValue: item.xsddmc ?? '',
                      ),
                      FormBuilderDateTimePicker(
                        attribute: "cjsj",
                        inputType: InputType.date,
                        format: DateFormat("yyyy-MM-dd"),
                        decoration: InputDecoration(labelText: "采集时间"),
                        initialValue: item.cjsj,
                      ),
                      FormBuilderDateTimePicker(
                        attribute: "scsj",
                        inputType: InputType.date,
                        format: DateFormat('yyyy-MM-dd'),
                        decoration: InputDecoration(labelText: "上传时间"),
                        initialValue: item.scsj,
                      ),
                      FormBuilderTextField(
                        attribute: "cjrbh",
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "采集人编号"),
                        initialValue: item.cjrbh ?? '',
                      ),
                      FormBuilderTextField(
                        attribute: "cjbmbh",
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "采集部门编号"),
                        initialValue: item.cjbmbh ?? '',
                      ),
                      FormBuilderTextField(
                        attribute: "swsjbh",
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "涉稳事件编号"),
                        initialValue: item.swsjbh ?? '',
                      ),
                      FormBuilderTextField(
                        attribute: "zdasjqbxxbh",
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "信息编号"),
                        initialValue: item.zdasjqbxxbh ?? '',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 10,
            ),
            Text('附件详情',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Card(
                  child: ListView.builder(
                    itemCount: clueFjList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = clueFjList[index];
                      return ListTile(
                          leading: getLeadingIcon(item.wjlj),
                          title: Text(item.fjmc ?? ''),
                          subtitle: Text(item.scsbbm ?? ''),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              setState(() {
                                clueFjList.remove(item);
                              });
                            },
                          ),
                          onTap: () {
                            Widget content = getDialogContent(context, item.wjlj);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return MultiMediaDialog(
                                    content: content,
                                  );
                                });
                          });
                    },
                  ),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _saveClue(context);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
