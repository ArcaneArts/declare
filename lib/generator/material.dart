import 'package:declare/declare.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class MaterialUIGenerator extends m.StatelessWidget {
  final Widget? home;
  final m.ThemeData? lightTheme;
  final m.ThemeData? darkTheme;
  final DeclareThemeMode themeMode;
  final String? title;
  final Color? color;

  const MaterialUIGenerator(
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
          MaterialButtonGenerator(),
          MaterialScreenGenerator(),
          MaterialTitleBarGenerator(),
          MaterialSectionGenerator(),
          MaterialTileGenerator(),
          MaterialCardGenerator(),
        ],
        builder: (context) => m.MaterialApp(
          title: title ?? "App",
          color: color,
          theme: lightTheme ??
              m.ThemeData.light(
                useMaterial3: true,
              ).copyWith(
                  colorScheme: m.ColorScheme.fromSeed(
                      seedColor: const Color(0xFF3734eb),
                      brightness: m.Brightness.light),
                  brightness: m.Brightness.light),
          darkTheme: darkTheme ??
              m.ThemeData.dark(useMaterial3: true).copyWith(
                  colorScheme: m.ColorScheme.fromSeed(
                      seedColor: const Color(0xFF3734eb),
                      brightness: m.Brightness.dark),
                  brightness: m.Brightness.dark),
          themeMode: themeMode.material,
          home: home,
        ),
      );
}

class MaterialTitleBarGenerator extends UIGenerator<TitleBar> {
  const MaterialTitleBarGenerator();

  @override
  Widget build(BuildContext context, TitleBar data) => m.AppBar(
        title: Text(data.title),
        leading: data.leading?.withSocket(SocketType.icon),
        actions:
            data.actions.map((e) => e.withSocket(SocketType.icon)).toList(),
      );
}

class MaterialButtonGenerator extends UIGenerator<Button> {
  const MaterialButtonGenerator();

  @override
  Widget build(BuildContext context, Button data) {
    SocketType? type = Socket.of(context);

    return switch (data) {
      (Button b) when type == SocketType.icon && b.icon != null => m.IconButton(
          onPressed: b.onPressed, icon: Icon(b.icon), tooltip: b.text),
      (Button b) when type == SocketType.icon && b.text != null =>
        m.TextButton(onPressed: b.onPressed, child: Text(b.text!)),
      (Button b)
          when type == SocketType.screenAction &&
              b.icon != null &&
              b.text == null =>
        m.FloatingActionButton(onPressed: b.onPressed, child: Icon(b.icon!)),
      (Button b)
          when type == SocketType.screenAction &&
              b.icon != null &&
              b.text != null =>
        m.FloatingActionButton.extended(
            onPressed: b.onPressed, icon: Icon(b.icon!), label: Text(b.text!)),
      (Button b)
          when type == SocketType.screenAction &&
              b.icon == null &&
              b.text != null =>
        m.FloatingActionButton.extended(
            onPressed: b.onPressed,
            icon: const Icon(m.Icons.favorite_rounded),
            label: Text(b.text!)),
      (Button b) when b.icon != null && b.text == null && b.elevated =>
        m.FloatingActionButton(onPressed: b.onPressed, child: Icon(b.icon!)),
      (Button b) when b.icon != null && b.text == null && !b.elevated =>
        m.IconButton(onPressed: b.onPressed, icon: Icon(b.icon!)),
      (Button b) when b.icon == null && b.text != null && b.elevated =>
        m.ElevatedButton(onPressed: b.onPressed, child: Text(b.text!)),
      (Button b) when b.icon == null && b.text != null && !b.elevated =>
        m.TextButton(onPressed: b.onPressed, child: Text(b.text!)),
      (Button b) when b.icon != null && b.text != null && b.elevated =>
        m.ElevatedButton(
            onPressed: b.onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(b.icon!),
                const Gap(7),
                Text(b.text!),
              ],
            )),
      (Button b) when b.icon != null && b.text != null && !b.elevated =>
        m.TextButton(
            onPressed: b.onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(b.icon!),
                const Gap(7),
                Text(b.text!),
              ],
            )),
      _ => m.ElevatedButton(
          onPressed: data.onPressed,
          child: const SizedBox(width: 50, height: 50))
    };
  }
}

class MaterialScreenGenerator extends UIGenerator<Screen> {
  const MaterialScreenGenerator();

  @override
  Widget build(BuildContext context, Screen data) => m.Scaffold(
        bottomNavigationBar: data.footer?.withSocket(SocketType.screenFooter),
        body: data.body,
        appBar: data.header != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: data.header!.withSocket(SocketType.screenHeader),
              )
            : null,
        floatingActionButton: data.action?.withSocket(SocketType.screenAction),
      );
}

class MaterialTileGenerator extends UIGenerator<Tile> {
  const MaterialTileGenerator();

  @override
  Widget build(BuildContext context, Tile data) => m.ListTile(
        title: Text(data.title),
        leading: data.leading?.withSocket(SocketType.icon),
        trailing: data.trailing?.withSocket(SocketType.icon),
        onTap: data.onTap,
        subtitle: data.subtitle == null ? null : Text(data.subtitle!),
      );
}

class MaterialCardGenerator extends UIGenerator<Card> {
  const MaterialCardGenerator();

  @override
  Widget build(BuildContext context, Card data) => m.Card(
        child: data.child,
      );
}

class MaterialSectionGenerator extends UIGenerator<Section> {
  const MaterialSectionGenerator();

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
