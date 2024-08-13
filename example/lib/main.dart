import 'package:declare/declarables/collection.dart';
import 'package:declare/declarables/tile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Test(),
        debugShowCheckedModeBanner: false,
      );
}

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Collection(
          children: [
            ...List.generate(
                100,
                (i) => Tile(
                    title: Text("This is a title for $i"),
                    subtitle:
                        i % 2 == 0 ? Text("This is a subtitle for $i") : null,
                    leading: i % 4 == 0 ? Icon(Icons.ac_unit) : null,
                    trailing: i % 2 == 1 ? Icon(Icons.delete_rounded) : null,
                    onPressed: () => print("Tile $i pressed"),
                    onLongPressed: () => print("Tile $i long pressed")))
          ],
        ),
      );
}
