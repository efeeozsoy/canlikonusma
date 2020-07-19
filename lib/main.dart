import 'package:canli_konusma_app/app/landing_page.dart';
import 'package:canli_konusma_app/locator.dart';
import 'package:canli_konusma_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Canlı Konuşma",
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: LandingPage()),
    );
  }
}

 