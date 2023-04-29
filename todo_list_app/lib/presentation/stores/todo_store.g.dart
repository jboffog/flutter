// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TodoStore on _TodoStoreBase, Store {
  late final _$todoListAtom = Atom(name: '_TodoStoreBase.todoList', context: context);

  @override
  ObservableList<TodoEntity> get todoList {
    _$todoListAtom.reportRead();
    return super.todoList;
  }

  @override
  set todoList(ObservableList<TodoEntity> value) {
    _$todoListAtom.reportWrite(value, super.todoList, () {
      super.todoList = value;
    });
  }

  late final _$manageDataAsyncAction = AsyncAction('_TodoStoreBase.manageData', context: context);

  @override
  Future<void> manageData({bool loaddb = false}) {
    return _$manageDataAsyncAction.run(() => super.manageData(loaddb: loaddb));
  }

  late final _$addTodoAsyncAction = AsyncAction('_TodoStoreBase.addTodo', context: context);

  @override
  Future<void> addTodo({required String title, bool isDone = false}) {
    return _$addTodoAsyncAction.run(() => super.addTodo(title: title, isDone: isDone));
  }

  late final _$updateTodoAsyncAction = AsyncAction('_TodoStoreBase.updateTodo', context: context);

  @override
  Future<void> updateTodo({required int id, required String title, bool isDone = false}) {
    return _$updateTodoAsyncAction.run(() => super.updateTodo(id: id, title: title, isDone: isDone));
  }

  late final _$deleteTodoByIdAsyncAction = AsyncAction('_TodoStoreBase.deleteTodoById', context: context);

  @override
  Future<void> deleteTodoById(int id) {
    return _$deleteTodoByIdAsyncAction.run(() => super.deleteTodoById(id));
  }

  @override
  String toString() {
    return '''
todoList: ${todoList}
    ''';
  }
}
