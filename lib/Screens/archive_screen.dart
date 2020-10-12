import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ArchiveScreen extends StatefulWidget {
  @override
  ArchiveScreenState createState() => ArchiveScreenState();
}

class ArchiveScreenState extends State<ArchiveScreen> {
  bool status1 = false;

  noConnection(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              height: 50,
              width: 100,
              child: Center(
                child: Text("Нет подключения к интернету"),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 20),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        child: Container(
                            height: 50,
                            width: 60,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 17, bottom: 17, right: 10),
                              child: SvgPicture.asset(
                                  'assets/svg_images/arrow_right.svg'),
                            )),
                        onTap: ()  {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            "Архив",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF424242)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 15, top: 15, left: 15),
                          child: Text(
                            'Обращение от 20.02.20',
                            style:
                            TextStyle(fontSize: 17, color: Color(0xFF424242)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15, top: 15, right: 15),
                          child:
                          Image(image: AssetImage('assets/images/arrow_right.png')),
                        ),
                      ],
                    ),
                    onTap: () async {
//                      if (await Internet.checkConnection()) {
//                        Navigator.push(
//                          context,
//                          new MaterialPageRoute(
//                            builder: (context) => new ServiceChatScreen(),
//                          ),
//                        );
//                      } else {
//                        noConnection(context);
//                      }
                    },
                  )),
              Divider(height: 1.0, color: Colors.grey),
            ],
          ),
        )
    );
  }
}