library declare;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode, Colors;
import 'package:flutter/widgets.dart';
import 'package:toxic/extensions/iterable.dart';

export 'package:declare/generator/cupertino.dart';
export 'package:declare/generator/material.dart';
export 'package:declare/generator/neumorphic.dart';
export 'package:declare/generator/shadcn.dart';

enum DeclareThemeMode {
  system,
  light,
  dark,
}

extension XDeclareThemeMode on DeclareThemeMode {
  ThemeMode get material => switch (this) {
        DeclareThemeMode.system => ThemeMode.system,
        DeclareThemeMode.light => ThemeMode.light,
        DeclareThemeMode.dark => ThemeMode.dark,
      };
}

class UIGeneratorCluster extends StatelessWidget {
  final List<UIGenerator> generators;
  final UIGenerator<Declarable> defaultGenerator;
  final Widget Function(BuildContext context) builder;

  const UIGeneratorCluster(
      {super.key,
      required this.builder,
      this.generators = const [],
      this.defaultGenerator = const DefaultUIGenerator()});

  @override
  Widget build(BuildContext context) => Builder(builder: builder);

  static Widget generate<T extends Declarable>(BuildContext context, T input) {
    UIGeneratorCluster c = UIGeneratorCluster.of(context);
    UIGenerator<T>? generator = c.generators
        .select((element) => element.innerType == T) as UIGenerator<T>?;
    return generator?.build(context, input) ??
        c.defaultGenerator.build(context, input);
  }

  static UIGeneratorCluster of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<UIGeneratorCluster>()!;
}

class DefaultUIGenerator extends UIGenerator<Declarable> {
  const DefaultUIGenerator();

  @override
  Widget build(BuildContext context, Declarable data) => kDebugMode
      ? Container(
          decoration: BoxDecoration(
            color: Colors.red.shade900,
            border: Border.all(color: Colors.yellow),
          ),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Text(
              "!${data.runtimeType}!",
              style:
                  TextStyle(fontSize: 18, color: Colors.yellowAccent.shade200),
            ),
          ),
        )
      : const SizedBox.shrink();
}

abstract class UIGenerator<T extends Declarable> {
  const UIGenerator();

  Widget build(BuildContext context, T data);

  Type get innerType => T;
}

enum SocketType {
  sectionAction,
  screenAction,
  screenHeader,
  screenFooter,
  icon
}

extension XSocketType on SocketType {
  Widget? of(Widget? widget) =>
      widget != null ? Socket(type: this, builder: (context) => widget) : null;
}

extension XWidget on Widget {
  Widget withSocket(SocketType type) =>
      Socket(type: type, builder: (context) => this);
}

class WidgetInject extends StatelessWidget {
  final List<Widget> children;
  final Widget Function(BuildContext context) builder;

  static List<Widget>? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<WidgetInject>()?.children;

  const WidgetInject(
      {super.key, this.children = const [], required this.builder});

  @override
  Widget build(BuildContext context) => Builder(builder: builder);
}

class Socket extends StatelessWidget {
  final SocketType type;
  final Widget Function(BuildContext context) builder;

  const Socket({super.key, required this.type, required this.builder});

  static SocketType? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<Socket>()?.type;

  @override
  Widget build(BuildContext context) => Builder(builder: builder);
}

abstract class Declarable extends StatelessWidget {
  const Declarable({super.key});

  @override
  Widget build(BuildContext context);
}

class Button extends Declarable {
  final VoidCallback? onPressed;
  final String? text;
  final IconData? icon;
  final bool elevated;

  const Button(
      {super.key, this.onPressed, this.text, this.icon, this.elevated = false});

  @override
  Widget build(BuildContext context) =>
      UIGeneratorCluster.generate(context, this);
}

class TitleBar extends Declarable {
  final String title;
  final List<Widget> actions;
  final Widget? leading;
  final Widget? bottom;

  const TitleBar(
      {super.key,
      required this.title,
      this.actions = const [],
      this.leading,
      this.bottom});

  @override
  Widget build(BuildContext context) =>
      UIGeneratorCluster.generate(context, this);
}

class Screen extends Declarable {
  final Widget? action;
  final Widget? header;
  final Widget? footer;
  final Widget? body;

  const Screen({super.key, this.action, this.header, this.footer, this.body});

  @override
  Widget build(BuildContext context) =>
      UIGeneratorCluster.generate(context, this);
}

class Section extends Declarable {
  final String? title;
  final Widget? leading;
  final List<Widget> actions;
  final List<Widget> children;

  const Section(
      {super.key,
      this.title,
      this.leading,
      this.actions = const [],
      this.children = const []});

  @override
  Widget build(BuildContext context) =>
      UIGeneratorCluster.generate(context, this);
}

class Tile extends Declarable {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const Tile(
      {super.key,
      this.leading,
      required this.title,
      this.subtitle,
      this.trailing,
      this.onTap});

  @override
  Widget build(BuildContext context) =>
      UIGeneratorCluster.generate(context, this);
}

class Card extends Declarable {
  final Widget child;

  const Card({super.key, required this.child});

  @override
  Widget build(BuildContext context) =>
      UIGeneratorCluster.generate(context, this);
}
