import 'package:first_team_project/core/models/main_model.dart';
import 'package:first_team_project/core/models/task.dart';
import 'package:first_team_project/ui/helper_widget/oval_checkbox.dart';
import 'package:first_team_project/ui/util/DateString.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

import '../util/CustomColors.dart';
import '../util/SizeRatio.dart';

// const Duration _kExpand = Duration(milliseconds: 200);

// class TaskTile extends StatefulWidget {
//   const TaskTile({
//     Key key,
//     this.onExpansionChanged,
//     this.initiallyExpanded = false,
//     this.task,
//   })  : assert(initiallyExpanded != null),
//         super(key: key);

//   final ValueChanged<bool> onExpansionChanged;
//   final bool initiallyExpanded;
//   final Task task;

//   @override
//   _TaskTileState createState() => _TaskTileState();
// }

// class _TaskTileState extends State<TaskTile>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;
//   CurvedAnimation _easeInAnimation;
//   Animation<double> _iconTurns;

//   bool _isExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(duration: _kExpand, vsync: this);
//     _easeInAnimation =
//         CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
//     _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_easeInAnimation);
//     _isExpanded =
//         PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
//     if (_isExpanded) _controller.value = 1.0;
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleTap() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       if (_isExpanded)
//         _controller.forward();
//       else
//         _controller.reverse();
//       PageStorage.of(context)?.writeState(context, _isExpanded);
//     });
//     if (widget.onExpansionChanged != null)
//       widget.onExpansionChanged(_isExpanded);
//   }

//   Widget _buildChildren(BuildContext context, Widget child) {
//     final width = MediaQuery.of(context).size.width;

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16.0),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(-1, 3),
//             color: Colors.grey.shade300,
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Material(
//             borderRadius: BorderRadius.circular(16.0),
//             type: MaterialType.transparency,
//             clipBehavior: Clip.antiAlias,
//             child: InkWell(
//               onTap: _handleTap,
//               child: Container(
//                 margin: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     SizedBox(
//                       width: width * 0.1,
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints(
//                           maxWidth: width * SizeRatio.iconSize3RatioWidth + 20,
//                           maxHeight: width * SizeRatio.iconSize3RatioWidth + 20,
//                         ),
//                         child: AspectRatio(
//                           aspectRatio: 1.0,
//                           child: ClipOval(
//                             child: Container(
//                               width: width * SizeRatio.iconSize3RatioWidth + 20,
//                               height:
//                                   width * SizeRatio.iconSize3RatioWidth + 20,
//                               color: widget.task.taskColor,
//                               child: Icon(
//                                 widget.task.taskIcon,
//                                 color: Colors.white,
//                                 size: width * SizeRatio.iconSize3RatioWidth,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: width * 0.35,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             widget.task.title,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: TextStyle(
//                               color: CustomColor.primaryTextColor,
//                               fontSize: width * SizeRatio.heading3RatioWidth,
//                               // fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           Text(
//                             widget.task.totalSubtasks > 0
//                                 ? "${widget.task.totalSubtasks - widget.task.subtaskCompleted} Subtasks Remaining"
//                                 : "No Subtasks",
//                             style: TextStyle(
//                                 color: CustomColor.primarySubheadingTextColor,
//                                 fontSize:
//                                     width * SizeRatio.subheading4RatioWidth),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: width * 0.28,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: <Widget>[
//                           Text(
//                             "FROM ${DateString.dynamicTime(widget.task.from)}",
//                             style: TextStyle(
//                               fontSize:
//                                   width * SizeRatio.subheading4RatioWidth * 0.8,
//                               color: CustomColor.primarySubheadingTextColor,
//                             ),
//                           ),
//                           Text(
//                             "TO ${DateString.dynamicTime(widget.task.to)}",
//                             style: TextStyle(
//                               fontSize:
//                                   width * SizeRatio.subheading4RatioWidth * 0.8,
//                               color: CustomColor.primarySubheadingTextColor,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: width * 0.05,
//                       child: widget.task.subtasks != null
//                           ? RotationTransition(
//                               turns: _iconTurns,
//                               child: Icon(
//                                 Icons.expand_more,
//                                 color: CustomColor.primaryIconColor,
//                               ),
//                             )
//                           : Container(),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           ClipRect(
//             child: Align(
//               heightFactor: _easeInAnimation.value,
//               child: widget.task.subtasks == null
//                   ? Container()
//                   : Column(
//                       children: widget.task.subtasks
//                           .map(
//                             (subtask) => CheckboxListTile(
//                               title: Text(
//                                 subtask.title,
//                               ),
//                               subtitle: Text(
//                                 "FROM ${DateString.dynamicTime(subtask.from)}\t\t\tTO ${DateString.dynamicTime(subtask.to)}",
//                                 style: TextStyle(
//                                   fontSize: width *
//                                       SizeRatio.subheading4RatioWidth *
//                                       0.8,
//                                   color: CustomColor.primarySubheadingTextColor,
//                                 ),
//                               ),
//                               selected: subtask.isCompleted,
//                               value: subtask.isCompleted,
//                               onChanged: (isChecked) {
//                                 setState(() {
//                                   subtask.isCompleted = isChecked;
//                                 });
//                               },
//                               activeColor: subtask.subtaskColor,
//                               checkColor: Colors.white,
//                             ),
//                           )
//                           .toList(),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller.view,
//       builder: _buildChildren,
//     );
//   }
// }

class TaskTile extends StatelessWidget {
  const TaskTile({Key key, this.task}) : super(key: key);
  final Task task;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final model = ScopedModel.of<MainModel>(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * SizeRatio.paddingRatioWidth, vertical: width * SizeRatio.paddingRatioWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * SizeRatio.borderRadiusRatioWidth),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 5,
            offset: Offset(0, 0),
          )
        ],
      ),
      child: ListTile(
        leading: Container(
          width: width * 0.02,
          decoration: BoxDecoration(
            color: task.taskColor,
            borderRadius: BorderRadius.circular(width * SizeRatio.borderRadiusRatioWidth)
          ),
        ),
        title: Text(
          "${task.title}",
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: TextStyle(
            fontSize: width * SizeRatio.heading3RatioWidth,
            fontWeight: FontWeight.bold,
            color: task.isCompleted
                ? CustomColor.primarySubheadingTextColor
                : CustomColor.primaryTextColor,
          ),
        ),
        subtitle: Text(
          "${DateString.dynamicTime(task.from)}",
          style: TextStyle(fontSize: width * SizeRatio.subheading4RatioWidth * 0.8),
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.pushNamed(context, '/task_show_page', arguments: task.id);
          },
        ),
      ),
    );
  }
}
