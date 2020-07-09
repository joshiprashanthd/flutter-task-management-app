import 'package:first_team_project/ui/helper_widget/custom_flat_button.dart';
import 'package:first_team_project/ui/util/SizeRatio.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  const TimePicker(
      {Key key, this.color, this.width, this.onTimeChanged, this.initialTime, this.showAMPMlabel = true, this.show24HourFormat = false})
      : super(key: key);
  final Color color;
  final TimeOfDay initialTime;
  final double width;
  final void Function(TimeOfDay) onTimeChanged;
  final bool showAMPMlabel;
  final bool show24HourFormat;

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
        show24HourFormat ? 
        "${initialTime.hour.toString().padLeft(2, '0')}:${initialTime.minute.toString().padLeft(2, '0')}"
        : "${(initialTime.hour % 12)}:${initialTime.minute.toString().padLeft(2, '0')}${showAMPMlabel ? (initialTime.hour >= 12 ? " PM" : " AM") : ""}",
        style: TextStyle(
          fontSize: width * SizeRatio.subheading4RatioWidth,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: color.withAlpha(50),
      onPressed: () async {
        await _getTime(context);
      },
    );
  }

  Future<void> _getTime(BuildContext context) async {
    TimeOfDay newTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              primaryColor: color,
              accentColor: color,
              colorScheme: ColorScheme.light(primary: color),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
              fontFamily: 'Quicksand',
            ),
            child: child,
          );
        });

    onTimeChanged(newTime ?? initialTime);
  }
}
