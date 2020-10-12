class User{
  int id;
  String name;
  String username;
  String email;

  User({this.id, this.name, this.email, this.username});

  factory User.fromJson(Map<String, dynamic> parsedJson){
    return User(
      id: parsedJson["id"],
      name: parsedJson["name"] as String,
      username: parsedJson["username"] as String,
      email: parsedJson["email"] as String,
    );
  }
}