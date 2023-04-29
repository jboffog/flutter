// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_interpolation_to_compose_strings
import 'package:mobx/mobx.dart';
import 'package:todo_list_app/domain/entities/todo_entity.dart';
import 'package:todo_list_app/domain/use_cases/todo_use_case.dart';

part 'todo_store.g.dart';

class TodoStore = _TodoStoreBase with _$TodoStore;

abstract class _TodoStoreBase with Store {
  final TodoUseCase _usecase;

  _TodoStoreBase(this._usecase) {
    manageData(loaddb: true);
  }

  @observable
  ObservableList<TodoEntity> todoList = ObservableList<TodoEntity>();

  @action
  Future<void> manageData({bool loaddb = false}) async {
    if (loaddb) await _usecase.init();

    List<TodoEntity> todos = await _usecase.getAll();
    todoList.clear();
    todoList.addAll(todos);
  }

  @action
  Future<void> addTodo({required String title, bool isDone = false}) async {
    TodoEntity newTodo =
        TodoEntity(title: title, isDone: isDone, id: DateTime.now().millisecondsSinceEpoch, key: todoList.length);
    await _usecase.add(newTodo);
    manageData();
  }

  @action
  Future<void> updateTodo({required int id, required String title, bool isDone = false}) async {
    int todoIndex = todoList.indexWhere((todo) => todo.id == id);
    if (todoIndex != -1) {
      TodoEntity updatedTodo = todoList.where((todo) => todo.id == id).first;
      updatedTodo.title = title;
      updatedTodo.isDone = isDone;
      await _usecase.update(updatedTodo);
      manageData();
    }
  }

  @action
  Future<void> deleteTodoById(int id) async {
    await _usecase.delete(id);
    manageData();
  }
}
