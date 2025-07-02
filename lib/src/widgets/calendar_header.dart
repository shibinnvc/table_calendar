// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/src/customization/header_style.dart';
import 'package:table_calendar/src/shared/utils.dart'
    show CalendarFormat, CalendarHeaderView, DayBuilder;
import 'package:table_calendar/src/widgets/custom_icon_button.dart';
import 'package:table_calendar/src/widgets/format_button.dart';

class CalendarHeader extends StatelessWidget {
  final dynamic locale;
  final DateTime focusedMonth;
  final CalendarFormat calendarFormat;
  final HeaderStyle headerStyle;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  final VoidCallback onLeftChevronYearTap;
  final VoidCallback onRightChevronYearTap;
  final VoidCallback onHeaderTap;
  final VoidCallback onHeaderLongPress;
  final ValueChanged<CalendarFormat> onFormatButtonTap;
  final Map<CalendarFormat, String> availableCalendarFormats;
  final DayBuilder? headerTitleBuilder;
  final CalendarHeaderView calendarHeaderView;

  const CalendarHeader({
    super.key,
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
    required this.calendarHeaderView,
    required this.onLeftChevronYearTap,
    required this.onRightChevronYearTap,
  });

  @override
  Widget build(BuildContext context) {
    final month = headerStyle.monthTextFormatter?.call(focusedMonth, locale) ??
        DateFormat.MMMM(locale).format(focusedMonth);
    final year = headerStyle.yearTextFormatter?.call(focusedMonth, locale) ??
        DateFormat.y(locale).format(focusedMonth);

    return Container(
      decoration: headerStyle.decoration,
      margin: headerStyle.headerMargin,
      padding: headerStyle.headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (!headerStyle.titleLeft && headerStyle.leftChevronVisible)
            leftChevronButton(onTap: onLeftChevronTap),
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
                            if (calendarHeaderView ==
                                CalendarHeaderView.singleView)
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
                      if (calendarHeaderView == CalendarHeaderView.singleView)
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
            leftChevronButton(onTap: onLeftChevronTap),
          if (headerStyle.rightChevronVisible)
            rightChevronButton(onTap: onRightChevronTap),
          if (calendarHeaderView ==
              CalendarHeaderView.seperateMonthYearView) ...[
            Spacer(),
            leftChevronButton(onTap: onLeftChevronYearTap),
            Text(
              year,
              textAlign: headerStyle.titleCentered
                  ? TextAlign.center
                  : TextAlign.start,
              style: headerStyle.yearTextStyle,
            ),
            rightChevronButton(onTap: onRightChevronYearTap),
          ]
        ],
      ),
    );
  }

  CustomIconButton leftChevronButton({required VoidCallback onTap}) {
    return CustomIconButton(
      icon: headerStyle.leftChevronIcon,
      onTap: calendarHeaderView == CalendarHeaderView.singleView
          ? onLeftChevronTap
          : onLeftChevronYearTap,
      margin: headerStyle.leftChevronMargin,
      padding: headerStyle.leftChevronPadding,
    );
  }

  CustomIconButton rightChevronButton({required VoidCallback onTap}) {
    return CustomIconButton(
      icon: headerStyle.rightChevronIcon,
      onTap: onTap,
      margin: headerStyle.rightChevronMargin,
      padding: headerStyle.rightChevronPadding,
    );
  }
}
