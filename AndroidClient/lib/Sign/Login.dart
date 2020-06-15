import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:myapp/Sign/ParseJsonBody.dart';
import 'package:myapp/Application/App1.dart';
import 'dart:io';
import 'dart:convert';

import 'package:myapp/util/MyToken.dart';
import 'package:myapp/sign/Register.dart';
import 'package:myapp/util/MyHttp.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => new _Login();
}

class _Login extends State<Login> {


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Form表单',
      home: new Scaffold(
        body: new Column(
          children: <Widget>[
            new Container(
                padding: EdgeInsets.only(top: 100.0, bottom: 10.0),
                child: new Text(
                  '单点登陆',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0x4a,0x2b,0x2b), fontSize: 80.0),
                )),
            new Container(
              padding: const EdgeInsets.all(16.0),
              child: new Form(
                key: loginKey,
                autovalidate: true,
                child: new Column(
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                          border: new Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  width: 0.5))),
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          labelText: 'username',
                          labelStyle: new TextStyle(
                              fontSize: 25.0,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          _userName = value;
                        },
                        onFieldSubmitted: (value) {},
                      ),
                    ),
                    new Container(
                      decoration: new BoxDecoration(
                          border: new Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  width: 0.5))),
                      child: new TextFormField(
                        decoration: new InputDecoration(
                            labelText: 'password',
                            labelStyle: new TextStyle(
                                fontSize: 25.0,
                                color: Color.fromARGB(255, 0x63, 0x0a, 0x67)),
                            border: InputBorder.none,
                            suffixIcon: new IconButton(
                              icon: new Icon(
                                showPsd
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              onPressed: showPassWord,
                            )),
                        obscureText: !showPsd,
                        onSaved: (value) {
                          _password = value;
                        },
                      ),
                    ),
                    new Container(
                      height: 45.0,
                      margin: EdgeInsets.only(top: 40.0),
                      child: new SizedBox.expand(
                        child: new RaisedButton(
                          onPressed: login,
                          color: Color.fromARGB(255, 0x6d, 0x8a, 0xc5),
                          child: new Text(
                            '登录',
                            style: TextStyle(
                                fontSize: 40.0,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(45.0)),
                        ),
                      ),
                    ),
                    new Container(
                      height: 45.0,
                      margin: EdgeInsets.only(top: 40.0),
                      child: new SizedBox.expand(
                        child: new RaisedButton(
                          onPressed: register,
                          color: Color.fromARGB(255, 0xf6, 0x63, 0xd8),
                          child: new Text(
                            '注册',
                            style: TextStyle(
                                fontSize: 40.0,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(45.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //获取Key用来获取Form表单组件
  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();
  String _userName;
  String _password;
  bool showPsd = false;
  static MyToken tokenStorage = new MyToken();
  static BaseOptions options = new BaseOptions(
    headers: {HttpHeaders.acceptHeader: "accept: application/json"},
  );
  Dio dio = new Dio(options);

  void register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Register();
    }));
  }

  void showPassWord() {
    setState(() {
      showPsd = !showPsd;
    });
  }

  void login() {
    var loginForm = loginKey.currentState;
    if (loginForm.validate()) {
      loginForm.save();
      if (_userName == null ||
          _userName.isEmpty ||
          _password == null ||
          _password.isEmpty) {
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text('提示'),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[new Text('用户名及密码不能为空')],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('确定'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ).then((val) {});
      } else {
        try {
          var formData = {
            'username': _userName,
            'password': _password,
          };
          var jsonData = jsonEncode(formData);
          MyHttp httpPost = new MyHttp("");
          Future<Response> response =
              httpPost.doPost("http://192.168.0.186:8080/Login/login", jsonData);
          response.then((Response response) {
            ParseJsonBody resBody = ParseJsonBody.fromJson(response.data);
            if (resBody.statuscode == "002") {
              showDialog<Null>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    title: new Text('提示'),
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[new Text('用户不存在')],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text('确定'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ).then((val) {});
            } else if (resBody.statuscode == "003") {
              showDialog<Null>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    title: new Text('提示'),
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[new Text('密码错误')],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text('确定'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ).then((val) {});
            } else if (resBody.statuscode == "200") {
              Future<String> token = tokenStorage.setString(resBody.data);
              token.then((String token) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return App1();
                }));
              });
            } else {
              showDialog<Null>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    title: new Text('提示'),
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[new Text('Loging登录出错，请重试')],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text('确定'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ).then((val) {});
            }
          });
        } catch (e) {
          print(e);
        }
      }
    }
  }


}
