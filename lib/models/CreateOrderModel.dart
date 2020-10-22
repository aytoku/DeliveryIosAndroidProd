import 'dart:convert';
import 'package:flutter_app/models/last_addresses_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../Config/config.dart';
import '../PostData/necessary_address_data_pass.dart';
import '../data/data.dart';
import 'AuthCode.dart';
import 'CartDataModel.dart';
import 'NecessaryAddressModel.dart';
import 'ResponseData.dart';

class CreateOrder {
  String address;
  String office;
  DestinationPoints restaurantAddress;
  String intercom;
  String entrance;
  String floor;
  String comment;
  String delivery;
  CartDataModel cartDataModel;
  Records restaurant;
  String payment_type;
  bool door_to_door;

  CreateOrder({
    this.address,
    this.office,
    this.restaurantAddress,
    this.intercom,
    this.entrance,
    this.floor,
    this.comment,
    this.delivery,
    this.cartDataModel,
    this.restaurant,
    this.payment_type,
    this.door_to_door
  });

  static Future<bool> sendRefreshToken() async {
    bool isSuccess = false;
    var url = 'https://client.apis.prod.faem.pro/api/v2/auth/refresh';
    var response = await http.post(
        url, body: jsonEncode({"refresh": authCodeData.refresh_token}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    print('ТУТ КЕФРЕЭ ' + authCodeData.refresh_token);
    if (response.statusCode == 200) {
      isSuccess = true;
      var jsonResponse = convert.jsonDecode(response.body);
      authCodeData = AuthCodeData.fromJson(jsonResponse);
      necessaryDataForAuth.refresh_token = authCodeData.refresh_token;
      NecessaryDataForAuth.saveData();
      //await sendFCMToken(FCMToken);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    print(response.body);
    return isSuccess;
  }

  Future sendData() async {
    NecessaryAddressData necessaryAddressData = await loadNecessaryAddressData(address);
    // Добавляем адрес в последние использованые
    if(necessaryAddressData != null && necessaryAddressData.destinationPoints.length >  0) {
      await LastAddressesModel.addAddress(necessaryAddressData.destinationPoints[0]);
    }
    await sendRefreshToken();
    print(authCodeData.token);
    var url = 'https://client.apis.prod.faem.pro/api/v2/orders';
    var json = jsonEncode({
      "callback_phone": currentUser.phone,
      "increased_fare": 25,
      "comment": comment,
      "features_uuids": (door_to_door) ? [
        "8209935f-6251-4982-9b02-b2d642418b5e"
      ] : null,
      "products_input": cartDataModel.toServerJSON(),
      "routes": [
        restaurant.destination_points[0].toJson(),
        necessaryAddressData.destinationPoints[0].toJson()
      ],
      "payment_type": payment_type,
      "service_uuid": "833fc341-dbd8-4dcb-adff-fd22246756d1",
    });
    print(json);
    var response = await http.post(url, body: jsonEncode({
      "callback_phone": currentUser.phone,
      "increased_fare": 25,
      "comment": comment,
      "features_uuids": (door_to_door) ? [
        "8209935f-6251-4982-9b02-b2d642418b5e"
      ] : null,
      "products_input": cartDataModel.toServerJSON(),
      "routes": [
        restaurantAddress.toJson(),
        necessaryAddressData.destinationPoints[0].toJson()
      ],
      "payment_type": payment_type,
      "service_uuid": "833fc341-dbd8-4dcb-adff-fd22246756d1",
    }), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Source':'ios_client_app_1',
      'Authorization':'Bearer ' + authCodeData.token
    });

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    print(response.body);
  }


}