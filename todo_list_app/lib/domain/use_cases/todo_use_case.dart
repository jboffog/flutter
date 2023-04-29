import 'package:todo_list_app/domain/entities/todo_entity.dart';
import 'package:todo_list_app/domain/repositories/todo_irepository.dart';

abstract class ITodoUseCase {
  Future<bool> init();
  Future<void> add(TodoEntity todo);
  Future<List<TodoEntity>> getAll();
  Future<void> update(TodoEntity todo);
  Future<void> delete(int id);
}

class TodoUseCase implements ITodoUseCase {
  final ITodoRepository repo;

  TodoUseCase(this.repo);

  @override
  Future<bool> init() {
    return repo.init();
  }

  @override
  Future<void> add(TodoEntity todo) {
    return repo.add(todo);
  }

  @override
  Future<void> delete(int id) {
    return repo.delete(id);
  }

  @override
  Future<List<TodoEntity>> getAll() {
    return repo.getAll();
  }

  @override
  Future<void> update(TodoEntity todo) {
    return repo.update(todo);
  }
}
