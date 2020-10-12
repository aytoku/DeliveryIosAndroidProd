import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/GetData/getImage.dart';
import 'package:flutter_app/GetData/getOrder.dart';
import 'package:flutter_app/GetData/getTicketByFilter.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/PostData/chat.dart';
import 'package:flutter_app/GetData/orders_story_data.dart';
import 'package:flutter_app/PostData/restaurant_data_pass.dart';
import 'package:flutter_app/Screens/orders_details.dart';
import 'package:flutter_app/Screens/profile_screen.dart';
import 'package:flutter_app/Screens/restaurant_screen.dart';
import 'package:flutter_app/Screens/service_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/ChatHistoryModel.dart';
import 'package:flutter_app/models/OrderStoryModel.dart';
import 'package:flutter_app/models/QuickMessagesModel.dart';
import 'package:flutter_app/models/TicketModel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_app/models/ResponseData.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth_screen.dart';
import 'infromation_screen.dart';
import 'my_addresses_screen.dart';
import 'orders_story_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super(key: homeScreenKey);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  List<OrderChecking> orderList;
  int page = 1;
  int limit = 12;
  bool isLoading = true;
  List<Records> records_items = new List<Records>();
  String category;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<BasketButtonState> basketButtonStateKey = new GlobalKey<BasketButtonState>();
  bool _color;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _color = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('darova' + state.toString());
    if(state == AppLifecycleState.resumed){
      setState(() {

      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _buildNearlyRestaurant() {
    List<Widget> restaurantList = [];
    records_items.forEach((Records restaurant) {
      restaurantList.add(GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.0, // soften the shadow
                    spreadRadius: 3.0, //extend the shadow
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(width: 1.0, color: Colors.grey[200])),
            child: Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0)),
                    child: Hero(
                        tag: restaurant.uuid,
                        child: Image.network(
                          getImage(restaurant.image),
                          height: 200.0,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ))),
                Container(
                  margin: EdgeInsets.only(left: 15.0, top: 12, bottom: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          restaurant.name,
                          style: TextStyle(
                              fontSize: 21.0,
                              color: Color(0xFF3F3F3F),
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            (restaurant.order_preparation_time_second != null)? '~' + '${restaurant.order_preparation_time_second ~/ 60} мин' : '',
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              (restaurant.destination_points != null)
                                  ? restaurant.destination_points[0].type
                                  : ' ',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3F3F3F),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          onTap: () async {
            if (await Internet.checkConnection()) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
//                    if(currentUser.cartDataModel.cart.length > 0 && currentUser.cartDataModel.cart[0].restaurant.uuid != restaurant.uuid){
//                      currentUser.cartDataModel.cart.clear();
//                    }
                  return RestaurantScreen(restaurant: restaurant);
                }),
              );
            } else {
              noConnection(context);
            }
            print(await Internet.checkConnection());
          }));
    });
    return Column(children: restaurantList);
  }

  List<Widget> getSideBarItems(bool isLogged) {
    List<Widget> allSideBarItems = [
      ListTile(
        title: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            'Инфоромация',
            style: TextStyle(
                fontSize: 17, color: Color(0xFF424242), letterSpacing: 0.45),
          ),
        ),
        onTap: () async {
          if (await Internet.checkConnection()) {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new InformationScreen(),
              ),
            );
          } else {
            noConnection(context);
          }
        },
      ),
    ];

    if (isLogged) {
      allSideBarItems.insertAll(0, [
        Padding(
          padding: EdgeInsets.only(top: 60),
          child: InkWell(
            child: ListTile(
              title: Text(
                necessaryDataForAuth.name ?? ' ',
                style: TextStyle(
                    color: Color(0xFF424242),
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              subtitle: Text(
                necessaryDataForAuth.phone_number ?? ' ',
                style: TextStyle(color: Color(0x9B9B9B9B), fontSize: 14),
              ),
              trailing: GestureDetector(
                child: SvgPicture.asset(
                    'assets/svg_images/pencil.svg'),
              ),
            ),
            onTap: () async {
              if (await Internet.checkConnection()) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new ProfileScreen(),
                  ),
                );
              } else {
                noConnection(context);
              }
            },
          ),
        ),
//              ListTile(
//                title: Text('Способы оплаты'),
//                onTap: (){
//                  Navigator.push(
//                    context,
//                    new MaterialPageRoute(
//                      builder: (context) => new PaymentsMethodsScreen(),
//                    ),
//                  );
//                },
//              ),
        ListTile(
          title: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              'История заказов',
              style: TextStyle(
                  fontSize: 17, color: Color(0xFF424242), letterSpacing: 0.45),
            ),
          ),
          onTap: () async {
            if (await Internet.checkConnection()) {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new OrdersStoryScreen(),
                ),
              );
            } else {
              noConnection(context);
            }
          },
        ),
        ListTile(
          title: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              'Мои адреса',
              style: TextStyle(
                  fontSize: 17, color: Color(0xFF424242), letterSpacing: 0.45),
            ),
          ),
          onTap: () async {
            if (await Internet.checkConnection()) {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new MyAddressesScreen(),
                ),
              );
            } else {
              noConnection(context);
            }
          },
        ),
        ListTile(
          title: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Stack(
                children: [
                  Text(
                    'Служба поддержки',
                    style: TextStyle(
                        fontSize: 17, color: Color(0xFF424242), letterSpacing: 0.45),
                  ),
//                FutureBuilder(
//                  future: TicketsList.hasNewMessage(),
//                  builder: (BuildContext context, AsyncSnapshot snapshot) {
//                    if(snapshot.connectionState == ConnectionState.done && snapshot.data != null && snapshot.data){
//                      return Align(
//                        alignment: Alignment.topRight,
//                        child: Padding(
//                          padding: EdgeInsets.only(right: 90, bottom: 2),
//                          child: SvgPicture.asset('assets/svg_images/chat_circle.svg'),
//                        ),
//                      );
//                    }
//                    return Container(height: 0);
//                  },
//                ),
                ],
              )
          ),
          onTap: () async {
            if (await Internet.checkConnection()) {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new ServiceScreen(),
                ),
              );
            } else {
              noConnection(context);
            }
          },
        ),
//              ListTile(
//                title: Text('Настройки'),
//                onTap: (){
//                  Navigator.push(
//                    context,
//                    new MaterialPageRoute(
//                      builder: (context) => new SettingsScreen(),
//                    ),
//                  );
//                },
//              ),
      ]);
    } else {
      allSideBarItems.insert(
          0,
          Padding(
            padding: EdgeInsets.only(top: 60),
            child: ListTile(
                title: InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      'Авторизоваться',
                      style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF424242),
                          letterSpacing: 0.45),
                    ),
                  ),
                  onTap: () async {
                    if (await Internet.checkConnection()) {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new AuthScreen(),
                        ),
                      );
                    } else {
                      noConnection(context);
                    }
                  },
                )),
          ));
    }
    return allSideBarItems;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
          child: Drawer(
            child: ListView(
              children: getSideBarItems(currentUser.isLoggedIn),
            ),
          ),
        ),
        body: FutureBuilder<DeliveryResponseData>(
            future: loadRestaurant(page, limit),
            initialData: null,
            builder: (BuildContext context,
                AsyncSnapshot<DeliveryResponseData> snapshot) {
              print(snapshot.connectionState);
              if (snapshot.hasData) {
                if (page == 1) {
                  this.records_items.clear();
                }
                if (snapshot.data.records_count == 0) {
                  return Center(
                    child: Text('Нет товаров данной категории'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  records_items.addAll(snapshot.data.records);
                  isLoading = false;
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoading &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      if (snapshot.data.records_count - (page + 1) * limit >
                          (-1) * limit) {
                        // snapshot = null;
                        setState(() {
                          isLoading = true;
                          page++;
                        });
                      }
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 0, left: 0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 0,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: InkWell(
                                  child: Container(
                                      height: 40,
                                      width: 60,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 12, bottom: 12, right: 0),
                                          child: SvgPicture.asset(
                                              'assets/svg_images/menu.svg')
                                      )),
                                  onTap: () {
                                    _scaffoldKey.currentState.openDrawer();
                                  },
                                ),
                              ),
                            ),
//                          Flexible(
//                            flex: 5,
//                            child: Padding(
//                              padding: EdgeInsets.only(left: 50,),
//                              child: GestureDetector(
//                                  child: Text(
//                                    'Указать адрес доставки',
//                                    style: TextStyle(
//                                        color: Colors.redAccent,
//                                        decoration: TextDecoration.underline,
//                                        fontSize: 14
//                                    ),
//                                  )
//                              ),
//                            ),
//                          ),
//                          Flexible(
//                            flex: 2,
//                            child: Padding(
//                              padding: EdgeInsets.only(left: 50),
//                              child: GestureDetector(
//                                child: SvgPicture.asset('assets/svg_images/search.svg')
//                              ),
//                            ),
//                          ),
                          ],
                        ),
                      ),
//                      GestureDetector(
//                        child: Container(
//                          color: Colors.red,
//                          height: 60,
//                          width: 100,
//                          child: Text('asdasd'),
//                        ),
//                        onTap: ()async {
//                          await getOrder('b24d27f6-2c70-468c-a234-2509a96deccd');
//                          //launch("tel://+79187072154");
//                        },
//                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: <Widget>[
                            FutureBuilder<List<OrderChecking>>(
                              future: OrderChecking.getActiveOrder(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<OrderChecking>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                    snapshot.data != null &&
                                    snapshot.data.length > 0) {
                                  orderList = snapshot.data;
                                  return (currentUser.isLoggedIn)
                                      ? Container(
                                    height: 230,
                                    child: ListView(
                                      children: snapshot.data,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  ) : Container(
                                    height: 0,
                                  );
                                } else {
                                  orderList = null;
                                  return Center(
                                    child: Container(
                                      height: 0,
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text('Все рестораны',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Color(0xFF3F3F3F),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      )),
                                ),
                              ],
                            ),
                            _buildNearlyRestaurant()
                          ],
                        ),
                      ),
                      (currentUser.cartDataModel.cart != null &&
                          currentUser.cartDataModel.cart.length != 0)
                          ? BasketButton(
                        key: basketButtonStateKey,
                        restaurant:
                        currentUser.cartDataModel.cart[0].restaurant,
                      )
                          : Visibility(
                        child: Container(height: 80),
                        visible: false,
                      )
                    ],
                  ),
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

class OrderChecking extends StatefulWidget {
  OrdersStoryModelItem ordersStoryModelItem;

  OrderChecking({Key key, this.ordersStoryModelItem}) : super(key: key);
  static var state_array = [
    'waiting_for_confirmation',
    'cooking',
    'offer_offered',
    'smart_distribution',
    'finding_driver',
    'offer_rejected',
    'order_start',
    'on_place',
    'on_the_way',
    'order_payment'
  ];

  @override
  OrderCheckingState createState() {
    return new OrderCheckingState(ordersStoryModelItem);
  }

  static Future<List<OrderChecking>> getActiveOrder() async {
    List<OrderChecking> activeOrderList = new List<OrderChecking>();
    OrdersStoryModel ordersStoryModel = await loadOrdersStoryModel();
    orderCheckingStates.clear();
    ordersStoryModel.ordersStoryModelItems
        .forEach((OrdersStoryModelItem element) {
      if (state_array.contains(element.state)) {
        print(element.uuid);
        GlobalKey<OrderCheckingState> key = new GlobalKey<OrderCheckingState>();
        orderCheckingStates[element.uuid] = key;
        activeOrderList.add(new OrderChecking(
          ordersStoryModelItem: element,
          key: key,
        ));
      }
    });
    return activeOrderList;
  }
}

class OrderCheckingState extends State<OrderChecking> with AutomaticKeepAliveClientMixin {
  OrdersStoryModelItem ordersStoryModelItem;
  @override
  bool get wantKeepAlive => true;

  OrderCheckingState(this.ordersStoryModelItem);

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Container(
                height: 210,
                width: 315,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                      child: Text(
                        'Кому вы хотите позвонить?',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF424242)),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                      child: Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20, left: 15),
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                    'assets/svg_images/call_to_restaurant.svg'),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'В заведение',
                                    style: TextStyle(
                                        fontSize: 17, color: Color(0xFF424242)),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      onTap: () {
                        launch("tel://" + ordersStoryModelItem.store.phone);
                      },
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                      child: Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20, left: 15),
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                    'assets/svg_images/call_to_driver.svg'),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Водителю',
                                    style: TextStyle(
                                        fontSize: 17, color: Color(0xFF424242)),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      onTap: () {
                        launch("tel://" + ordersStoryModelItem.driver.phone);
                      },
                    )
                  ],
                )),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var processing = ['waiting_for_confirmation'];
    var cooking_state = [
      'cooking',
      'offer_offered',
      'smart_distribution',
      'finding_driver',
      'offer_rejected',
      'order_start',
      'on_place'
    ];
    var in_the_way = ['on_the_way'];
    var take = ['order_payment'];
    //return Text('Ваш заказ из ' + (ordersStoryModelItem.store != null ? ordersStoryModelItem.store.name : 'Пусто'),);
    if (!OrderChecking.state_array.contains(ordersStoryModelItem.state)) {
      return Container();
    }
    print('ALO RABOTAI SUKA' + '' + ordersStoryModelItem.own_delivery.toString());
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0, // soften the shadow
                spreadRadius: 3.0, //extend the shadow
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(17.0),
            border: Border.all(width: 1.0, color: Colors.grey[200])),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        child: Text(
                          'Ваш заказ из ' +
                              (ordersStoryModelItem.store != null
                                  ? ordersStoryModelItem.store.name
                                  : 'Пусто'),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10, left: 20, top: 0),
                      child: InkWell(
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(44)),
                              color: Color(0xF6F6F6F6)),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 7, bottom: 0),
                              child: Text(
                                'Заказ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) {
                              return OrdersDetailsScreen(
                                  ordersStoryModelItem: ordersStoryModelItem);
                            }),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: (in_the_way
                  .contains(ordersStoryModelItem.state)) ? Padding(
                padding: EdgeInsets.only(right: 170, bottom: 8),
                child: Text(ordersStoryModelItem.driver.color + ' ' + ordersStoryModelItem.driver.car + ' ' + ordersStoryModelItem.driver.reg_number,
                  style: TextStyle(color: Color(0xFF000000), fontSize: 16),),
              ) : Container(height: 0),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            color: (processing
                                .contains(ordersStoryModelItem.state))
                                ? Color(0xFF4DC3E9)
                                : Color(0xF6F6F6F6)),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: (processing
                                  .contains(ordersStoryModelItem.state))
                                  ? SvgPicture.asset(
                                  'assets/svg_images/white_clock.svg')
                                  : SvgPicture.asset(
                                  'assets/svg_images/clock.svg'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text('Обработка',
                                  style: (processing
                                      .contains(ordersStoryModelItem.state))
                                      ? TextStyle(
                                      color: Colors.white, fontSize: 10)
                                      : TextStyle(
                                      color: Color(0x42424242),
                                      fontSize: 10)),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            color: (cooking_state
                                .contains(ordersStoryModelItem.state))
                                ? Color(0xFF51ca64)
                                : Color(0xF6F6F6F6)),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: (cooking_state
                                  .contains(ordersStoryModelItem.state))
                                  ? SvgPicture.asset(
                                  'assets/svg_images/white_bell.svg')
                                  : SvgPicture.asset(
                                  'assets/svg_images/bell.svg'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text('Готовится',
                                  style: (cooking_state
                                      .contains(ordersStoryModelItem.state))
                                      ? TextStyle(
                                      color: Colors.white, fontSize: 10)
                                      : TextStyle(
                                      color: Color(0x42424242),
                                      fontSize: 10)),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            color: Color(0xF6F6F6F6)),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: (in_the_way
                                  .contains(ordersStoryModelItem.state))
                                  ? SvgPicture.asset(
                                  'assets/svg_images/light_car.svg')
                                  : SvgPicture.asset(
                                  'assets/svg_images/car.svg'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text('В пути',
                                  style: (in_the_way
                                      .contains(ordersStoryModelItem.state))
                                      ? TextStyle(
                                      color: Colors.black, fontSize: 10)
                                      : TextStyle(
                                      color: Color(0x42424242),
                                      fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            color: (take.contains(ordersStoryModelItem.state))
                                ? Color(0xFFFE534F)
                                : Color(0xF6F6F6F6)),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: (take.contains(ordersStoryModelItem.state))
                                  ? SvgPicture.asset(
                                  'assets/svg_images/white_ready.svg')
                                  : SvgPicture.asset(
                                  'assets/svg_images/ready.svg'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text('Заберите',
                                  style: (take
                                      .contains(ordersStoryModelItem.state))
                                      ? TextStyle(
                                      color: Colors.white, fontSize: 10)
                                      : TextStyle(
                                      color: Color(0x42424242),
                                      fontSize: 10)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            (in_the_way.contains(ordersStoryModelItem.state) && ordersStoryModelItem.own_delivery != null && ordersStoryModelItem.own_delivery) ? Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Text('Доставку осуществляет курьер от заведения',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14
                ),
              )
            ) :
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, right: 30, left: 10),
                        child: (in_the_way.contains(ordersStoryModelItem.state))
                            ? Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(11)),
                              border: Border.all(color: Color(0xFF45C64E)),
                              color: Colors.white),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 5, right: 10, bottom: 5, left: 10),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SvgPicture.asset(
                                    'assets/svg_images/phone.svg'),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Позвонить',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                            : Container(),
                      ),
                      onTap: () {
                        showAlertDialog(context);
                      },
                    )),
                Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 10),
                        child: (in_the_way.contains(ordersStoryModelItem.state)) ? Container(
                          width: 130,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(11)),
                              color: Color(0xFF45C64E)),
                          child: Padding(
                            padding: EdgeInsets.only(top: 5, right: 10, bottom: 5, left: 10),
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: SvgPicture.asset('assets/svg_images/chat.svg'),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 20, top: 2),
                                    child: Text(
                                      'Чат',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                                FutureBuilder(future: ordersStoryModelItem.hasNewMessage(),
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if(snapshot.connectionState == ConnectionState.done && snapshot.data){
                                      return Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 65, bottom: 2),
                                          child: SvgPicture.asset('assets/svg_images/chat_circle.svg'),
                                        ),
                                      );
                                    }
                                    return Container(height: 0);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ) : Container(),
                      ),
                      onTap: (){
                        Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new ChatScreen(order_uuid: ordersStoryModelItem.uuid, key: chatKey),
                          ),
                        );
                      },
                    )
                ),
              ],
            )
          ],
        ));
  }
}

class RestaurantsCategory extends StatefulWidget {
  RestaurantsCategory({Key key}) : super(key: key);

  @override
  RestaurantsCategoryState createState() {
    return new RestaurantsCategoryState();
  }
}

class RestaurantsCategoryState extends State<RestaurantsCategory> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: Color(0xF6F6F6F6)),
            child: Padding(
                padding:
                EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Text(
                  'Популярное',
                  style: TextStyle(color: Color(0x42424242), fontSize: 15),
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: Color(0xF6F6F6F6)),
            child: Padding(
                padding:
                EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Text(
                  'Фаст-фуд',
                  style: TextStyle(color: Color(0x42424242), fontSize: 15),
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: Color(0xF6F6F6F6)),
            child: Padding(
                padding:
                EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Text(
                  'Фаст-фуд',
                  style: TextStyle(color: Color(0x42424242), fontSize: 15),
                )),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  String order_uuid;

  ChatScreen({Key key, this.order_uuid}) : super(key: key);

  @override
  ChatScreenState createState() {
    return new ChatScreenState(order_uuid);
  }
}

class ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  List<ChatMessageScreen> chatMessageList;
  String order_uuid;

  ChatScreenState(this.order_uuid);

  TextEditingController messageField = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      setState(() {

      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  buildChat() {
    List<String> messagedUuid = new List<String>();
    chatMessageList.forEach((element) {
      if (element.chatMessage.to == 'client' &&
          element.chatMessage.ack == false) {
        element.chatMessage.ack = true;
        messagedUuid.add(element.chatMessage.uuid);
      }
    });
    if (messagedUuid.length > 0) {
      Chat.readMessage(messagedUuid);
    }
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Чат с водителем',
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF424242)),
                ),
              )),
          leading: InkWell(
            child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 15, top: 0),
                    child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 20, right: 0),
                          child: Image(image: AssetImage('assets/images/arrow_left.png'),),
                        )))),
            onTap: () {
              Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                  builder: (context) => new HomeScreen(),
                ),
              );
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: MediaQuery.of(context).viewInsets.left,
              right: MediaQuery.of(context).viewInsets.right,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: chatMessageList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return chatMessageList[index];
                            },
                            //chatMessageList
                          ),
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 60,
                            child: QuickMessageScreen(
                              messageField: messageField,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 65, bottom: 20, right: 15, left: 15),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10, top: 0),
                                        child: Container(
                                          height: 34,
                                          child: TextField(
                                            controller: messageField,
                                            decoration: new InputDecoration(
                                              contentPadding: EdgeInsets.only(bottom: 5, left: 10, right: 15),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: const BorderRadius.all(
                                                    const Radius.circular(15.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFC8C7CC)
                                                  )
                                              ),
                                              border: new OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(
                                                  const Radius.circular(15.0),
                                                ),
                                              ),
                                            ),
//                            decoration: InputDecoration(
//                              suffix: GestureDetector(
//                                child: SvgPicture.asset(
//                                    'assets/svg_images/send_message.svg'),
//                                onTap: () async {
//                                  if (await Internet.checkConnection()) {
//                                    var message = await Chat.sendMessage(
//                                        order_uuid, messageField.text, 'driver');
//                                    chatMessagesStates.forEach((key, value) {
//                                      print(
//                                          key + ' ' + value.currentState.toString());
//                                    });
//                                    messageField.clear();
//                                    setState(() {
//                                      GlobalKey<ChatMessageScreenState>
//                                      chatMessageScreenStateKey =
//                                      new GlobalKey<ChatMessageScreenState>();
//                                      chatMessagesStates[message.uuid] =
//                                          chatMessageScreenStateKey;
//                                      chatMessageList.insert(
//                                          0,
//                                          new ChatMessageScreen(
//                                              key: chatMessageScreenStateKey,
//                                              chatMessage: message));
//                                    });
//                                  } else {
//                                    noConnection(context);
//                                  }
//                                },
//                              ),
//                            ),
                                          ),
                                        )
                                    )
                                ),
                                InkWell(
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      child: Padding(
                                        padding: EdgeInsets.all(6),
                                        child: SvgPicture.asset(
                                            'assets/svg_images/send_message.svg'),
                                      )
                                  ),
                                  onTap: () async {
                                    if (await Internet.checkConnection()) {
                                      var message = await Chat.sendMessage(
                                          order_uuid, messageField.text, 'driver');
                                      chatMessagesStates.forEach((key, value) {
                                        print(
                                            key + ' ' + value.currentState.toString());
                                      });
                                      print("Отправка сообщения");
                                      messageField.clear();
                                      setState(() {
                                        GlobalKey<ChatMessageScreenState>
                                        chatMessageScreenStateKey =
                                        new GlobalKey<ChatMessageScreenState>();
                                        chatMessagesStates[message.uuid] =
                                            chatMessageScreenStateKey;
                                        chatMessageList.insert(
                                            0,
                                            new ChatMessageScreen(
                                                key: chatMessageScreenStateKey,
                                                chatMessage: message));
                                      });
                                    } else {
                                      noConnection(context);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
//                  Padding(
//                    padding: EdgeInsets.only(top: 60, bottom: 20, right: 15, left: 15),
//                    child: Container(
//                      height: 40,
//                      child: TextField(
//                        controller: messageField,
//                        decoration: InputDecoration(
//                          suffix: GestureDetector(
//                            child: SvgPicture.asset(
//                                'assets/svg_images/send_message.svg'),
//                            onTap: () async {
//                              if (await Internet.checkConnection()) {
//                                var message = await Chat.sendMessage(
//                                    order_uuid, messageField.text, 'driver');
//                                chatMessagesStates.forEach((key, value) {
//                                  print(
//                                      key + ' ' + value.currentState.toString());
//                                });
//                                messageField.clear();
//                                setState(() {
//                                  GlobalKey<ChatMessageScreenState>
//                                  chatMessageScreenStateKey =
//                                  new GlobalKey<ChatMessageScreenState>();
//                                  chatMessagesStates[message.uuid] =
//                                      chatMessageScreenStateKey;
//                                  chatMessageList.insert(
//                                      0,
//                                      new ChatMessageScreen(
//                                          key: chatMessageScreenStateKey,
//                                          chatMessage: message));
//                                });
//                              } else {
//                                noConnection(context);
//                              }
//                            },
//                          ),
//                        ),
//                      ),
//                    ),
//                  )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (chatMessageList != null) {
      print(chatMessageList.length);
      return buildChat();
    }
    return FutureBuilder<ChatHistoryModel>(
      future: Chat.loadChatHistory(order_uuid, 'driver'),
      builder:
          (BuildContext context, AsyncSnapshot<ChatHistoryModel> snapshot) {
        print('tututuwapatututuwapa ' + order_uuid);
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          chatMessagesStates.clear();
          chatMessageList = new List<ChatMessageScreen>();
          snapshot.data.chatMessageList.forEach((element) {
            GlobalKey<ChatMessageScreenState> chatMessageScreenStateKey =
            new GlobalKey<ChatMessageScreenState>();
            chatMessagesStates[element.uuid] = chatMessageScreenStateKey;
            chatMessageList.add(new ChatMessageScreen(
                chatMessage: element, key: chatMessageScreenStateKey));
          });
//          GlobalKey<ChatMessageScreenState> chatMessageScreenStateKey =
//              new GlobalKey<ChatMessageScreenState>();
          //chatMessagesStates['123'] = chatMessageScreenStateKey;
//          chatMessageList.add(new ChatMessageScreen(
//              key: chatMessageScreenStateKey,
//              chatMessage: new ChatMessage(
//                  message: 'halo',
//                  ack: false,
//                  uuid: '123',
//                  from: 'driver',
//                  to: 'client')
//          ));
          return buildChat();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

// ignore: must_be_immutable
class ChatMessageScreen extends StatefulWidget {
  ChatMessage chatMessage;

  ChatMessageScreen({Key key, this.chatMessage}) : super(key: key);

  @override
  ChatMessageScreenState createState() {
    return new ChatMessageScreenState(chatMessage);
  }
}

class ChatMessageScreenState extends State<ChatMessageScreen> with WidgetsBindingObserver {
  ChatMessage chatMessage;

  ChatMessageScreenState(this.chatMessage);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      setState(() {

      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: <Widget>[
          (chatMessage.to == 'client')
              ? Padding(
            padding: EdgeInsets.only(right: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFE5E6EA),
                        borderRadius: BorderRadius.circular(17.0),
                        border:
                        Border.all(width: 1.0, color: Color(0xFFE5E6EA))),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        chatMessage.message,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            decoration: TextDecoration.none),
                      ),
                    )),
              ),
            ),
          )
              : Padding(
            padding: EdgeInsets.only(left: 15),
            child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFFC5B58),
                          borderRadius: BorderRadius.circular(17.0),
                          border: Border.all(
                              width: 1.0, color: Color(0xFFFC5B58))),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          chatMessage.message,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              decoration: TextDecoration.none),
                        ),
                      )),
                )),
          ),
          (chatMessage.to != 'client') ?
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: (chatMessage.ack ) ? Align(
              alignment: Alignment.centerRight,
              child: Text('Прочитано',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ): Align(
              alignment: Alignment.centerRight,
              child: Text('Доставлено',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
          ) :
          Container(height: 0,)
        ],
      ),
    );
  }
}

class QuickMessageScreen extends StatefulWidget {
  TextEditingController messageField;

  QuickMessageScreen({Key key, this.messageField}) : super(key: key);

  @override
  QuickMessageScreenState createState() {
    return new QuickMessageScreenState(messageField: messageField);
  }
}

class QuickMessageScreenState extends State<QuickMessageScreen> with WidgetsBindingObserver{
  TextEditingController messageField;

  QuickMessageScreenState({this.messageField});

  QuickMessageItem quickMessage;
  String quickTextMessage;

  buildQuickMessages() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(quickMessage.messages.length, (index) {
        return GestureDetector(
          child: Padding(
              padding: EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                      )
                    ],
                    color: (quickMessage.messages[index] != quickTextMessage)
                        ? Colors.white
                        : Colors.redAccent),
                child: Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 10,
                    ),
                    child: Text(
                      quickMessage.messages[index],
                      style: TextStyle(
                          color:
                          (quickMessage.messages[index] != quickTextMessage)
                              ? Color(0x99999999)
                              : Colors.white,
                          fontSize: 15),
                    )),
              )),
          onTap: () {
            setState(() {
              quickTextMessage = quickMessage.messages[index];
              messageField.text = quickTextMessage;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (quickMessage != null) {
      return buildQuickMessages();
    }
    return FutureBuilder<QuickMessages>(
      future: Chat.getMessages(),
      builder: (BuildContext context, AsyncSnapshot<QuickMessages> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          quickMessage = snapshot.data.chatMessageList[0];
          return buildQuickMessages();
        } else {
          return Container();
        }
      },
    );
  }
}