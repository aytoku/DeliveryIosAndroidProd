import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/device_id_screen.dart';

class App extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Faem Eda",
      theme: ThemeData(
        primaryColor: Color(0xFFFD6F6D),
        cursorColor: Color(0xFFFD6F6D),
        unselectedWidgetColor: Color(0xFFFD6F6D),
        selectedRowColor: Color(0xFFFD6F6D),
        toggleableActiveColor: Color(0xFFFD6F6D),
      ),
      home: DeviceIdScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
