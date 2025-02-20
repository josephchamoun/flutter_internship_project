import 'package:internship_mobile_project/Bindings/ProfileBinding.dart';
import 'package:internship_mobile_project/Bindings/RegistrationBinding.dart';
import 'package:internship_mobile_project/Views/RegistrationForm.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Routes/AppRoute.dart';
import 'package:internship_mobile_project/Views/profile.dart';

import '../Bindings/LoginBinding.dart';
import '../Bindings/MainpageBinding.dart';
import '../Views/Login.dart';
import '../Views/mainpage.dart';

class AppPage {
  static final List<GetPage> pages = [
    GetPage(
        name: AppRoute.register,
        page: () => Registration(),
        binding: RegistrationBinding()),
    GetPage(name: AppRoute.login, page: () => Login(), binding: LoginBinding()),
    GetPage(
        name: AppRoute.mainpage,
        page: () => Mainpage(),
        binding: MainpageBinding()),
    GetPage(
        name: AppRoute.profile,
        page: () => Profile(),
        binding: ProfileBinding())
  ];
}
