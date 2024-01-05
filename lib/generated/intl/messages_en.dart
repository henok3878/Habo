// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(theme) => "${Intl.select(theme, {
            'device': 'Device',
            'light': 'Light',
            'dark': 'Dark',
            'oled': 'OLED black',
            'other': 'Device',
          })}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("About"),
        "accountabilityPartner":
            MessageLookupByLibrary.simpleMessage("Accountability partner"),
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "advancedHabitBuilding":
            MessageLookupByLibrary.simpleMessage("Advanced habit building"),
        "advancedHabitBuildingDescription": MessageLookupByLibrary.simpleMessage(
            "This section helps you better define your habits utilizing the Habit loop. You should define cues, routines, and rewards for every habit."),
        "allHabitsWillBeReplaced": MessageLookupByLibrary.simpleMessage(
            "All habits will be replaced with habits from backup."),
        "allow": MessageLookupByLibrary.simpleMessage("Allow"),
        "alreadyHaveAnAccountSignIn":
            MessageLookupByLibrary.simpleMessage("Already have an account?"),
        "appNotifications":
            MessageLookupByLibrary.simpleMessage("App notifications"),
        "appNotificationsChannel": MessageLookupByLibrary.simpleMessage(
            "Notification channel for application notifications"),
        "at7AM": MessageLookupByLibrary.simpleMessage("At 7:00AM"),
        "backup": MessageLookupByLibrary.simpleMessage("Backup"),
        "backupFailedError": MessageLookupByLibrary.simpleMessage(
            "ERROR: Creating backup failed."),
        "buyMeACoffee": MessageLookupByLibrary.simpleMessage("Buy me a coffee"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "check": MessageLookupByLibrary.simpleMessage("Check"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "congratulationsReward": MessageLookupByLibrary.simpleMessage(
            "Congratulations! Your reward:"),
        "copyright": MessageLookupByLibrary.simpleMessage("©2023 Habo"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createHabit": MessageLookupByLibrary.simpleMessage("Create Habit"),
        "createYourAccount":
            MessageLookupByLibrary.simpleMessage("Create your account"),
        "createYourFirstHabit":
            MessageLookupByLibrary.simpleMessage("Create your first habit."),
        "cue": MessageLookupByLibrary.simpleMessage("Cue"),
        "cueDescription": MessageLookupByLibrary.simpleMessage(
            "is the trigger that initiates your habit. It could be a specific time, location, feeling, or an event."),
        "cueNumbered": MessageLookupByLibrary.simpleMessage("1. Cue"),
        "currentStreak": MessageLookupByLibrary.simpleMessage("Current streak"),
        "dan": MessageLookupByLibrary.simpleMessage("Dan"),
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "defineYourHabits":
            MessageLookupByLibrary.simpleMessage("Define your habits"),
        "defineYourHabitsDescription": MessageLookupByLibrary.simpleMessage(
            "To better stick to your habits, you can define:"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "disclaimer": MessageLookupByLibrary.simpleMessage("Disclaimer"),
        "do50PushUps": MessageLookupByLibrary.simpleMessage("Do 50 push ups"),
        "doNotForgetToCheckYourHabits": MessageLookupByLibrary.simpleMessage(
            "Do not forget to check your habits."),
        "doNotHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "donateToCharity":
            MessageLookupByLibrary.simpleMessage("Donate 10\$ to charity"),
        "done": MessageLookupByLibrary.simpleMessage("Done"),
        "editHabit": MessageLookupByLibrary.simpleMessage("Edit Habit"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emptyList": MessageLookupByLibrary.simpleMessage("Empty list"),
        "exercise": MessageLookupByLibrary.simpleMessage("Exercise"),
        "fail": MessageLookupByLibrary.simpleMessage("Fail"),
        "fifteenMinOfVideoGames":
            MessageLookupByLibrary.simpleMessage("15 min. of video games"),
        "firstDayOfWeek":
            MessageLookupByLibrary.simpleMessage("First day of the week"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "habit": MessageLookupByLibrary.simpleMessage("Habit"),
        "habitContract": MessageLookupByLibrary.simpleMessage("Habit contract"),
        "habitContractDescription": MessageLookupByLibrary.simpleMessage(
            "While positive reinforcement is recommended, some people may opt for a habit contract. A habit contract allows you to specify a sanction that will be imposed if you miss your habit, and may involve an accountability partner who helps supervise your goals."),
        "habitDeleted": MessageLookupByLibrary.simpleMessage("Habit deleted."),
        "habitLoop": MessageLookupByLibrary.simpleMessage("Habit loop"),
        "habitLoopDescription": MessageLookupByLibrary.simpleMessage(
            "Habit Loop is a psychological model describing the process of habit formation. It consists of three components: Cue, Routine, and Reward. The Cue triggers the Routine (habitual action), which is then reinforced by the Reward, creating a loop that makes the habit more ingrained and likely to be repeated."),
        "habitNotifications":
            MessageLookupByLibrary.simpleMessage("Habit notifications"),
        "habitNotificationsChannel": MessageLookupByLibrary.simpleMessage(
            "Notification channel for habit notifications"),
        "habitTitleEmptyError": MessageLookupByLibrary.simpleMessage(
            "The habit title can not be empty."),
        "habits": MessageLookupByLibrary.simpleMessage("Habits:"),
        "habo": MessageLookupByLibrary.simpleMessage("Habo"),
        "haboNeedsPermission": MessageLookupByLibrary.simpleMessage(
            "Habo needs permission to send notifications to work properly."),
        "ifYouWantToSupport": MessageLookupByLibrary.simpleMessage(
            "If you want to support Habo you can:"),
        "invalidEmailAddress":
            MessageLookupByLibrary.simpleMessage("Invalid Email Address"),
        "invalidName": MessageLookupByLibrary.simpleMessage("Invalid Name"),
        "invalidPassword":
            MessageLookupByLibrary.simpleMessage("Invalid Password"),
        "logYourDays": MessageLookupByLibrary.simpleMessage("Log your days"),
        "modify": MessageLookupByLibrary.simpleMessage("Modify"),
        "month": MessageLookupByLibrary.simpleMessage("Month"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "noDataAboutHabits": MessageLookupByLibrary.simpleMessage(
            "There is no data about habits."),
        "notSoSuccessful":
            MessageLookupByLibrary.simpleMessage("Not so successful"),
        "note": MessageLookupByLibrary.simpleMessage("Note"),
        "notificationTime":
            MessageLookupByLibrary.simpleMessage("Notification time"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "observeYourProgress":
            MessageLookupByLibrary.simpleMessage("Observe your progress"),
        "ohNoSanction":
            MessageLookupByLibrary.simpleMessage("Oh no! Your sanction:"),
        "onboarding": MessageLookupByLibrary.simpleMessage("Onboarding"),
        "orSignInWith": MessageLookupByLibrary.simpleMessage("or Sign in with"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordNotMatched":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "pleaseEnterEmailAddress": MessageLookupByLibrary.simpleMessage(
            "Please, enter your email address"),
        "pleaseEnterName":
            MessageLookupByLibrary.simpleMessage("Please, enter your name"),
        "pleaseEnterPassword":
            MessageLookupByLibrary.simpleMessage("Please, enter your password"),
        "pleaseReEnterPassword": MessageLookupByLibrary.simpleMessage(
            "Please, re-enter your password"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "registrationComplete":
            MessageLookupByLibrary.simpleMessage("Registration Complete!"),
        "remainderOfReward": MessageLookupByLibrary.simpleMessage(
            "The reminder of the reward after a successful routine."),
        "remainderOfSanction": MessageLookupByLibrary.simpleMessage(
            "The reminder of the sanction after a unsuccessful routine."),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "restore": MessageLookupByLibrary.simpleMessage("Restore"),
        "restoreFailedError": MessageLookupByLibrary.simpleMessage(
            "ERROR: Restoring backup failed."),
        "reward": MessageLookupByLibrary.simpleMessage("Reward"),
        "rewardDescription": MessageLookupByLibrary.simpleMessage(
            "is the benefit or positive feeling you experience after performing the routine. It reinforces the habit."),
        "rewardNumbered": MessageLookupByLibrary.simpleMessage("3. Reward"),
        "routine": MessageLookupByLibrary.simpleMessage("Routine"),
        "routineDescription": MessageLookupByLibrary.simpleMessage(
            "is the action you take in response to the cue. This is the habit itself."),
        "routineNumbered": MessageLookupByLibrary.simpleMessage("2. Routine"),
        "sanction": MessageLookupByLibrary.simpleMessage("Sanction"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "setColors": MessageLookupByLibrary.simpleMessage("Set colors"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "showMonthName":
            MessageLookupByLibrary.simpleMessage("Show month name"),
        "showReward": MessageLookupByLibrary.simpleMessage("Show reward"),
        "showSanction": MessageLookupByLibrary.simpleMessage("Show sanction"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "signInError": MessageLookupByLibrary.simpleMessage(
            "Unable to login. Check your details and network, then retry."),
        "signOut": MessageLookupByLibrary.simpleMessage("Sign Out"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "signUpError": MessageLookupByLibrary.simpleMessage(
            "Registration failed. Verify your information and network, then retry."),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "skipDoesNotAffectStreaks": MessageLookupByLibrary.simpleMessage(
            "Skip (does not affect streaks)"),
        "soundEffects": MessageLookupByLibrary.simpleMessage("Sound effects"),
        "sourceCode":
            MessageLookupByLibrary.simpleMessage("Source code (GitHub)"),
        "statistics": MessageLookupByLibrary.simpleMessage("Statistics"),
        "successful": MessageLookupByLibrary.simpleMessage("Successful"),
        "termsAndConditions":
            MessageLookupByLibrary.simpleMessage("Terms and Conditions"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "themeSelect": m0,
        "topStreak": MessageLookupByLibrary.simpleMessage("Top streak"),
        "total": MessageLookupByLibrary.simpleMessage("Total"),
        "trackYourProgress": MessageLookupByLibrary.simpleMessage(
            "You can track your progress through the calendar view in every habit or on the statistics page."),
        "twoDayRule": MessageLookupByLibrary.simpleMessage("Two day rule"),
        "twoDayRuleDescription": MessageLookupByLibrary.simpleMessage(
            "With two day rule, you can miss one day and do not lose a streak if the next day is successful."),
        "undo": MessageLookupByLibrary.simpleMessage("Undo"),
        "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "useTwoDayRule":
            MessageLookupByLibrary.simpleMessage("Use Two day rule"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "week": MessageLookupByLibrary.simpleMessage("Week"),
        "yourCommentHere":
            MessageLookupByLibrary.simpleMessage("Your note here")
      };
}
