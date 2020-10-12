import 'package:flutter/material.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/Screens/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/CartDataModel.dart';

class DeviceIdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NecessaryDataForAuth>(
      future: NecessaryDataForAuth.getData(),
      // ignore: missing_return
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
            return HomeScreen();
          }
          print(necessaryDataForAuth.refresh_token);
          return HomeScreen();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ara extends StatelessWidget {
  Widget build(BuildContext context) {
    print('ZAEBALI');
    return GestureDetector(
      child: Text('sdfsdf'),
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new DeviceIdScreen(),
          ),
        );
      },
    );
  }
}
