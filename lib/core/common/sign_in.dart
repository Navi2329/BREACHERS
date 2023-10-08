import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:societysync/core/constants/constants.dart';
import 'package:societysync/features/auth/controller/auth_controller.dart';
import 'package:societysync/theme/themes.dart';

class SignInButton extends ConsumerWidget {
  final bool islogin;
  const SignInButton({Key? key, this.islogin=true}) : super(key: key);

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context,islogin);
  }

  void logout(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          onPressed: () {
            logout(context, ref);
            signInWithGoogle(context, ref);
          },
          icon: Image.asset(
            Constants.googlePath,
            width: 50,
          ),
          label: const Text('Sign in with Google'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Pallete.greyColor,
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
        ));
  }
}
