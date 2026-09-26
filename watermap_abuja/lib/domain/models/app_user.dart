/// A locally-registered user. There is no backend: credentials live only on
/// this device (see [AuthService]) so bookings can still be tied to a name,
/// phone and delivery contact without requiring a server.
class AppUser {
  final String name;
  final String phone;
  final String email;

  const AppUser({required this.name, required this.phone, required this.email});

  factory AppUser.fromMap(Map<dynamic, dynamic> map) => AppUser(
        name: map['name'] as String,
        phone: map['phone'] as String,
        email: map['email'] as String,
      );

  Map<String, dynamic> toMap() => {'name': name, 'phone': phone, 'email': email};
}
