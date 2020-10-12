class Owners{
  List<OwnersModel>ownersModelList;

  Owners({
    this.ownersModelList
  });

  factory Owners.fromJson(List<dynamic> parsedJson){
    var owners_list = parsedJson;
    List<OwnersModel> ownersList = null;
    if(owners_list != null){
      ownersList = owners_list.map((i) =>
          OwnersModel.fromJson(i)).toList();
    }

    return Owners(
      ownersModelList: ownersList,
    );
  }
}

class OwnersModel {
  int id;
  String created_at;
  String updated_at;
  String uuid;
  String name;
  String comment;

  OwnersModel( {
    this.id,
    this.created_at,
    this.updated_at,
    this.uuid,
    this.name,
    this.comment
  });

  factory OwnersModel.fromJson(Map<String, dynamic> parsedJson){

    return OwnersModel(
      id:parsedJson['id'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
      uuid:parsedJson['uuid'],
      name:parsedJson['name'],
      comment:parsedJson['comment'],
    );
  }
}