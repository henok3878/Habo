import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habo/auth/auth_manager.dart';
import 'package:habo/auth/sign_in_screen.dart';
import 'package:habo/auth/sign_up_screen.dart';
import 'package:habo/habits/edit_habit_screen.dart';
import 'package:habo/habits/habits_manager.dart';
import 'package:habo/habits/habits_screen.dart';
import 'package:habo/navigation/app_state_manager.dart';
import 'package:habo/navigation/routes.dart';
import 'package:habo/onboarding/onboarding_screen.dart';
import 'package:habo/settings/settings_manager.dart';
import 'package:habo/settings/settings_screen.dart';
import 'package:habo/splash_screen.dart';
import 'package:habo/statistics/statistics_screen.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final SettingsManager settingsManager;
  final HabitsManager habitsManager;
  final AuthManager authManager;

  AppRouter(
      {required this.appStateManager,
      required this.settingsManager,
      required this.habitsManager,
      required this.authManager})
      : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    settingsManager.addListener(notifyListeners);
    habitsManager.addListener(notifyListeners);
    authManager.addListener(notifyListeners);
    settingsManager.getSeenOnboarding;
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    settingsManager.removeListener(notifyListeners);
    habitsManager.removeListener(notifyListeners);
    authManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey, onPopPage: _handlePopPage, pages: getPages(context));
  }

  List<Page> getPages(context) {
    List<Page> pages = [];
    if (!allInitialized()) {
      pages.add(SplashScreen.page());
    }
    if (authManager.status == Status.authenticated) {
      if (allInitialized()) {
        pages.add(HabitsScreen.page());
      }
      if (appStateManager.getStatistics) {
        pages.add(StatisticsScreen.page());
      }
      if (appStateManager.getSettings) {
        pages.add(SettingsScreen.page());
      }
      if (appStateManager.getCreateHabit) {
        pages.add(EditHabitScreen.page(null));
      }
      if (appStateManager.getEditHabit != null) {
        pages.add(EditHabitScreen.page(appStateManager.getEditHabit!));
      }
    } else {
      if (appStateManager.getSignUp ||
          authManager.status == Status.registering) {
        pages.add(SignUpScreen.page());
      } else if (appStateManager.getSignIn ||
          authManager.status == Status.authenticating ||
          settingsManager.getSeenOnboarding) {
        pages.add(SignInScreen.page());
      }
    }
    if (appStateManager.getOnboarding || !settingsManager.getSeenOnboarding) {
      pages.add(OnboardingScreen.page());
    }

    return pages;
  }

  bool allInitialized() {
    return settingsManager.isInitialized &&
        habitsManager.isInitialized &&
        authManager.isInitialized;
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

    if (route.settings.name == Routes.statisticsPath) {
      appStateManager.goStatistics(false);
    }

    if (route.settings.name == Routes.settingsPath) {
      appStateManager.goSettings(false);
    }

    if (route.settings.name == Routes.onboardingPath) {
      appStateManager.goOnboarding(false);
    }

    if (route.settings.name == Routes.createHabitPath) {
      appStateManager.goCreateHabit(false);
    }

    if (route.settings.name == Routes.editHabitPath) {
      appStateManager.goEditHabit(null);
    }
    if (route.settings.name == Routes.signInPath) {
      appStateManager.goSignIn(false);
    }
    if (route.settings.name == Routes.signUpPath) {
      appStateManager.goSignUp(false);
    }

    return false;
  }

  @override
  Future<void> setNewRoutePath(configuration) async {}
}
