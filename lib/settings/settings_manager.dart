import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:habo/constants.dart';
import 'package:habo/model/settings_data.dart';
import 'package:habo/notifications.dart';
import 'package:habo/themes.dart';
import 'package:just_audio/just_audio.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';

class SettingsManager extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SettingsData _settingsData = SettingsData();
  bool _isInitialized = false;

  final _checkPlayer = AudioPlayer(handleAudioSessionActivation: false);
  final _clickPlayer = AudioPlayer(handleAudioSessionActivation: false);

  final InAppReview inAppReview = InAppReview.instance;

  void initialize() async {
    await loadData();
    _isInitialized = true;
    notifyListeners();
    _checkPlayer.setAsset('assets/sounds/check.wav');
    _clickPlayer.setAsset('assets/sounds/click.wav');
  }

  @override
  void dispose() {
    _checkPlayer.dispose();
    _clickPlayer.dispose();
    super.dispose();
  }

  resetAppNotification() {
    if (_settingsData.showDailyNot) {
      resetAppNotificationIfMissing(_settingsData.dailyNotTime);
    }
  }

  playCheckSound() {
    if (_settingsData.soundEffects) {
      _checkPlayer.setClip(
          start: const Duration(seconds: 0), end: const Duration(seconds: 2));
      _checkPlayer.play();
    }
  }

  playClickSound() {
    if (_settingsData.soundEffects) {
      _clickPlayer.setClip(
          start: const Duration(seconds: 0), end: const Duration(seconds: 2));
      _clickPlayer.play();
    }
  }

  void checkInAppReview() async {
    _settingsData.checks++;

    if (_settingsData.checks >= _settingsData.reviewTresHold) {
      showInAppReview();
      _settingsData.reviewTresHold *= 2;
    }
    saveData();
  }

  void showInAppReview() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  void saveData() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('habo_settings', jsonEncode(_settingsData));
  }

  Future<void> loadData() async {
    final SharedPreferences prefs = await _prefs;
    String? json = prefs.getString('habo_settings');
    if (json != null) {
      _settingsData = SettingsData.fromJson(jsonDecode(json));
    }
  }

  ThemeData get getDark {
    switch (_settingsData.theme) {
      case Themes.device:
        return HaboTheme.darkTheme;
      case Themes.light:
        return HaboTheme.lightTheme;
      case Themes.dark:
        return HaboTheme.darkTheme;
      case Themes.oled:
        return HaboTheme.oledTheme;
      default:
        return HaboTheme.darkTheme;
    }
  }

  ThemeData get getLight {
    switch (_settingsData.theme) {
      case Themes.device:
        return HaboTheme.lightTheme;
      case Themes.light:
        return HaboTheme.lightTheme;
      case Themes.dark:
        return HaboTheme.darkTheme;
      case Themes.oled:
        return HaboTheme.oledTheme;
      default:
        return HaboTheme.lightTheme;
    }
  }

  Themes get getThemeString {
    return _settingsData.theme;
  }

  StartingDayOfWeek get getWeekStartEnum {
    return _settingsData.weekStart;
  }

  TimeOfDay get getDailyNot {
    return _settingsData.dailyNotTime;
  }

  bool get getShowDailyNot {
    return _settingsData.showDailyNot;
  }

  bool get getSoundEffects {
    return _settingsData.soundEffects;
  }

  bool get getShowMonthName {
    return _settingsData.showMonthName;
  }

  bool get getSeenOnboarding {
    return _settingsData.seenOnboarding;
  }

  Color get checkColor {
    return _settingsData.checkColor;
  }

  Color get failColor {
    return _settingsData.failColor;
  }

  Color get skipColor {
    return _settingsData.skipColor;
  }

  bool get isInitialized {
    return _isInitialized;
  }

  set setTheme(Themes value) {
    _settingsData.theme = value;
    saveData();
    notifyListeners();
  }

  set setWeekStart(StartingDayOfWeek value) {
    _settingsData.weekStart = value;
    saveData();
    notifyListeners();
  }

  set setDailyNot(TimeOfDay notTime) {
    _settingsData.dailyNotTime = notTime;
    setAppNotification(notTime);
    saveData();
    notifyListeners();
  }

  set setShowDailyNot(bool value) {
    _settingsData.showDailyNot = value;
    if (value) {
      setAppNotification(_settingsData.dailyNotTime);
    } else {
      disableAppNotification();
    }
    saveData();
    notifyListeners();
  }

  set setSoundEffects(bool value) {
    _settingsData.soundEffects = value;
    saveData();
    notifyListeners();
  }

  set setShowMonthName(bool value) {
    _settingsData.showMonthName = value;
    saveData();
    notifyListeners();
  }

  set setSeenOnboarding(bool value) {
    _settingsData.seenOnboarding = value;
    saveData();
    notifyListeners();
  }

  set checkColor(Color value) {
    _settingsData.checkColor = value;
    saveData();
    notifyListeners();
  }

  set failColor(Color value) {
    _settingsData.failColor = value;
    saveData();
    notifyListeners();
  }

  set skipColor(Color value) {
    _settingsData.skipColor = value;
    saveData();
    notifyListeners();
  }
}
