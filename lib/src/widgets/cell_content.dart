// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../customization/calendar_builders.dart';
import '../customization/calendar_style.dart';

class CellContent extends StatelessWidget {
  final DateTime day;
  final DateTime focusedDay;
  final dynamic locale;
  final bool isTodayHighlighted;
  final bool isToday;
  final bool isSelected;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isWithinRange;
  final bool isOutside;

  final bool isHoliday;
  final bool isWeekend;
  final CalendarStyle calendarStyle;
  final CalendarBuilders calendarBuilders;
  final List<DateTime> highlightedDates;

  const CellContent({
    Key? key,
    required this.day,
    required this.highlightedDates,
    required this.focusedDay,
    required this.calendarStyle,
    required this.calendarBuilders,
    required this.isTodayHighlighted,
    required this.isToday,
    required this.isSelected,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isWithinRange,
    required this.isOutside,
    required this.isHoliday,
    required this.isWeekend,
    this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dowLabel = DateFormat.EEEE(locale).format(day);
    final dayLabel = DateFormat.yMMMMd(locale).format(day);
    final semanticsLabel = '$dowLabel, $dayLabel';

    Widget? cell = calendarBuilders.prioritizedBuilder?.call(context, day, focusedDay);

    if (cell != null) {
      return Semantics(
        label: semanticsLabel,
        excludeSemantics: true,
        child: cell,
      );
    }

    final text = '${day.day}';
    final margin = calendarStyle.cellMargin;
    final padding = calendarStyle.cellPadding;
    final alignment = calendarStyle.cellAlignment;
    final duration = const Duration(milliseconds: 250);
    if (isSelected) {
      cell = calendarBuilders.selectedBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.selectedDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.selectedTextStyle),
          );
    } else if (isToday && isTodayHighlighted) {
      cell = calendarBuilders.todayBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.todayDecoration,
            alignment: alignment,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: calendarStyle.todayTextStyle,
                ),
              ],
            ),
          );
    } else if (isToday &&
        isTodayHighlighted &&
        highlightedDates.contains(day.toLocal().subtract(
            Duration(hours: day.toLocal().hour, minutes: day.toLocal().minute, seconds: day.toLocal().second, milliseconds: day.toLocal().millisecond, microseconds: day.toLocal().microsecond)))) {
      cell = calendarBuilders.todayBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.todayDecoration,
            alignment: alignment,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: calendarStyle.outsideTextStyle,
                    ),
                  ],
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF4B39EF)),
                      width: 5,
                      height: 5,
                    )),
              ],
            ),
          );
    } else if (highlightedDates.contains(day.toLocal().subtract(
        Duration(hours: day.toLocal().hour, minutes: day.toLocal().minute, seconds: day.toLocal().second, milliseconds: day.toLocal().millisecond, microseconds: day.toLocal().microsecond)))) {
      cell = AnimatedContainer(
        duration: duration,
        margin: margin,
        padding: padding,
        alignment: alignment,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: calendarStyle.outsideTextStyle,
                ),
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF4B39EF)),
                  width: 5,
                  height: 5,
                )),
          ],
        ),
      );
    } else if (isRangeStart) {
      cell = calendarBuilders.rangeStartBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.rangeStartDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.rangeStartTextStyle),
          );
    } else if (isRangeEnd) {
      cell = calendarBuilders.rangeEndBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.rangeEndDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.rangeEndTextStyle),
          );
    } else if (isHoliday) {
      cell = calendarBuilders.holidayBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.holidayDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.holidayTextStyle),
          );
    } else if (isWithinRange) {
      cell = calendarBuilders.withinRangeBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.withinRangeDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.withinRangeTextStyle),
          );
    } else if (isOutside) {
      cell = calendarBuilders.outsideBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.outsideDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.outsideTextStyle),
          );
    } else {
      cell = calendarBuilders.defaultBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: isWeekend ? calendarStyle.weekendDecoration : calendarStyle.defaultDecoration,
            alignment: alignment,
            child: Text(
              text,
              style: isWeekend ? calendarStyle.weekendTextStyle : calendarStyle.defaultTextStyle,
            ),
          );
    }

    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: cell,
    );
  }
}
