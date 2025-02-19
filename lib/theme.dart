import 'package:flutter/material.dart';

final themeData = ThemeData(
  fontFamily: 'Inter',
  brightness: Brightness.light,
  hintColor: const Color.fromRGBO(158, 158, 158, 1),
  primaryColor: const Color.fromRGBO(255, 110, 64, 1),
  primaryColorLight: const Color.fromRGBO(0, 0, 0, 0.541),
  iconTheme: const IconThemeData(color: Colors.black),
  primaryIconTheme:
      const IconThemeData(color: Colors.red, opacity: 1.0, size: 50.0),
  colorScheme: const ColorScheme.light(
    primary: Colors.black,
    secondary: Color.fromARGB(255, 163, 163, 163),
    background: Colors.white,
    surfaceTint: Colors.transparent,
  ),
  outlinedButtonTheme: buildOutlinedButtonThemeData(
    bgDisabled: const Color.fromRGBO(158, 158, 158, 1),
    bgEnabled: const Color.fromRGBO(0, 0, 0, 1),
    fgDisabled: const Color.fromRGBO(255, 255, 255, 1),
    fgEnabled: const Color.fromRGBO(255, 255, 255, 1),
  ),
  elevatedButtonTheme: buildElevatedButtonThemeData(
    onPrimary: const Color.fromRGBO(255, 255, 255, 1),
    primary: const Color.fromRGBO(0, 0, 0, 1),
  ),
  switchTheme: getSwitchThemeData(const Color.fromRGBO(102, 187, 106, 1)),
  scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    iconTheme: const IconThemeData(color: Colors.black),
    elevation: 0,
  ),
  //https://api.flutter.dev/flutter/material/TextTheme-class.html
  textTheme: _buildTextTheme(const Color.fromRGBO(0, 0, 0, 1)),
  primaryTextTheme: const TextTheme().copyWith(
    bodyMedium: const TextStyle(color: Colors.yellow),
    bodyLarge: const TextStyle(color: Colors.orange),
  ),
  cardColor: const Color.fromRGBO(250, 250, 250, 1.0),
  dialogTheme: const DialogTheme().copyWith(
    backgroundColor: const Color.fromRGBO(250, 250, 250, 1.0), //
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    contentTextStyle: const TextStyle(
      fontFamily: 'Inter-Medium',
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  inputDecorationTheme: const InputDecorationTheme().copyWith(
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(45, 194, 98, 1.0),
      ),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    side: const BorderSide(
      color: Colors.black,
      width: 2,
    ),
    fillColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(MaterialState.selected)
          ? const Color.fromRGBO(0, 0, 0, 1)
          : const Color.fromRGBO(255, 255, 255, 1);
    }),
    checkColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(MaterialState.selected)
          ? const Color.fromRGBO(255, 255, 255, 1)
          : const Color.fromRGBO(0, 0, 0, 1);
    }),
  ),
);

OutlinedButtonThemeData buildOutlinedButtonThemeData({
  required Color bgDisabled,
  required Color bgEnabled,
  required Color fgDisabled,
  required Color fgEnabled,
}) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(50, 16, 50, 16),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter-SemiBold',
        fontSize: 18,
      ),
    ).copyWith(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return bgDisabled;
          }
          return bgEnabled;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return fgDisabled;
          }
          return fgEnabled;
        },
      ),
      alignment: Alignment.center,
    ),
  );
}

TextTheme _buildTextTheme(Color textColor) {
  return const TextTheme().copyWith(
    headlineMedium: TextStyle(
      color: textColor,
      fontSize: 32,
      fontWeight: FontWeight.w600,
      fontFamily: 'Inter',
    ),
    headlineSmall: TextStyle(
      color: textColor,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      fontFamily: 'Inter',
    ),
    titleLarge: TextStyle(
      color: textColor,
      fontSize: 18,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: textColor,
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: textColor,
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Inter',
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Inter',
      color: textColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(
      color: textColor.withOpacity(0.6),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Inter',
      color: textColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.underline,
    ),
  );
}

ElevatedButtonThemeData buildElevatedButtonThemeData({
  required Color onPrimary, // text button color
  required Color primary,
  double elevation = 2, // background color of button
}) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: onPrimary,
      backgroundColor: primary,
      elevation: elevation,
      alignment: Alignment.center,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter-SemiBold',
        fontSize: 18,
      ),
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  );
}

SwitchThemeData getSwitchThemeData(Color activeColor) {
  return SwitchThemeData(
    thumbColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return activeColor;
      }
      return null;
    }),
    trackColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return activeColor;
      }
      return null;
    }),
  );
}
