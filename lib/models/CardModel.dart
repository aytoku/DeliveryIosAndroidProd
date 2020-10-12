import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class CardModel{
  static List<CardModel> _CardsList;
  String number;
  String expiration;
  String cvv;
  CardTypes type;

  CardModel( {
    this.number,
    this.expiration,
    this.cvv,
    this.type
  });

  static Future saveData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cards_list', CardModel.toJson());
  }

  static Future<List<CardModel>> getCards() async{
    if(_CardsList != null)
      return _CardsList;

    _CardsList = new List<CardModel>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('cards_list'))
      return _CardsList;
    var json_addresses = convert.jsonDecode(prefs.getString('cards_list')) as List;

    _CardsList = json_addresses.map((i) =>
        CardModel.fromJson(i)).toList();
    return _CardsList;
  }

  static String toJson(){
    List<Map<String, dynamic>> list = new List<Map<String, dynamic>>();
    _CardsList.forEach((CardModel cardModel) {
      Map<String, dynamic> item =
      {
        "number": cardModel.number,
        "expiration": cardModel.expiration,
        "cvv":cardModel.cvv,
        "type": cardModel.type.index,
      };
      list.add(item);
    });
    return convert.jsonEncode(list);
  }

  factory CardModel.fromJson(Map<String, dynamic> parsedJson){
    CardTypes type = parsedJson['type'] == 0 ? CardTypes.visa : CardTypes.mastercard ;

    return new CardModel(
        type:type,
        number:parsedJson['number'],
        expiration: parsedJson['expiration'],
        cvv:parsedJson['cvv'],
    );
  }
}

enum CardTypes{visa, mastercard}