import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_nfc_plugin/models/nfc_event.dart';
import 'package:flutter_nfc_plugin/models/nfc_message.dart';
import 'package:flutter_nfc_plugin/models/nfc_state.dart';
import 'package:flutter_nfc_plugin/nfc_plugin.dart';
import 'package:intl/intl.dart';
import 'package:jeecgboot_app/model/dict_model.dart';
import 'package:jeecgboot_app/pages/clue_page.dart';
import 'package:progress_dialog/progress_dialog.dart';

import './clue_attachment_page.dart';
import '../model/clue.dart';
import '../model/clue_attachment.dart';
import '../net/api.dart';
import '../utils.dart';

class ClueFormPage extends StatefulWidget {
  ClueFormPage({Key key, this.data}) : super(key: key);
  Clue data;
  //static String tag = 'clue-form';

  @override
  _ClueFormPageState createState() => _ClueFormPageState();
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon, this.fileType});
  String title;
  IconData icon;
  FileType fileType;
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(
      title: '添加图片', icon: Icons.add_photo_alternate, fileType: FileType.image),
  CustomPopupMenu(
      title: '添加视频', icon: Icons.video_call, fileType: FileType.video),
  CustomPopupMenu(
      title: '添加音频', icon: Icons.audiotrack, fileType: FileType.audio),
  CustomPopupMenu(title: '添加文件', icon: Icons.note_add, fileType: FileType.any),
];

class _ClueFormPageState extends State<ClueFormPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<ClueAttachment> clueFjList = [];
  List<DictModel> clueXslx = [];
  bool showFjxx = false;

  String nfcState = 'Unknown';
  String nfcError = '';
  String nfcMessage = '';
  String nfcTechList = '';
  String nfcId = '';
  NfcMessage nfcMessageStartedWith;

  NfcPlugin nfcPlugin = NfcPlugin();
  StreamSubscription<NfcEvent> _nfcMesageSubscription;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    if (widget.data.id != null) {
      clueFjList = await API.instance.getXsFj(context, widget.data.id);
    }
    clueXslx = await API.instance.getDictItems(context, 'xs_xslx');

    setState(() {});
  }

  void _onChangeXslx(dynamic value) {
    setState(() {
      showFjxx = value == 'ry' || value == 'cl';
      if (showFjxx) {
        initPlatformState();
      }
    });
  }

  _addAttachement(FileType fileType) {
    return () async {
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
    };
  }

  _saveClue(BuildContext context) async {
    if (_fbKey.currentState.saveAndValidate()) {
      var pr = ProgressDialog(context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: true);
      await pr.show();
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
      await pr.show();
      Navigator.of(context).pop({'result': result});
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.data;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.id != null ? '编辑' : '添加'),
        actions: [
          RaisedButton.icon(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CluePage()),
              );
            },
            icon: Icon(Icons.list),
            label: Text('线索列表'),
            color: Theme.of(context).primaryColorDark,
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
                    decoration: InputDecoration(labelText: "标题"),
                    initialValue: item.xsbt ?? '',
                    validators: [
                      FormBuilderValidators.required(errorText: '线索标题不能为空'),
                      FormBuilderValidators.min(5),
                    ],
                  ),
                  FormBuilderTextField(
                    attribute: "xsddmc",
                    decoration: InputDecoration(labelText: "地点"),
                    initialValue: item.xsddmc ?? '',
                    validators: [
                      FormBuilderValidators.required(errorText: '地点不能为空'),
                      FormBuilderValidators.min(2),
                    ],
                  ),
                  FormBuilderChoiceChip(
                    attribute: "xslx",
                    decoration: InputDecoration(labelText: "类型"),
                    initialValue: item.xslx,
                    validators: [
                      FormBuilderValidators.required(errorText: '线索类型不能为空')
                    ],
                    options: clueXslx
                        .map((item) => FormBuilderFieldOption(
                            value: item.value, child: Text("${item.text}")))
                        .toList(),
                    onChanged: _onChangeXslx,
                  ),
                  showFjxx ? Text('$nfcId') : Container(),
                  showFjxx
                      ? FormBuilderTextField(
                          attribute: "fjxx",
                          decoration: InputDecoration(labelText: "证件/车牌号"),
                          initialValue: item.fjxx ?? '',
                        )
                      : Container(),
                  showFjxx
                      ? FormBuilderTextField(
                          attribute: "sjh",
                          decoration: InputDecoration(labelText: "手机号"),
                          initialValue: item.sjh ?? '',
                        )
                      : Container(),
                  ExpansionTile(
                    title: Text('详细信息'),
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: "xsxq",
                        decoration: InputDecoration(labelText: "详细信息"),
                        initialValue: item.xsxq ?? '',
                        validators: [
                          //FormBuilderValidators.required(),
                          //FormBuilderValidators.min(5),
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: "xsddbh",
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "地址编号"),
                        initialValue: item.xsddbh ?? '',
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
                        decoration: InputDecoration(labelText: "事件编号"),
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
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: choices.map((choice) {
                return Expanded(
                  child: IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(
                      choice.icon,
                      size: 36.0,
                    ),
                    onPressed: _addAttachement(choice.fileType),
                  ),
                );
              }).toList(),
            ),
            Divider(
              height: 10,
            ),
            Text('附件详情',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
            ListView.builder(
              shrinkWrap: true,
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
                      setState(
                        () {
                          clueFjList.remove(item);
                        },
                      );
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
                      },
                    );
                  },
                );
              },
            )
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

  Future<void> initPlatformState() async {
    NfcState _nfcState;

    try {
      _nfcState = await nfcPlugin.nfcState;
      print('NFC state is $_nfcState');
    } on PlatformException {
      print('Method "NFC state" exception was thrown');
    }

    try {
      final NfcEvent _nfcEventStartedWith = await nfcPlugin.nfcStartedWith;
      print('NFC event started with is ${_nfcEventStartedWith.toString()}');
      if (_nfcEventStartedWith != null) {
        setState(() {
          nfcMessageStartedWith = _nfcEventStartedWith.message;
        });
      }
    } on PlatformException {
      print('Method "NFC event started with" exception was thrown');
    }

    if (_nfcState == NfcState.enabled) {
      _nfcMesageSubscription = nfcPlugin.onNfcMessage.listen((NfcEvent event) {
        if (event.error.isNotEmpty) {
          setState(() {
            nfcMessage = 'ERROR: ${event.error}';
            nfcId = '';
          });
        } else {
          setState(() {
            nfcMessage = event.message.payload.toString();
            nfcTechList = event.message.techList.toString();
            nfcId = event.message.id;
          });
        }
      });
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      nfcState = _nfcState.toString();
    });
  }
}
