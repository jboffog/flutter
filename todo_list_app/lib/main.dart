import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:todo_list_app/presentation/pages/list_todo_page.dart';
import 'package:todo_list_app/presentation/utils/colors.dart';
import 'package:todo_list_app/presentation/utils/strings.dart';
import 'package:todo_list_app/todo_module.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future.delayed(const Duration(seconds: 1))
      .then((value) => runApp(ModularApp(module: TodoModule(), child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: AppStrings.APP_TITLE,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: AppColors.APP_PRIMARY_SWATCH,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const TodoListScreen());
  }
}
