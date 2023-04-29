// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:todo_list_app/domain/entities/todo_entity.dart';
import 'package:todo_list_app/domain/enums/todos_visibility_enum.dart';
import 'package:todo_list_app/presentation/pages/handle_todo_dialog.dart';
import 'package:todo_list_app/presentation/pages/widgets/list_item.dart';
import 'package:todo_list_app/presentation/stores/todo_store.dart';
import 'package:todo_list_app/presentation/utils/colors.dart';
import 'package:todo_list_app/presentation/utils/dimens.dart';
import 'package:todo_list_app/presentation/utils/strings.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late TodoStore store;

  final int DEFAULT_INDEX = 2;
  final int INDEX_TO_SHOW_INFO_BUTTON = 2;
  late int _idTodoAnimation = -1;
  final Duration _applyOpacityDuration = const Duration(milliseconds: 500);
  final Duration _animationDuration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    store = Modular.get<TodoStore>();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Builder(builder: (context) {
          return Scaffold(
              appBar: AppBar(title: const Text(AppStrings.MAIN_APP_BAR_TITLE)),
              body: _buildBody(),
              bottomNavigationBar: _buildBottomNavigationBar(context));
        }));
  }

  Widget _buildBody() {
    return SafeArea(
        child: Padding(
            padding: AppDimens.DEFAULT_PAGE_PADDING,
            child: Column(children: [
              Observer(builder: (context) {
                return Expanded(
                    child: TabBarView(physics: const NeverScrollableScrollPhysics(), children: [
                  _handleTodosVisibility(context, store.todoList.toList()),
                  _handleTodosVisibility(context, store.todoList.where((element) => !element.isDone).toList(),
                      visibility: TodosVisibility.pending),
                  _handleTodosVisibility(context, store.todoList.where((element) => element.isDone).toList(),
                      visibility: TodosVisibility.done)
                ]));
              })
            ])));
  }

  Widget _handleTodosVisibility(BuildContext context, List<TodoEntity> list, {TodosVisibility? visibility}) {
    if (list.isNotEmpty) {
      return ListView.builder(itemCount: list.length, itemBuilder: (_, index) => _buildListItem(list[index], context));
    }

    return _handleMessageVisiblity(visibility, list);
  }

  Widget _buildListItem(TodoEntity todo, BuildContext context) {
    return AnimatedOpacity(
      opacity: _idTodoAnimation != todo.id ? 1.0 : 0.0,
      duration: _animationDuration,
      child: TodoListItem(
          todo: todo,
          onToggle: (value) => _applyFadeAnimation(todo.id).then((value) => store
              .updateTodo(id: todo.id, title: todo.title, isDone: !todo.isDone)
              .then((value) => _showToast(AppStrings.TODO_UPDATED_TEXT))),
          onDelete: () async =>
              await store.deleteTodoById(todo.key).then((value) => _showToast(AppStrings.TODO_DELETED_TEXT)),
          onEdit: () async {
            final result = await showDialog(context: context, builder: (_) => HandleTodoDialog(todo: todo));
            if (result != null) {
              store
                  .updateTodo(id: todo.id, title: result, isDone: todo.isDone)
                  .then((value) => _showToast(AppStrings.TODO_UPDATED_TEXT));
            }
          }),
    );
  }

  Widget _buildMessageWidget(String message) {
    return Row(
        children: [Expanded(child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)))]);
  }

  Widget _handleMessageVisiblity(TodosVisibility? visibility, List<TodoEntity> list) {
    if (visibility == null && list.isEmpty) {
      return _buildMessageWidget(AppStrings.NOTHING_TO_SHOW_TEXT);
    } else if (visibility == TodosVisibility.done && list.isEmpty) {
      return _buildMessageWidget(AppStrings.ALL_PENDING_TEXT);
    } else if (visibility == TodosVisibility.pending && list.isEmpty) {
      return _buildMessageWidget(AppStrings.ALL_DONE_TEXT);
    } else {
      return const SizedBox();
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(
          padding: AppDimens.DEFAULT_BOTTOM_NAVIGATOR_BAR_PADDING,
          child: Container(
              decoration: BoxDecoration(color: AppColors.LIGHT_GRAY, borderRadius: AppDimens.DEFAULT_BORDER_RADIUS),
              child: TabBar(
                  indicator: BoxDecoration(
                      color: AppColors.LIGHT_PRIMARY_COLOR, borderRadius: AppDimens.DEFAULT_BORDER_RADIUS),
                  labelColor: AppColors.WHITE,
                  unselectedLabelColor: AppColors.BLACK,
                  onTap: (value) => setState(() {}),
                  tabs: [
                    Tab(text: TodosVisibility.all.asString),
                    Tab(text: TodosVisibility.pending.asString),
                    Tab(text: TodosVisibility.done.asString)
                  ]))),
      Padding(
          padding: Platform.isAndroid
              ? AppDimens.DEFAULT_MAIN_ACTION_BUTTON_PADDING_ANDROID
              : AppDimens.DEFAULT_MAIN_ACTION_BUTTON_PADDING,
          child: _getTabBarIndex(context) != INDEX_TO_SHOW_INFO_BUTTON
              ? FloatingActionButton(
                  onPressed: () async {
                    final result = await showDialog(context: context, builder: (_) => const HandleTodoDialog());
                    if (result != null) {
                      store
                          .addTodo(title: result)
                          .then((value) => _applyFadeAnimation(store.todoList.last.id))
                          .then((value) => setState((() {})))
                          .then((value) => _showToast(AppStrings.TODO_INCLUDED_TEXT));
                    }
                  },
                  child: const Icon(Icons.add))
              : FloatingActionButton(
                  onPressed: () => _showToast(AppStrings.DELETE_TODO_INFO_TEXT), child: const Icon(Icons.info)))
    ]));
  }

  Future<void> _applyFadeAnimation(int id) async {
    setState(() => _idTodoAnimation = id);
    await Future.delayed(_applyOpacityDuration).then((value) => _idTodoAnimation = -1);
  }

  _getTabBarIndex(BuildContext context) {
    try {
      return DefaultTabController.of(context)!.index;
    } catch (e) {
      return DEFAULT_INDEX;
    }
  }

  _showToast(String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 1),
        elevation: AppDimens.DEFAULT_ELEVATION,
        behavior: SnackBarBehavior.floating));
  }
}
