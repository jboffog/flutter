// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:todo_list_app/domain/entities/todo_entity.dart';
import 'package:todo_list_app/presentation/utils/colors.dart';
import 'package:todo_list_app/presentation/utils/dimens.dart';
import 'package:todo_list_app/presentation/utils/strings.dart';

class HandleTodoDialog extends StatefulWidget {
  final TodoEntity? todo;

  const HandleTodoDialog({super.key, this.todo});

  @override
  _HandleTodoDialogState createState() => _HandleTodoDialogState();
}

class _HandleTodoDialogState extends State<HandleTodoDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;

  late TextEditingController _controller;

  final int MAX_LEN = 100;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.todo?.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlinedInputBorder =
        OutlineInputBorder(borderRadius: AppDimens.DEFAULT_BORDER_RADIUS, borderSide: AppDimens.DEFAULT_BORDER_SIDE);
    return AlertDialog(
        shape: outlinedInputBorder,
        elevation: AppDimens.DEFAULT_ELEVATION,
        title: Text(widget.todo != null ? AppStrings.HANDLE_EDIT_APP_BAR_TITLE : AppStrings.HANDLE_NEW_APP_BAR_TITLE,
            textAlign: TextAlign.center),
        titlePadding: AppDimens.DEFAULT_TITLE_DIALOG_PADDING,
        content: Form(
            key: _formKey,
            child: TextFormField(
                maxLines: null,
                maxLength: MAX_LEN,
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                    isDense: true,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    focusedErrorBorder: outlinedInputBorder,
                    errorBorder: outlinedInputBorder,
                    labelText: AppStrings.LABEL_HANDLE_TEXT,
                    labelStyle: const TextStyle(color: AppColors.BLACK),
                    focusedBorder: outlinedInputBorder,
                    enabledBorder: outlinedInputBorder),
                validator: (value) {
                  if (value == null || value.isEmpty) return AppStrings.HANDLE_ERROR_TEXT;

                  return null;
                },
                onSaved: (value) => _title = value!)),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsPadding: AppDimens.DEFAULT_ACTIONS_PADDING,
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text(AppStrings.HANDLE_CANCEL_BTN_TEXT)),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pop(context, _title);
                }
              },
              child: const Text(AppStrings.HANDLE_CONCLUDED_BTN_TEXT))
        ]);
  }
}
