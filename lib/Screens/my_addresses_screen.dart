import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/my_addresses_model.dart';
import 'package:flutter_svg/svg.dart';
import 'add_my_address_screen.dart';
import 'auto_complete.dart';
import 'home_screen.dart';

class MyAddressesScreen extends StatefulWidget {
  @override
  MyAddressesScreenState createState() => MyAddressesScreenState();
}

class MyAddressesScreenState extends State<MyAddressesScreen> {
  List<MyFavouriteAddressesModel> myAddressesModelList;
  GlobalKey<AutoCompleteDemoState> autoCompleteKey = new GlobalKey();
  bool addressScreenButton = false;

  void _deleteButton(MyFavouriteAddressesModel myAddressesModel) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
            )),
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                child: _buildDeleteBottomNavigationMenu(myAddressesModel),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                    )),
              ));
        });
  }

  _buildDeleteBottomNavigationMenu(MyFavouriteAddressesModel myAddressesModel) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Center(
                      child: Container(
                        width: 67,
                        height: 7,
                        decoration: BoxDecoration(
                            color: Color(0xFFEBEAEF),
                            borderRadius: BorderRadius.all(Radius.circular(11))),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 0, right: 15),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              top: 33,
                              bottom: 0,
                            ),
                            child: SvgPicture.asset('assets/svg_images/mini_black_ellipse.svg'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 3,
                              left: 25,
                              bottom: 5,
                            ),
                            child: AutoComplete(
                              autoCompleteKey, 'Введите адрес дома',
                              onSelected: () async {
                                if (await Internet.checkConnection()) {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(builder: (context) {
                                      myAddressesModel.tag = "house";
                                      myAddressesModel.address = FavouriteAddress.fromInitialAddressModelChild(autoCompleteKey
                                          .currentState.selectedValue);
                                      return new AddMyAddressScreen(
                                          myAddressesModel: myAddressesModel);
                                    }),
                                  );
                                } else {
                                  noConnection(context);
                                }
                              },
                            ),
                          ),
//              Align(
//                alignment: Alignment.topRight,
//                child: Padding(
//                  padding: EdgeInsets.only(right: 80, top: 20, bottom: 20,),
//                  child: Container(
//                    width: 1,
//                    height: 30,
//                    color: Color(0xFFEBEAEF),
//                  ),
//                ),
//              ),
//              Align(
//                alignment: Alignment.topRight,
//                child: Padding(
//                  padding: EdgeInsets.only(right: 15, top: 30, bottom: 20,),
//                  child: Text('Карта'),
//                ),
//              )
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Divider(
                      color: Color(0xFFEDEDED),
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: FutureBuilder<List<MyFavouriteAddressesModel>>(
          future: MyFavouriteAddressesModel.getAddresses(),
          builder: (BuildContext context,
              AsyncSnapshot<List<MyFavouriteAddressesModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              myAddressesModelList = snapshot.data;
              if (myAddressesModelList.length == 0 || addressScreenButton) {
                myAddressesModelList
                    .add(new MyFavouriteAddressesModel(tag: null));
                addressScreenButton = false;
              }
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 0, bottom: 0),
                                  child: Container(
                                      height: 40,
                                      width: 60,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 12, bottom: 12, right: 10),
                                        child: SvgPicture.asset(
                                            'assets/svg_images/arrow_left.svg'),
                                      )))),
                          onTap: () {
                            homeScreenKey = new GlobalKey<HomeScreenState>();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                    (Route<dynamic> route) => false);
                          },
                        ),
                        InkWell(
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 0, top: 0),
                                child: Container(
                                    height: 40,
                                    width: 60,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 12, bottom: 12, right: 15),
                                        child: SvgPicture.asset(
                                            'assets/svg_images/plus.svg')
                                    )),
                              )),
                          onTap: () async {
                            if (await Internet.checkConnection()) {
                              setState(() {
                                addressScreenButton = true;
                              });
                            } else {
                              noConnection(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 30, bottom: 15),
                      child: Text('Мои адреса',
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF424242))),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children:
                      List.generate(myAddressesModelList.length, (index) {
                        if (myAddressesModelList[index].tag ==
                            null) {
                          return Column(
                            children: <Widget>[
                              GestureDetector(
                                  child: Row(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 15, left: 30, bottom: 15),
                                            child: GestureDetector(
                                                child: Row(
                                                  children: <Widget>[
                                                    Image(
                                                      image: AssetImage(
                                                          'assets/images/plus_icon.png'),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        'Добавить адрес дома',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                            Color(0xFF424242)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                onTap: () async {
                                                  if (await Internet
                                                      .checkConnection()) {
                                                    _deleteButton(
                                                        myAddressesModelList[
                                                        index]);
                                                  } else {
                                                    noConnection(context);
                                                  }
                                                })),
                                      ),
                                    ],
                                  )),
                              Divider(height: 1.0, color: Color(0xFFEDEDED)),
                            ],
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, top: 10, bottom: 10),
                                  child: Text(
                                    (myAddressesModelList[index].name != " ") ?
                                    myAddressesModelList[index].name
                                        :
                                    "-",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, top: 10, bottom: 10),
                                    child: Text(
                                        myAddressesModelList[index].address.unrestrictedValue),
                                  ),
                                  onTap: () async {
                                    if (await Internet.checkConnection()) {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) {
                                              return new AddMyAddressScreen(
                                                myAddressesModel:
                                                myAddressesModelList[index],
                                              );
                                            }),
                                      );
                                    } else {
                                      noConnection(context);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
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