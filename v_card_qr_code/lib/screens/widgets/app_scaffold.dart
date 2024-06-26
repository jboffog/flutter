import 'package:flutter/material.dart';
import 'package:v_card_qr_code/helpers/color.dart';
import 'package:v_card_qr_code/screens/widgets/app_bar.dart';

class AppScaffold extends StatefulWidget {
  final AppAppBar? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final Key? scaffoldKey;

  const AppScaffold(
      {super.key, this.appBar, required this.body, this.backgroundColor, this.scaffoldKey, this.bottomNavigationBar});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
        key: widget.scaffoldKey,
        backgroundColor: widget.backgroundColor ?? AppColors().bgColor,
        appBar: widget.appBar,
        body: widget.body,
        bottomNavigationBar: widget.bottomNavigationBar);
  }
}
