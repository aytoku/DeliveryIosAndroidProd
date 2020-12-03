import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/GetData/orders_story_data.dart';
import 'package:flutter_app/Screens/restaurant_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/OrderStoryModel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'orders_details.dart';

class OrdersStoryScreen extends StatefulWidget {
  OrdersStoryScreen({Key key}) : super(key: key);

  @override
  OrdersStoryScreenState createState() => OrdersStoryScreenState();
}

class OrdersStoryScreenState extends State<OrdersStoryScreen> {
  int page = 1;
  int limit = 12;
  bool isLoading = true;
  List<OrdersStoryModelItem> records_items = new List<OrdersStoryModelItem>();

  Widget column(OrdersStoryModelItem ordersStoryModelItem) {
    var format = new DateFormat('HH:mm, dd.MM.yy');
    return Column(
      children: <Widget>[
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Text(ordersStoryModelItem.routes[0].value,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14, color: Color(0xFF000000))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, top: 10, right: 15),
                child: Text(
                  format.format(DateTime.fromMillisecondsSinceEpoch( ordersStoryModelItem.created_at_unix * 1000)),
                  style: TextStyle(fontSize: 12, color: Color(0xFFB0B0B0)),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5, left: 15, bottom: 15),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${ordersStoryModelItem.price + ordersStoryModelItem.tariff.productsPrice - ordersStoryModelItem.tariff.bonusPayment} \₽',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB0B0B0),
                  ),
                ),
              ),
            )
          ],
        ),
        Divider(height: 1.0, color: Color(0xFFF5F5F5)),
      ],
    );
  }

  _buildOrdersStoryItems() {
    List<Widget> restaurantList = [];
    int i = 0;
    GlobalKey<CartItemsQuantityState> cartItemsQuantityKey = new GlobalKey();
    if(records_items == null){
      return Container();
    }else{
      records_items.forEach((OrdersStoryModelItem ordersStoryModelItem) {
        var format = new DateFormat('HH:mm, dd-MM-yy');
        var date = new DateTime.fromMicrosecondsSinceEpoch(
            ordersStoryModelItem.created_at_unix * 1000);
        var time = '';
        time = format.format(date);
        if(ordersStoryModelItem.products!= null && ordersStoryModelItem.products.length > 0){
          restaurantList.add(
            InkWell(
                child: column(ordersStoryModelItem),
                onTap: () async {
                  if (await Internet.checkConnection()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return OrdersDetailsScreen(
                            ordersStoryModelItem: ordersStoryModelItem);
                      }),
                    );
                  } else {
                    noConnection(context);
                  }
                }),
          );
        }
        i++;
      });
    }
    return Column(children: restaurantList);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: FutureBuilder<OrdersStoryModel>(
            future: loadOrdersStoryModel(),
            initialData: null,
            builder: (BuildContext context,
                AsyncSnapshot<OrdersStoryModel> snapshot) {
              print(snapshot.connectionState);
              if (snapshot.hasData) {
                records_items = snapshot.data.ordersStoryModelItems;
                return Column(
                  children: [
                    ScreenTitlePop(img: 'assets/svg_images/arrow_left.svg', title: 'История зазказов',),
                    Divider(height: 1.0, color: Color(0xFFF5F5F5)),
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              NotificationListener<ScrollNotification>(
                                  onNotification: (ScrollNotification scrollInfo) {
                                    if (!isLoading &&
                                        scrollInfo.metrics.pixels ==
                                            scrollInfo.metrics.maxScrollExtent) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                    }
                                  },
                                  child: _buildOrdersStoryItems()),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}