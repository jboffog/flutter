// ignore_for_file: avoid_print

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list_app/data/models/todo.dart';

class HiveTodoStorage {
  static const _todoBoxName = 'todoBox';

  Future<bool> init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      Hive.registerAdapter(TodoAdapter());
      await Hive.openBox<Todo>(_todoBoxName);

      print('db is loaded');
      return true;
    } catch (e) {
      print('error on load db: $e');
      return false;
    }
  }

  Future<void> add(Todo todo) async {
    Box<Todo> todoBox = Hive.box<Todo>(_todoBoxName);
    await todoBox.add(todo);
  }

  Future<void> delete(int key) async {
    Box<Todo> todoBox = Hive.box<Todo>(_todoBoxName);
    await todoBox.delete(key);
  }

  Future<List<Todo>> getAll() async {
    Box<Todo> todoBox = Hive.box<Todo>(_todoBoxName);
    return todoBox.values.toList();
  }

  Future<void> update(Todo todo, int key) async {
    Box<Todo> todoBox = Hive.box<Todo>(_todoBoxName);
    await todoBox.put(key, todo);
  }
}
