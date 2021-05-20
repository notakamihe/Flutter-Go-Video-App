class User {
  String id;
  String name;
  String email;
  String password;
  DateTime createdOn;

  User({this.id, this.name, this.email, this.password, this.createdOn});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      password: json["password"],
      createdOn: json["createdOn"],
    );
  }
}