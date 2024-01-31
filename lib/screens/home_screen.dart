import 'package:flutter/material.dart';
import 'package:my_pa/screens/stream_chat.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Stream Chat",
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "History",
                  child: const Text("History"),
                  onTap: () {},
                ),
                PopupMenuItem(
                  value: "Theme",
                  child: const Text("Change theme"),
                  onTap: () {},
                ),
                PopupMenuItem(
                  value: "About",
                  child: const Text("About us"),
                  onTap: () {},
                )
              ];
            })
          ],
        ),
        body: const StreamChat());
  }
}
