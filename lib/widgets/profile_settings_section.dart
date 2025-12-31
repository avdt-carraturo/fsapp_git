import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Impostazioni",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        SwitchListTile(
          title: const Text("Notifiche"),
          value: true,
          onChanged: (value) {
            // TODO: collegare notifiche
          },
        ),

        SwitchListTile(
          title: const Text("Tema scuro"),
          value: themeProvider.isDark,
          onChanged: (value) {
            themeProvider.toggleTheme(value);
          },
        ),
      ],
    );
  }
}
