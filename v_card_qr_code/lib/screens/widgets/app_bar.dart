import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_card_qr_code/helpers/color.dart';

class AppAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;
  final Size? preferredSizeBottom;

  const AppAppBar({super.key, required this.title, this.bottom, this.preferredSizeBottom});

  @override
  State<AppAppBar> createState() => _AppAppBarState();

  @override
  Size get preferredSize {
    double preferredSize = kToolbarHeight;
    if (bottom != null && preferredSizeBottom != null) {
      preferredSize = kToolbarHeight + preferredSizeBottom!.height;
    } else if (bottom != null && preferredSizeBottom == null) {
      preferredSize = kToolbarHeight + kBottomNavigationBarHeight;
    }

    return Size.fromHeight(preferredSize);
  }
}

class _AppAppBarState extends State<AppAppBar> {
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        centerTitle: true,
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [AppColors().primaryColor, AppColors().secundaryColor]))),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        bottom: widget.bottom,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary);
  }
}
