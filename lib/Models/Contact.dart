import 'dart:convert';

class ContactModel {
  final String? email;
  final String? phone;

  ContactModel({
    this.email,
    this.phone,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      email: json['email'],
      phone: json['phone'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
    };
  }
}
