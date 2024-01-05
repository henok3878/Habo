import 'package:flutter/material.dart';
import 'package:habo/auth/auth_form_field.dart';
import 'package:habo/auth/auth_manager.dart';
import 'package:habo/generated/l10n.dart';
import 'package:habo/habits/habits_manager.dart';
import 'package:habo/navigation/app_state_manager.dart';
import 'package:habo/navigation/routes.dart';
import 'package:habo/utils/validators.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: Routes.signInPath,
      key: ValueKey(Routes.signInPath),
      child: const SignInScreen(),
    );
  }

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  late final emailController;
  late final passwordController;

  void initializeControllers() {
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) return;

    if (Validators.isValidEmail(email) &&
        Validators.isValidPassword(password)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
  }

  @override
  void initState() {
    initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthManager authManager = Provider.of<AuthManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).signIn,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppTextFormField(
                  controller: emailController,
                  labelText: S.of(context).email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _formKey.currentState?.validate(),
                  validator: (value) {
                    return value!.isEmpty
                        ? S.of(context).pleaseEnterEmailAddress
                        : Validators.isValidEmail(value)
                            ? null
                            : S.of(context).invalidEmailAddress;
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: passwordNotifier,
                  builder: (_, passwordObscure, __) {
                    return AppTextFormField(
                      obscureText: passwordObscure,
                      controller: passwordController,
                      labelText: S.of(context).password,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (_) => _formKey.currentState?.validate(),
                      validator: (value) {
                        return value!.isEmpty
                            ? S.of(context).pleaseEnterPassword
                            : Validators.isValidPassword(value)
                                ? null
                                : S.of(context).invalidPassword;
                      },
                      suffixIcon: IconButton(
                        onPressed: () =>
                            passwordNotifier.value = !passwordObscure,
                        style: IconButton.styleFrom(
                          minimumSize: const Size.square(48),
                        ),
                        icon: Icon(
                          passwordObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(S.of(context).forgotPassword),
                ),
                const SizedBox(height: 20),
                authManager.status == Status.authenticating
                    ? const Center(child: CircularProgressIndicator())
                    : ValueListenableBuilder(
                        valueListenable: fieldValidNotifier,
                        builder: (_, isValid, __) {
                          return FilledButton(
                            onPressed: isValid
                                ? () async {
                                    bool result = await authManager.signIn(
                                        emailController.text,
                                        passwordController.text);

                                    if (!result) {
                                      Provider.of<HabitsManager>(context,
                                              listen: false)
                                          .showErrorMessage(
                                              S.of(context).signInError);
                                    }
                                  }
                                : null,
                            style: FilledButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Theme.of(context).primaryColor, // Text color
                            ),
                            child: Text(
                              S.of(context).signIn,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).doNotHaveAnAccount,
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        Provider.of<AppStateManager>(context, listen: false)
                            .goSignUp(true);
                      },
                      child: Text(S.of(context).register),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
