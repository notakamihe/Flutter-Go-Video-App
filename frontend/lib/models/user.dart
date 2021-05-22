class User {
  String id;
  String name;
  String email;
  String password;
  DateTime createdOn;

  User({this.id, this.name, this.email, this.password, this.createdOn});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"].toString(),
      name: json["name"],
      email: json["email"],
      password: json["password"],
      createdOn: DateTime.parse(json["createdOn"] != null ? json["createdOn"] : json["createdon"]),
    );
  }

  @override
  String toString() {
    return "User(id: ${this.id}, name: ${this.name}, email: ${this.email}, password: ${this.password}, createdOn: ${this.createdOn}, )";
  }
}