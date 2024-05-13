import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class PackageLocalizations {
  final Locale locale;
  PackageLocalizations(this.locale);

  // Example of a localized string getter
  static PackageLocalizations of(BuildContext context) => Localizations.of<PackageLocalizations>(context, PackageLocalizations)!;

}

class PackageLocalizationsDelegate extends LocalizationsDelegate<PackageLocalizations> {
  const PackageLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<PackageLocalizations> load(Locale locale) => SynchronousFuture<PackageLocalizations>(PackageLocalizations(locale));

  @override
  bool shouldReload(PackageLocalizationsDelegate old) => false;
}
