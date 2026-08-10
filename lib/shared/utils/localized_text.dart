/// Picks the correct string for the active language code from the three stored
/// content columns. Content lives in the database as `*_en / *_ur / *_ps`
/// columns; this keeps that selection in one place.
String pickLang(String code, String en, String ur, String ps) {
  switch (code) {
    case 'ur':
      return ur.isNotEmpty ? ur : en;
    case 'ps':
      return ps.isNotEmpty ? ps : en;
    default:
      return en;
  }
}
