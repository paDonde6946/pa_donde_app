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
}
