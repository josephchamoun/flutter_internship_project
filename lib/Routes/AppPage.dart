import 'package:internship_mobile_project/Bindings/RegistrationBinding.dart';
import 'package:internship_mobile_project/Views/RegistrationForm.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Routes/AppRoute.dart';

import '../Bindings/LoginBinding.dart';
import '../Views/Login.dart';

class AppPage{
  static final List <GetPage> pages=
  [
    GetPage(name: AppRoute.register, page: ()=> Registration(), binding: RegistrationBinding() ),
    GetPage(name: AppRoute.login, page: ()=> Login(), binding: LoginBinding() )
  ];

}