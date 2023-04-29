class TodoEntity {
  String title;
  bool isDone;
  int id;
  dynamic key;

  TodoEntity({
    required this.title,
    required this.isDone,
    required this.id,
    this.key,
  });
}
