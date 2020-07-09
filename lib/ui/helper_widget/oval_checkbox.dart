import 'package:first_team_project/ui/util/SizeRatio.dart';
import 'package:flutter/material.dart';

class OvalCheckbox extends StatefulWidget {
  OvalCheckbox({
    Key key,
    this.onChecked,
    this.width,
    this.initialValue = false,
    this.borderColor = Colors.white,
    this.fillColor = Colors.white,
    this.iconColor = Colors.white,
    this.checkedColor = Colors.white,
  }) : super(key: key);

  final void Function() onChecked;
  final double width;
  final bool initialValue;
  final Color checkedColor;
  final Color fillColor;
  final Color iconColor;
  final Color borderColor;

  @override
  _OvalCheckboxState createState() => _OvalCheckboxState();
}

class _OvalCheckboxState extends State<OvalCheckbox> {
  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: 25,
      height: double.infinity,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: GestureDetector(
          child: Container(
            child: Center(
              child: widget.initialValue
                  ? Icon(
                      Icons.check_circle,
                      color: widget.iconColor,
                      size: widget.width * SizeRatio.iconSize1RatioWidth,
                    )
                  : Icon(
                      Icons.check_circle_outline,
                      color: widget.iconColor,
                      size: widget.width * SizeRatio.iconSize1RatioWidth,
                    ),
            ),
          ),
          onTap: widget.onChecked,
        ),
      ),
    );
  }
}
