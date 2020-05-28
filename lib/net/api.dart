import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jeecgboot_app/model/dict_model.dart';
import 'package:jeecgboot_app/model/directive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../model/clue.dart';
import '../model/clue_attachment.dart';
import '../model/general_response.dart';
import '../pages/login_page.dart';
import '../pages/welcome_page.dart';

class API {
  static String _apiBaseUrl;
  BaseOptions _options;
  Dio dio;

  handleError(context, err) {
    print('handleError $err');
    // Token失效，重新登录
    if (err?.response?.data != null &&
        err?.response?.data['message'] == "Token失效，请重新登录") {
      SharedPreferences.getInstance().then((prefs) {
        prefs.remove('token');
        print("prefs.remove('token')");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            ModalRoute.withName(WelcomePage.tag));
      });
    }
  }

  // https://stackoverflow.com/questions/12649573/how-do-you-build-a-singleton-in-dart
  // _internal vs _privateConstructor
  API._internal();
  static API _instance;
  static API get instance {
    if (_instance == null) {
      _instance = API._internal();
      API._apiBaseUrl = config.apiBaseUrl;
      print('set _apiBaseUrl to ${API._apiBaseUrl}');
      _instance._options = BaseOptions(
          baseUrl: API._apiBaseUrl,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          headers: {"X-Access-Token": null});
      _instance.dio = Dio(_instance._options);
      /*
        Token invalid 
        {
            "timestamp": "2020-02-27 09:04:38",
            "status": 500,
            "error": "Internal Server Error",
            "message": "Token失效，请重新登录",
            "path": "/jeecg-boot/xs/qbSwxszb/queryQbSwxszbfjByMainId"
        }
      */
      InterceptorsWrapper tokenInterceptor = InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          print("REQUEST[${options?.method}] => PATH: ${options?.path}");
          return options;
        },
        onResponse: (Response response) async {
          print(
              "RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
          return response;
        },
        onError: (DioError err) async {
          if (err?.response?.statusCode == 500 &&
              err?.response?.data['message'] == "Token失效，请重新登录") {
            // 清除token信息
            var prefs = await SharedPreferences.getInstance();
            prefs.remove('token');
            prefs.remove('username');
            print("prefs.remove('token')");
            _instance.dio.reject('Token失效，请重新登录');
          }
          print(
              "ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
          return err;
        },
      );
      // initial interceptor
      print("initial interceptor");
      _instance.dio.interceptors.add(tokenInterceptor);
    }
    _instance.checkAndSetToken();
    return _instance;
  }

  checkAndSetToken() async {
    if (_options.headers['X-Access-Token'] == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String tokenPref = prefs.getString('token');
      if (tokenPref != null) {
        print("set token: $tokenPref");
        _options.headers['X-Access-Token'] = tokenPref;
      }
    }
  }

  /*
    The success return response is
    {
        "success": true,
        "message": "登录成功",
        "code": 200,
        "result": {
            "multi_depart": 1,
            "userInfo": {
                "id": "e9ca23d68d884d4ebb19d07889727dae",
                "username": "admin",
                "realname": "管理员",
                "avatar": "user/20190119/logo-2_1547868176839.png",
                "birthday": "2018-12-05",
                "sex": 1,
                "email": "11@qq.com",
                "phone": "18566666661",
                "orgCode": "A01",
                "status": 1,
                "delFlag": "0",
                "workNo": "111",
                "post": "",
                "telephone": null,
                "createBy": null,
                "createTime": "2038-06-21 17:54:10",
                "updateBy": "admin",
                "updateTime": "2019-11-21 16:39:35",
                "activitiSync": "1",
                "identity": null,
                "departIds": null
            },
            "departs": [{
                "id": "c6d7cb4deeac411cb3384b1b31278596",
                "parentId": "",
                "departName": "北京国炬公司",
                "departNameEn": null,
                "departNameAbbr": null,
                "departOrder": 0,
                "description": null,
                "orgCategory": "1",
                "orgType": "1",
                "orgCode": "A01",
                "mobile": null,
                "fax": null,
                "address": null,
                "memo": null,
                "status": null,
                "delFlag": "0",
                "createBy": "admin",
                "createTime": "2019-02-11 14:21:51",
                "updateBy": "admin",
                "updateTime": "2019-03-22 16:47:19"
            }],
            "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1ODI3Mjc1MjcsInVzZXJuYW1lIjoiYWRtaW4ifQ.f0Wkb0kTNKXPEjlDz_qhGhCeRrhHuvY1lFtVmIhnKsI"
        },
        "timestamp": 1582725727621
    }

    the failure response is
    {
        "success": false,
        "message": "验证码错误",
        "code": 500,
        "result": null,
        "timestamp": 1582724627440
    }
    or
    {
        "success": false,
        "message": "用户名或密码错误",
        "code": 500,
        "result": null,
        "timestamp": 1582725996351
    }  
   */
  Future<bool> login(context, username, password) async {
    try {
      Response response = await dio.post('/sys/simpleLogin',
          data: {'username': username, 'password': password});
      print(response);
      if (response?.data['success']) {
        var _token = response?.data['result']['token'];
        _options.headers['X-Access-Token'] = _token;
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('token', _token);
        prefs.setString('username', username);
        print("prefs.setString('token', $_token)");
        return true;
      }
      return false;
    } catch (e) {
      handleError(context, e);
      throw e;
    }
  }

  /*
    The request is using query string parameter like
    _t: 1582770675
    column: createTime
    order: desc
    field: id,,,xsbt,xsxq,xsddbh,xsddmc,cjsj,cjrbh,xslx,tsxq,swsjbh,action
    pageNo: 1
    pageSize: 10
    The success response is
    {
        "success": true,
        "message": "操作成功！",
        "code": 200,
        "result": {
            "records": [{
                "swsjbh": null,
                "xsddbh": "2392",
                "updateTime": "2020-02-24",
                "cjbmbh": "110",
                "xsxq": "9月23日10名红河民办教师省政府上访，现场无过激行为",
                "zdasjqbxxbh": null,
                "tsxq": null,
                "cjsj": "2019-09-23",
                "wxdj": null,
                "scsj": "2019-09-23",
                "createBy": null,
                "xsbt": "省政府上访人员照片",
                "cjrbh": "151951",
                "createTime": null,
                "updateBy": "admin",
                "xsddmc": "省政府",
                "id": "6513",
                "htbdbj": "N",
                "xslx": null
            }],
            "total": 2,
            "size": 10,
            "current": 1,
            "orders": [],
            "searchCount": true,
            "pages": 1
        },
        "timestamp": 1582726163688
    }
   */
  Future<List<Clue>> getXsList(context, pageNo, pageSize) async {
    try {
      await checkAndSetToken();
      Response response = await dio.get(
        '/xs/qbSwxszb/list',
        queryParameters: {
          'pageNo': pageNo,
          'pageSize': pageSize,
          'column': 'cjsj',
          'order': 'desc'
        },
      );
      if (response?.data['success']) {
        List<dynamic> records = response?.data['result']['records'];
        return records.map((item) => Clue.fromJson(item)).toList();
      }
      return null;
    } catch (e) {
      handleError(context, e);
      throw e;
    }
  }

  Future<List<Clue>> getXsListByRwid(context, rwid, pageNo, pageSize,
      {String column = 'cjsj', String order = 'desc'}) async {
    try {
      await checkAndSetToken();
      Response response = await dio.get(
        '/xs/qbSwxszb/listByRwid',
        queryParameters: {
          'rwid': rwid,
          'pageNo': pageNo,
          'pageSize': pageSize,
        },
      );
      if (response?.data['success']) {
        List<dynamic> records = response?.data['result']['records'];
        return records.map((item) => Clue.fromJson(item)).toList();
      }
      return null;
    } catch (e) {
      handleError(context, e);
      throw e;
    }
  }

  /*
    The request use query string parameter
    id: xxx

    The response is like this
    {
        "success": true,
        "message": "操作成功！",
        "code": 200,
        "result": [{
            "id": "15828104564090",
            "wjlj": "loveyou-cut_1582810462457.mp4",
            "fjmc": "loveyou",
            "fjscsj": null,
            "swxsbh": "6513",
            "scsbbm": "123",
            "createBy": "admin",
            "createTime": "2020-02-27",
            "updateBy": null,
            "updateTime": null
        }, {
            "id": "15828104689741",
            "wjlj": "fine-cut_1582810473855.mp3",
            "fjmc": "fine",
            "fjscsj": null,
            "swxsbh": "6513",
            "scsbbm": "234",
            "createBy": "admin",
            "createTime": "2020-02-27",
            "updateBy": null,
            "updateTime": null
        }, {
            "id": "15828104793522",
            "wjlj": "001-boy_1582810485531.png",
            "fjmc": "body",
            "fjscsj": null,
            "swxsbh": "6513",
            "scsbbm": "345",
            "createBy": "admin",
            "createTime": "2020-02-27",
            "updateBy": null,
            "updateTime": null
        }, {
            "id": "15828104905953",
            "wjlj": "diveintopython_1582810536572.pdf",
            "fjmc": "python",
            "fjscsj": null,
            "swxsbh": "6513",
            "scsbbm": "456",
            "createBy": "admin",
            "createTime": "2020-02-27",
            "updateBy": null,
            "updateTime": null
        }],
        "timestamp": 1582810644035
    }
    */
  Future<List<ClueAttachment>> getXsFj(context, id) async {
    try {
      await checkAndSetToken();
      Response response = await dio.get(
        '/xs/qbSwxszb/queryQbSwxszbfjByMainId',
        queryParameters: {'id': id},
      );
      if (response?.data['success']) {
        List<dynamic> result = response?.data['result'];
        return result.map((item) => ClueAttachment.fromJson(item)).toList();
      }
      return null;
    } catch (e) {
      handleError(context, e);
      throw e;
    }
  }

  /*
    The passed data may like 
    {
        "xsbt": "aaa",
        "xsxq": "bbb",
        "qbSwxszbfjList": [{
            "id": "15827697728270",
            "wjlj": "003-man_1582770116355.png",
            "fjmc": "ddd",
            "scsbbm": "aaa"
        }]
    }
    the result is
    {
        "success": true,
        "message": "添加成功！",
        "code": 200,
        "result": null,
        "timestamp": 1582770122798
    }  
   */
  Future<GeneralResponse> addXs(context, Map data) async {
    try {
      await checkAndSetToken();
      Response response = await dio.post(
        '/xs/qbSwxszb/add',
        data: data,
      );
      if (response?.data['success']) {
        return GeneralResponse.fromJson(response?.data);
      }
      return null;
    } catch (e) {
      handleError(context, e);
      throw e;
    }
  }

  /*
    The request is like
    {
        "swsjbh": null,
        "xsddbh": null,
        "updateTime": null,
        "cjbmbh": null,
        "xsxq": "bbb",
        "zdasjqbxxbh": null,
        "tsxq": null,
        "cjsj": null,
        "wxdj": null,
        "scsj": null,
        "createBy": "admin",
        "xsbt": "aaa",
        "cjrbh": null,
        "createTime": "2020-02-27",
        "updateBy": null,
        "xsddmc": null,
        "id": "1232853366749470722",
        "htbdbj": null,
        "xslx": null,
        "qbSwxszbfjList": [{
            "id": "15827697728270",
            "fjmc": "ddd",
            "scsbbm": "aaa",
            "wjlj": "003-man_1582770116355.png"
        }, {
            "id": "15827702101921",
            "wjlj": "004-girl-1_1582770215893.png",
            "fjmc": "",
            "scsbbm": ""
        }]
    }
    The response is like
    {
        "success": true,
        "message": "编辑成功!",
        "code": 200,
        "result": null,
        "timestamp": 1582770674984
    }
  */
  Future<GeneralResponse> editXs(context, Map data) async {
    try {
      await checkAndSetToken();
      Response response = await dio.put(
        '/xs/qbSwxszb/edit',
        data: data,
      );
      if (response?.data['success']) {
        return GeneralResponse.fromJson(response?.data);
      }
      return null;
    } catch (e) {
      handleError(context, e);
      throw e;
    }
  }

  /*
    The request is using query string parameters
    id: xxxx
    The response is like
    {
        "success": true,
        "message": "删除成功!",
        "code": 200,
        "result": null,
        "timestamp": 1582770846220
    }
   */
  Future<GeneralResponse> deleteXs(context, String id) async {
    try {
      await checkAndSetToken();
      Response response = await dio.delete(
        '/xs/qbSwxszb/delete',
        queryParameters: {
          'id': id,
        },
      );
      if (response?.data['success']) {
        return GeneralResponse.fromJson(response?.data);
      }
      return null;
    } catch (e) {
      handleError(context, e);
      throw e;
    }
  }

  /*
    The request is using Form data
    {
      isup: 1
      file: (binary)
    }
    The result is like 
    {
        "success": true,
        "message": "004-girl-1_1582770215893.png",
        "code": 0,
        "result": null,
        "timestamp": 1582770215893
    }
  */
  Future<GeneralResponse> upload(context, filePath) async {
    try {
      await checkAndSetToken();
      Response response = await dio.post('/sys/common/upload',
          data: FormData.fromMap(
              {'isup': 1, "file": await MultipartFile.fromFile(filePath)}));
      if (response?.data['success'] && response?.data['message'] != null) {
        return GeneralResponse.fromJson(response?.data);
      }
      return null;
    } catch (e) {
      handleError(context, e);
      throw e;
    }
  }

  /*
    The request is using query string parameter like
    _t: 1585459960
    column: createTime
    order: desc
    field: id,,,lclb,rwlb,ybh,fqrbh,mblx,mbbh,rwzt,jsrbh,jssj,clyj,cljg,fqbmbh,mbbmbh,bjsj,fqsj,rwbt,ygdrk,fsyj,lzfs,fkjzsj,fksm,sjfksj,fqcs,action
    pageNo: 1
    pageSize: 10
    The success response is
    {
        "success": true,
        "message": "操作成功！",
        "code": 200,
        "result": {
            "records": [{"jsrbh":"151952","cljg":"接收","fkjzsj":null,"rwzt":"未签收","fqcs":3,"rwlb":"事件信息","jssj":"2018-10-30","mblx":"事件信息","fqsj":"2018-10-25","clyj":null,"updateBy":null,"ygdrk":null,"id":"5054","lclb":"分发","fqrbh":"151951","rwbt":"毛蝌蚪有毒","mbbh":"5060","fqbmbh":"110","lzfs":null,"updateTime":null,"fsyj":null,"fksm":null,"sjfksj":null,"bjsj":null,"createBy":null,"createTime":null,"mbbmbh":"290","sysOrgCode":null,"ybh":"107"}],
            "total": 2,
            "size": 10,
            "current": 1,
            "orders": [],
            "searchCount": true,
            "pages": 1
        },
        "timestamp": 1582726163688
    }
   */
  Future<List<Directive>> getDirectiveList(context, pageNo, pageSize,
      {String column = 'fqsj', String order = 'desc'}) async {
    try {
      await checkAndSetToken();
      Response response = await dio.get(
        '/xs/qbRwlz/list',
        queryParameters: {
          'pageNo': pageNo,
          'pageSize': pageSize,
          'lzfs': 'XSSJZL',
          'column': 'fqsj',
          'order': 'desc',
        },
      );
      if (response?.data['success']) {
        List<dynamic> records = response?.data['result']['records'];
        return records.map((item) => Directive.fromJson(item)).toList();
      }
      return null;
    } catch (e) {
      handleError(context, e);
      throw e;
    }
  }

  /*
    The request is using query string parameter like
    acceptALL: Y
    The success response is
    {"success":true,"message":"任务签收成功!签收[0]条指令","code":200,"result":null,"timestamp":1585460657081}
   */
  Future<String> acceptDirective(context) async {
    try {
      await checkAndSetToken();
      Response response = await dio.post(
        '/xs/qbRwlz/accept',
        queryParameters: {
          'acceptALL': 'Y',
        },
      );
      if (response?.data['success']) {
        return response?.data['message'];
      }
      return null;
    } catch (e) {
      handleError(context, e);
      throw e;
    }
  }

  Future<List<DictModel>> getDictItems(context, String dictCode) async {
    try {
      await checkAndSetToken();
      Response response = await dio.get('/sys/dict/getDictItems/${dictCode}');
      if (response?.data['success']) {
        List<dynamic> records = response?.data['result'];
        return records.map((item) => DictModel.fromJson(item)).toList();
      }
      return null;
    } catch (e) {
      handleError(context, e);
      throw e;
    }
  }

  static String getStaticFilePath(fileName) {
    return '$_apiBaseUrl/sys/common/static/$fileName';
  }
}
