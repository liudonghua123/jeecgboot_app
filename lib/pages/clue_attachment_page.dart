import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jeecgboot_app/model/clue_attachment.dart';
import 'package:multi_media_picker/multi_media_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../model/general_response.dart';
import '../net/api.dart';
import '../widgets/audio_widget.dart';
import '../widgets/video_widget.dart';

class ClueAttachmentPage extends StatefulWidget {
  ClueAttachmentPage({Key key, @required this.fileType}) : super(key: key);
  FileType fileType;

  @override
  _ClueAttachmentPageState createState() => _ClueAttachmentPageState();
}

class _ClueAttachmentPageState extends State<ClueAttachmentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String fjmc;
  String filePathSelected;
  bool isFromGallery = false;

  Widget showFilePreview() {
    if (filePathSelected == null) {
      return FlatButton.icon(
          onPressed: _handleSelectFile,
          icon: Icon(Icons.add),
          label: Text('添加文件'));
    }
    Widget presentationWidget;
    switch (widget.fileType) {
      case FileType.video:
        presentationWidget = VideoWidget(
          source: filePathSelected,
          width: MediaQuery.of(context).size.width,
          height: 300,
          play: false,
        );
        break;
      case FileType.audio:
        presentationWidget = AudioWidget(
            source: filePathSelected,
            width: MediaQuery.of(context).size.width,
            play: false);
        break;
      case FileType.image:
        presentationWidget = Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Image.file(
              File(filePathSelected),
              fit: BoxFit.cover,
            ));
        break;
      default:
        presentationWidget = Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: FlatButton(
            child: Text(filePathSelected),
            onPressed: () {},
          ),
        );
    }
    return presentationWidget;
  }

  _handleSelectFile() async {
    var _filePathSelected = null;
    if (widget.fileType == FileType.image) {
      var medias = await MultiMediaPicker.pickImages(
        source: isFromGallery ? ImageSource.gallery : ImageSource.camera,
        singleImage: true,
      );
      if (medias != null) _filePathSelected = medias[0].path;
    } else if (widget.fileType == FileType.video) {
      var media = await MultiMediaPicker.pickVideo(
        source: isFromGallery ? ImageSource.gallery : ImageSource.camera,
      );
      if (media != null) _filePathSelected = media.path;
    } else {
      _filePathSelected = await FilePicker.getFilePath(type: widget.fileType);
    }
    setState(() {
      filePathSelected = _filePathSelected;
      print('filePathSelected: $filePathSelected');
    });
  }

  _handleAddAttachment() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var pr = ProgressDialog(context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: true);
      try {
        await pr.show();
        GeneralResponse result =
            await API.instance.upload(context, filePathSelected);
        Navigator.of(context).pop(
            ClueAttachment.fromJson({'wjlj': result.message, 'fjmc': fjmc}));
      } catch (e) {} finally {
        await pr.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Center(child: showFilePreview()),
            ),
            SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.text,
                autofocus: false,
                initialValue: '',
                decoration: InputDecoration(
                  hintText: '请输入附件名称',
                  labelText: '附件名称',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                onSaved: (String val) {
                  fjmc = val;
                },
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return '请输入附件名称';
                  }
                  return null;
                },
              ),
            ),
            widget.fileType == FileType.image ||
                    widget.fileType == FileType.video
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('是否从gallery中选择'),
                      Switch(
                        value: isFromGallery,
                        onChanged: (value) => this.setState(() {
                          isFromGallery = value;
                        }),
                      )
                    ],
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            Row(children: <Widget>[
              Expanded(
                  child: RaisedButton.icon(
                      color: Theme.of(context).primaryColor,
                      onPressed: _handleAddAttachment,
                      icon: Icon(Icons.add),
                      label: Text('添加'))),
            ])
          ],
        )),
      ),
    );
  }
}
