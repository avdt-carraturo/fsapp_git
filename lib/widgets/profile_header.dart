import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fsapp_shared/shared.dart';

class ProfileHeader extends StatelessWidget {
  final Utente? utente;

  const ProfileHeader({super.key, this.utente});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundImage: firebaseUser?.photoURL != null
              ? NetworkImage(firebaseUser!.photoURL!)
              : null,
          child: firebaseUser?.photoURL == null
              ? const Icon(Icons.person, size: 36)
              : null,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              utente?.nominativo ??
                  firebaseUser?.displayName ??
                  'Utente',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              utente?.email ?? firebaseUser?.email ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
