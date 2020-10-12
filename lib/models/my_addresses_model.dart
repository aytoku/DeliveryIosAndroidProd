import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class MyAddressesModel{
  static List<MyAddressesModel> _AddressesList;
  MyAddressesType type;
  String address;
  String name;
  String comment;

  MyAddressesModel( {
    this.type,
    this.address,
    this.name,
    this.comment
  });

  static Future saveData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('addresses_list', MyAddressesModel.toJson());
  }

  static Future<List<MyAddressesModel>> getAddresses() async{
    if(_AddressesList != null)
      return _AddressesList;

    _AddressesList = new List<MyAddressesModel>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('addresses_list'))
      return _AddressesList;
    var json_addresses = convert.jsonDecode(prefs.getString('addresses_list')) as List;

    _AddressesList = json_addresses.map((i) =>
        MyAddressesModel.fromJson(i)).toList();
    return _AddressesList;
  }

  static String toJson(){
    List<Map<String, dynamic>> list = new List<Map<String, dynamic>>();
    _AddressesList.forEach((MyAddressesModel address) {
      Map<String, dynamic> item =
      {
        "name": address.name,
        "address": address.address,
        "type": address.type.index,
        "comment": address.comment,
      };
      list.add(item);
    });
    return convert.jsonEncode(list);
  }

  factory MyAddressesModel.fromJson(Map<String, dynamic> parsedJson){
    MyAddressesType type = parsedJson['type'] == 0 ? MyAddressesType.empty : MyAddressesType.home ;

    return new MyAddressesModel(
      type:type,
      address:parsedJson['address'],
      name: parsedJson['name'],
      comment:parsedJson['comment'],
    );
  }
}

enum MyAddressesType{empty, home}