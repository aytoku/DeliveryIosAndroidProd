import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/addCardScreen.dart';

class AddCartScreen extends StatefulWidget {
  AddCartScreen({Key key}) : super(key: key);

  @override
  _AddCartScreenState createState() => _AddCartScreenState();
}

class _AddCartScreenState extends State<AddCartScreen> {
  _buildNearlyRestaurant() {
    List<Widget> restaurantList = [];
    addCart.forEach((AddCart addCart) {
      restaurantList.add(GestureDetector(
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    //builder: (_) => RestaurantScreen(restaurant: restaurant),
                    ),
              ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(width: 1.0, color: Colors.grey[200])),
            child: Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Hero(
                        tag: addCart.name,
                        child: Image(
                          image: AssetImage(addCart.imageUrl),
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: 450.0,
                        ))),
                Container(
                  margin: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        addCart.name,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )));
    });

    return Column(children: restaurantList);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Old School"),
          ),
          body: _buildNearlyRestaurant()),
    );
  }
}
