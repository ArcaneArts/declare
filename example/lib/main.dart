import 'package:declare/declare.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AppTest());
}

class AppTest extends StatelessWidget {
  const AppTest({super.key});

  @override
  Widget build(BuildContext context) => const ShadcnUIGenerator(
        home: MainTest(),
      );
}

class MainTest extends StatelessWidget {
  const MainTest({super.key});

  @override
  Widget build(BuildContext context) => Screen(
        header: const TitleBar(title: "Declare Example"),
        body: ListView(
          children: [
            Tile(
              leading: const Icon(Icons.radio_button_checked_sharp),
              title: "Buttons",
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Buttons())),
            ),
          ],
        ),
      );
}

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) => Screen(
        header: const TitleBar(title: "Buttons"),
        body: Padding(
          padding: const EdgeInsets.all(14),
          child: ListView(
            children: [
              Section(
                title: "Non Elevated",
                children: [
                  IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Button(
                          text: "Text Only",
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Button(
                          icon: Icons.add,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Button(
                          text: "Text and Icon",
                          icon: Icons.add,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Section(
                title: "Elevated",
                children: [
                  IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Button(
                          elevated: true,
                          text: "Text Only",
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Button(
                          elevated: true,
                          icon: Icons.add,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Button(
                          elevated: true,
                          text: "Text and Icon",
                          icon: Icons.add,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
}
