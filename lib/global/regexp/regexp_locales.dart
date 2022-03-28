class RegExpLocales {
  static RegExp get expresionPlacaCarro => RegExp(
        r"[a-z][a-z][a-z][0-9][0-9][0-9]",
        caseSensitive: false,
        multiLine: false,
      );

  static RegExp get expresionPlacaMoto => RegExp(
        r"[a-z][a-z][a-z][0-9][0-9][a-z]",
        caseSensitive: false,
        multiLine: false,
      );
  static RegExp get expresionContrasenia => RegExp(
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])([A-Za-z\d$@$!%*?&]|[^ ]){8,15}$",
        caseSensitive: false,
        multiLine: false,
      );
}
