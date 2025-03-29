import 'dart:convert';

class User {
  final String? name;
  final String? email;
  final String? address;
  final String? oldpassword;
  final String? password;
  final String? password_confirmation;

  User(
      {this.name,
      this.email,
      this.address,
      this.oldpassword,
      this.password,
      this.password_confirmation});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "address": address,
      "password": password,
      "password_confirmation": password_confirmation
    };
  }

  String toJson() => json.encode(toMap());
}
