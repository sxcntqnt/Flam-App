import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/utils/size_utils.dart';
import 'package:dezole/common/utils/snackbar_utils.dart';
import 'package:dezole/common/widget/common_container.dart';
import 'package:dezole/common/widget/common_dropdown_box.dart';
import 'package:dezole/common/widget/custom_button.dart';
import 'package:dezole/common/widget/custom_text_field.dart';
import 'package:dezole/common/widget/form_validator.dart';
import 'package:dezole/core/providers/auth_provider.dart';
import 'package:dezole/feature/auth/login/login_page.dart';

class SignUpWidget extends ConsumerStatefulWidget {
  const SignUpWidget({super.key});

  @override
  ConsumerState<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends ConsumerState<SignUpWidget> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _genderList = ["Male", "Female", "Other"];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      appBarTitle: "Sign Up",
      title: "Sign up with your email or phone number",
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            ReusableTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _nameController,
              hintText: "Name",
              validator: (v) => FormValidator.validateFieldNotEmpty(v, "Name"),
            ),
            ReusableTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _emailController,
              hintText: "Email",
              validator: FormValidator.validateEmail,
            ),
            ReusableTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _phoneController,
              hintText: "Phone Number",
              validator: FormValidator.validatePhoneNumber,
            ),
            ReusableTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
              controller: _genderController,
              hintText: "Gender",
              validator: (v) =>
                  FormValidator.validateFieldNotEmpty(v, "Gender"),
              readOnly: true,
              onTap: () => showPopUpMenuWithItems(
                context: context,
                title: "Select",
                onItemPressed: (p0) {
                  _genderController.text = p0;
                  setState(() {});
                },
                dataItems: _genderList,
              ),
            ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomRoundedButtom(
                    title: "Sign Up",
                    onPressed: _handleSignUp,
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWidget(),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Sign in',
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

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await ref
        .read(authProvider.notifier)
        .signUp(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          gender: _genderController.text,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      SnackBarUtils.showSuccessBar(
        context: context,
        message: 'Account created successfully!',
      );
    }
  }
}
