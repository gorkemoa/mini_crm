import 'package:flutter/material.dart';

abstract class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Specific
  static const double cardPadding = 16.0;
  static const double screenPadding = 16.0;
  static const double sectionSpacing = 24.0;
  static const double itemSpacing = 12.0;
  static const double formFieldSpacing = 16.0;

  // EdgeInsets helpers
  static const EdgeInsets cardPaddingAll = EdgeInsets.all(cardPadding);
  static const EdgeInsets screenPaddingAll = EdgeInsets.all(screenPadding);
  static const EdgeInsets screenPaddingH = EdgeInsets.symmetric(horizontal: screenPadding);
  static const EdgeInsets screenPaddingV = EdgeInsets.symmetric(vertical: screenPadding);

  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
}
