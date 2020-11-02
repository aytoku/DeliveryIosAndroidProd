import 'package:flutter/material.dart';
import 'package:flutter_app/GetData/getImage.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/PostData/restaurant_items_data_pass.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/models/ResponseData.dart';
import 'package:flutter_app/models/RestaurantDataItems.dart';
import 'package:flutter_app/models/food.dart';
import 'package:flutter_app/models/order.dart';
import 'package:flutter_svg/svg.dart';
import '../models/RestaurantDataItems.dart';
import '../models/RestaurantDataItems.dart';
import 'cart_screen.dart';
import 'home_screen.dart';

class RestaurantScreen extends StatefulWidget {
  final Records restaurant;

  RestaurantScreen({Key key, this.restaurant}) : super(key: key);

  @override
  RestaurantScreenState createState() =>
      RestaurantScreenState(restaurant, '');
}

class RestaurantScreenState extends State<RestaurantScreen> {
  final Records restaurant;
  // Добавленные глобалки
  RestaurantDataItems restaurantDataItems; // Модель текущего меню
  CategoryList categoryList; // Виджет с категориями еды
  // (для подгрузки ВПЕРЕД по клику по категории)
  ScrollController foodScrollController = new ScrollController(); // Скролл контроллер для хавки
  List<MenuItem> food_menu_items = new List<MenuItem>(); // Виджеты с хавкой
  int load_category_index = 0; // Индекс подгружаемой категории (няряду с page)
  // Конец добавленных мной глобалок
  int page = 1;
  int limit = 12;
  String category;

  GlobalKey<FormState> foodItemFormKey = GlobalKey();
  GlobalKey<CounterState> counterKey = new GlobalKey();
  GlobalKey<BasketButtonState> basketButtonStateKey =
  new GlobalKey<BasketButtonState>();
  bool isLoading = true;

  GlobalKey<FormState> _foodItemFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();


  RestaurantScreenState(this.restaurant, this.category);

  _dayOff(FoodRecords restaurantDataItems,
      GlobalKey<CartItemsQuantityState> cartItemsQuantityKey) {
    GlobalKey<VariantsSelectorState> variantsSelectorStateKey =
    GlobalKey<VariantsSelectorState>();
    GlobalKey<ToppingsSelectorState> toppingsSelectorStateKey =
    new GlobalKey<ToppingsSelectorState>();

    DateTime now = DateTime.now();
    int dayNumber  = now.weekday-1;

    int work_beginning = restaurant.work_schedule[dayNumber].work_beginning;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
          )),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('К сожалению, доставка не доступна.\nБлижайшее время в ${( work_beginning/ 60).toStringAsFixed(0)} часов',
                  style: TextStyle(
                      fontSize: 16
                  ),
                  textAlign: TextAlign.center,
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10,left: 15, right: 15, bottom: 15),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  child: Text(
                    "Далее",
                    style:
                    TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  color: Color(0xFFFE534F),
                  splashColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(
                      left: 110, top: 20, right: 110, bottom: 20),
                  onPressed: () async {
                    homeScreenKey = new GlobalKey<HomeScreenState>();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false);
                  },
                )
            ),
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        elevation: 20,
        content: Center(
          child: Text("Товар добавлен в коризну"),
        ));
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return Padding(
          padding: EdgeInsets.only(bottom: 500),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              height: 50,
              width: 100,
              child: Center(
                child: Text("Товар добавлен в коризну"),
              ),
            ),
          ),
        );
      },
    );
  }

  showCartClearDialog(BuildContext context, Order order,
      GlobalKey<CartItemsQuantityState> cartItemsQuantityKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Container(
                height: 242,
                width: 300,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 15),
                      child: Text(
                        'Все ранее добавленные блюда из ресторна ${currentUser.cartDataModel.cart[0].restaurant.name} будут удалены из корзины',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Center(
                            child: Text(
                              'Ок',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (await Internet.checkConnection()) {
                          if (currentUser.cartDataModel.cart.length > 0 &&
                              currentUser
                                  .cartDataModel.cart[0].restaurant.uuid !=
                                  restaurant.uuid) {
                            currentUser.cartDataModel.cart.clear();
                            currentUser.cartDataModel.addItem(order);
                            currentUser.cartDataModel.saveData();
                            basketButtonStateKey.currentState.refresh();
                            cartItemsQuantityKey.currentState.refresh();
                            counterKey.currentState.refresh();
                          }
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Padding(
                            padding: EdgeInsets.only(bottom: 0),
                            child: showAlertDialog(context),
                          );
                        } else {
                          noConnection(context);
                        }
                      },
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Center(
                            child: Text(
                              'Отмена',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }



  Widget foodList(String s) {
    return Text(s, style: TextStyle(fontSize: 15.0, color: Color(0x99999999)));
  }

  @override
  void initState() {
    super.initState();
    // Инициализируем список категорий
    categoryList = new CategoryList(key: new GlobalKey<CategoryListState>(), restaurant: restaurant, parent: this);
    // Навешиваем лисенер на скролл контроллер
    foodScrollController.addListener(() {
      // Примерная высота одного элемента хавки
      int item_height = 225;
      // Вычисляем точную высоту одного элемента хавки
      if(food_menu_items.length>0 && food_menu_items[0].key.currentContext != null)
        item_height =food_menu_items[0].key.currentContext.size.height.round();

      if(!isLoading){
        // Используя силу математики, находим индекс хавки, на которую сейчас
        // смотрим
        int ind = (foodScrollController.position.pixels~/item_height)*2;
        // Если: у нас не пустой список еды, индекс подходит по верхней
        // и нижней границе листа, а также существует стейт элемента хавки, на который мы смотрим
        if(food_menu_items.length > 0 && ind < food_menu_items.length && ind >= 0 && food_menu_items[ind].key.currentState != null) {
          // Если категория выбранная категория изменилась
          if (categoryList.key.currentState.currentCategory !=
              food_menu_items[ind].key.currentState
                  .restaurantDataItems.category) {
            // Выбираем категорию и скроллим сам список категорий к ней
            categoryList.key.currentState.SelectCategory(food_menu_items[ind].key.currentState
                .restaurantDataItems.category);
            categoryList.key.currentState.ScrollToSelectedCategory();
          }
        }
      }
    });
  }

  _buildFoodCategoryList() {
    if(restaurant.product_category.length>0)
      return categoryList;
    else
      return Container(height: 0);
  }

  Widget _buildScreen() {
    isLoading = false;
    // Если хавки нет
    if (restaurantDataItems.records_count == 0) {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: InkWell(
                        onTap: () async {
                          homeScreenKey =
                          new GlobalKey<HomeScreenState>();
                          if(await Internet.checkConnection()){
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                    (Route<dynamic> route) => false);
                          }else{
                            noConnection(context);
                          }
                        },
                        child: Container(
                            height: 40,
                            width: 60,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 12, bottom: 12, right: 10, left: 16),
                              child: SvgPicture.asset(
                                  'assets/svg_images/arrow_left.svg'),
                            ))),
                  ),
                ),
                Flexible(
                  flex: 7,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Text(
                        this.restaurant.name,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Divider(color: Color(0xFFEEEEEE), height: 1,),
          ),
          _buildFoodCategoryList(),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Divider(color: Color(0xFFEEEEEE), height: 1,),
          ),
          Align(
            alignment: Alignment.center,
            child: Center(
              child: Text('Нет товаров данной категории'),
            ),
          ),
          SizedBox(height: 10.0),
        ],
      );
    }


    food_menu_items.addAll(MenuItem.fromFoodRecordsList(restaurantDataItems.records, this));
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: InkWell(
                              onTap: () async {
                                if(await Internet.checkConnection()){
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()),
                                          (Route<dynamic> route) => false);
                                }else{
                                  noConnection(context);
                                }
                              },
                              child: Container(
                                  height: 40,
                                  width: 60,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 12,
                                        bottom: 12,
                                        right: 16),
                                    child: SvgPicture.asset(
                                        'assets/svg_images/arrow_left.svg'),
                                  ))),
                        )),
                    Flexible(
                      flex: 7,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(right: 30),
                          child: Text(
                            this.restaurant.name,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3F3F3F)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Divider(color: Color(0xFFEEEEEE), height: 1,),
          ),
          _buildFoodCategoryList(),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Divider(color: Color(0xFFEEEEEE), height: 1,),
          ),
          Expanded(
              child:  GridView.count(
                padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 0),
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.65,
                controller: foodScrollController,
                children: List.generate(food_menu_items.length, (index) {
                  // Выводим итем хавки
                  return food_menu_items[index];
                }),
              )
          ),
          BasketButton(
              key: basketButtonStateKey, restaurant: restaurant)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(restaurantDataItems != null){
      return _buildScreen();
    }
    return Scaffold(
      key: _scaffoldStateKey,
      body: FutureBuilder<RestaurantDataItems>(
          future: loadAllRestaurantItems(restaurant),
          initialData: null,
          builder: (BuildContext context,
              AsyncSnapshot<RestaurantDataItems> snapshot) {
            print(snapshot.connectionState);
            if (snapshot.connectionState == ConnectionState.done) {
              restaurantDataItems = snapshot.data;
              return _buildScreen();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
  // Подгрузка итемов с категорией
  Future<bool> GoToCategory(int categoryIndex) async {
    if(isLoading)
      return false;
    isLoading = true;
    // находим итем с данной категорией
    for(int i = 0; i<food_menu_items.length;i++) {
      var item = food_menu_items[i];
      if(item.restaurantDataItems.category == restaurant.product_category[categoryIndex]){
        while(item.key.currentContext == null) {
          await foodScrollController.animateTo(foodScrollController.offset+200, duration: new Duration(milliseconds: 15),
              curve: Curves.ease);
        }
        // джампаем к нему
        await Scrollable.ensureVisible(item.key.currentContext, duration: new Duration(milliseconds: 100),
            curve: Curves.ease);
        break;
      }
    }
    isLoading = false;
    return true;
  }
}

class CartItemsQuantity extends StatefulWidget {
  CartItemsQuantity({
    Key key,
    this.restaurantDataItems,
  }) : super(key: key);
  final FoodRecords restaurantDataItems;

  @override
  CartItemsQuantityState createState() {
    return new CartItemsQuantityState(restaurantDataItems);
  }
}

class CartItemsQuantityState extends State<CartItemsQuantity> {
  final FoodRecords restaurantDataItems;

  CartItemsQuantityState(this.restaurantDataItems);

  @override
  Widget build(BuildContext context) {
    int amount = 0;
    currentUser.cartDataModel.cart.forEach((element) {
      if (element.food.uuid == restaurantDataItems.uuid) {
        amount = element.quantity;
      }
    });
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: (amount != 0)
          ? Container(
        decoration: BoxDecoration(
            color: Color(0xFFFE534F), shape: BoxShape.circle),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text('$amount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              )),
        ),
      )
          : (restaurantDataItems.weight != null && restaurantDataItems.weight_measure!= null)
          ? Text(
        restaurantDataItems.weight + ' ' + restaurantDataItems.weight_measure,
        style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12),
      )
          : Container(),
    );
  }

  void refresh() {
    setState(() {});
  }
}

class Counter extends StatefulWidget {
  GlobalKey<PriceFieldState> priceFieldKey;
  Counter({Key key, this.priceFieldKey}) : super(key: key);

  @override
  CounterState createState() {
    return new CounterState(priceFieldKey);
  }
}

class CounterState extends State<Counter> {
  GlobalKey<PriceFieldState> priceFieldKey;
  CounterState(this.priceFieldKey);

  int counter = 1;

  // ignore: non_constant_identifier_names
  void _incrementCounter_plus() {
    setState(() {
      counter++;
      if(priceFieldKey.currentState != null){
        priceFieldKey.currentState.setCount(counter);
      }
    });
  }

  // ignore: non_constant_identifier_names
  void _incrementCounter_minus() {
    setState(() {
      counter--;
      if(priceFieldKey.currentState != null){
        priceFieldKey.currentState.setCount(counter);
      }
    });
  }


  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 0),
      child: Container(
        width: 122,
        height: 58,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Color(0xF5F5F5F5))),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
            child: InkWell(
              onTap: () {
                if (counter != 1) {
                  _incrementCounter_minus();
                  // counter = restaurantDataItems.records_count;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                ),
                height: 40,
                width: 28,
                child: Padding(
                  padding: EdgeInsets.all(7),
                  child: SvgPicture.asset('assets/svg_images/minus.svg'),
                ),
              ),
            ),
          ),
          SizedBox(width: 19.0),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              '$counter',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 0, top: 0, bottom: 0),
            child: InkWell(
              onTap: () async {
                if (await Internet.checkConnection()) {
                  setState(() {
                    _incrementCounter_plus();
                    // counter = restaurantDataItems.records_count;
                  });
                } else {
                  noConnection(context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                ),
                height: 40,
                width: 28,
                child: Padding(
                  padding: EdgeInsets.all(7),
                  child: SvgPicture.asset('assets/svg_images/plus_counter.svg'),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}


class PriceField extends StatefulWidget {
  FoodRecords restaurantDataItems;
  PriceField({Key key, this.restaurantDataItems}) : super(key: key);

  @override
  PriceFieldState createState() {
    return new PriceFieldState(restaurantDataItems);
  }
}

class PriceFieldState extends State<PriceField> {
  int count = 1;
  FoodRecords restaurantDataItems;
  PriceFieldState(this.restaurantDataItems);
  Widget build(BuildContext context) {
    return Text(

      '${restaurantDataItems.price * count}\₽',

      style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000)),
      overflow: TextOverflow.ellipsis,
    );
  }
  void setCount(int newCount){
    setState(() {
      count = newCount;
    });
  }
}

class ButtonCounter extends StatefulWidget {
  ButtonCounter({Key key}) : super(key: key);

  @override
  ButtonCounterState createState() {
    return new ButtonCounterState();
  }
}

class ButtonCounterState extends State<ButtonCounter> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    currentUser.cartDataModel.cart.forEach(
            (Order order) => totalPrice += order.quantity * order.food.price);

    return Text('${totalPrice.toStringAsFixed(0)} \₽',
        style: TextStyle(
            fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.white));
  }

  void refresh() {
    setState(() {});
  }
}

class BasketButton extends StatefulWidget {
  final Records restaurant;

  BasketButton({Key key, this.restaurant}) : super(key: key);

  @override
  BasketButtonState createState() {
    return new BasketButtonState(restaurant);
  }
}

class BasketButtonState extends State<BasketButton> {
  GlobalKey<ButtonCounterState> buttonCounterKey = new GlobalKey();
  final Records restaurant;

  BasketButtonState(this.restaurant);

  noConnection(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              height: 50,
              width: 100,
              child: Center(
                child: Text("Нет подключения к интернету"),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (currentUser.cartDataModel.cart != null &&
        (currentUser.cartDataModel.cart.length == 0 ||
            currentUser.cartDataModel.cart[0].restaurant.uuid !=
                restaurant.uuid)) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 20),
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE32636),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      (restaurant.order_preparation_time_second != null)? '${restaurant.order_preparation_time_second ~/ 60} мин' : '',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
            Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 15,
                  ),
                  child: Text('Корзина',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                )),
            Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE32636),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: new ButtonCounter(
                    key: buttonCounterKey,
                  ),
                ))
          ],
        ),
        color: Color(0xFFFE534F),
        splashColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
        onPressed: () async {
          if (await Internet.checkConnection()) {
            if (currentUser.cartDataModel.cart.length == 0) {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) =>
                  new EmptyCartScreen(restaurant: restaurant),
                ),
              );
            } else {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new CartScreen(restaurant: restaurant),
                ),
              );
            }
          } else {
            noConnection(context);
          }
        },
      ),
    );
  }

  void refresh() {
    print('yua is arone');
    //buttonCounterKey.currentState.refresh();
    setState(() {});
  }
}

class VariantsSelector extends StatefulWidget {
  List<Variants> variantsList;

  VariantsSelector({Key key, this.variantsList}) : super(key: key);

  @override
  VariantsSelectorState createState() => VariantsSelectorState(variantsList);
}

class VariantsSelectorState extends State<VariantsSelector> {
  Variants selectedVariant = null;
  List<Variants> variantsList;

  VariantsSelectorState(this.variantsList);

  Widget build(BuildContext context) {
    List<Widget> widgetsList = new List<Widget>();
    variantsList.forEach((element) {
      widgetsList.add(
        ListTile(
          title: GestureDetector(
            child: Text(
              element.name,
              style: TextStyle(color: Color(0xFF424242)),
            ),onTap: (){
            setState(() {
              selectedVariant = element;
            });
          },
          ),
          leading: Radio(
            value: element,
            groupValue: selectedVariant,
            onChanged: (Variants value) {
              setState(() {
                selectedVariant = value;
              });
            },
          ),
        ),
      );
    });
    return Container(
      color: Colors.white,
      child: ScrollConfiguration(
        behavior: new ScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: widgetsList,
          ),
        ),
      ),
    );
  }
}

class ToppingsSelector extends StatefulWidget {
  List<Toppings> toppingsList;

  ToppingsSelector({Key key, this.toppingsList}) : super(key: key);

  @override
  ToppingsSelectorState createState() => ToppingsSelectorState(toppingsList);
}

class ToppingsSelectorState extends State<ToppingsSelector> {
  List<Toppings> toppingsList;
  List<MyCheckBox> widgetsList = new List<MyCheckBox>();

  ToppingsSelectorState(this.toppingsList);

  Widget build(BuildContext context) {
    toppingsList.forEach((element) {
      widgetsList.add(MyCheckBox(
          key: new GlobalKey<MyCheckBoxState>(),
          topping: element,
          title: element.name));
    });
    return Container(
      color: Colors.white,
      child: ScrollConfiguration(
        behavior: new ScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: widgetsList,
          ),
        ),
      ),
    );
  }

  List<Toppings> getSelectedToppings() {
    List<Toppings> result = new List<Toppings>();
    widgetsList.forEach((element) {
      if (element.key.currentState != null &&
          element.key.currentState.isSelected) {
        result.add(element.topping);
      }
    });
    return result;
  }
}

class MyCheckBox extends StatefulWidget {
  Toppings topping;
  String title;
  GlobalKey<MyCheckBoxState> key;

  MyCheckBox({this.key, this.topping, this.title}) : super(key: key);

  @override
  MyCheckBoxState createState() => MyCheckBoxState(topping, title);
}

class MyCheckBoxState extends State<MyCheckBox> {
  Toppings topping;
  String title;
  bool isSelected = false;

  MyCheckBoxState(this.topping, this.title);

  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(color: Color(0xff424242)),
      ),
      value: isSelected,
      onChanged: (bool f) {
        setState(() {
          isSelected = f;
        });
      },
    );
  }
}


// Список категорий
class CategoryList extends StatefulWidget {
  CategoryList({this.key, this.restaurant, this.parent}) : super(key: key);
  final GlobalKey<CategoryListState> key;
  final RestaurantScreenState parent;
  final Records restaurant;

  @override
  CategoryListState createState() {
    return new CategoryListState(restaurant, parent);
  }
}

class CategoryListState extends State<CategoryList> {
  final Records restaurant;
  final RestaurantScreenState parent;
  String currentCategory;
  List<CategoryListItem> categoryItems;

  CategoryListState(this.restaurant, this.parent);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryItems = new List<CategoryListItem>();
    currentCategory = (restaurant.product_category.length > 0) ? restaurant.product_category[0] : '';
  }
  @override
  Widget build(BuildContext context) {
    // Если категории в списке отличаются от категорий ресторана
    if(categoryItems.length != restaurant.product_category.length){
      // Очищаем лист, если он не очищен
      if(categoryItems.length != 0)
        categoryItems.clear();
      // Заполянем список категорий категориями продуктов
      restaurant.product_category.forEach((element) {
        categoryItems.add(new CategoryListItem(key: new GlobalKey<CategoryListItemState>(),
            categoryList: this,value: element));
      });
    }
    // Скроллинг к выбранной категории после билда скрина
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ScrollToSelectedCategory();
    });

    return  Container(
      height: 50,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: categoryItems
      ),
    );

  }

  void SelectCategory(String category) {
    String oldCategory = this.currentCategory;
    this.currentCategory = category;
    CategoryListItem categoryItem =
    categoryItems.firstWhere((element) => element.value == oldCategory);
    categoryItem.key.currentState.setState(() { });
    categoryItem =
        categoryItems.firstWhere((element) => element.value == category);
    categoryItem.key.currentState.setState(() { });
  }

  void ScrollToSelectedCategory() async{
    print(currentCategory);
    CategoryListItem selected_category =
    categoryItems.firstWhere((element) => element.value == currentCategory);
    if(selected_category!=null && selected_category.key.currentContext != null)
      await Scrollable.ensureVisible(selected_category.key.currentContext, duration: new Duration(seconds: 1), curve: Curves.ease);
  }

  void refresh(){
    setState(() {

    });
  }
}

// Итем списка категорий
class CategoryListItem extends StatefulWidget {
  CategoryListItem({this.key, this.value, this.categoryList}) : super(key: key);
  final GlobalKey<CategoryListItemState> key;
  final String value;
  final CategoryListState categoryList;

  @override
  CategoryListItemState createState() {
    return new CategoryListItemState(value,categoryList);
  }
}


class CategoryListItemState extends State<CategoryListItem> with AutomaticKeepAliveClientMixin {
  final CategoryListState categoryList;
  final String value;

  CategoryListItemState(this.value, this.categoryList);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
          padding:
          EdgeInsets.only(left: 11, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: (value != categoryList.currentCategory)
                    ? Color(0xFFF6F6F6)
                    : Color(0xFFFE534F)),
            child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(
                        color: (value != categoryList.currentCategory)
                            ? Color(0xFF424242)
                            : Colors.white,
                        fontSize: 15),
                  ),
                )),
          )),
      onTap: () async {
        if (await Internet.checkConnection()) {
          //Если категория загрузась без ошибок
          if(await categoryList.parent.GoToCategory(categoryList.restaurant.product_category.indexOf(value)))
            categoryList.SelectCategory(value); // выделяем ее
        } else {
          noConnection(context);
        }
      },
    );
  }
}

// Итем хавки
class MenuItem extends StatefulWidget {
  MenuItem({this.key, this.restaurantDataItems, this.parent}) : super(key: key);
  final GlobalKey<MenuItemState> key;
  final RestaurantScreenState parent;
  final FoodRecords restaurantDataItems;

  @override
  MenuItemState createState() {
    return new MenuItemState(restaurantDataItems, parent);
  }
  static List<MenuItem> fromFoodRecordsList(List<FoodRecords> foodRecordsList, RestaurantScreenState parent) {
    List<MenuItem> result = new List<MenuItem>();
    foodRecordsList.forEach((element) {
      result.add(new MenuItem(parent: parent, restaurantDataItems: element, key: new GlobalKey<MenuItemState>()));
    });
    return result;
  }
}

class MenuItemState extends State<MenuItem> with AutomaticKeepAliveClientMixin{
  final FoodRecords restaurantDataItems;
  final RestaurantScreenState parent;

  MenuItemState(this.restaurantDataItems, this.parent);


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    GlobalKey<CartItemsQuantityState> cartItemsQuantityKey = new GlobalKey();
    CartItemsQuantity cartItemsQuantity = new CartItemsQuantity(
      key: cartItemsQuantityKey,
      restaurantDataItems: restaurantDataItems,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
          child: GestureDetector(
              onTap: () async {
                if (await Internet.checkConnection()) {
                  _onPressedButton(restaurantDataItems, cartItemsQuantityKey);
                } else {
                  noConnection(context);
                }
              },
              child: Container(
                //width: 170,
                height: 260,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.0, // soften the shadow
                        spreadRadius: 3.0, //extend the shadow
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(width: 1.0, color: Colors.grey[200])),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                        child: Hero(
                          tag: restaurantDataItems.name,
                          child: Image.network(
                            getImage(restaurantDataItems.image),
                            fit: BoxFit.cover,
                            height: 190,
                            width: MediaQuery.of(context).size.width,
                          ),)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 15),
                              child: Text(
                                restaurantDataItems.name,
                                style: TextStyle(
                                    fontSize: 15.0, color: Color(0xFF3F3F3F)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(left: 10, right: 10, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Align(
                                    child: Text(
                                      '${restaurantDataItems.price}\₽',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF6EC292)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Align(
                                    child: cartItemsQuantity,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
  void _onPressedButton(FoodRecords food, GlobalKey<CartItemsQuantityState> cartItemsQuantityKey) {

    DateTime now = DateTime.now();
    int currentTime = now.hour*60+now.minute;
    print((currentTime/60).toString() + 'KANTENT');
    print((now.hour).toString() + 'KANTENT');
    print((now.minute).toString() + 'KANTENT');
    int dayNumber  = now.weekday-1;

    int work_beginning = parent.restaurant.work_schedule[dayNumber].work_beginning;
    int work_ending = parent.restaurant.work_schedule[dayNumber].work_ending;
    bool day_off = parent.restaurant.work_schedule[dayNumber].day_off;
    bool available = parent.restaurant.available != null ? parent.restaurant.available : true;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
            )),
        context: context,
        builder: (context) {
          if(day_off ||
              !available ||
              !(currentTime >= work_beginning && currentTime < work_ending)){
            return Container(
              height: 200,
              child: parent._dayOff(food, cartItemsQuantityKey),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                  )),
            );
          }else{
            if(food.comment != "" && food.comment != null){
              return Container(
                height: 520,
                child: _buildBottomNavigationMenu(food, cartItemsQuantityKey),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                    )),
              );
            }else{
              return Container(
                height: 440,
                child: _buildBottomNavigationMenu(food, cartItemsQuantityKey),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                    )),
              );
            }
          }
        });
  }
  Container _buildBottomNavigationMenu(FoodRecords restaurantDataItems, GlobalKey<CartItemsQuantityState> cartItemsQuantityKey) {
    GlobalKey<VariantsSelectorState> variantsSelectorStateKey =
    GlobalKey<VariantsSelectorState>();
    GlobalKey<ToppingsSelectorState> toppingsSelectorStateKey =
    new GlobalKey<ToppingsSelectorState>();
    GlobalKey<PriceFieldState> priceFieldKey =
    new GlobalKey<PriceFieldState>();

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0)),
                        child: Stack(
                          children: <Widget>[
                            Hero(
                                tag: restaurantDataItems.name,
                                child: Image.network(
                                  getImage(restaurantDataItems.image),
                                  fit: BoxFit.cover,
                                  height: 320.0,
                                  width: MediaQuery.of(context).size.width,
                                )),
                            Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, right: 15),
                                  child: GestureDetector(
                                    child: SvgPicture.asset(
                                        'assets/svg_images/bottom_close.svg'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ))
                          ],
                        )),
                    (restaurantDataItems.comment != "" &&
                        restaurantDataItems.comment != null)
                        ? Container(
                      color: Color(0xFFFAFAFA),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                            EdgeInsets.only(left: 15, top: 20, bottom: 10),
                            child: Text(
                              restaurantDataItems.comment,
                              style: TextStyle(
                                  color: Color(0xFFB0B0B0), fontSize: 13),
                            ),
                          )),
                    )
                        : Container(
                      height: 0,
                    ),
                    (restaurantDataItems.variants != null)
                        ? Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          'Варианты',
                          style: TextStyle(color: Color(0xFF424242)),
                        ),
                      ),
                    )
                        : Container(
                      height: 0,
                    ),
                    (restaurantDataItems.variants != null)
                        ? VariantsSelector(
                        key: variantsSelectorStateKey,
                        variantsList: restaurantDataItems.variants)
                        : Container(height: 0),
                    (restaurantDataItems.toppings != null)
                        ? Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          'Топпинги',
                          style: TextStyle(color: Color(0xFF424242)),
                        ),
                      ),
                    )
                        : Container(
                      height: 0,
                    ),
                    (restaurantDataItems.toppings != null)
                        ? ToppingsSelector(
                        key: toppingsSelectorStateKey,
                        toppingsList: restaurantDataItems.toppings)
                        : Container(height: 0),
                  ]),
                ),
              )),
//          Expanded(
//            child: ListView(
//              scrollDirection: Axis.vertical,
//              children: List.generate(food_records_items.length, (index){
//                return Row(
//                  children: <Widget>[
//                    (food_records_items[index].variants != null) ? Text(food_records_items[index].variants[index].name) : Container(),
//                  ],
//                );
//              },
//              ),
//            ),
//          ),
          Container(
            margin: EdgeInsets.only(right: 0.0, top: 10, bottom: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 10),
                      child: Container(
                        child: RichText(text:
                        TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: restaurantDataItems.name,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF000000)),),
                              TextSpan(text: (restaurantDataItems.weight != null && restaurantDataItems.weight_measure!= null)
                                  ? '  ' + restaurantDataItems.weight + " " + restaurantDataItems.weight_measure
                                  : '', style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFFB0B0B0)),)
                            ]
                        )
                        ),
                      ),
                    )),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: PriceField(key: priceFieldKey, restaurantDataItems: restaurantDataItems),
                    )
                  ],
                ),
                SizedBox(
                  height: 4.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0),
                          child: Counter(
                              key: parent.counterKey,
                              priceFieldKey: priceFieldKey
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, right: 5, bottom: 10),
                          child: FlatButton(
                            child: Text(
                              "Добавить",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            color: Color(0xFFFE534F),
                            splashColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.only(
                                left: 70, top: 20, right: 70, bottom: 20),
                            onPressed: () async {
                              if (await Internet.checkConnection()) {
                                FoodRecords foodOrder =
                                FoodRecords.fromFoodRecords(
                                    restaurantDataItems);
                                if (variantsSelectorStateKey.currentState !=
                                    null) {
                                  if (variantsSelectorStateKey
                                      .currentState.selectedVariant !=
                                      null) {
                                    foodOrder.variants = [
                                      variantsSelectorStateKey
                                          .currentState.selectedVariant
                                    ];
                                  } else {
                                    foodOrder.variants = null;
                                  }
                                  print(foodOrder.variants);
                                }
                                if (toppingsSelectorStateKey.currentState !=
                                    null) {
                                  List<Toppings> toppingsList =
                                  toppingsSelectorStateKey.currentState
                                      .getSelectedToppings();
                                  if (toppingsList.length != null) {
                                    foodOrder.toppings = toppingsList;
                                  } else {
                                    foodOrder.toppings = null;
                                  }
                                  foodOrder.toppings.forEach((element) {
                                    print(element.name);
                                  });
                                }
                                if (currentUser.cartDataModel.cart.length > 0 &&
                                    parent.restaurant.uuid !=
                                        currentUser.cartDataModel.cart[0]
                                            .restaurant.uuid) {
                                  parent.showCartClearDialog(
                                      context,
                                      new Order(
                                          food: foodOrder,
                                          quantity:
                                          parent.counterKey.currentState.counter,
                                          restaurant: parent.restaurant,
                                          date: DateTime.now().toString()),
                                      cartItemsQuantityKey);
                                } else {
                                  currentUser.cartDataModel.addItem(new Order(
                                      food: foodOrder,
                                      quantity: parent.counterKey.currentState.counter,
                                      restaurant: parent.restaurant,
                                      date: DateTime.now().toString()));
                                  currentUser.cartDataModel.saveData();
                                  Navigator.pop(context);
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 0),
                                    child: parent.showAlertDialog(context),
                                  );
                                  parent.basketButtonStateKey.currentState.refresh();
                                  cartItemsQuantityKey.currentState.refresh();
                                  parent.counterKey.currentState.refresh();
                                }
                              } else {
                                noConnection(context);
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}