import 'package:flutter/material.dart';
import 'package:flutter_app/GetData/owners.dart';
import 'package:flutter_app/Screens/partner_screen.dart';
import 'package:flutter_app/models/OwnersModel.dart';

class PartnersScreen extends StatefulWidget {
  @override
  PartnersScreenState createState() => PartnersScreenState();
}

class PartnersScreenState extends State<PartnersScreen>{
  Owners owners;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: FutureBuilder<Owners>(
          future: getOwners(),
          builder: (BuildContext context, AsyncSnapshot<Owners>snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              owners = snapshot.data;
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 40, bottom: 30, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
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
                        ),
                        Flexible(
                          flex: 10,
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Text("Партнеры", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold ),),
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: List.generate(owners.ownersModelList.length, (index){
                        return GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      owners.ownersModelList[index].name
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15, top: 10, bottom: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image(image: AssetImage('assets/images/arrow_right.png')),
                                ),
                              )
                            ],
                          ),
                          onTap: (){
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => new PartnerScreen(owner: owners.ownersModelList[index]),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  )
                ],
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
    );
  }
}