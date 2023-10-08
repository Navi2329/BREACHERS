import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:societysync/core/common/loader.dart';
import 'package:societysync/core/common/sign_in.dart';
import 'package:societysync/core/constants/constants.dart';
import 'package:societysync/features/auth/controller/auth_controller.dart';
import 'package:societysync/responsive_widgets.dart';



class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          TextButton(onPressed: () => signInAsGuest(ref, context), child: const Text('Skip For Now'))
        ],
      ),
      body: isLoading? const Loader(): Column(children: [
        const SizedBox(height: 20),
        const Text('Welcome to SocietySync',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        const SizedBox(height: 50),
        Image.asset(Constants.logoPath, height: 200),
        const SizedBox(height: 100),
        const Text(
          'A place where you can connect with your society members',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        const Responsive(child: SignInButton()),
      ]),
    );
  }
}
