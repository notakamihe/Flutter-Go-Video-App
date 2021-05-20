class Video {
  String id;
  String title;
  String description;
  DateTime createdOn;
  List<String> likes;
  String fileUrl;
  String coverUrl;
  int views;
  Object user;

  Video(
    this.id, 
    this.title, 
    this.description, 
    this.createdOn, 
    this.likes, 
    this.fileUrl, 
    this.coverUrl,
    this.views,
    this.user
  );
}