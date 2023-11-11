import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googledocs_clone/colors.dart';
import 'package:googledocs_clone/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

import '../repository/auth_repository.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final errorModel =
        await ref.watch(authRepositoryProvider).signInWithGoogle();
    final navigator = Routemaster.of(context);

    if (errorModel.code == null) {
      print(errorModel.toMap());
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace('/');
    } else {
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(errorModel.data),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  final  ref.watch(authRepositoryProvider).signInWithGoogle();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text('Login Screen'),
            ElevatedButton.icon(
              icon: Image.asset(
                'assets/images/g-logo-2.png',
                height: 20,
              ),
              onPressed: () => signInWithGoogle(ref, context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kwhiteColor,
                minimumSize: const Size(150, 50),
              ),
              label: const Text(
                'Sign In with Google',
                style: TextStyle(color: kblackCOlor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
