class Video {
  String id;
  String title;
  String description;
  DateTime createdOn;
  List<dynamic> likes;
  String fileUrl;
  String thumbnailUrl;
  int views;
  Map<String, dynamic> user;

  Video({
    this.id, 
    this.title, 
    this.description, 
    this.createdOn, 
    this.likes, 
    this.fileUrl, 
    this.thumbnailUrl,
    this.views,
    this.user
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json["_id"].toString(),
      title: json["title"],
      description: json["description"],
      createdOn: DateTime.parse(json["createdon"]),
      likes: json["likes"],
      fileUrl: json["fileurl"],
      thumbnailUrl: json["thumbnailurl"],
      views: json["views"],
      user: json["user"]
    );
  }

  @override
  String toString() {
    return "User(id: ${this.id}, title: ${this.title}, description: ${this.description}, createdOn: ${this.createdOn}, likes: ${this.likes}, fileUrl: ${this.fileUrl}, thumbnailUrl: ${this.thumbnailUrl}, views: ${this.views}, user: ${this.user})";
  }
}