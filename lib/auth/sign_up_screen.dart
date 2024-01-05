import 'package:flutter/material.dart';
import 'package:habo/auth/auth_form_field.dart';
import 'package:habo/auth/auth_manager.dart';
import 'package:habo/generated/l10n.dart';
import 'package:habo/habits/habits_manager.dart';
import 'package:habo/navigation/app_state_manager.dart';
import 'package:habo/navigation/routes.dart';
import 'package:habo/utils/validators.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: Routes.signUpPath,
      key: ValueKey(Routes.signUpPath),
      child: const SignUpScreen(),
    );
  }

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  void initializeControllers() {
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
    confirmPasswordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty && password.isEmpty && confirmPassword.isEmpty) return;

    if (Validators.isValidEmail(email) &&
        Validators.isValidPassword(password) &&
        Validators.isValidPassword(confirmPassword)) {
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
          S.of(context).signUp,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextFormField(
                    labelText: S.of(context).email,
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (value) {
                      return value!.isEmpty
                          ? S.of(context).pleaseEnterEmailAddress
                          : Validators.isValidEmail(value)
                              ? null
                              : S.of(context).invalidEmailAddress;
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: passwordNotifier,
                    builder: (_, passwordObscure, __) {
                      return AppTextFormField(
                        obscureText: passwordObscure,
                        controller: passwordController,
                        labelText: S.of(context).password,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? S.of(context).pleaseEnterPassword
                              : Validators.isValidPassword(value)
                                  ? null
                                  : S.of(context).invalidPassword;
                        },
                        suffixIcon: Focus(
                          /// If false,
                          ///
                          /// disable focus for all of this node's descendants
                          descendantsAreFocusable: false,

                          /// If false,
                          ///
                          /// make this widget's descendants un-traversable.
                          // descendantsAreTraversable: false,
                          child: IconButton(
                            onPressed: () =>
                                passwordNotifier.value = !passwordObscure,
                            style: IconButton.styleFrom(
                              minimumSize: const Size.square(48),
                            ),
                            icon: Icon(
                              passwordObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: confirmPasswordNotifier,
                    builder: (_, confirmPasswordObscure, __) {
                      return AppTextFormField(
                        labelText: S.of(context).confirmPassword,
                        controller: confirmPasswordController,
                        obscureText: confirmPasswordObscure,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? S.of(context).pleaseReEnterPassword
                              : Validators.isValidPassword(value)
                                  ? passwordController.text ==
                                          confirmPasswordController.text
                                      ? null
                                      : S.of(context).passwordNotMatched
                                  : S.of(context).invalidPassword;
                        },
                        suffixIcon: Focus(
                          /// If false,
                          ///
                          /// disable focus for all of this node's descendants.
                          descendantsAreFocusable: false,

                          /// If false,
                          ///
                          /// make this widget's descendants un-traversable.
                          // descendantsAreTraversable: false,
                          child: IconButton(
                            onPressed: () => confirmPasswordNotifier.value =
                                !confirmPasswordObscure,
                            style: IconButton.styleFrom(
                              minimumSize: const Size.square(48),
                            ),
                            icon: Icon(
                              confirmPasswordObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  authManager.status == Status.registering
                      ? const Center(child: CircularProgressIndicator())
                      : ValueListenableBuilder(
                          valueListenable: fieldValidNotifier,
                          builder: (_, isValid, __) {
                            return FilledButton(
                              onPressed: isValid
                                  ? () {
                                      authManager.signUp(
                                        emailController.text,
                                        passwordController.text,
                                      );
                                      if (authManager.status ==
                                          Status.authenticated) {
                                        Provider.of<HabitsManager>(context,
                                                listen: false)
                                            .showErrorMessage(
                                                S.of(context).signUpError);
                                      }

                                      emailController.clear();
                                      passwordController.clear();
                                      confirmPasswordController.clear();
                                    }
                                  : null,
                              child: Text(S.of(context).signUp),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).alreadyHaveAnAccountSignIn,
              ),
              TextButton(
                onPressed: () {
                  Provider.of<AppStateManager>(context, listen: false)
                      .goSignIn(true);
                  Provider.of<AppStateManager>(context, listen: false)
                      .goSignUp(false);
                },
                child: Text(S.of(context).signIn),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
