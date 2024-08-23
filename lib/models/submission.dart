class Submission {
  final String firstName;
  final String lastName;
  final String email;
  final String message;
  bool isSynced;  // New field to indicate if the data is synced

  Submission({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.message,
    this.isSynced = false,  // Default to false when creating a new submission
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      firstName: json['First name'],
      lastName: json['Last name'],
      email: json['email'],
      message: json['message'],
      isSynced: json['isSynced'] ?? false,  // Default to false if not provided
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'First name': firstName,
      'Last name': lastName,
      'email': email,
      'message': message,
      'isSynced': isSynced,  // Include the sync status in JSON
    };
  }
}
