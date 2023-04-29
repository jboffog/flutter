// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:todo_list_app/presentation/utils/colors.dart';

class AppDimens {
  static const DEFAULT_PAGE_PADDING = EdgeInsets.only(left: 8, right: 8);
  static const DEFAULT_BOTTOM_NAVIGATOR_BAR_PADDING = EdgeInsets.only(top: 8, left: 8, right: 8);
  static const DEFAULT_MAIN_ACTION_BUTTON_PADDING = EdgeInsets.only(right: 12, top: 12);
  static const DEFAULT_MAIN_ACTION_BUTTON_PADDING_ANDROID = EdgeInsets.only(right: 12, top: 12, bottom: 12);
  static const DEFAULT_TITLE_DIALOG_PADDING = EdgeInsets.only(bottom: 22, top: 22);

  static const DEFAULT_INNER_PADDING = EdgeInsets.only(bottom: 12, top: 12);
  static final DEFAULT_BORDER_RADIUS = BorderRadius.circular(25.0);
  static final DEFAULT_BORDER_SIDE = BorderSide(color: AppColors.LIGHT_PRIMARY_COLOR!, width: 1.0);
  static const DEFAULT_ACTIONS_PADDING = EdgeInsets.only(bottom: 22);
  static const DEFAULT_DISMISSIBLE_ICON_PADDING = EdgeInsets.fromLTRB(0, 0, 16, 0);

  static double DEFAULT_ELEVATION = 5;
}
