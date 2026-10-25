enum UserRole {
  hero,
  mitra;

  String get label => this == UserRole.hero ? 'Hero' : 'Mitra';
  String get roleLabel => this == UserRole.hero ? 'Pelanggan' : 'Penjual';
  String get apiValue => name;

  static UserRole? fromStorage(String? value) {
    for (final role in UserRole.values) {
      if (role.name == value) return role;
    }
    return null;
  }
}
