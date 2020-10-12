import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/CreateOrderModel.dart';
import 'package:flutter_app/models/OwnersModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<Owners> getOwners() async {
  Owners owners = null;
  await CreateOrder.sendRefreshToken();
  var url = 'https://crm.apis.prod.faem.pro/api/v2/owners';
  var response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'ios_client_app_1',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    owners = Owners.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return owners;
}