class User {
  final String userId;
  final String name;
  final String firstName;
  final String lastName;
  final String email;
  final String token;
  final String authToken;

  User(
      {required this.userId,
      required this.name,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.token,
      required this.authToken});
}
