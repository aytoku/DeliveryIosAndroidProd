class DeliveryResponseData {
  List<Records> records;
  int records_count;

  DeliveryResponseData( {
    this.records,
    this.records_count,
  });

  factory DeliveryResponseData.fromJson(Map<String, dynamic> parsedJson){

    var records_list = parsedJson['records'] as List;
    print(records_list.runtimeType);
    List<Records> recordList = records_list.map((i) => Records.fromJson(i)).toList();

    return DeliveryResponseData(
        records:recordList,
        records_count:parsedJson['records_count']
    );
  }
}

class Records{
  String uuid;
  String name;
  String phone;
  String comment;
  bool own_delivery;
  String image;
  bool available;
  List<WorkSchedule> work_schedule;
  String type;
  List<String> product_category;
  List<DestinationPoints> destination_points;
  List<String> destination_points_uuid;
  int order_preparation_time_second;
  int created_at_unix;

  Records( {
    this.uuid,
    this.name,
    this.phone,
    this.comment,
    this.own_delivery,
    this.image,
    this.available,
    this.work_schedule,
    this.type,
    this.product_category,
    this.destination_points,
    this.destination_points_uuid,
    this.order_preparation_time_second,
    this.created_at_unix,
  });

  Map<String, dynamic> toJson(){
    List<dynamic> dp;
    if(destination_points != null && destination_points.length > 0) {
      dp = new List<dynamic>();
//      dp.add(destination_points[0].toJson());
      destination_points.forEach((element) {
        dp.add(
            element.toJson()
        );
      });
    }

    return
      {
        'uuid': this.uuid,
        'name': this.name,
        'phone': this.phone,
        'comment': this.comment,
        'own_delivery': this.own_delivery,
        'image': this.image,
        'available': this.available,
        'work_schedule': null,
        'type': this.type,
        'product_category': null,
        'destination_points': dp,
        'destination_points_uuid': null,
        'order_preparation_time_second': this.order_preparation_time_second,
        'created_at_unix': this.created_at_unix,
      };
  }

  factory Records.fromJson(Map<String, dynamic> parsedJson){

    var work_schedule_list = parsedJson['work_schedule'] as List;
    List<WorkSchedule> workScheduleList = null;
    if(work_schedule_list != null){
      workScheduleList = work_schedule_list.map((i) =>
          WorkSchedule.fromJson(i)).toList();
    }

    var destination_points_list = parsedJson['destination_points'] as List;
    List<DestinationPoints> destinationPointsList = null;
    if(destination_points_list != null){
      destinationPointsList = destination_points_list.map((i) =>
          DestinationPoints.fromJson(i)).toList();
    }

    var product_category_list = parsedJson['product_category'] as List;
    List<String> productCategoryList = new List<String>();
    if(product_category_list !=null) {
      product_category_list.forEach((element) {
        productCategoryList.add(element as String);
      });
    }

    var destination_points_uuid_list = parsedJson['destination_points_uuid'] as List;
    List<String> destinationPointsUuidList = new List<String>();
    if(destination_points_uuid_list != null){
      destination_points_uuid_list.forEach((element) {
        destinationPointsUuidList.add(element as String);
      });
    }

    return Records(
      uuid: parsedJson['uuid'],
      name: parsedJson['name'],
      phone: parsedJson['phone'],
      comment: parsedJson['comment'],
      own_delivery: parsedJson['own_delivery'],
      image: parsedJson['image'],
      work_schedule: workScheduleList,
      type: parsedJson['type'],
      product_category: productCategoryList,
      available: parsedJson['available'],
      destination_points: destinationPointsList,
      destination_points_uuid: destinationPointsUuidList,
      order_preparation_time_second: parsedJson['order_preparation_time_second'],
      created_at_unix: parsedJson['created_at_unix'],
    );
  }

  String getCategoriesString(){
    String result = '';
    product_category.forEach((element) {
      result += element + ', ';
    });
    if(result == ''){
      return result;
    }
    return result.substring(0, result.length - 3);
  }
}

class WorkSchedule{
  int week_day;
  bool day_off;
  int work_beginning;
  int work_ending;

  WorkSchedule( {
    this.week_day,
    this.day_off,
    this.work_beginning,
    this.work_ending,
  });

  Map<String, dynamic> toJson(){
    return
      {
        'week_day': this.week_day,
        'day_off': this.day_off,
        'work_beginning': this.work_beginning,
        'work_ending': this.work_ending,
      };
  }

  factory WorkSchedule.fromJson(Map<String, dynamic> parsedJson){
    return WorkSchedule(
      week_day:parsedJson['week_day'],
      day_off:parsedJson['day_off'],
      work_beginning:parsedJson['work_beginning'],
      work_ending:parsedJson['work_ending'],
    );
  }
}

class DestinationPoints{
  String uuid;
  String point_type;
  String unrestricted_value;
  String value;
  String country;
  String region;
  String region_type;
  String type;
  String city;
  String category;
  String city_type;
  String street;
  String street_type;
  String street_with_type;
  String house;
  int front_door;
  String comment;
  bool out_of_town;
  String house_type;
  int accuracy_level;
  int radius;
  double lat;
  double lon;
  String name;

  DestinationPoints( {
    this.uuid,
    this.point_type,
    this.unrestricted_value,
    this.value,
    this.country,
    this.region,
    this.region_type,
    this.type,
    this.city,
    this.category,
    this.city_type,
    this.street,
    this.street_type,
    this.street_with_type,
    this.house,
    this.front_door,
    this.comment,
    this.out_of_town,
    this.house_type,
    this.accuracy_level,
    this.radius,
    this.lat,
    this.lon,
    this.name
  });

  factory DestinationPoints.fromJson(Map<String, dynamic> parsedJson){

    return DestinationPoints(
      uuid:parsedJson['uuid'],
      point_type:parsedJson['point_type'],
      unrestricted_value:parsedJson['unrestricted_value'],
      value:parsedJson['value'],
      country:parsedJson['country'],
      region:parsedJson['region'],
      region_type:parsedJson['region_type'],
      type:parsedJson['type'],
      city:parsedJson['city'],
      category:parsedJson['category'],
      city_type:parsedJson['city_type'],
      street:parsedJson['street'],
      street_type:parsedJson['street_type'],
      street_with_type:parsedJson['street_with_type'],
      house:parsedJson['house'],
      front_door:parsedJson['front_door'],
      comment:parsedJson['comment'],
      out_of_town:parsedJson['out_of_town'],
      house_type:parsedJson['house_type'],
      accuracy_level:parsedJson['accuracy_level'],
      radius:parsedJson['radius'],
      lat:parsedJson['lat'],
      lon:parsedJson['lon'],
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> temp = new Map<String, dynamic>();
    temp = {
      'uuid': uuid,
      'point_type':point_type,
      'unrestricted_value':unrestricted_value,
      'value':value,
      'country':country,
      'region':region,
      'region_type':region_type,
      'type':type,
      'city':city,
      'category':category,
      'city_type':city_type,
      'street':street,
      'street_type':street_type,
      'street_with_type':street_with_type,
      'house':house,
      'front_door':front_door,
      'comment':comment,
      'out_of_town':out_of_town,
      'house_type':house_type,
      'accuracy_level':accuracy_level,
      'radius':radius,
      'lat':lat,
      'lon':lon,
    };
    return temp;
  }
}