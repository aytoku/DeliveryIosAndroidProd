import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Screens/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/CartDataModel.dart';
import 'package:flutter_app/models/amplitude.dart';

class DeviceIdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NecessaryDataForAuth>(
      future: NecessaryDataForAuth.getData(),
      builder:
          (BuildContext context, AsyncSnapshot<NecessaryDataForAuth> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          CartDataModel.getCart().then((value) {
            currentUser.cartDataModel = value;
            print('Cnjbn');
          });
          necessaryDataForAuth = snapshot.data;
          if (necessaryDataForAuth.refresh_token == null ||
              necessaryDataForAuth.phone_number == null ||
              necessaryDataForAuth.name == null) {
            currentUser.isLoggedIn = false;
            AmplitudeAnalytics.initialize(necessaryDataForAuth.device_id).then((value){
              AmplitudeAnalytics.analytics.logEvent('open_app');
            });
            return HomeScreen();
          }
          print(necessaryDataForAuth.refresh_token);
          AmplitudeAnalytics.initialize(necessaryDataForAuth.phone_number).then((value){
            AmplitudeAnalytics.analytics.logEvent('open_app');
          });
          return HomeScreen();
        } else {
          return Center(
              child: CircularProgressIndicator()
//            Image.asset('assets/images/popugai.gif', height: 200.0,
//              width: 200.0,
//            ),
          );
        }
      },
    );
  }
}