import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/my_addresses_model.dart';
import 'package:flutter_svg/svg.dart';
import 'my_addresses_screen.dart';

// ignore: must_be_immutable
class AddMyAddressScreen extends StatefulWidget {
  MyFavouriteAddressesModel myAddressesModel;

  AddMyAddressScreen({Key key, this.myAddressesModel}) : super(key: key);

  @override
  AddMyAddressScreenState createState() =>
      AddMyAddressScreenState(myAddressesModel);
}

class AddMyAddressScreenState extends State<AddMyAddressScreen> {
  bool status1 = false;
  String name;
  MyFavouriteAddressesModel myAddressesModel;

  AddMyAddressScreenState(this.myAddressesModel);

  TextEditingController nameField = new TextEditingController();
  TextEditingController commentField = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameField.text = myAddressesModel.name;
    commentField.text = myAddressesModel.description;
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 25),
                        child: Container(
                            height: 40,
                            width: 60,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 12, bottom: 12, right: 10),
                              child:SvgPicture.asset(
                                  'assets/svg_images/arrow_left.svg'),
                            )))),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              (myAddressesModel.uuid != null && myAddressesModel.uuid != "") ?
              GestureDetector(
                child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 40, right: 15, bottom: 25),
                      child: Text(
                        'Удалить',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242)),
                      ),
                    )),
                onTap: () async {
                  if (await Internet.checkConnection()) {
                    await myAddressesModel.delete();
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (context) => new MyAddressesScreen()),
                            (route) => route.isFirst);
                  } else {
                    noConnection(context);
                  }
                },
              )
                  :
              Container(height: 0,width: 0)
            ],
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 80, left: 20),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Название',
                          style: TextStyle(fontSize: 14, color: Color(0xFF9B9B9B))),
                    ),
                    Container(
                      height: 30,
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 0, right: 20),
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: nameField,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 1.0, color: Color(0xFFEDEDED)),
                  ],
                ),
              )
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 120, left: 0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 30, left: 15, right: 15),
                      child: Text(myAddressesModel.address.unrestrictedValue,
                          style: TextStyle(fontSize: 17, color: Color(0xFF424242))),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, right: 10, bottom: 20, left: 15),
                      child: Text(
                          'г.Владикавказ, республика Северная Осетия-Алания, Россия',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 11, color: Color(0xFF9B9B9B))),
                    ),
                  ),
                  Divider(height: 1.0, color: Color(0xFFEDEDED)),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 230),
              child: TextField(
                controller: commentField,
                textCapitalization: TextCapitalization.sentences,
                decoration: new InputDecoration(
                  hintText: 'Подкажите водителю, как лучше к вам подъехать',
                  hintStyle: TextStyle(color: Color(0xFF9B9B9B), fontSize: 14),
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: FlatButton(
                child: Text(
                  "Сохранить",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                color: Color(0xFFFE534F),
                splashColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding:
                EdgeInsets.only(left: 100, top: 20, right: 100, bottom: 20),
                onPressed: () async {
                  if (await Internet.checkConnection()) {
                    myAddressesModel.tag = "house";
                    myAddressesModel.name = nameField.text;
                    myAddressesModel.description = commentField.text;
                    await myAddressesModel.ifNoBrainsSave();
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (context) => new MyAddressesScreen()),
                            (route) => route.isFirst);
                  } else {
                    noConnection(context);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}