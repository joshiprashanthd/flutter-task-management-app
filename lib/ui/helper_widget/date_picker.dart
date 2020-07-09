import 'package:first_team_project/ui/util/DateString.dart';
import 'package:first_team_project/ui/util/SizeRatio.dart';
import 'package:flutter/material.dart';

import 'custom_flat_button.dart';

class DatePicker extends StatelessWidget {
  const DatePicker(
      {Key key, this.width, this.date, this.color, this.onDateChanged})
      : super(key: key);
  final double width;
  final DateTime date;
  final Color color;
  final void Function(DateTime) onDateChanged;

  @override
  Widget build(BuildContext context) {
    return CustomFlatButton(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(width * SizeRatio.borderRadiusRatioWidth * 4),
      ),
      color: color.withAlpha(10),
      height: width * 0.075,
      highlightElevation: 0,
      child: Text(
        "${DateString.staticTime(DateTime(date.year, date.month, date.day), onlyDate: true)}",
        style: TextStyle(
          fontSize: width * SizeRatio.subheading4RatioWidth,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: color.withAlpha(50),
      onPressed: () async {
        await _getDate(context);
      },
    );
  }

  Future<void> _getDate(BuildContext context) async {
    DateTime newDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              fontFamily: 'Quicksand',
              primaryColor: color,
              accentColor: color,
              colorScheme: ColorScheme.light(primary: color),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        });
    onDateChanged(newDate ?? date);
  }
}
