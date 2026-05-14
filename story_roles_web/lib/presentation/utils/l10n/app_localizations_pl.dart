// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'StoryRoles';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get enterValidEmail => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String passwordRequireMinCharacters(int numberOfCharacters) {
    return 'Password must be at least $numberOfCharacters characters';
  }

  @override
  String get trackTitle => 'File Title';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get registrationFailed => 'Registration failed. Please try again.';

  @override
  String get registrationSuccess => 'Registration successful! Please log in.';

  @override
  String get loginFailed => 'Login failed. Please check your credentials.';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get noTrackPlaying => 'No track playing';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';
}
