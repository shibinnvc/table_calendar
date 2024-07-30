// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../customization/header_style.dart';
import '../shared/utils.dart' show CalendarFormat, DayBuilder;
import 'custom_icon_button.dart';
import 'format_button.dart';

class CalendarHeader extends StatelessWidget {
  final dynamic locale;
  final DateTime focusedMonth;
  final CalendarFormat calendarFormat;
  final HeaderStyle headerStyle;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  final VoidCallback onHeaderTap;
  final VoidCallback onHeaderLongPress;
  final ValueChanged<CalendarFormat> onFormatButtonTap;
  final Map<CalendarFormat, String> availableCalendarFormats;
  final DayBuilder? headerTitleBuilder;
  final bool isSeperateHeaderTitle;

  const CalendarHeader(
      {Key? key,
      this.locale,
      required this.focusedMonth,
      required this.calendarFormat,
      required this.headerStyle,
      required this.onLeftChevronTap,
      required this.onRightChevronTap,
      required this.onHeaderTap,
      required this.onHeaderLongPress,
      required this.onFormatButtonTap,
      required this.availableCalendarFormats,
      this.headerTitleBuilder,
      this.isSeperateHeaderTitle = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final month = headerStyle.titleTextFormatter?.call(focusedMonth, locale) ??
        DateFormat.MMMM(locale).format(focusedMonth);
    final year = headerStyle.titleTextFormatter?.call(focusedMonth, locale) ??
        DateFormat.y(locale).format(focusedMonth);

    return Container(
      decoration: headerStyle.decoration,
      margin: headerStyle.headerMargin,
      padding: headerStyle.headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (!headerStyle.titleLeft && headerStyle.leftChevronVisible)
            CustomIconButton(
              icon: headerStyle.leftChevronIcon,
              onTap: onLeftChevronTap,
              margin: headerStyle.leftChevronMargin,
              padding: headerStyle.leftChevronPadding,
            ),
          if (headerStyle.isTitleExpanded)
            Expanded(
              child: headerTitleBuilder?.call(context, focusedMonth) ??
                  GestureDetector(
                      onTap: onHeaderTap,
                      onLongPress: onHeaderLongPress,
                      child: RichText(
                          textAlign: headerStyle.titleCentered
                              ? TextAlign.center
                              : TextAlign.start,
                          text: TextSpan(children: [
                            TextSpan(
                              text: '$month ',
                              style: headerStyle.monthTextStyle,
                            ),
                            TextSpan(
                              text: year,
                              style: headerStyle.yearTextStyle,
                            ),
                          ]))
                      // Text(
                      //   text,
                      //   style: headerStyle.titleTextStyle,
                      // textAlign: headerStyle.titleCentered
                      //     ? TextAlign.center
                      //     : TextAlign.start,
                      // ),
                      ),
            ),
          if (!headerStyle.isTitleExpanded)
            GestureDetector(
                onTap: onHeaderTap,
                onLongPress: onHeaderLongPress,
                child: RichText(
                    textAlign: headerStyle.titleCentered
                        ? TextAlign.center
                        : TextAlign.start,
                    text: TextSpan(children: [
                      TextSpan(
                        text: '$month ',
                        style: headerStyle.monthTextStyle,
                      ),
                      TextSpan(
                        text: year,
                        style: headerStyle.yearTextStyle,
                      ),
                    ]))),
          if (headerStyle.formatButtonVisible &&
              availableCalendarFormats.length > 1)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FormatButton(
                onTap: onFormatButtonTap,
                availableCalendarFormats: availableCalendarFormats,
                calendarFormat: calendarFormat,
                decoration: headerStyle.formatButtonDecoration,
                padding: headerStyle.formatButtonPadding,
                textStyle: headerStyle.formatButtonTextStyle,
                showsNextFormat: headerStyle.formatButtonShowsNext,
              ),
            ),
          if (headerStyle.titleLeft && headerStyle.leftChevronVisible)
            CustomIconButton(
              icon: headerStyle.leftChevronIcon,
              onTap: onLeftChevronTap,
              margin: headerStyle.leftChevronMargin,
              padding: headerStyle.leftChevronPadding,
            ),
          if (headerStyle.rightChevronVisible)
            CustomIconButton(
              icon: headerStyle.rightChevronIcon,
              onTap: onRightChevronTap,
              margin: headerStyle.rightChevronMargin,
              padding: headerStyle.rightChevronPadding,
            ),
        ],
      ),
    );
  }
}
