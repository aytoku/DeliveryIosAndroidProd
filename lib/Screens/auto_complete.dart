import 'package:flutter/material.dart';
import 'package:flutter_app/PostData/necessary_address_data_pass.dart';
import 'package:flutter_app/models/InitialAddressModel.dart';
import 'package:flutter_app/models/NecessaryAddressModel.dart';
import 'package:flutter_app/models/RecommendationAddressModel.dart';
import 'package:flutter_app/models/ResponseData.dart';
import 'package:flutter_app/models/last_addresses_model.dart';
import 'package:flutter_app/models/my_addresses_model.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'device_id_screen.dart';

class AutoComplete extends StatefulWidget {
  String hint;
  TextEditingController controller = new TextEditingController();
  VoidCallback onSelected;

  AutoComplete(Key key, this.hint, {this.onSelected}) : super(key: key);

  @override
  AutoCompleteDemoState createState() => AutoCompleteDemoState(hint, controller, onSelected: onSelected);
}

class AutoCompleteDemoState extends State<AutoComplete> with AutomaticKeepAliveClientMixin{
  // Говорим, что автокомплит не хочет терять свой стейт (не помню зачем)
  @override
  bool get wantKeepAlive => true;

  // Подисказка
  String hint;
  // Событие на выбор значения в списке
  VoidCallback onSelected;
  // Последнее выбранное значение
  InitialAddressModel selectedValue;


  AutoCompleteDemoState(this.hint, this.controller, {this.onSelected});


  // Текстовое поле для автокомплита и его контроллеры
  TypeAheadField searchTextField;
  TextEditingController controller;
  FocusNode node = new FocusNode();

  // Получение контекстных подсказок для конкретного значения из текстфилда
  Future<List<InitialAddressModel>> findAddress(String searchText) async {
    // Результирующий список
    List<InitialAddressModel> necessaryAddressDataItems;

    try {
      // Если в поле автокомплита был введен текст
      if (searchText.length > 0) {
        // то получаем релеватные подсказки с сервера
        necessaryAddressDataItems =
            (await loadNecessaryAddressData(searchText)).destinationPoints;
      } else {
        // иначе получаем список рекомендаций для заполнения с того же сервера
        List<RecommendationAddressModel> temp = await RecommendationAddress.getRecommendations("target");
        // который загоняем в подсказски автокомплита
        necessaryAddressDataItems = temp.map<InitialAddressModel>((item) => item.address).toList();
      }
    }
    catch (e) {
      print("Error getting addresses.");
    } finally {
      return necessaryAddressDataItems;
    }
  }

  @override
  void initState() {
    super.initState();
  }


  Widget row(InitialAddressModel address) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
        child: Text(
          address.name != null && address.name != '' && address.name != " " ? address.name : address.unrestrictedValue,
          //user.unrestricted_value,
          style: TextStyle(fontSize: 16.0, decoration: TextDecoration.none),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Theme(
        data: new ThemeData(hintColor: Color(0xF2F2F2F2)),
        child: Padding(
            padding: EdgeInsets.only(left: 15, right: 0, top: 10),
            child: searchTextField = TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: controller,
                cursorColor: Color(0xFFFD6F6D),
                textCapitalization: TextCapitalization.sentences,
                focusNode: node,
                style: TextStyle(
                  color: Color(0xFF000000),
                ),
                decoration: new InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                      color: Color(0xFFD4D4D4),
                      fontSize: 17
                  ),
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
              suggestionsCallback: (pattern) async {
                print('autocomplite');
                return await findAddress(pattern);
              },
              keepSuggestionsOnSuggestionSelected: true,
              loadingBuilder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, suggestion) => Text('error'),
              noItemsFoundBuilder: (context) => Text(''),
              itemBuilder: (context, suggestion) {
                print('vi zaebali menya ispolzovat postoyanno fagoti');
                return row(suggestion);
              },
              onSuggestionSelected: (suggestion) { // При выборе значения из списка
                // Переносим это значение в текстфилд
                controller.text =(suggestion as InitialAddressModel).unrestrictedValue;
                // и фиксируем его, как последнее выбранное
                selectedValue = (suggestion as InitialAddressModel);

                // Избегаем потери фокуса и ставим курсор в конец
                node.requestFocus();
                controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));

                // Если было передано дополнительное событие, то вызываем его
                if(onSelected != null){
                  onSelected();
                }
              },
            )
        ),
      ),
    );
  }
}