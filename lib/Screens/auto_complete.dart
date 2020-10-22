import 'package:flutter/material.dart';
import 'package:flutter_app/PostData/necessary_address_data_pass.dart';
import 'package:flutter_app/models/NecessaryAddressModel.dart';
import 'package:flutter_app/models/ResponseData.dart';
import 'package:flutter_app/models/last_addresses_model.dart';
import 'package:flutter_app/models/my_addresses_model.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'device_id_screen.dart';

class AutoComplete extends StatefulWidget {
  String hint;

  AutoComplete(Key key, this.hint) : super(key: key);

  @override
  AutoCompleteDemoState createState() => AutoCompleteDemoState(hint);
}

class AutoCompleteDemoState extends State<AutoComplete> with AutomaticKeepAliveClientMixin{
  String hint;
  @override
  bool get wantKeepAlive => true;

  AutoCompleteDemoState(this.hint);
  TextEditingController controller = new TextEditingController();
  FocusNode node = new FocusNode();

  TypeAheadField searchTextField;

  Future<List<DestinationPoints>> getUsers(String name) async {
    List<DestinationPoints> necessaryAddressDataItems;
    try {
      if (name.length > 0) {
        necessaryAddressDataItems =
            (await loadNecessaryAddressData(name)).destinationPoints;
      } else {
        // Вывод фаворитных адресов
        List<MyAddressesModel> temp = await MyAddressesModel.getAddresses();
        necessaryAddressDataItems = new List<DestinationPoints>();
        // Бежим по фаворитным адресам
        for (int i = 0; i < temp.length; i++) {
          var element = temp[i];
          // Получаем адрес с серва
          NecessaryAddressData necessaryAddressData =
          await loadNecessaryAddressData(element.address);
          // Если на серве есть такой адрес
          if(necessaryAddressData.destinationPoints.length > 0){
            necessaryAddressData.destinationPoints[0].comment = element.comment;
            necessaryAddressData.destinationPoints[0].name = element.name;
            necessaryAddressDataItems
                .add(necessaryAddressData.destinationPoints[0]);
          }else{
            necessaryAddressDataItems.add(new DestinationPoints(
                street: element.address, house: '', comment: temp[i].comment, name: element.name));
          }
        }

        // Вывод последних адресов
        List<DestinationPoints> last_dp = await LastAddressesModel.getAddresses();
        necessaryAddressDataItems.addAll(last_dp);
      }
      print(necessaryAddressDataItems[0].unrestricted_value);
    } catch (e) {
      print("Error getting users.");
    } finally {
      return necessaryAddressDataItems;
    }
  }

  @override
  void initState() {
    //getUsers('');
    super.initState();
  }

  Widget row(DestinationPoints user) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
        child: Text(
          user.name != null && user.name != '' ? user.name : user.unrestricted_value,
          //user.unrestricted_value,
          style: TextStyle(fontSize: 16.0, decoration: TextDecoration.none),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                //autofocus: true,
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
                return await getUsers(pattern);
              },
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
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text(suggestion['name']),
                  subtitle: Text('\$${suggestion['price']}'),
                );
              },
              onSuggestionSelected: (suggestion) {
                print('asdasdasdadasd');
                controller.text =(suggestion as DestinationPoints).unrestricted_value;
                //FocusScope.of(context).unfocus();
                node.requestFocus();
                print(controller.text.length);
                controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
              },
            )
        ),
      ),
    );
  }
}