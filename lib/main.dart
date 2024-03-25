import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:leetkode/pages/compare_all.dart';
import 'package:leetkode/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      dark: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        title: 'LeetKode',
        home: const HomePage(),
      ),
    );
  }
}
