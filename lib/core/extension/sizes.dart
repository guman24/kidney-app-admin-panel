import 'package:flutter/cupertino.dart';
import 'package:responsive_framework/responsive_framework.dart';

extension SizesX on BuildContext {
  Size get windowSize => MediaQuery.sizeOf(this);

  bool get isPhone => ResponsiveBreakpoints.of(this).isPhone;
  bool get isMobile => ResponsiveBreakpoints.of(this).isMobile;
  bool get isTablet => ResponsiveBreakpoints.of(this).isTablet;
  bool get isDesktop => ResponsiveBreakpoints.of(this).isDesktop;

  double get width => windowSize.width;
  double get height => windowSize.height;

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get safeAreaHorizontalPadding => MediaQuery.paddingOf(this).horizontal;
  double get safeAreaVerticalPadding => MediaQuery.paddingOf(this).vertical;
}
