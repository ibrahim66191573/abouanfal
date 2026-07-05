class AppUser {
  final String uid;
  final String fullName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final double? latitude;
  final double? longitude;

  const AppUser({
    required this.uid,
    required this.fullName,
    this.email,
    this.phoneNumber,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      fullName: map['fullName'] ?? '',
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
