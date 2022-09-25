import 'package:flutter/material.dart';
import 'package:notes_app/DB/Notes_DB.dart';
import 'package:notes_app/Screens/DescriptionScreen.dart';
import 'package:notes_app/Screens/HomeScreen.dart';
import 'package:notes_app/Theme/Style.dart';
import 'package:notes_app/Theme/Theme_Provider.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// ThemeData _light =
//     ThemeData(primarySwatch: Colors.deepOrange, brightness: Brightness.light);
// ThemeData _dark = ThemeData(brightness: Brightness.dark);

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AppDatabase()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider()..initialize()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, provider, child) => MaterialApp(
          title: 'Notes App',
          theme: Style.lightTheme(context),
          darkTheme: Style.darkTheme(context),
          themeMode: provider.themeMode,
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
          routes: {
            '/description': (context) => DescriptionScreen(),
          },
        ),
      ),
    );
  }
}
