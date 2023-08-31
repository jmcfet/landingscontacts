

import 'package:flutter/material.dart';

abstract class NavigationItem {}

class HeaderItem implements NavigationItem {
  GestureDetector gestureDetector;

  HeaderItem(this.gestureDetector);
}

class SimpleItem implements NavigationItem {
  SimpleItem({   this.title, this.leadingIconData, this.trailingIconData});

  final String? title;
  final IconData? leadingIconData, trailingIconData;
}
