import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myapp/sign/Login.dart';
import 'package:myapp/Sign/ParseJsonBody.dart';
import 'package:myapp/util/MyToken.dart';
import 'package:myapp/util/MyHttp.dart';
import 'App1.dart';

class App2 extends StatefulWidget {
  @override
  _App2 createState() => new _App2();
}

class _App2 extends State<App2> {

  @override
  Widget build(BuildContext context) {
    toLogin();
    return MaterialApp(
        title: 'App1',
        home: new Scaffold(
            body: new Column(children: <Widget>[
              new Container(
                  padding: EdgeInsets.only(top: 100.0, bottom: 10.0),
                  child: new Text(
                    'App2',
                    style: TextStyle(
                        color: Color.fromARGB(255,0x4a,0x2b,0x2b), fontSize: 80.0),
                  )),
              new Container(
                  padding: EdgeInsets.only(top: 100.0, bottom: 10.0),
                  child: new Text(
                    '此服务只有管理员才能使用',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0x10, 0x10, 0x10), fontSize: 30.0),
                    textAlign: TextAlign.center,
                  )),
              new Container(
                height: 45.0,
                margin: EdgeInsets.only(top: 100.0),
                child: new SizedBox.expand(
                  child: new RaisedButton(
                    onPressed: changeApp,
                    color: Color.fromARGB(255, 0x6d, 0x8a, 0xc5),
                    child: new Text(
                      'App1',
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
                margin: EdgeInsets.only(top: 20.0),
                child: new SizedBox.expand(
                  child: new RaisedButton(
                    onPressed: logout,
                    color: Color.fromARGB(255, 0xf6, 0x63, 0xd8),
                    child: new Text(
                      '注销',
                      style: TextStyle(
                          fontSize: 40.0,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(45.0)),
                  ),
                ),
              ),
            ])));
  }

  bool hasAccess = false;
  int appType = 2;
  static MyToken myToken = new MyToken();

  void changeApp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return App1();
    }));
  }

  void toLogin() {
    Future<String> token = myToken.getString();
    token.then((String token) {
      MyHttp httpGet = new MyHttp(token);
      httpGet.setServiceType(appType);
      Future<Response> response =
          httpGet.doGet("http://192.168.0.186:8080/JWT/token");
      response.then((Response response) {
        ParseJsonBody resBody = ParseJsonBody.fromJson(response.data);
        if (resBody.statuscode == "001") {
          showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new AlertDialog(
                title: new Text('提示'),
                content: new SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[new Text('Token已失效，前往登录页面')],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('确定'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Login();
                      }));
                    },
                  ),
                ],
              );
            },
          ).then((val) {});
        } else {
          if (resBody.message == "1") {
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text('App1'),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text('good！您拥有此服务权限',
                            style: TextStyle(
                                color: Color.fromARGB(255, 141, 197, 132),
                                fontSize: 30.0))
                      ],
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
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text('App2'),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text('sorry！您的权限不够',
                            style: TextStyle(
                                color: Color.fromARGB(255, 246, 143, 99),
                                fontSize: 30.0))
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('确定'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return App1();
                        }));
                      },
                    ),
                  ],
                );
              },
            ).then((val) {});
          }
        }
      });
    });
  }

  void logout() {
    myToken.setString("null");
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

}
