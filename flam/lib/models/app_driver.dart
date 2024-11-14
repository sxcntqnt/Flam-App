class DriverUser {
  String? userId;      // Firebase User ID
  String email;        // User's email
  String password;     // User's password (though typically, you don't store passwords in plain text)
  String role;         // User's role (for example, "Driver")

  // Constructor
  DriverUser({
    this.userId,
    required this.email,
    required this.password,
    this.role = 'Driver',  // Default role is 'Driver', can be changed if needed
  });

}
