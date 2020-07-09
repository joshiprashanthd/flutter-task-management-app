import 'package:first_team_project/core/models/task.dart';
import 'package:first_team_project/ui/helper_widget/custom_flat_button.dart';
import 'package:first_team_project/ui/util/CustomColors.dart';
import 'package:first_team_project/ui/util/SizeRatio.dart';
import 'package:flutter/material.dart';

class NumberPicker extends StatelessWidget {
  NumberPicker({
    Key key,
    @required this.minValue,
    @required this.maxValue,
    @required this.initialValue,
    @required this.step,
    @required this.onChanged,
    @required this.task,
    @required this.title,
  }) : super(key: key);

  final double minValue;
  final double maxValue;
  final double initialValue;
  final double step;
  final void Function(double) onChanged;
  final Task task;
  final String title;

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return CustomFlatButton(
      color: task.taskColor.withAlpha(10),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(width * SizeRatio.borderRadiusRatioWidth),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: width * SizeRatio.paddingRatioWidth * 0.1),
      minWidth: 20,
      highlightElevation: 0,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Text(
        "${initialValue.toInt()}",
        style: TextStyle(
          color: task.taskColor,
          fontWeight: FontWeight.bold,
          fontSize: width * SizeRatio.subheading4RatioWidth,
        ),
      ),
      onPressed: () async {
        showDialog(
          useRootNavigator: true,
          barrierDismissible: true,
          context: context,
          builder: (context) {
            return DialogWithSlider(
              height: height,
              context: context,
              width: width,
              initialValue: initialValue,
              maxValue: maxValue,
              minValue: minValue,
              onChanged: (newValue) {
                onChanged(newValue);
                Navigator.pop(context);
              },
              step: step,
              task: task,
              title: title,
            );
          },
        );
      },
    );
  }
}

class DialogWithSlider extends StatefulWidget {
  DialogWithSlider({
    Key key,
    @required this.minValue,
    @required this.maxValue,
    @required this.initialValue,
    @required this.step,
    @required this.onChanged,
    @required this.task,
    @required this.title,
    @required this.width,
    @required this.context,
    @required this.height,
  }) : super(key: key);

  final double minValue;
  final double maxValue;
  final double initialValue;
  final double step;
  final void Function(double) onChanged;
  final Task task;
  final String title;
  final double width;
  final double height;
  final BuildContext context;

  @override
  _DialogWithSliderState createState() => _DialogWithSliderState();
}

class _DialogWithSliderState extends State<DialogWithSlider> {
  double value;

  @override
  void initState() {
    super.initState();

    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text(
      //   "${widget.title}",
      //   style: TextStyle(color: CustomColor.primaryTextColor),
      // ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          widget.width * SizeRatio.borderRadiusRatioWidth,
        ),
      ),
      // contentPadding: EdgeInsets.all( widget.width * SizeRatio.paddingRatioWidth * 0.1),
      content: SizedBox(
        height: widget.height * 0.06,
        width: widget.width,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Slider(
              label: "${value.toInt()}",
              value: value,
              min: widget.minValue,
              max: widget.maxValue,
              divisions: (widget.maxValue - widget.minValue) ~/ widget.step,
              activeColor: widget.task.taskColor,
              inactiveColor: widget.task.taskColor.withAlpha(10),
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });
              },
            ),
            Text(
              "${value.toInt()} ${widget.title}",
              style: TextStyle(color: CustomColor.primaryTextColor),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        CustomFlatButton(
          child: Text(
            "OK",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.task.taskColor,
                fontSize: widget.width * SizeRatio.subheading4RatioWidth),
          ),
          highlightElevation: 0,
          splashColor: Colors.transparent,
          highlightColor: widget.task.taskColor.withAlpha(10),
          onPressed: () {
            widget.onChanged(value);
          },
        )
      ],
    );
  }
}
