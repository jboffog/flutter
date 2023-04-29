import 'package:todo_list_app/domain/entities/todo_entity.dart';

abstract class ITodoRepository {
  Future<bool> init();
  Future<void> add(TodoEntity todo);
  Future<List<TodoEntity>> getAll();
  Future<void> update(TodoEntity todo);
  Future<void> delete(int id);
}
