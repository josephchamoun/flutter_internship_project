import 'package:flutter/material.dart';
import 'package:internship_mobile_project/Views/RegistrationForm.dart';
import 'package:get/get.dart';

import 'Routes/AppPage.dart';
import 'Routes/AppRoute.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoute.login,
      getPages: AppPage.pages,
      home: Registration(),
    );
  }
}
