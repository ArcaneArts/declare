import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class MasonryListViewGrid extends StatefulWidget {
  const MasonryListViewGrid({
    required this.column,
    required this.children,
    this.mainAxisGap = 0.0,
    this.crossAxisGap = 0.0,
    this.padding = const EdgeInsets.all(0),
    super.key,
  });

  /// Create the fixed number of column.
  final int column;

  /// Creates a widget that insets its children in Masonry List View Grid.
  final List<Widget> children;

  /// Gap between the child items in Horizontal axis.
  final double mainAxisGap;

  /// Gap between the child items in Vertical axis.
  final double crossAxisGap;

  /// The amount of space by which to inset the children.
  final EdgeInsets padding;

  @override
  State<MasonryListViewGrid> createState() => _MasonryListViewGridState();
}

class _MasonryListViewGridState extends State<MasonryListViewGrid> {
  late LinkedScrollControllerGroup _controllers;
  late List<ScrollController> _scrollControllers;
  late List<double> sizedBoxHeights;
  late VoidCallback _scrollCallbackFunction;

  @override
  void initState() {
    super.initState();

    _controllers = LinkedScrollControllerGroup();

    sizedBoxHeights = List.generate(widget.column, (_) => 0);

    _scrollControllers = List.generate(
      widget.column,
      (_) => _controllers.addAndGet(),
    );

    _scrollCallbackFunction = throttle(() {
      setSizedBoxHeights();
    }, 500);

    _controllers.addOffsetChangedListener(_scrollCallbackFunction);
  }

  @override
  void dispose() {
    _controllers.removeOffsetChangedListener(_scrollCallbackFunction);
    for (var scrollController in _scrollControllers) {
      scrollController.dispose();
    }

    super.dispose();
  }

  VoidCallback throttle(Function cb, int milliSeconds) {
    bool shouldWait = false;
    bool isWaiting = false;
    void timerFunction() {
      Timer(
        Duration(milliseconds: milliSeconds),
        () {
          if (isWaiting) {
            cb();
            isWaiting = false;
            timerFunction();
          } else {
            shouldWait = false;
          }
        },
      );
    }

    return () {
      if (shouldWait) {
        isWaiting = true;
        return;
      }

      cb();
      shouldWait = true;

      timerFunction();
    };
  }

  void setSizedBoxHeights() {
    if (_scrollControllers.every((element) =>
        _scrollControllers[0].position.maxScrollExtent ==
        element.position.maxScrollExtent)) {
      return;
    }

    bool isReachedEnd = false;
    double overallMaxOffset = 0;

    for (int index = 0; index < _scrollControllers.length; index++) {
      double currentMaxExtend =
          _scrollControllers[index].position.maxScrollExtent;

      if (currentMaxExtend - sizedBoxHeights[index] > overallMaxOffset) {
        overallMaxOffset = currentMaxExtend - sizedBoxHeights[index];
      }

      if (_controllers.offset >= currentMaxExtend) isReachedEnd = true;
    }

    if (isReachedEnd) {
      List<double>? newSizedBoxHeights;
      for (int index = 0; index < _scrollControllers.length; index++) {
        double currentMaxExtend =
            _scrollControllers[index].position.maxScrollExtent;

        double neededHeight =
            overallMaxOffset - (currentMaxExtend - sizedBoxHeights[index]);

        if (neededHeight > 0) {
          newSizedBoxHeights ??= List.generate(widget.column, (index) => 0);
          newSizedBoxHeights[index] = neededHeight;
        }
      }

      if (newSizedBoxHeights != null) {
        setState(() {
          sizedBoxHeights = newSizedBoxHeights!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.padding.left,
        right: widget.padding.right,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.column,
          (i) {
            ListView lv = ListView.builder(
              controller: _scrollControllers[i],
              itemCount: (widget.children.length % widget.column < i
                      ? (widget.children.length / widget.column).ceil()
                      : (widget.children.length / widget.column).floor()) +
                  1,
              itemBuilder: (BuildContext context, int columnChildIndex) {
                int maxLength = (widget.children.length % widget.column < i
                        ? (widget.children.length / widget.column).ceil()
                        : (widget.children.length / widget.column).floor()) +
                    1;

                //Adds sizedBox to match scroll height of all columns
                if (columnChildIndex == maxLength - 1) {
                  return SizedBox(
                    height: sizedBoxHeights[i] + widget.padding.bottom,
                  );
                }

                return Container(
                  margin: EdgeInsets.only(
                    top: columnChildIndex == 0 ? widget.padding.top : 0,
                    right: i < widget.column - 1 ? widget.mainAxisGap / 2 : 0,
                    left: i > 0 ? widget.mainAxisGap / 2 : 0,
                  ),
                  child: widget.children.length <=
                          (columnChildIndex * widget.column) + i
                      ? const SizedBox.shrink()
                      : widget.children[(columnChildIndex * widget.column) + i],
                );
              },
            );

            return Expanded(
              child: i == widget.column - 1
                  ? lv
                  : ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: lv),
            );
          },
        ),
      ),
    );
  }
}
