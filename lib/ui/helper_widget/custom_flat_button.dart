import 'package:flutter/material.dart';
import 'package:first_team_project/ui/util/SizeRatio.dart';

class CustomFlatButton extends StatefulWidget {
  CustomFlatButton(
      {Key key,
      this.onPressed,
      this.onLongPress,
      this.child,
      this.shape,
      this.color,
      this.splashColor,
      this.highlightColor,
      this.hoverColor,
      this.focusColor,
      this.elevation = 0,
      this.minWidth,
      this.height,
      this.focusElevation,
      this.highlightElevation,
      this.hoverElevation,
      this.padding,
      this.enableAnimation = true})
      : super(key: key);

  final void Function() onPressed;
  final void Function() onLongPress;

  final Widget child;

  final ShapeBorder shape;

  final Color color;
  final Color splashColor;
  final Color highlightColor;
  final Color focusColor;
  final Color hoverColor;

  final EdgeInsetsGeometry padding;

  final bool enableAnimation;

  final double minWidth;
  final double height;
  final double elevation;
  final double focusElevation;
  final double highlightElevation;
  final double hoverElevation;

  @override
  _CustomFlatButtonState createState() => _CustomFlatButtonState();
}

class _CustomFlatButtonState extends State<CustomFlatButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ScaleTransition(
      scale: widget.enableAnimation
          ? _scaleAnimation
          : Tween<double>(begin: 1, end: 1).animate(_controller),
      child: GestureDetector(
        child: MaterialButton(
          padding: widget.padding,
          focusElevation: widget.focusElevation,
          highlightElevation: widget.highlightElevation,
          hoverElevation: widget.hoverElevation,
          minWidth: widget.minWidth,
          elevation: widget.elevation,
          height: widget.height,
          color: widget.color,
          shape: widget.shape,
          splashColor: widget.splashColor,
          highlightColor: widget.highlightColor,
          hoverColor: widget.hoverColor,
          focusColor: widget.focusColor,
          child: widget.child,
          onHighlightChanged: (highlight) {
            if (highlight)
              _controller.forward();
            else
              _controller.reverse();
          },
          onPressed: widget.onPressed,
          onLongPress: widget.onLongPress,
        ),
      ),
    );
  }
}
