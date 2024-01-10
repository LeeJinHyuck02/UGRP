import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prototype_2/assets/provider.dart';
import 'package:prototype_2/screen/loginscreen.dart';
import 'package:prototype_2/screen/survey.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Spots>(create: (_) => Spots()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<Menu>(create: (_) => Menu()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
