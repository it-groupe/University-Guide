import 'package:flutter/material.dart';

/// ظلال موحدة للكروت والمكونات
abstract class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
  ];

  static const List<BoxShadow> elevatedButton = [
    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
  ];
}
