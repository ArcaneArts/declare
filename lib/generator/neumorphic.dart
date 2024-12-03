import 'package:declare/declare.dart';
import 'package:flutter/material.dart' as m;
import 'package:gap/gap.dart';
import 'package:gusto_neumorphic/gusto_neumorphic.dart' hide Card;

class NeumorphicUIGenerator extends StatelessWidget {
  final Widget? home;
  final NeumorphicThemeData? lightTheme;
  final NeumorphicThemeData? darkTheme;
  final DeclareThemeMode themeMode;
  final String? title;
  final Color? color;

  const NeumorphicUIGenerator(
      {super.key,
      required this.home,
      this.lightTheme,
      this.color,
      this.title,
      this.darkTheme,
      this.themeMode = DeclareThemeMode.dark});

  @override
  Widget build(BuildContext context) => UIGeneratorCluster(
        generators: const [
          NeumorphicButtonGenerator(),
          NeumorphicScreenGenerator(),
          NeumorphicTitleBarGenerator(),
          NeumorphicTileGenerator(),
          NeumorphicSectionGenerator(),
          NeumorphicCardGenerator(),
        ],
        builder: (context) => NeumorphicApp(
          debugShowCheckedModeBanner: false,
          home: home,
          theme: lightTheme ?? NeumorphicThemeData(depth: 7),
          darkTheme: darkTheme ??
              NeumorphicThemeData.dark(
                  depth: 7, shadowLightColor: Colors.white.withOpacity(0.3)),
          themeMode: themeMode.material,
          color: color,
          title: title ?? "App",
        ),
      );
}

class NeumorphicCardGenerator extends UIGenerator<Card> {
  const NeumorphicCardGenerator();

  @override
  Widget build(BuildContext context, Card data) => m.Padding(
        padding: const m.EdgeInsets.all(7),
        child: Neumorphic(
          child: data.child,
        ),
      );
}

class NeumorphicTitleBarGenerator extends UIGenerator<TitleBar> {
  const NeumorphicTitleBarGenerator();

  @override
  Widget build(BuildContext context, TitleBar data) => NeumorphicAppBar(
        title: Text(data.title),
        leading: data.leading?.withSocket(SocketType.icon),
        actions: [
          for (var action in data.actions) action.withSocket(SocketType.icon),
          ...WidgetInject.of(context) ?? []
        ],
      );
}

class NeumorphicButtonGenerator extends UIGenerator<Button> {
  const NeumorphicButtonGenerator();

  @override
  Widget build(BuildContext context, Button data) {
    SocketType? type = Socket.of(context);

    return m.Padding(
      padding: EdgeInsets.all(7),
      child: switch (data) {
        (Button b) when type == SocketType.sectionAction && b.icon != null =>
          TextButton(
            onPressed: b.onPressed,
            child: Icon(b.icon, size: 18),
          ),
        (Button b)
            when (type == SocketType.icon || type == SocketType.screenAction) &&
                b.icon != null =>
          TextButton(
            onPressed: b.onPressed,
            child: Icon(b.icon, size: 24),
          ),
        (Button b) when b.icon != null && b.text == null && !b.elevated =>
          TextButton(
            onPressed: b.onPressed,
            child: Icon(b.icon, size: 24),
          ),
        (Button b) when b.icon != null && b.text == null && b.elevated =>
          NeumorphicButton(
            padding: EdgeInsets.zero,
            onPressed: b.onPressed,
            child: Icon(b.icon, size: 24),
          ),
        (Button b) when b.icon == null && b.text != null && !b.elevated =>
          TextButton(
            onPressed: b.onPressed,
            child: Text(b.text!),
          ),
        (Button b) when b.icon == null && b.text != null && b.elevated =>
          NeumorphicButton(
            padding: EdgeInsets.zero,
            onPressed: b.onPressed,
            child: Text(b.text!),
          ),
        (Button b) when b.icon != null && b.text != null && !b.elevated =>
          TextButton(
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
          NeumorphicButton(
            padding: EdgeInsets.zero,
            onPressed: b.onPressed,
            child: Row(
              children: [
                Icon(b.icon, size: 24),
                const Gap(8),
                Text(b.text!),
              ],
            ),
          ),
        _ => TextButton(
            onPressed: data.onPressed,
            child: const SizedBox(width: 50, height: 50),
          )
      },
    );
  }
}

class NeumorphicScreenGenerator extends UIGenerator<Screen> {
  const NeumorphicScreenGenerator();

  @override
  Widget build(BuildContext context, Screen data) => Scaffold(
        appBar: data.header != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60), child: data.header!)
            : null,
        body: data.body ?? const SizedBox.shrink(),
      );
}

class NeumorphicSectionGenerator extends UIGenerator<Section> {
  const NeumorphicSectionGenerator();

  @override
  Widget build(BuildContext context, Section data) => Card(
        child: Column(
          children: [
            if (data.title != null || data.leading != null)
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (data.leading != null) ...[
                      data.leading!.withSocket(SocketType.icon),
                      const Gap(9)
                    ],
                    if (data.title != null)
                      Text(data.title!,
                          style: m.Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
                    ...data.actions.map((e) => e.withSocket(SocketType.icon)),
                  ],
                ),
              ),
            ...data.children,
          ],
        ),
      );
}

class NeumorphicTileGenerator extends UIGenerator<Tile> {
  const NeumorphicTileGenerator();

  @override
  Widget build(BuildContext context, Tile data) => ListTile(
        title: Text(data.title),
        subtitle: data.subtitle == null ? null : Text(data.subtitle!),
        onTap: data.onTap,
        trailing: data.trailing?.withSocket(SocketType.icon),
        leading: data.leading?.withSocket(SocketType.icon),
      );
}
