import 'dart:convert';
import 'package:flutter_app/models/RestaurantDataItems.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<RestaurantDataItems> loadRestaurantItems(String uuid, String category, int page, int limit) async {
  RestaurantDataItems restaurantDataItems1 = null;
  print(uuid);
  var json_request = jsonEncode({
    "store_uuid": uuid,
    "category": category,
    "page": page,
    "limit": limit
  });
  if(category == ''){
    json_request = jsonEncode({
      "store_uuid": uuid,
      "page": page,
      "limit": limit
    });
  }
  var url = 'https://crm.apis.prod.faem.pro/api/v2/products';
  var response = await http.post(url, body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    restaurantDataItems1 = new RestaurantDataItems.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(restaurantDataItems1);
  return restaurantDataItems1;
}