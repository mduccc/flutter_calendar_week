import 'package:flutter/cupertino.dart';

class DecorationItem {
  final Widget decoration;
  final DateTime date;
  final Alignment decorationAlignment;

  DecorationItem({
    this.decoration,
    this.date,
    this.decorationAlignment = FractionalOffset.center,
  });
}
