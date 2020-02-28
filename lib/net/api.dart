import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jeecgboot_app/pages/login_page.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class API {
  static String schema = 'http';
  static String host = '192.168.1.96';
  static int port = 3000;
  static String baseUrl = '$schema://$host:$port/jeecg-boot';
  static String token;
  static BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {"X-Access-Token": token});
  static Dio dio = Dio(options);

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
  static InterceptorsWrapper tokenInterceptor = InterceptorsWrapper(
    onRequest: (RequestOptions options) async {
      print("REQUEST[${options?.method}] => PATH: ${options?.path}");
      return options;
    },
    onResponse: (Response response) async {
      print(
          "RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
      if (response?.statusCode == 500 &&
          response?.data?.message == "Token失效，请重新登录") {
        // 清除token信息
        SharedPreferences.getInstance().then((prefs) {
          prefs.remove('token');
          print("prefs.remove('token')");
        });
        // 跳转到LoginPage
        Navigator.of(MyApp.globalContext).pushNamed(LoginPage.tag);
        dio.reject('Token失效，请重新登录');
      }
      return response;
    },
    onError: (DioError err) async {
      print(
          "ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
      return err;
    },
  );

  // https://stackoverflow.com/questions/12649573/how-do-you-build-a-singleton-in-dart
  // _internal vs _privateConstructor
  API._internal();
  static API _instance;
  static API get instance {
    if (_instance == null) {
      _instance = API._internal();
      // initial interceptor
      print("initial interceptor");
      dio.interceptors.add(tokenInterceptor);
    }
    checkAndSetToken();
    return _instance;
  }

  static checkAndSetToken() async {
    if (options.headers['X-Access-Token'] == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String tokenPref = prefs.getString('token');
      if (tokenPref != null) {
        print("set token: $tokenPref");
        token = tokenPref;
        options.headers['X-Access-Token'] = token;
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
  Future<bool> login(username, password) async {
    try {
      Response response = await dio.post('/sys/simpleLogin',
          data: {'username': username, 'password': password});
      print(response);
      if (response.data['success'] && response.data['result'] != null) {
        token = response.data['result']['token'];
        options.headers['X-Access-Token'] = token;
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('token', token);
          print("prefs.setString('token', $token)");
        });
        return true;
      }
      return false;
    } catch (e) {
      print(e);
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
  Future<List> getXsList(pageNo, pageSize,
      {String column = 'createTime', String order = 'desc'}) async {
    try {
      await checkAndSetToken();
      Response response = await dio.get(
        '/xs/qbSwxszb/list',
        queryParameters: {
          'pageNo': pageNo,
          'pageSize': pageSize,
        },
      );
      if (response.data['success'] && response.data['result'] != null) {
        return response.data['result']['records'];
      }
      return null;
    } catch (e) {
      print(e);
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
  Future<List> getXsFj(id) async {
    try {
      await checkAndSetToken();
      Response response = await dio.get(
        '/xs/qbSwxszb/queryQbSwxszbfjByMainId',
        queryParameters: {'id': id},
      );
      if (response.data['success'] && response.data['result'] != null) {
        return response.data['result'];
      }
      return null;
    } catch (e) {
      print(e);
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
  Future<List> addXs(Map data) async {
    try {
      await checkAndSetToken();
      Response response = await dio.post(
        '/xs/qbSwxszb/add',
        data: data,
      );
      if (response.data['success'] && response.data['result'] != null) {
        return response.data['result'];
      }
      return null;
    } catch (e) {
      print(e);
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
  Future<List> editXs(Map data) async {
    try {
      await checkAndSetToken();
      Response response = await dio.put(
        '/xs/qbSwxszb/edit',
        data: data,
      );
      if (response.data['success'] && response.data['result'] != null) {
        return response.data['result'];
      }
      return null;
    } catch (e) {
      print(e);
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
  Future<List> deleteXs(String id) async {
    try {
      await checkAndSetToken();
      Response response = await dio.delete(
        '/xs/qbSwxszb/delete',
        queryParameters: {
          'id': id,
        },
      );
      if (response.data['success'] && response.data['result'] != null) {
        return response.data['result'];
      }
      return null;
    } catch (e) {
      print(e);
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
  Future<List> upload(filePath) async {
    try {
      await checkAndSetToken();
      Response response = await dio.post('/sys/common/upload',
          data: FormData.fromMap(
              {'isup': 1, "file": await MultipartFile.fromFile(filePath)}));
      if (response.data['success'] && response.data['message'] != null) {
        return response.data['message'];
      }
      return null;
    } catch (e) {
      print(e);
    }
  }

  static String getStaticFilePath(fileName) {
    return '$baseUrl/sys/common/static/$fileName';
  }
}
