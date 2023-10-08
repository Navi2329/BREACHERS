import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:societysync/core/common/error.dart';
import 'package:societysync/core/common/loader.dart';
import 'package:societysync/core/common/sign_in.dart';
import 'package:societysync/features/auth/controller/auth_controller.dart';
import 'package:societysync/features/societies/controller.dart';
import 'package:societysync/models/society.dart';

class SocietyListDrawer extends ConsumerWidget {
  const SocietyListDrawer({super.key});

  void navigateToCreateSociety(BuildContext context) {
    Routemaster.of(context).push('/create-Society');
  }

  void navigateToSociety(BuildContext context, Society society) {
    Routemaster.of(context).push('/r/${society.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest
                ? const SignInButton()
                : ListTile(
                    title: const Text('Create a Society'),
                    leading: const Icon(Icons.add),
                    onTap: () => navigateToCreateSociety(context),
                  ),
            if (!isGuest)
              ref.watch(usersocietyProvider).when(
                    data: (societies) => Expanded(
                      child: ListView.builder(
                        itemCount: societies.length,
                        itemBuilder: (BuildContext context, int index) {
                          final society = societies[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(society.avatar),
                            ),
                            title: Text('r/${society.name}'),
                            onTap: () {
                              navigateToSociety(context, society);
                            },
                          );
                        },
                      ),
                    ),
                    error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
          ],
        ),
      ),
    );
  }
}
