// lib/models/submission.dart

class Submission {
  final String firstName;
  final String lastName;
  final String email;
  final String message;

  Submission({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.message,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      firstName: json['First name'],
      lastName: json['Last name'],
      email: json['email'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'First name': firstName,
      'Last name': lastName,
      'email': email,
      'message': message,
    };
  }
}
