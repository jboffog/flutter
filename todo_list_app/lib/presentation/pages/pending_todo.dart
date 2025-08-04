// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo_list_app/domain/entities/todo_entity.dart';
import 'package:todo_list_app/domain/enums/todos_nomenclature_enum.dart';
import 'package:todo_list_app/presentation/pages/handle_todo_dialog.dart';
import 'package:todo_list_app/presentation/pages/widgets/list_item.dart';
import 'package:todo_list_app/presentation/stores/todo_store.dart';
import 'package:todo_list_app/presentation/utils/constants.dart';
import 'package:todo_list_app/presentation/utils/dimens.dart';
import 'package:todo_list_app/presentation/utils/strings.dart';

class PendingTodosPage extends StatefulWidget {
  final TodosNomenclature todoNomenclature;
  final TodoStore store;

  const PendingTodosPage({
    super.key,
    required this.todoNomenclature,
    required this.store,
  });

  @override
  State<PendingTodosPage> createState() => _PendingTodosPageState();
}

class _PendingTodosPageState extends State<PendingTodosPage> {
  final Duration _animationDuration = AppConstants.APPLY_ANIMATION_DURANTION;
  final Duration _applyOpacityDuration = AppConstants.APPLY_OPACITY_ANIMATION_DURATION;

  late int _idTodoAnimation = -1;

  Future<void> _applyFadeAnimation(int id) async {
    setState(() => _idTodoAnimation = id);
    await Future.delayed(_applyOpacityDuration).then((value) => _idTodoAnimation = -1);
  }

  Widget _buildMessageWidget(String message) {
    return Row(children: [
      Expanded(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      )
    ]);
  }

  Widget _buildListItem(TodoEntity todo, BuildContext context) {
    return AnimatedOpacity(
      opacity: _idTodoAnimation != todo.id ? 1.0 : 0.0,
      duration: _animationDuration,
      child: TodoListItem(
          todo: todo,
          onToggle: (value) => _applyFadeAnimation(todo.id).then(
                (value) => widget.store
                    .updateTodo(id: todo.id, title: todo.title, isDone: !todo.isDone)
                    .then((value) => _showToast(context: context, msg: AppStrings.TODO_UPDATED_TEXT)),
              ),
          onDelete: () async => await widget.store.deleteTodoById(todo.key).then(
                (value) => _showToast(context: context, msg: AppStrings.TODO_DELETED_TEXT),
              ),
          onEdit: () async {
            final result = await showDialog(
              context: context,
              builder: (_) => HandleTodoDialog(todo: todo),
            );
            if (result != null) {
              widget.store.updateTodo(id: todo.id, title: result, isDone: todo.isDone).then(
                    (value) => _showToast(context: context, msg: AppStrings.TODO_UPDATED_TEXT),
                  );
            }
          }),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showToast(
      {required String msg, required BuildContext context}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 1),
        elevation: AppDimens.DEFAULT_ELEVATION,
        behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    final pendingTodos = widget.store.todoList.where((element) => !element.isDone).toList();

    if (pendingTodos.isNotEmpty) {
      return ListView.builder(
        itemCount: pendingTodos.length,
        itemBuilder: (_, index) => _buildListItem(pendingTodos[index], context),
      );
    } else {
      return _buildMessageWidget(AppStrings.ALL_DONE_TEXT);
    }
  }
}
