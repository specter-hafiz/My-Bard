import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:my_pa/key.dart';
import 'package:my_pa/provider/db_provider.dart';
import 'package:my_pa/provider/theme_provider.dart';
import 'package:my_pa/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: secreteKey, enableDebugging: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        Provider<DBProvider>(
          create: (_) => DBProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context, listen: false).themeData,
        home: const MyHomePage(),
      ),
    );
  }
}

class SectionItem {
  final int index;
  final String title;
  final Widget widget;
  const SectionItem({
    required this.index,
    required this.title,
    required this.widget,
  });
}
