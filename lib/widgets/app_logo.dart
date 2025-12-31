import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:fsapp_shared/shared.dart';

class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;

  const AppLogo({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    return Image.asset(
      isDark
          ? 'packages/fsapp_shared/assets/app_logo_dark.png'
          : 'packages/fsapp_shared/assets/app_logo.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
