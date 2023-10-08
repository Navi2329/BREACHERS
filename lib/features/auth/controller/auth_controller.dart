import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:societysync/core/type.dart';
import 'package:societysync/features/auth/repository/repo.dart';
import 'package:societysync/models/user.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepo: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStatechange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});
class AuthController extends StateNotifier<bool>{
  final AuthRepo _authRepo;
  final Ref _ref;
  AuthController({required AuthRepo authRepo, required Ref ref})
      : _authRepo = authRepo,
        _ref = ref,
        super(false);

  Stream<User?> get authStatechange => _authRepo.authStatechange;

  void signInWithGoogle(BuildContext context,bool islogin) async {
    state = true;
    final user = await _authRepo.signInWithGoogle(islogin);
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) => _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

    void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepo.signInAsGuest();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) => _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

    Stream<UserModel> getUserData(String uid) {
    return _authRepo.getUserData(uid);
  }
    void logout() async {
    _authRepo.logOut();
  }
}
