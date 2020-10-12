import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/PostData/auth_code_data_pass.dart';
import 'package:flutter_app/PostData/auth_data_pass.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/Auth.dart';
import 'package:flutter_app/models/firebase_notification_handler.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'home_screen.dart';
import 'name_screen.dart';

class CodeScreen extends StatefulWidget {
  CodeScreen({Key key}) : super(key: key);

  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  TextField code1;
  TextField code2;
  TextField code3;
  TextField code4;
  String error = '';
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  String temp1 = '';
  String temp2 = '';
  String temp3 = '';
  String temp4 = '';
  GlobalKey<ButtonState> buttonStateKey = new GlobalKey<ButtonState>();

  void buttonColor() {
    String code = code1.controller.text +
        code2.controller.text +
        code3.controller.text +
        code4.controller.text;
    if (code.length > 0 &&
        buttonStateKey.currentState.color != Color(0xFFFE534F)) {
      buttonStateKey.currentState.setState(() {
        buttonStateKey.currentState.color = Color(0xFFFE534F);
      });
    } else if (code.length == 0 &&
        buttonStateKey.currentState.color != Color(0xFFF3F3F3)) {
      buttonStateKey.currentState.setState(() {
        buttonStateKey.currentState.color = Color(0xFFF3F3F3);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller1.addListener(() {
      if(controller1.text.length > 1){
        if(controller1.text[0] == temp1){
          temp1 = controller1.text[1];
          controller1.text = controller1.text[1];
        }else{
          temp1 = controller1.text[0];
          controller1.text = controller1.text[0];
        }
      }
      else
        temp1 = controller1.text;
    });
    controller2.addListener(() {
      if(controller2.text.length > 1){
        if(controller2.text[0] == temp2){
          temp2 = controller2.text[1];
          controller2.text = controller2.text[1];
        }else{
          temp2 = controller2.text[0];
          controller2.text = controller2.text[0];
        }
      }
      else
        temp2 = controller2.text;
    });
    controller3.addListener(() {
      if(controller3.text.length > 1){
        if(controller3.text[0] == temp3){
          temp3 = controller3.text[1];
          controller3.text = controller3.text[1];
        }else{
          temp3 = controller3.text[0];
          controller3.text = controller3.text[0];
        }
      }
      else
        temp3 = controller3.text;
    });
    controller4.addListener(() {
      if(controller4.text.length > 1){
        if(controller4.text[0] == temp4){
          temp4 = controller4.text[1];
          controller4.text = controller4.text[1];
        }else{
          temp4 = controller4.text[0];
          controller4.text = controller4.text[0];
        }
      }
      else
        temp4 = controller4.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: FutureBuilder<AuthData>(
          future:
          loadAuthData(necessaryDataForAuth.device_id, currentUser.phone),
          builder: (BuildContext context, AsyncSnapshot<AuthData> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: <Widget>[
                  InkWell(
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                                padding: EdgeInsets.only(right: 15, top: 30),
                                child: Container(
                                  width: 40,
                                  height: 60,
                                  child: Center(
                                    child: SvgPicture.asset(
                                        'assets/svg_images/code_cross.svg'),
                                  ),
                                ))),
                      ],
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 40),
                        child: Text('Введите код из смс',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: 180,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: 0, left: 0, bottom: 10),
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                        EdgeInsets.only(left: 7, right: 7),
                                        child: code1 = TextField(
                                            autofocus: true,
                                            focusNode: new FocusNode(),
                                            controller: controller1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 28),
                                            keyboardType: TextInputType.number,
                                            maxLength: 2,
                                            decoration: new InputDecoration(
                                              enabledBorder:
                                              UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFFD6F6D)),
                                              ),
                                              counterText: '',
                                            ),
                                            onChanged: (String value) {
                                              if (value != '') {
                                                code2.focusNode.requestFocus();
                                              }
                                              buttonColor();
                                            }),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                        EdgeInsets.only(left: 7, right: 7),
                                        child: code2 = TextField(
                                            focusNode: new FocusNode(),
                                            controller: controller2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 28),
                                            keyboardType: TextInputType.number,
                                            maxLength: 2,
                                            decoration: new InputDecoration(
                                              enabledBorder:
                                              UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFFD6F6D)),
                                              ),
                                              counterText: '',
                                            ),
                                            onChanged: (String value) {
                                              if (value != '') {
                                                code3.focusNode.requestFocus();
                                              }
                                              if(value.isEmpty){
                                                code1.focusNode.requestFocus();
                                              }
                                              buttonColor();
                                            }),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                        EdgeInsets.only(left: 7, right: 7),
                                        child: code3 = TextField(
                                            focusNode: new FocusNode(),
                                            controller: controller3,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 28),
                                            keyboardType: TextInputType.number,
                                            maxLength: 2,
                                            decoration: new InputDecoration(
                                              enabledBorder:
                                              UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFFD6F6D)),
                                              ),
                                              counterText: '',
                                            ),
                                            onChanged: (String value) {
                                              if (value != '') {
                                                code4.focusNode.requestFocus();
                                              }
                                              if(value.isEmpty){
                                                code2.focusNode.requestFocus();
                                              }
                                              buttonColor();
                                            }),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                        EdgeInsets.only(left: 7, right: 7),
                                        child: code4 = TextField(
                                          onChanged: (String value){
                                            if(value.isEmpty){
                                              code3.focusNode.requestFocus();
                                            }
                                            if(value.length != 0){
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                            }
                                          },
                                          focusNode: new FocusNode(),
                                          controller: controller4,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 28),
                                          keyboardType: TextInputType.number,
                                          maxLength: 2,
                                          decoration: new InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFFD6F6D)),
                                            ),
                                            counterText: '',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 0,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 0, left: 0),
                                child: Text(
                                  error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 0, top: 15),
                              child: new TimerCountDown(codeScreenState: this),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 20, left: 0, right: 0, top: 10),
                              child: Button(
                                key: buttonStateKey,
                                color: Color(0xFFF3F3F3),
                                onTap: () async {
                                  if (await Internet.checkConnection()) {
                                    String temp = '';
                                    temp = code1.controller.text +
                                        code2.controller.text +
                                        code3.controller.text +
                                        code4.controller.text;
                                    authCodeData = await loadAuthCodeData(
                                        necessaryDataForAuth.device_id,
                                        int.parse(temp));
                                    if (authCodeData != null) {
                                      necessaryDataForAuth.phone_number =
                                          currentUser.phone;
                                      necessaryDataForAuth.refresh_token =
                                          authCodeData.refresh_token;
                                      NecessaryDataForAuth.saveData();
                                      await new FirebaseNotifications().setUpFirebase();
                                      if(necessaryDataForAuth.name == null){
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) =>
                                            new NameScreen(),
                                          ),
                                        );
                                      }
                                      else{
                                        homeScreenKey =
                                        new GlobalKey<HomeScreenState>();
                                        currentUser.isLoggedIn = true;
                                        Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) => HomeScreen()),
                                                (Route<dynamic> route) => false);
                                      }
                                    } else {
                                      setState(() {
                                        error = 'Вы ввели неверный смс код';
                                      });
                                    }
                                  } else {
                                    noConnection(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class TimerCountDown extends StatefulWidget {
  TimerCountDown({
    Key key,
    this.codeScreenState,
  }) : super(key: key);
  final _CodeScreenState codeScreenState;

  @override
  TimerCountDownState createState() {
    return new TimerCountDownState(codeScreenState: codeScreenState);
  }
}

class TimerCountDownState extends State<TimerCountDown> {
  TimerCountDownState({this.codeScreenState});

  final _CodeScreenState codeScreenState;
  Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
            _timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_start == 60) {
      startTimer();
    }
    return _start != 0
        ? Center(
      child: Text('Получить новый код можно через $_start c',
          style: TextStyle(
            color: Color(0x97979797),
            fontSize: 13.0,
            letterSpacing: 1.2,
          )),
    )
        : GestureDetector(
      child: Text(
        'Отпарвить код повторно',
        style: TextStyle(),
      ),
      onTap: () {
        codeScreenState.setState(() {});
      },
    );
  }
}

class Button extends StatefulWidget {
  Color color;
  final AsyncCallback onTap;

  Button({Key key, this.color, this.onTap}) : super(key: key);

  @override
  ButtonState createState() {
    return new ButtonState(color, onTap);
  }
}

class ButtonState extends State<Button> {
  String error = '';
  TextField code1;
  TextField code2;
  TextField code3;
  TextField code4;
  Color color;
  final AsyncCallback onTap;

  ButtonState(this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    if(){
//
//    }
    return FlatButton(
      child: Text('Далее',
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colors.white)),
      color: color,
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.only(left: 120, top: 20, right: 120, bottom: 20),
      onPressed: () async {
        if (await Internet.checkConnection()) {
          await onTap();
        } else {
          noConnection(context);
        }
      },
    );
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+]?7)[0-9]{10}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Укажите норер';
    } else if (!regExp.hasMatch(value)) {
      return 'Указан неверный номер';
    }
    return null;
  }
}
