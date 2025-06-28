import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/pages/login_page.dart';
import 'package:frontend/screans/note_list.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          Widget child;

          if (snapshot.connectionState == ConnectionState.waiting) {
            child = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            child = NoteList();
          } else {
            child = const LoginPage();
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: KeyedSubtree(key: ValueKey(child.runtimeType), child: child),
          );
        },
      ),
    );
  }
}
