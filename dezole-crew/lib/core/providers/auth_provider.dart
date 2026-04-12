import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final String? token;
  final String? userId;
  final String? email;
  final String? role;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.userId,
    this.email,
    this.role,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    String? userId,
    String? email,
    String? role,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      role: role ?? this.role,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  final _authStateSubject = BehaviorSubject<AuthState>.seeded(const AuthState());
  
  Stream<AuthState> get authStateStream => _authStateSubject.stream;

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    _authStateSubject.add(state.copyWith(status: AuthStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      state = AuthState(
        status: AuthStatus.authenticated,
        token: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        role: 'DRIVER',
      );
      _authStateSubject.add(state);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      _authStateSubject.add(state);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    _authStateSubject.add(state.copyWith(status: AuthStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      state = AuthState(
        status: AuthStatus.authenticated,
        token: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        role: 'DRIVER',
      );
      _authStateSubject.add(state);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      _authStateSubject.add(state);
    }
  }

  Future<void> logout() async {
    state = const AuthState(status: AuthStatus.unauthenticated);
    _authStateSubject.add(state);
  }

  void clearError() {
    state = state.copyWith(
      status: AuthStatus.authenticated,
      errorMessage: null,
    );
    _authStateSubject.add(state);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.status == AuthStatus.authenticated;
});

final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return authNotifier.authStateStream;
});