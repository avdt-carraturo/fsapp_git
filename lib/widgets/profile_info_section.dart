import 'package:flutter/material.dart';
import 'package:fsapp_shared/shared.dart';

class ProfileInfoSection extends StatelessWidget {
  final Utente? utente;

  const ProfileInfoSection({super.key, this.utente});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.badge),
          title: const Text("Tipo utente"),
          subtitle:
              Text(utente?.tipo == 'O' ? 'Operatore' : 'Passeggero'),
        ),
        if (utente?.tipo == 'O')
          ListTile(
            leading: const Icon(Icons.apartment),
            title: const Text("Area"),
            subtitle: Text(utente?.area ?? '-'),
          ),
      ],
    );
  }
}
