import 'package:flutter/material.dart';

import 'pages/contacts.dart';
import 'pages/loginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cantacts App',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      //..............................................................FireBase............................................//
      home: LoginPage(),
      // routes: {
      //   // "/": (context) => const ExcelExport(),
      //   // MyRoutes.loginScreen: (context) => const LoginPage(),
      //   // MyRoutes.landingPage: (context) => LandingPage(),
      // },
    );
  }
}
