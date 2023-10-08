import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:societysync/core/common/error.dart';
import 'package:societysync/core/common/loader.dart';
import 'package:societysync/core/common/post_card.dart';
import 'package:societysync/features/auth/controller/auth_controller.dart';
import 'package:societysync/features/posts/controller/post_controller.dart';
import 'package:societysync/features/societies/controller.dart';
class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    if (!isGuest) {
      return ref.watch(usersocietyProvider).when(
            data: (societies) => ref.watch(userPostsProvider(societies)).when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = data[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return ErrorText(
                      error: error.toString(),
                    );
                  },
                  loading: () => const Loader(),
                ),
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          );
    }
    return ref.watch(usersocietyProvider).when(
          data: (societies) => ref.watch(guestPostsProvider).when(
                data: (data) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = data[index];
                      return PostCard(post: post);
                    },
                  );
                },
                error: (error, stackTrace) {
                  return ErrorText(
                    error: error.toString(),
                  );
                },
                loading: () => const Loader(),
              ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
