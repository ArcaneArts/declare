import 'package:declare/declare.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ListTile, Icons;
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

class ShadcnUIGenerator extends StatelessWidget {
  final Widget? home;
  final shad.ThemeData? lightTheme;
  final shad.ThemeData? darkTheme;
  final DeclareThemeMode themeMode;
  final String? title;
  final Color? color;

  const ShadcnUIGenerator(
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
          ShadcnButtonGenerator(),
          ShadcnScreenGenerator(),
          ShadcnTitleBarGenerator(),
          ShadcnSectionGenerator(),
          ShadcnTileGenerator(),
          ShadcnCardGenerator(),
        ],
        builder: (context) => shad.ShadcnApp(
          debugShowCheckedModeBanner: false,
          title: title ?? "App",
          color: color,
          theme: switch (themeMode == DeclareThemeMode.system
              ? WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                      Brightness.light
                  ? DeclareThemeMode.light
                  : DeclareThemeMode.dark
              : themeMode) {
            DeclareThemeMode.light => lightTheme ??
                shad.ThemeData(
                    colorScheme: shad.ColorSchemes.lightZinc(), radius: 0.33),
            DeclareThemeMode.dark => darkTheme ??
                shad.ThemeData(
                    colorScheme: shad.ColorSchemes.darkZinc(), radius: 0.33),
            _ => throw UnimplementedError(),
          },
          home: home,
        ),
      );
}

class ShadcnTitleBarGenerator extends UIGenerator<TitleBar> {
  const ShadcnTitleBarGenerator();

  @override
  Widget build(BuildContext context, TitleBar data) => shad.AppBar(
        trailing: [
          for (var action in data.actions) action.withSocket(SocketType.icon),
          ...WidgetInject.of(context) ?? []
        ],
        title: Text(data.title),
        leading: [
          if (data.leading != null) data.leading!.withSocket(SocketType.icon),
        ],
      );
}

class ShadcnCardGenerator extends UIGenerator<Card> {
  const ShadcnCardGenerator();

  @override
  Widget build(BuildContext context, Card data) => shad.Card(
        child: data.child,
      );
}

class ShadcnButtonGenerator extends UIGenerator<Button> {
  const ShadcnButtonGenerator();

  @override
  Widget build(BuildContext context, Button data) {
    SocketType? type = Socket.of(context);

    return switch (data) {
      (Button b) when type == SocketType.icon && b.icon != null =>
        shad.TextButton(
          onPressed: b.onPressed,
          density: shad.ButtonDensity.icon,
          child: Icon(b.icon),
        ),
      (Button b) when type == SocketType.icon && b.text != null =>
        shad.TextButton(
          onPressed: b.onPressed,
          density: shad.ButtonDensity.icon,
          child: Text(b.text!),
        ),
      (Button b)
          when type == SocketType.screenAction &&
              b.icon != null &&
              b.text == null =>
        shad.OutlineButton(
          onPressed: b.onPressed,
          density: shad.ButtonDensity.icon,
          child: Icon(b.icon!),
        ),
      (Button b)
          when type == SocketType.screenAction &&
              b.icon != null &&
              b.text != null =>
        shad.OutlineButton(
          onPressed: b.onPressed,
          leading: Icon(b.icon!),
          density: shad.ButtonDensity.icon,
          child: Text(b.text!),
        ),
      (Button b)
          when type == SocketType.screenAction &&
              b.icon == null &&
              b.text != null =>
        shad.PrimaryButton(
            onPressed: b.onPressed,
            leading: const Icon(Icons.favorite_rounded),
            density: shad.ButtonDensity.comfortable,
            child: Text(b.text!)),
      (Button b) when b.icon != null && b.text == null && b.elevated =>
        shad.PrimaryButton(
          onPressed: b.onPressed,
          density: shad.ButtonDensity.icon,
          child: Icon(b.icon!),
        ),
      (Button b) when b.icon != null && b.text == null && !b.elevated =>
        shad.TextButton(
          onPressed: b.onPressed,
          density: shad.ButtonDensity.icon,
          child: Icon(b.icon!),
        ),
      (Button b) when b.icon == null && b.text != null && b.elevated =>
        shad.SecondaryButton(
          onPressed: b.onPressed,
          density: shad.ButtonDensity.icon,
          child: Text(b.text!),
        ),
      (Button b) when b.icon == null && b.text != null && !b.elevated =>
        shad.TextButton(
          onPressed: b.onPressed,
          density: shad.ButtonDensity.icon,
          child: Text(b.text!),
        ),
      (Button b) when b.icon != null && b.text != null && b.elevated =>
        shad.SecondaryButton(
            leading: Icon(b.icon!),
            density: shad.ButtonDensity.icon,
            onPressed: b.onPressed,
            child: Text(b.text!)),
      (Button b) when b.icon != null && b.text != null && !b.elevated =>
        shad.TextButton(
            density: shad.ButtonDensity.icon,
            leading: Icon(b.icon!),
            onPressed: b.onPressed,
            child: Text(b.text!)),
      _ => shad.SecondaryButton(
          onPressed: data.onPressed,
          child: const SizedBox(width: 50, height: 50))
    };
  }
}

class ShadcnScreenGenerator extends UIGenerator<Screen> {
  const ShadcnScreenGenerator();

  @override
  Widget build(BuildContext context, Screen data) => shad.Scaffold(
        footers: [
          if (data.footer != null) data.footer!,
        ],
        headers: [
          if (data.header != null)
            WidgetInject(
              children: [
                if (data.action != null)
                  data.action!.withSocket(SocketType.screenAction),
              ],
              builder: (context) => data.header!,
            )
        ],
        child: data.body ?? const SizedBox.shrink(),
      );
}

class ShadcnTileGenerator extends UIGenerator<Tile> {
  const ShadcnTileGenerator();

  @override
  Widget build(BuildContext context, Tile data) => ListTile(
        title: Text(data.title),
        leading: data.leading?.withSocket(SocketType.icon),
        trailing: data.trailing?.withSocket(SocketType.icon),
        onTap: data.onTap,
        subtitle: data.subtitle == null ? null : Text(data.subtitle!),
      );
}

class ShadcnSectionGenerator extends UIGenerator<Section> {
  const ShadcnSectionGenerator();

  @override
  Widget build(BuildContext context, Section data) => Padding(
      padding: const EdgeInsets.all(4),
      child: shad.Card(
          padding: const EdgeInsets.all(4),
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
                            style: shad.Theme.of(context).typography.h4),
                      const Spacer(),
                      ...data.actions.map((e) => e.withSocket(SocketType.icon)),
                    ],
                  ),
                ),
              ...data.children
            ],
          )));
}
