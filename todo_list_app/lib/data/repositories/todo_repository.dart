import 'package:todo_list_app/data/local_storage/hive_todo_storage.dart';
import 'package:todo_list_app/data/models/todo.dart';
import 'package:todo_list_app/domain/entities/todo_entity.dart';
import 'package:todo_list_app/domain/repositories/todo_irepository.dart';

class TodoRepositoryImpl implements ITodoRepository {
  final HiveTodoStorage _storage;

  TodoRepositoryImpl(this._storage);

  @override
  Future<bool> init() async {
    return await _storage.init();
  }

  @override
  Future<void> add(TodoEntity todo) async {
    Todo todoToBox = Todo(title: todo.title, id: todo.id);
    await _storage.add(todoToBox);
  }

  @override
  Future<void> delete(int key) async {
    await _storage.delete(key);
  }

  @override
  Future<List<TodoEntity>> getAll() async {
    List<TodoEntity> result = [];
    List<Todo> list = await _storage.getAll();

    for (Todo todo in list) {
      TodoEntity todoEntity = TodoEntity(title: todo.title, isDone: todo.isDone, id: todo.id, key: todo.key);
      result.add(todoEntity);
    }

    return result;
  }

  @override
  Future<void> update(TodoEntity todo) async {
    Todo todoToBox = Todo(title: todo.title, id: todo.id, isDone: todo.isDone);
    await _storage.update(todoToBox, todo.key);
  }
}
