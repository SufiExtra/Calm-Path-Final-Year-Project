class Patient {
  final String email;
  final String name;
  final String phoneNumber;
  final String uid;

  Patient({
    required this.email,
    required this.phoneNumber,
    required this.uid,
    required this.name,
  });

  factory Patient.fromMap(Map<String, dynamic> data) {
    return Patient(
      email: data['email'] ?? '',
      phoneNumber: data['number'] ?? '',
      uid: data['patientid'] ?? '',
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'number': phoneNumber,
      'patientid': uid,
      'name': name,
    };
  }
}
