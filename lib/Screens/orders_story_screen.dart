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
                  '${ordersStoryModelItem.price + ordersStoryModelItem.tariff.productsPrice - ordersStoryModelItem.tariff.bonusPayment} \Р',
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

    return Column(children: restaurantList);
  }

  void _onPressedButton(OrdersStoryModelItem food,
      GlobalKey<CartItemsQuantityState> cartItemsQuantityKey) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
        )),
        context: context,
        builder: (context) {
          return Container(
              height: 450,
              child: Container(
                child: _buildBottomNavigationMenu(food, cartItemsQuantityKey),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                    )),
              ));
        });
  }

  void _deleteButton() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(0),
          topRight: const Radius.circular(0),
        )),
        context: context,
        builder: (context) {
          return Container(
              height: 140,
              child: Container(
                child: _buildDeleteBottomNavigationMenu(),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                    )),
              ));
        });
  }

  Column _buildDeleteBottomNavigationMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Align(
          child: Padding(
            padding: EdgeInsets.only(right: 0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 15),
                    child: Text(
                      'Вы действительно хотите удалить\nданную поездку?',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 30, left: 15),
                          child: GestureDetector(
                            child: Text(
                              'Закрыть',
                              style: TextStyle(fontSize: 17),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 30, right: 15),
                          child: GestureDetector(
                            child: Text(
                              'Удалить заказ',
                              style: TextStyle(fontSize: 17),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildBottomNavigationMenu(OrdersStoryModelItem restaurantDataItems,
      GlobalKey<CartItemsQuantityState> cartItemsQuantityKey) {
    var format = new DateFormat('HH:mm');
    var date = new DateTime.fromMicrosecondsSinceEpoch(
        restaurantDataItems.created_at_unix * 1000);
    var time = '';
    time = format.format(date);
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 15),
            child: Text(
              time,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 15),
              child: Text(
                (restaurantDataItems.store != null)
                    ? restaurantDataItems.routes[0].unrestricted_value
                    : 'Пусто',
                style: TextStyle(
                  fontSize: 17.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 15),
              child: Text(
                (restaurantDataItems.store != null)
                    ? restaurantDataItems.routes[1].unrestricted_value
                    : 'Пусто',
                style: TextStyle(
                  fontSize: 17.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 15),
              child: Text(
                'Заказ',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            )),
        Flexible(
          child: Padding(
              padding: EdgeInsets.only(top: 10, left: 15),
              child: ListView(
                children: List.generate(
                    (restaurantDataItems.products != null)
                        ? restaurantDataItems.products.length
                        : 0, (index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                              '${restaurantDataItems.products[index].number}'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Image(
                            image: AssetImage('assets/images/cross.png'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(restaurantDataItems.products[index].name),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                              '${restaurantDataItems.products[index].price} \Р'),
                        )
                      ],
                    ),
                  );
                }),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
          child: FlatButton(
            child: Center(
              child: Text(
                'Удалить заказ',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0x42424242),
                ),
              ),
            ),
            color: Color(0xF5F5F5F5),
            splashColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.only(left: 10, top: 20, right: 20, bottom: 20),
            onPressed: _deleteButton,
          ),
        )
      ],
    );
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
