import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // Responsive font sizes
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    double scaleFactor = screenWidth(context) / 375; // Base width (iPhone SE)
    return baseSize * scaleFactor;
  }

  // Responsive padding/margin
  static double getResponsivePadding(BuildContext context, double basePadding) {
    double scaleFactor = screenWidth(context) / 375;
    return basePadding * scaleFactor;
  }

  // Responsive height
  static double getResponsiveHeight(BuildContext context, double baseHeight) {
    double scaleFactor = screenHeight(context) / 812; // Base height (iPhone SE)
    return baseHeight * scaleFactor;
  }

  // Responsive width
  static double getResponsiveWidth(BuildContext context, double baseWidth) {
    double scaleFactor = screenWidth(context) / 375;
    return baseWidth * scaleFactor;
  }

  // Check if device is tablet
  static bool isTablet(BuildContext context) {
    return screenWidth(context) > 600;
  }

  // Check if device is mobile
  static bool isMobile(BuildContext context) {
    return screenWidth(context) <= 600;
  }
}
