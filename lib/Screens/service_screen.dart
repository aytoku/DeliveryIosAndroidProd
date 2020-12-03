import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../Internet/check_internet.dart';
import '../GetData/getTicketByFilter.dart';
import '../data/data.dart';
import '../models/TicketModel.dart';
import 'home_screen.dart';
import 'service_orders_story.dart';
import 'tickets_chat_screen.dart';

class ServiceScreen extends StatefulWidget {
  @override
  ServiceScreenState createState() => ServiceScreenState();
}

class ServiceScreenState extends State<ServiceScreen> {

  @override
  Widget build(BuildContext context) {
    var format1 = new DateFormat('dd.MM.yy, HH:mm');
    // TODO: implement build
    return Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        child: Container(
                            height: 50,
                            width: 60,
                            child: Padding(
                              padding:
                              EdgeInsets.only(top: 17, bottom: 17, right: 10),
                              child: SvgPicture.asset(
                                  'assets/svg_images/arrow_left.svg'),
                            )),
                        onTap: () async {
                          if (await Internet.checkConnection()) {
                            homeScreenKey = new GlobalKey<HomeScreenState>();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                    (Route<dynamic> route) => false);
                          } else {
                            noConnection(context);
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            "Служба поддержки",
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
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30, left: 16, bottom: 10),
                        child: Text('Ваши вопросы',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB9B9B9))),
                      ),
                    ),
                    ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(bottom: 15, top: 15),
                        child: Text(
                          'Ошибка в заказе',
                          style: TextStyle(fontSize: 17, color: Color(0xFF424242)),
                        ),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(bottom: 15, top: 15),
                        child:
                        SvgPicture.asset('assets/svg_images/arrow_right.svg'),
                      ),
                      onTap: () async {
                        if (await Internet.checkConnection()) {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new ServiceOrdersStoryScreen(
                                ticketModel: new TicketModel(
                                    title: '[ЕДА] Ошибка в заказе', description: ''),
                              ),
                            ),
                          );
                        } else {
                          noConnection(context);
                        }
                      },
                    ),
                    Divider(height: 1.0, color: Color(0xFFEDEDED)),
                    ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(bottom: 15, top: 15),
                        child: Text(
                          'Ошибка стоимости',
                          style: TextStyle(fontSize: 17, color: Color(0xFF424242)),
                        ),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(bottom: 15, top: 15),
                        child:
                        SvgPicture.asset('assets/svg_images/arrow_right.svg'),
                      ),
                      onTap: () async {
                        if (await Internet.checkConnection()) {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new ServiceOrdersStoryScreen(
                                  ticketModel: new TicketModel(
                                      title: '[ЕДА] Ошибка стоимости', description: '')),
                            ),
                          );
                        } else {
                          noConnection(context);
                        }
                      },
                    ),
                    Divider(height: 1.0, color: Color(0xFFEDEDED)),
                    ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(bottom: 15, top: 15),
                        child: Text(
                          'Ошибка программмы',
                          style: TextStyle(fontSize: 17, color: Color(0xFF424242)),
                        ),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(bottom: 15, top: 15),
                        child:
                        SvgPicture.asset('assets/svg_images/arrow_right.svg'),
                      ),
                      onTap: () async {
                        if (await Internet.checkConnection()) {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new ServiceOrdersStoryScreen(
                                  ticketModel: new TicketModel(
                                      title: '[ЕДА] Ошибка программмы', description: '')),
                            ),
                          );
                        } else {
                          noConnection(context);
                        }
                      },
                    ),
                    Divider(height: 1.0, color: Color(0xFFEDEDED)),
                    ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(bottom: 15, top: 15),
                        child: Text(
                          'Другая причина',
                          style: TextStyle(fontSize: 17, color: Color(0xFF424242)),
                        ),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(bottom: 15, top: 15),
                        child:
                        SvgPicture.asset('assets/svg_images/arrow_right.svg'),
                      ),
                      onTap: () async {
                        if (await Internet.checkConnection()) {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new ServiceOrdersStoryScreen(
                                  ticketModel: new TicketModel(
                                      title: '[ЕДА] Другая причина', description: '')),
                            ),
                          );
                        } else {
                          noConnection(context);
                        }
                      },
                    ),
                    Divider(height: 1.0, color: Color(0xFFEDEDED)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30, left: 16, bottom: 10),
                        child: Text('Мои обращения',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB9B9B9))),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, left: 16, bottom: 10),
                        child: Text('Текущие обращения',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB9B9B9))),
                      ),
                    ),
                    Container(
                      child: FutureBuilder<TicketsList>(
                        future:
                        getTicketsByFilter(1, 0, necessaryDataForAuth.phone_number),
                        builder:
                            (BuildContext context, AsyncSnapshot<TicketsList> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done &&
                              snapshot.data != null) {
                            if(snapshot.data.records == null && snapshot.data.recordsCount == 0){
                              return Container();
                            }
                            List<TicketsListRecord> unresolvedTickets = new List<TicketsListRecord>();
                            unresolvedTickets.addAll(snapshot.data.records.where((element) => element.status != 'resolved'));
                            return Container(
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                children: List.generate(unresolvedTickets.length, (index) {
                                  var format = new DateFormat('dd.MM.yy, HH:mm');
                                  return ListTile(
                                    leading: Text(format.format(DateTime.fromMillisecondsSinceEpoch(unresolvedTickets[index].createdAtUnix * 1000)),
                                      style: TextStyle(
                                          color: Color(0xFF424242),
                                          fontSize: 17
                                      ),
                                    ),
                                    trailing: SvgPicture.asset('assets/svg_images/arrow_right.svg'),
                                    onTap: () async {
                                      if (await Internet.checkConnection()) {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                new TicketsChatScreen(
                                                  order_uuid: unresolvedTickets[index].uuid,
                                                  time: format.format(DateTime.fromMillisecondsSinceEpoch(unresolvedTickets[index].createdAtUnix * 1000)),
                                                ))
                                        );
                                      } else {
                                        noConnection(context);
                                      }
                                      print('OYAOYA');
                                    },
                                  );
                                }),
                              ),
                            );
                          }
                          return Center(child: Container());
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, left: 16, bottom: 10),
                        child: Text('Решенные',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB9B9B9))),
                      ),
                    ),
                    Container(
                      child: FutureBuilder<TicketsList>(
                        future:
                        getTicketsByFilter(1, 0, necessaryDataForAuth.phone_number, status: 'resolved'),
                        builder:
                            (BuildContext context, AsyncSnapshot<TicketsList> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done &&
                              snapshot.data != null) {
                            if(snapshot.data.records == null && snapshot.data.recordsCount == 0){
                              return Container();
                            }
                            return Container(
                                child: ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  children: List.generate(snapshot.data.recordsCount, (index) {
                                    var format = new DateFormat('dd.MM.yy, HH:mm');
                                    return Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: Text(format.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.records[index].createdAtUnix * 1000)),
                                            style: TextStyle(
                                                color: Color(0xFF424242),
                                                fontSize: 17
                                            ),
                                          ),
                                          trailing: SvgPicture.asset('assets/svg_images/arrow_right.svg'),
                                          onTap: () async {
                                            if (await Internet.checkConnection()) {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                      new TicketsChatScreen(
                                                        order_uuid: snapshot.data.records[index].uuid,
                                                        time: format.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.records[index].createdAtUnix * 1000)),
                                                      ))
                                              );
                                            } else {
                                              noConnection(context);
                                            }
                                            print('OYAOYA');
                                          },
                                        ),
                                        Divider(height: 1.0, color: Color(0xFFEDEDED)),
                                      ],
                                    );
                                  }),
                                ));
                          }
                          return Center(child: Container());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}