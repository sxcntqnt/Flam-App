import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.avatarUrl,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  static const mock = User(
    id: '1',
    name: 'Nate Samson',
    email: 'nate@email.com',
    phone: '0712345678',
    gender: 'Male',
  );
}

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void setUser(User user) => state = user;
  void clearUser() => state = null;

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? gender,
  }) {
    if (state == null) return;
    state = state!.copyWith(
      name: name,
      email: email,
      phone: phone,
      gender: gender,
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
