// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'StoryRoles';

  @override
  String get login => 'Zaloguj';

  @override
  String get register => 'Zarejestruj';

  @override
  String get email => 'Email';

  @override
  String get password => 'Hasło';

  @override
  String get emailRequired => 'Email jest wymagany';

  @override
  String get enterValidEmail => 'Podaj prawidłowy email';

  @override
  String get passwordRequired => 'Hasło jest wymagane';

  @override
  String passwordRequireMinCharacters(int numberOfCharacters) {
    return 'Hasło musi mieć co najmniej $numberOfCharacters znaków';
  }

  @override
  String get trackTitle => 'Tytuł pliku';

  @override
  String get backToLogin => 'Powrót do logowania';

  @override
  String get registrationFailed => 'Rejestracja nie powiodła się.';

  @override
  String get registrationSuccess => 'Rejestracja udana! Zaloguj się.';

  @override
  String get loginFailed => 'Logowanie nie powiodło się.';

  @override
  String get loginSuccess => 'Zalogowano pomyślnie!';

  @override
  String get noTrackPlaying => 'Brak odtwarzanego utworu';

  @override
  String get play => 'Odtwórz';

  @override
  String get pause => 'Pauza';
}
