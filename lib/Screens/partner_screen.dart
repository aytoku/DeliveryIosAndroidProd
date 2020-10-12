import 'package:flutter/material.dart';
import 'package:flutter_app/models/OwnersModel.dart';

class PartnerScreen extends StatefulWidget {
  final OwnersModel owner;
  PartnerScreen({Key key, this.owner}) : super(key: key);
  @override
  PartnerScreenState createState() => PartnerScreenState(owner);
}

class PartnerScreenState extends State<PartnerScreen>{
  OwnersModel owner;
  PartnerScreenState(this.owner);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40, bottom: 30, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: EdgeInsets.only(),
                            child: Container(
                                width: 20,
                                height: 20,
                                child: Center(
                                  child: Image(image: AssetImage('assets/images/arrow_left.png')),
                                )
                            )
                        )
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 130),
                      child: Text(owner.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold ),),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  '№ ' + owner.id.toString(),
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0x97979797)
                  ),
                ),
              )
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  'ООО “Партнер 1”, 362040, Северная\nОсетия - Алания Респ., г. Владикавказ,\nпросп. Мира, д. 31, ORGN: 111111939',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
              )
            )
          ],
        )
    );
  }
}