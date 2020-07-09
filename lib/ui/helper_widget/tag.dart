import 'package:first_team_project/ui/util/SizeRatio.dart';
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  Tag({
    Key key,
    @required this.width,
    @required this.text,
    @required this.backgroundColor,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  final double width;
  final Text text;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? EdgeInsets.all(width * SizeRatio.paddingRatioWidth * 0.25),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ??
            BorderRadius.circular(width * SizeRatio.borderRadiusRatioWidth),
      ),
      child: text,
    );
  }
}
