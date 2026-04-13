import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

// Login state provider
final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>(
      (ref) => LoginViewModel(),
    );

// Login state
class LoginState {
  final String email;
  final String password;
  final bool isLoading;
  final String? errorMessage;
  final bool isObscure;
  final bool isEmailValid;
  final bool isPasswordValid;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage,
    this.isObscure = true,
    this.isEmailValid = false,
    this.isPasswordValid = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? errorMessage,
    bool? isObscure,
    bool? isEmailValid,
    bool? isPasswordValid,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isObscure: isObscure ?? this.isObscure,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    );
  }
}

// Login ViewModel
class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(const LoginState());

  // Email validation regex
  static final RegExp _emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+){1,}$',
  );

  void updateEmail(String email) {
    final isValid = _emailRegex.hasMatch(email.trim());
    state = state.copyWith(
      email: email.trim(),
      isEmailValid: isValid,
      errorMessage: isValid ? null : 'Please enter a valid email',
    );
  }

  void updatePassword(String password) {
    final isValid = password.length >= 6;
    state = state.copyWith(
      password: password,
      isPasswordValid: isValid,
      errorMessage: isValid ? null : 'Password must be at least 6 characters',
    );
  }

  void toggleObscure() {
    state = state.copyWith(isObscure: !state.isObscure);
  }

  Future<void> login() async {
    if (!state.isEmailValid || !state.isPasswordValid) {
      state = state.copyWith(
        errorMessage: 'Please fix validation errors before submitting',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, you would call your authentication API here
      // For demo purposes, we'll simulate a successful login
      // You would normally navigate to the home screen or org selection

      // For security: clear password from state after use
      state = state.copyWith(isLoading: false, password: '');

      // In a real app: Navigator.pushReplacement...
      // For now, just show success
      // This would be handled by the UI layer showing a success message
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Login failed: ${e.toString()}',
      );

      // Security: clear password on error
      state = state.copyWith(password: '');
    }
  }

  // Security method to clear sensitive data
  void clearCredentials() {
    state = const LoginState().copyWith(
      isEmailValid: false,
      isPasswordValid: false,
    );
  }

  @override
  void dispose() {
    clearCredentials();
    super.dispose();
  }
}

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginVm = ref.read(loginViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo or app name
            const Icon(Icons.business, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign in to continue',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Email field
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: const OutlineInputBorder(),
                errorText: loginState.isEmailValid ? null : 'Enter valid email',
                filled: true,
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onChanged: loginVm.updateEmail,
            ),
            const SizedBox(height: 16),

            // Password field
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    loginState.isObscure
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: loginVm.toggleObscure,
                ),
                border: const OutlineInputBorder(),
                errorText: loginState.isPasswordValid
                    ? null
                    : 'Password must be at least 6 characters',
                filled: true,
              ),
              obscureText: loginState.isObscure,
              textInputAction: TextInputAction.done,
              onChanged: loginVm.updatePassword,
            ),
            const SizedBox(height: 24),

            // Login button
            ElevatedButton(
              onPressed: loginState.isLoading
                  ? null
                  : (loginState.isEmailValid && loginState.isPasswordValid
                        ? loginVm.login
                        : null),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: loginState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // Error message
            if (loginState.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Text(
                  loginState.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
