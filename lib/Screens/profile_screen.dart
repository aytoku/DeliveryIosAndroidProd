import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/last_addresses_model.dart';
import 'package:flutter_svg/svg.dart';
import 'auth_screen.dart';
import 'device_id_screen.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameField = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameField.text = necessaryDataForAuth.name;
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Align(
              child: Padding(
                padding: EdgeInsets.only(top: 30, bottom: 25),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        child: Padding(
                            padding: EdgeInsets.only(),
                            child: Container(
                                height: 40,
                                width: 60,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 12, bottom: 12, right: 0),
                                  child: SvgPicture.asset(
                                      'assets/svg_images/arrow_left.svg'),
                                ))),
                        onTap: () async {
                          if (await Internet.checkConnection()) {
                            homeScreenKey = new GlobalKey<HomeScreenState>();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                    (Route<dynamic> route) => false);
                          } else {
                            noConnection(context);
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Ваши данные",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                          EdgeInsets.only(left: 30, top: 0, bottom: 10),
                          child: Text(
                            'Ваше имя',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF8A8A8A)),
                          ),
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 30,
                          child: Padding(
                            padding:
                            EdgeInsets.only(left: 30, right: 0, bottom: 10),
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                  color: Color(0xFF515151), fontSize: 17),
                              controller: nameField,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              onChanged: (value) {
                                necessaryDataForAuth.name = value;
                                NecessaryDataForAuth.saveData();
                              },
                            ),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Divider(height: 1.0, color: Color(0xFFEDEDED)),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                          EdgeInsets.only(left: 30, top: 20, bottom: 15),
                          child: Text(
                            'Номер телефона',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF8A8A8A)),
                          ),
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding:
                            EdgeInsets.only(left: 30, right: 0, bottom: 10),
                            child: GestureDetector(
                              child: Text(
                                necessaryDataForAuth.phone_number,
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xFF515151)),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new AuthScreen(),
                                  ),
                                );
                              },
                            ))),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Divider(height: 1.0, color: Color(0xFFEDEDED)),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, bottom: 30),
                    child: GestureDetector(
                      child: Text(
                        'Выход',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242)),
                      ),
                      onTap: () async {
                        if (await Internet.checkConnection()) {
                          necessaryDataForAuth.refresh_token = null;
                          authCodeData.refresh_token = null;
                          await NecessaryDataForAuth.saveData();
                          await LastAddressesModel.clear();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => DeviceIdScreen()),
                                  (Route<dynamic> route) => false);
                        } else {
                          noConnection(context);
                        }
                      },
                    ),
                  )),
            )
          ],
        ));
  }
}
