import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final Alignment? alignment;
  final EdgeInsets? margin;
  const ItemContainer(
      {Key? key, required this.child, this.width, this.decoration, this.height, this.alignment, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) => width != null || height != null
      ? Container(
          margin: margin,
          width: width,
          height: height,
          decoration: decoration,
          alignment: alignment,
          child: child,
        )
      : Expanded(
          child: (decoration != null || alignment != null)
              ? Container(
                  margin: margin,
                  decoration: decoration,
                  alignment: alignment ?? Alignment.center,
                  child: child,
                )
              : Container(child: child),
        );
}
