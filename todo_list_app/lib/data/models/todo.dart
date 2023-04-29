// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late bool isDone;

  @HiveField(2)
  late int id;

  Todo({
    required this.title,
    this.isDone = false,
    required this.id,
  });
}
