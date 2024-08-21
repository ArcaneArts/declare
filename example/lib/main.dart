import 'package:declare/declare.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AppTest());
}

class AppTest extends StatelessWidget {
  const AppTest({super.key});

  @override
  Widget build(BuildContext context) => CupertinoUIGenerator(
      builder: (context) => MaterialApp(
            theme: ThemeData.dark(),
            home: ScreenTest(),
            debugShowCheckedModeBanner: false,
          ));
}

class ScreenTest extends StatelessWidget {
  const ScreenTest({super.key});

  @override
  Widget build(BuildContext context) => Screen(
        header: TitleBar(title: "Counter App", actions: [
          Button(
            onPressed: () {},
            text: 'Settings',
            icon: Icons.settings,
          )
        ]),
        action: Button(
          onPressed: () {},
          text: 'Increment',
          icon: Icons.add,
        ),
        body: ListView(
          children: [
            const Section(
              children: [
                Tile(
                  leading: Icon(Icons.favorite_rounded),
                  title: "Test",
                ),
                Tile(leading: Icon(Icons.favorite_rounded), title: "Test 2")
              ],
            ),
            Section(
              title: "Section Title",
              leading: Icon(Icons.account_circle_rounded),
              actions: [
                Button(
                  onPressed: () {},
                  icon: Icons.settings_rounded,
                )
              ],
              children: const [
                Tile(
                  leading: Icon(Icons.favorite_rounded),
                  title: "Test",
                ),
                Tile(leading: Icon(Icons.favorite_rounded), title: "Test 2")
              ],
            ),
            const Tile(
              leading: Icon(Icons.favorite_rounded),
              title: "Test",
            ),
          ],
        ),
      );
}
