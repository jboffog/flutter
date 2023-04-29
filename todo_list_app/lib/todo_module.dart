import 'package:flutter_modular/flutter_modular.dart';
import 'package:todo_list_app/data/local_storage/hive_todo_storage.dart';
import 'package:todo_list_app/domain/use_cases/todo_use_case.dart';
import 'package:todo_list_app/presentation/stores/todo_store.dart';

import 'data/repositories/todo_repository.dart';
// import 'presentation/pages/todo_list_page.dart';

class TodoModule extends Module {
  @override
  List<Bind> get binds {
    return [
      Bind((i) => HiveTodoStorage()),
      Bind((i) => TodoRepositoryImpl(i())),
      Bind((i) => TodoUseCase(i())),
      Bind((i) => TodoStore(i()))
    ];
  }
}
