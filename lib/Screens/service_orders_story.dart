import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/GetData/orders_story_data.dart';
import 'package:flutter_app/Screens/restaurant_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/OrderStoryModel.dart';
import 'package:flutter_app/models/TicketModel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'cost_error_screen.dart';

class ServiceOrdersStoryScreen extends StatefulWidget {
  final TicketModel ticketModel;

  ServiceOrdersStoryScreen({Key key, this.ticketModel}) : super(key: key);

  @override
  ServiceOrdersStoryScreenState createState() =>
      ServiceOrdersStoryScreenState(ticketModel: ticketModel);
}

class ServiceOrdersStoryScreenState extends State<ServiceOrdersStoryScreen> {
  int page = 1;
  int limit = 12;
  bool isLoading = true;
  List<OrdersStoryModelItem> records_items = new List<OrdersStoryModelItem>();
  final TicketModel ticketModel;

  ServiceOrdersStoryScreenState({this.ticketModel});

  column(OrdersStoryModelItem ordersStoryModelItem) {
    var format = new DateFormat('HH:mm, dd.MM.yy');
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(ordersStoryModelItem.routes[0].value,
                      style: TextStyle(fontSize: 14, color: Color(0xFF000000))),
                ),
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
                  '${ordersStoryModelItem.price + 134} \₽',
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
    }
    records_items.forEach((OrdersStoryModelItem ordersStoryModelItem) {
      var format = new DateFormat('HH:mm, dd-MM-yy');
      var date = new DateTime.fromMicrosecondsSinceEpoch(
          ordersStoryModelItem.created_at_unix * 1000);
      var time = '';
      time = format.format(date);
      if(ordersStoryModelItem.products != null && ordersStoryModelItem.products.length > 0){
        restaurantList.add(
          InkWell(
              child: column(ordersStoryModelItem),
              onTap: () async {
                if (await Internet.checkConnection()) {
                  ticketModel.uuid = ordersStoryModelItem.uuid;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) {
                      return CostErrorScreen(ticketModel: ticketModel);
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
                    Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 10),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              child: Container(
                                  height: 40,
                                  width: 60,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 12, bottom: 12, right: 10),
                                    child: SvgPicture.asset(
                                        'assets/svg_images/arrow_left.svg'),
                                  )
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "История заказов",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3F3F3F)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(height: 1.0, color: Color(0xFFF5F5F5)),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, left: 16, bottom: 10),
                        child: Text('По какому заказу ваше обращение?',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB9B9B9))),
                      ),
                    ),
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