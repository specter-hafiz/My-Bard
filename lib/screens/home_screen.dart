import 'package:flutter/material.dart';
import 'package:my_pa/provider/theme_provider.dart';
import 'package:my_pa/screens/about_screen.dart';
import 'package:my_pa/screens/history_screen.dart';
import 'package:my_pa/widgets/stream_chat.dart';
import 'package:provider/provider.dart';

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
          title: Text(
            "My Bard",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                //
                PopupMenuItem(
                  value: "History",
                  child: const Text("History"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HistoryScreen(),
                      ),
                    );
                  },
                ),
                PopupMenuItem(
                  value: "Theme",
                  child: const Text("Change theme"),
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                ),
                PopupMenuItem(
                  value: "About",
                  child: const Text("About us"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AboutScreen(),
                      ),
                    );
                  },
                )
              ];
            })
          ],
        ),
        body: const StreamChat());
  }
}
