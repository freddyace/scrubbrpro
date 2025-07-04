import 'package:flutter/cupertino.dart';

class InheritedThemeWrapper extends InheritedWidget {
  final bool isDarkMode;
  final Function(bool) toggleTheme;

  const InheritedThemeWrapper({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
    required super.child,
  });

  static InheritedThemeWrapper of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedThemeWrapper>()!;
  }

  @override
  bool updateShouldNotify(InheritedThemeWrapper oldWidget) {
    return oldWidget.isDarkMode != isDarkMode;
  }
}
