import 'package:flutter/material.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App information"),
      ),
      body: Column(
        children: [
          Text("App info appears here"),
        ],
      ),
    );
  }
}
