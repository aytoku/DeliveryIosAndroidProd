import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/CardModel.dart';
import 'AttachCardScreen.dart';
import 'home_screen.dart';

class PaymentsMethodsScreen extends StatefulWidget {
  @override
  PaymentsMethodsScreenState createState() => PaymentsMethodsScreenState();
}

class PaymentsMethodsScreenState extends State<PaymentsMethodsScreen>{
  bool status1 = false;
  GlobalKey<PaymentMethodSelectorState> paymentSelectorKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: FutureBuilder<List<CardModel>>(
        future: CardModel.getCards(),
        builder: (BuildContext context, AsyncSnapshot<List<CardModel>> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: EdgeInsets.only(left: 0, top: 40),
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child:Image(image: AssetImage('assets/images/arrow_left.png')),
                                  )
                              )
                          )
                      ),
                      onTap: (){
                        homeScreenKey = new GlobalKey<HomeScreenState>();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            HomeScreen()), (Route<dynamic> route) => false);
                      },
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50, right: 15),
                            child: Text(
                              'Изменить',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        )
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30, left: 20),
                    child: Text('Способы оплаты',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  ),
                ),
                PaymentMethodSelector(key: paymentSelectorKey, cardModelList: snapshot.data,),
                Container(
                  height: 30,
                  color: Color(0xF3F3F3F3),
                ),
                Align(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                    child: ListTile(
                      title: Text("Добавить карту", style: TextStyle(color: Colors.black),),
                      trailing: Image(image: AssetImage('assets/images/arrow_right.png')),
                      onTap: (){
                        CardModel cardModelItem = new CardModel(number: '', expiration: '', cvv: '', type: CardTypes.visa);
                        snapshot.data.add(cardModelItem);
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new AttachCardScreen(cardModel: cardModelItem),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Divider(height: 1.0, color: Colors.grey),
              ],
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PaymentMethodSelector extends StatefulWidget {
  final List<CardModel> cardModelList;
  PaymentMethodSelector({Key key, this.cardModelList}) : super(key: key);

  @override
  PaymentMethodSelectorState createState() {
    return new PaymentMethodSelectorState(cardModelList: cardModelList);
  }
}

class PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  final List<CardModel> cardModelList;
  PaymentMethodSelectorState({this.cardModelList});
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 200,
      child: ListView.builder(
        itemCount: cardModelList.length + 1,
        itemBuilder: (context, position) {
          if(position >= cardModelList.length){
            return ListTile(
              title: Text('Наличными'),
              //leading: SvgPicture.asset('assets/svg_images/visa.svg'),
              //trailing: position == selectedIndex ? SvgPicture.asset('assets/svg_images/selected_circle.svg') : SvgPicture.asset('assets/svg_images/circle.svg'),
              onTap: (){
                setState(() {
                  selectedIndex = position;
                });
              },
            );
          }
          return ListTile(
              title: Text('${cardModelList[position].number.substring(cardModelList[position].number.length-4)}'),
              //leading: SvgPicture.asset('assets/svg_images/visa.svg'),
              //trailing: position == selectedIndex ? SvgPicture.asset('assets/svg_images/selected_circle.svg') : SvgPicture.asset('assets/svg_images/circle.svg'),
              subtitle: Text(cardModelList[position].expiration.toString()),
              onTap: (){
                setState(() {
                  selectedIndex = position;
                });
              },
          );
        },
      )
    );
  }
}