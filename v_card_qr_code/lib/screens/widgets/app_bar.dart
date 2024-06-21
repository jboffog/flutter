import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_card_qr_code/helpers/color.dart';

class AppAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget? widgetTittle;
  final String? title;
  final PreferredSizeWidget? bottom;
  final Size? preferredSizeBottom;

  const AppAppBar({super.key, this.widgetTittle, this.title, this.bottom, this.preferredSizeBottom});

  @override
  State<AppAppBar> createState() => _AppAppBarState();

  @override
  Size get preferredSize {
    double preferredSize = 0.0;

    if (title != null || widgetTittle != null) {
      preferredSize = kToolbarHeight;
    }
    if (bottom != null && preferredSizeBottom != null) {
      preferredSize = preferredSize + preferredSizeBottom!.height;
    } else if (bottom != null && preferredSizeBottom == null) {
      preferredSize = preferredSize + kBottomNavigationBarHeight;
    }

    return Size.fromHeight(preferredSize);
  }
}

class _AppAppBarState extends State<AppAppBar> {
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        centerTitle: true,
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [AppColors().secundaryColor, AppColors().secundaryColor]))),
        title: widget.title != null
            ? Text(widget.title!, style: const TextStyle(color: Colors.white))
            : widget.widgetTittle,
        bottom: widget.bottom,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary);
  }
}
