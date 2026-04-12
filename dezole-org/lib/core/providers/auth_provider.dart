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
  final String? orgId;
  final String? orgName;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.userId,
    this.email,
    this.role,
    this.orgId,
    this.orgName,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    String? userId,
    String? email,
    String? role,
    String? orgId,
    String? orgName,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      role: role ?? this.role,
      orgId: orgId ?? this.orgId,
      orgName: orgName ?? this.orgName,
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
        token: 'org-token-${DateTime.now().millisecondsSinceEpoch}',
        userId: 'org-user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        role: 'ADMIN',
        orgId: 'org-${DateTime.now().millisecondsSinceEpoch}',
        orgName: 'My Sacco',
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

  Future<void> registerOrg({
    required String email,
    required String password,
    required String orgName,
    required String phone,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    _authStateSubject.add(state.copyWith(status: AuthStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      state = AuthState(
        status: AuthStatus.authenticated,
        token: 'org-token-${DateTime.now().millisecondsSinceEpoch}',
        userId: 'org-user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        role: 'ADMIN',
        orgId: 'org-${DateTime.now().millisecondsSinceEpoch}',
        orgName: orgName,
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

  void switchOrganization(String orgId, String orgName) {
    state = state.copyWith(
      orgId: orgId,
      orgName: orgName,
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

final currentOrgIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);
  return auth.orgId;
});

final currentOrgNameProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);
  return auth.orgName;
});

final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return authNotifier.authStateStream;
});