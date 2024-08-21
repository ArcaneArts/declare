import 'package:declare/declare.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CupertinoUIGenerator extends StatelessWidget {
  final Widget? home;
  final CupertinoThemeData? lightTheme;
  final CupertinoThemeData? darkTheme;
  final DeclareThemeMode themeMode;
  final String? title;
  final Color? color;

  const CupertinoUIGenerator(
      {super.key,
      required this.home,
      this.lightTheme,
      this.color,
      this.title,
      this.darkTheme,
      this.themeMode = DeclareThemeMode.system});

  @override
  Widget build(BuildContext context) => UIGeneratorCluster(
        generators: const [
          CupertinoButtonGenerator(),
          CupertinoScreenGenerator(),
          CupertinoTitleBarGenerator(),
          CupertinoTileGenerator(),
          CupertinoSectionGenerator(),
        ],
        builder: (context) => CupertinoApp(
          debugShowCheckedModeBanner: false,
          home: home,
          theme: switch (themeMode == DeclareThemeMode.system
              ? WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                      Brightness.light
                  ? DeclareThemeMode.light
                  : DeclareThemeMode.dark
              : themeMode) {
            DeclareThemeMode.light => lightTheme ??
                const CupertinoThemeData(
                    brightness: Brightness.light,
                    scaffoldBackgroundColor:
                        CupertinoColors.extraLightBackgroundGray),
            DeclareThemeMode.dark => darkTheme ??
                const CupertinoThemeData(brightness: Brightness.dark),
            _ => throw UnimplementedError(),
          },
          color: color,
          title: title ?? "App",
        ),
      );
}

class CupertinoTitleBarGenerator extends UIGenerator<TitleBar> {
  const CupertinoTitleBarGenerator();

  @override
  Widget build(BuildContext context, TitleBar data) => CupertinoNavigationBar(
        middle: Text(data.title),
        leading: data.leading?.withSocket(SocketType.icon),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var action in data.actions) action.withSocket(SocketType.icon),
            ...WidgetInject.of(context) ?? []
          ],
        ),
      );
}

class CupertinoButtonGenerator extends UIGenerator<Button> {
  const CupertinoButtonGenerator();

  @override
  Widget build(BuildContext context, Button data) {
    SocketType? type = Socket.of(context);

    return switch (data) {
      (Button b) when type == SocketType.sectionAction && b.icon != null =>
        CupertinoButton(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          onPressed: b.onPressed,
          minSize: 18,
          child: Icon(b.icon, size: 18),
        ),
      (Button b)
          when (type == SocketType.icon || type == SocketType.screenAction) &&
              b.icon != null =>
        CupertinoButton(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          onPressed: b.onPressed,
          child: Icon(b.icon, size: 24),
        ),
      (Button b) when b.icon != null && b.text == null && !b.elevated =>
        CupertinoButton(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          onPressed: b.onPressed,
          child: Icon(b.icon, size: 24),
        ),
      (Button b) when b.icon != null && b.text == null && b.elevated =>
        CupertinoButton.filled(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          onPressed: b.onPressed,
          child: Icon(b.icon, size: 24),
        ),
      (Button b) when b.icon == null && b.text != null && !b.elevated =>
        CupertinoButton(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          onPressed: b.onPressed,
          child: Text(b.text!),
        ),
      (Button b) when b.icon == null && b.text != null && b.elevated =>
        CupertinoButton.filled(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          onPressed: b.onPressed,
          child: Text(b.text!),
        ),
      (Button b) when b.icon != null && b.text != null && !b.elevated =>
        CupertinoButton(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          onPressed: b.onPressed,
          child: Row(
            children: [
              Icon(b.icon, size: 24),
              const Gap(8),
              Text(b.text!),
            ],
          ),
        ),
      (Button b) when b.icon != null && b.text != null && b.elevated =>
        CupertinoButton.filled(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
          onPressed: b.onPressed,
          child: Row(
            children: [
              Icon(b.icon, size: 24),
              const Gap(8),
              Text(b.text!),
            ],
          ),
        ),
      _ => CupertinoButton(
          onPressed: data.onPressed,
          child: const SizedBox(width: 50, height: 50),
        )
    };
  }
}

class CupertinoScreenGenerator extends UIGenerator<Screen> {
  const CupertinoScreenGenerator();

  @override
  Widget build(BuildContext context, Screen data) => CupertinoPageScaffold(
        navigationBar: data.header != null
            ? ObstructingPreferredSize(
                size: const Size.fromHeight(50),
                child: WidgetInject(
                    children: [
                      if (data.action != null)
                        data.action!.withSocket(SocketType.screenAction),
                    ],
                    builder: (context) =>
                        data.header!.withSocket(SocketType.screenHeader)),
              )
            : null,
        child: data.body ?? const SizedBox.shrink(),
      );
}

class CupertinoSectionGenerator extends UIGenerator<Section> {
  const CupertinoSectionGenerator();

  @override
  Widget build(BuildContext context, Section data) =>
      CupertinoListSection.insetGrouped(
        dividerMargin: 0,
        topMargin: 0,
        additionalDividerMargin: 0,
        margin: const EdgeInsets.only(left: 14, top: 7, bottom: 7, right: 14),
        header: data.title != null
            ? Container(
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  if (data.leading != null) ...[
                    IconTheme(
                        data: Theme.of(context).iconTheme.copyWith(
                            size: 18,
                            color: CupertinoTheme.of(context)
                                .textTheme
                                .tabLabelTextStyle
                                .color),
                        child: data.leading!.withSocket(SocketType.icon)),
                    const Gap(8),
                  ],
                  Text(
                    data.title!,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .tabLabelTextStyle
                        .copyWith(fontSize: 14),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var action in data.actions)
                        action.withSocket(SocketType.sectionAction),
                    ],
                  )
                ]),
              )
            : null,
        children: [
          ...data.children,
        ],
      );
}

class CupertinoTileGenerator extends UIGenerator<Tile> {
  const CupertinoTileGenerator();

  @override
  Widget build(BuildContext context, Tile data) => CupertinoListTile(
        title: Text(data.title),
        subtitle: data.subtitle == null ? null : Text(data.subtitle!),
        onTap: data.onTap,
        trailing: data.trailing?.withSocket(SocketType.icon),
        leading: data.leading?.withSocket(SocketType.icon),
      );
}

class ObstructingPreferredSize extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Size size;
  final Widget child;

  const ObstructingPreferredSize(
      {super.key, required this.size, required this.child});

  @override
  Widget build(BuildContext context) => child;

  @override
  Size get preferredSize => size;

  @override
  bool shouldFullyObstruct(BuildContext context) => false;
}
