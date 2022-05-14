class ProfileModel {
  final String name;
  final String address;
  final String email;
  final String contact;
  final String profile;

  ProfileModel(this.name, this.address, this.email, this.contact, this.profile);

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      map['name'] ?? '',
      map['address'] ?? '',
      map['email'] ?? '',
      map['contact'] ?? '',
      map['profile'] ?? '',
    );
  }
}
