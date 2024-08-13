import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;

  const Tile(
      {super.key,
      this.leading,
      this.title,
      this.subtitle,
      this.onPressed,
      this.onLongPressed,
      this.trailing});

  @override
  Widget build(BuildContext context) => ListTile(
        title: title,
        leading: leading,
        subtitle: subtitle,
        onLongPress: onLongPressed,
        trailing: trailing,
        onTap: onPressed,
      );
}
