import 'dart:convert';

class User{
  final String? name;
  final String email;
  final String password;
  final String? password_confirmation;

  User({this.name,required this.email,required this.password, this.password_confirmation});


  Map <String, dynamic> toMap()
  {
    return
        {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": password_confirmation
        };
  }
  String toJson() => json.encode(toMap());
}
