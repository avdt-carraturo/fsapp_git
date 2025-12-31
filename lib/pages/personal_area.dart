import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_settings_section.dart';
import '../widgets/profile_security_section.dart';
import 'package:fsapp_shared/shared.dart';

class AreaPersonalePage extends StatelessWidget {
  final Utente? utente;

  const AreaPersonalePage({super.key, this.utente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Area personale")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(utente: utente),
            const Divider(height: 40),
            ProfileInfoSection(utente: utente),
            const Divider(height: 40),
            const ProfileSettingsSection(),
            const Divider(height: 40),
            const ProfileSecuritySection(),
          ],
        ),
      ),
    );
  }
}
