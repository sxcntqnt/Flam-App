import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/utils/size_utils.dart';
import 'package:dezole/common/widget/common_container.dart';
import 'package:dezole/common/widget/custom_button.dart';
import 'package:dezole/common/widget/custom_text_field.dart';
import 'package:dezole/common/widget/form_validator.dart';
import 'package:dezole/core/providers/auth_provider.dart';
import 'package:dezole/feature/auth/register/screen/signup_page.dart';
import 'package:dezole/feature/dashboard/dashboard_widget.dart';

class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({super.key});

  @override
  ConsumerState<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      appBarTitle: "Sign Up",
      title: "Sign in with your email or phone number",
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            ReusableTextField(
              validator: (v) => FormValidator.validateFieldNotEmpty(v, "Field"),
              controller: _emailController,
              hintText: "Email or Phone Number",
            ),
            ReusableTextField(
              validator: (v) =>
                  FormValidator.validateFieldNotEmpty(v, "Password"),
              controller: _passwordController,
              hintText: "Password",
            ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomRoundedButtom(
                    title: "Sign Up",
                    onPressed: _handleLogin,
                  ),
            Stack(
              alignment: Alignment.center,
              children: [
                const Divider(thickness: 2),
                Container(
                  color: CustomTheme.lightColor,
                  width: 30.wp,
                  child: const Text("or", textAlign: TextAlign.center),
                ),
              ],
            ),
            CustomRoundedButtom(
              onPressed: () {},
              title: "Sign up with Gmail",
              color: Colors.transparent,
              textColor: CustomTheme.darkColor.withValues(alpha: 0.6),
              borderColor: CustomTheme.appColor,
            ),
            CustomRoundedButtom(
              onPressed: () {},
              title: "Sign up with Facebook",
              color: Colors.transparent,
              borderColor: CustomTheme.appColor,
              textColor: CustomTheme.darkColor.withValues(alpha: 0.6),
            ),
            CustomRoundedButtom(
              onPressed: () {},
              title: "Sign up with Apple",
              textColor: CustomTheme.darkColor.withValues(alpha: 0.6),
              color: Colors.transparent,
              borderColor: CustomTheme.appColor,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(color: CustomTheme.appColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await ref
        .read(authProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardWidget()),
        (route) => false,
      );
    }
  }
}
