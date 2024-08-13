import 'dart:math';

import 'package:declare/widget/masonry.dart';
import 'package:flutter/widgets.dart';

class CollectionMasonCount {
  final int count;

  const CollectionMasonCount(this.count);
}

class Collection extends StatelessWidget {
  final List<Widget> children;
  final double softWidth;

  const Collection({super.key, this.children = const [], this.softWidth = 250});

  @override
  Widget build(BuildContext context) {
    int cols = max(1, MediaQuery.of(context).size.width ~/ softWidth);
    return MasonryListViewGrid(
      key: ValueKey(CollectionMasonCount(cols)),
      column: cols,
      children: children,
    );
  }
}
