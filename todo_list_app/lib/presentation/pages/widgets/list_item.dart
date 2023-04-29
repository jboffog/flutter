import 'package:flutter/material.dart';
import 'package:todo_list_app/domain/entities/todo_entity.dart';
import 'package:todo_list_app/presentation/utils/colors.dart';
import 'package:todo_list_app/presentation/utils/dimens.dart';

class TodoListItem extends StatelessWidget {
  final TodoEntity todo;
  final void Function()? onDelete;
  final void Function(bool?)? onToggle;
  final void Function()? onEdit;
  const TodoListItem({Key? key, required this.todo, this.onDelete, this.onToggle, this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(todo.key.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          if (onDelete != null) onDelete!();
        },
        background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: AppColors.RED,
            child: const Padding(
                padding: AppDimens.DEFAULT_DISMISSIBLE_ICON_PADDING,
                child: Icon(Icons.delete, color: AppColors.WHITE))),
        child: ListTile(
            title: Text(todo.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, decoration: todo.isDone ? TextDecoration.lineThrough : null)),
            leading: Checkbox(value: todo.isDone, onChanged: onToggle),
            trailing: IconButton(icon: const Icon(Icons.edit), onPressed: onEdit)));
  }
}
