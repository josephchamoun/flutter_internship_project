class Messages {
  final String? subject;
  final String? message;
  final int? user;

  Messages({
    this.subject,
    this.message,
    this.user,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      subject: json['subject'],
      message: json['message'],
      user: json['user'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'message': message,
      'user': user,
    };
  }
}
