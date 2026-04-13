import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error, rateLimited }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final int failedAttempts;
  final DateTime? lockoutUntil;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.failedAttempts = 0,
    this.lockoutUntil,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    int? failedAttempts,
    DateTime? lockoutUntil,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockoutUntil: lockoutUntil ?? this.lockoutUntil,
    );
  }

  bool get isLocked {
    if (lockoutUntil == null) return false;
    return DateTime.now().isBefore(lockoutUntil!);
  }

  Duration? get remainingLockout {
    if (lockoutUntil == null) return null;
    final remaining = lockoutUntil!.difference(DateTime.now());
    return remaining.isNegative ? null : remaining;
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  static const int maxFailedAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const Duration rateLimitWindow = Duration(minutes: 1);
  static const int maxAttemptsPerWindow = 3;

  int _recentAttempts = 0;
  DateTime? _windowStart;

  AuthNotifier() : super(const AuthState());

  void _checkRateLimit() {
    final now = DateTime.now();
    if (_windowStart == null || now.difference(_windowStart!) > rateLimitWindow) {
      _windowStart = now;
      _recentAttempts = 0;
    }
    _recentAttempts++;
    if (_recentAttempts > maxAttemptsPerWindow) {
      state = state.copyWith(
        status: AuthStatus.rateLimited,
        errorMessage: 'Too many attempts. Please try again later.',
      );
    }
  }

  void _recordFailedAttempt() {
    final newAttempts = state.failedAttempts + 1;
    if (newAttempts >= maxFailedAttempts) {
      state = state.copyWith(
        failedAttempts: newAttempts,
        lockoutUntil: DateTime.now().add(lockoutDuration),
        status: AuthStatus.rateLimited,
        errorMessage: 'Account locked. Try again after ${lockoutDuration.inMinutes} minutes.',
      );
    } else {
      state = state.copyWith(
        failedAttempts: newAttempts,
        status: AuthStatus.error,
        errorMessage: 'Invalid credentials. ${maxFailedAttempts - newAttempts} attempts remaining.',
      );
    }
  }

  void _resetAttempts() {
    _recentAttempts = 0;
    _windowStart = null;
    state = const AuthState(status: AuthStatus.authenticated);
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (state.isLocked) {
      final remaining = state.remainingLockout;
      state = state.copyWith(
        status: AuthStatus.rateLimited,
        errorMessage: 'Account locked. Try again in ${remaining?.inMinutes ?? 0} minutes.',
      );
      return false;
    }

    _checkRateLimit();
    if (state.status == AuthStatus.rateLimited) {
      return false;
    }

    state = state.copyWith(status: AuthStatus.loading);

    await Future.delayed(const Duration(milliseconds: 500));

    final emailValid = email.isNotEmpty && email.length <= 255;
    final passwordValid = password.isNotEmpty && password.length >= 8;

    if (emailValid && passwordValid) {
      _resetAttempts();
      return true;
    } else {
      _recordFailedAttempt();
      return false;
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String phone,
    required String gender,
  }) async {
    if (state.isLocked) {
      state = state.copyWith(
        status: AuthStatus.rateLimited,
        errorMessage: 'Account locked. Try again later.',
      );
      return false;
    }

    _checkRateLimit();
    if (state.status == AuthStatus.rateLimited) {
      return false;
    }

    state = state.copyWith(status: AuthStatus.loading);

    await Future.delayed(const Duration(milliseconds: 500));

    final nameValid = name.isNotEmpty && name.length <= 100;
    final emailValid = email.isNotEmpty && email.length <= 255;
    final phoneValid = phone.length == 10;
    final genderValid = gender.isNotEmpty;

    if (nameValid && emailValid && phoneValid && genderValid) {
      _resetAttempts();
      return true;
    } else {
      _recordFailedAttempt();
      return false;
    }
  }

  void logout() => state = const AuthState(status: AuthStatus.unauthenticated);
  
  void clearError() => state = state.copyWith(errorMessage: null);
  
  void unlock() {
    state = const AuthState(status: AuthStatus.initial);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.status == AuthStatus.authenticated;
});

final isRateLimitedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.status == AuthStatus.rateLimited || authState.isLocked;
});