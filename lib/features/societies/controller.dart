import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:societysync/core/constants/constants.dart';
import 'package:societysync/core/providers/storage_provider.dart';
import 'package:societysync/core/type.dart';
import 'package:societysync/features/auth/controller/auth_controller.dart';
import 'package:societysync/features/societies/repo.dart';
import 'package:societysync/models/post.dart';
import 'package:societysync/models/society.dart';

final usersocietyProvider = StreamProvider<List<Society>>((ref) {
  final societycontroller = ref.watch(societyProvider.notifier);
  return societycontroller.getUserSocieties();
});

final societyProvider = StateNotifierProvider<SocietyController, bool>((ref) {
  final repo = ref.watch(societyRepoProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return SocietyController(
      repo: repo, storageRepository: storageRepository, ref: ref);
});

final societybynameProvider =
    StreamProvider.family<Society, String>((ref, name) {
  final societycontroller = ref.watch(societyProvider.notifier);
  return societycontroller.getSociety(name);
});

final searchSocietyProvider = StreamProvider.family((ref, String query) {
  final societycontroller = ref.watch(societyProvider.notifier);
  return societycontroller.searchSociety(query);
});

final getSocietyPostsProvider = StreamProvider.family((ref, String name) {
  final societycontroller = ref.watch(societyProvider.notifier);
  return societycontroller.getSocietyPosts(name);
});

class SocietyController extends StateNotifier<bool> {
  final SocietyRepo _socirepo;
  final Ref _ref;
  final StorageRepository _storageRepository;
  SocietyController(
      {required SocietyRepo repo,
      required Ref ref,
      required StorageRepository storageRepository})
      : _socirepo = repo,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createSociety(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Society society = Society(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );
    final result = await _socirepo.createSociety(society);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Society created successfully');

      Routemaster.of(context).pop();
    });
  }

  void joinSociety(Society society, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;
    if (society.members.contains(user.uid)) {
      res = await _socirepo.leaveSociety(society.name, user.uid);
    } else {
      res = await _socirepo.joinSociety(society.name, user.uid);
    }

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (society.members.contains(user.uid)) {
        showSnackBar(context, 'Societyleft successfully!');
      } else {
        showSnackBar(context, 'Society joined successfully!');
      }
    });
  }

  void editsociety({
    required File? profileFile,
    required File? bannerFile,
    required Uint8List? profileWebFile,
    required Uint8List? bannerWebFile,
    required BuildContext context,
    required Society society,
  }) async {
    state = true;
    if (profileFile != null || profileWebFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'societies/profile',
        id: society.name,
        file: profileFile,
        webFile: profileWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => society = society.copyWith(avatar: r),
      );
    }

    if (bannerFile != null || bannerWebFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'societies/banner',
        id: society.name,
        file: bannerFile,
        webFile: bannerWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => society = society.copyWith(banner: r),
      );
    }

    final res = await _socirepo.editSociety(society);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Society>> getUserSocieties() {
    final uid = _ref.read(userProvider)?.uid ?? '';
    return _socirepo.getUserSocieties(uid);
  }

  Stream<Society> getSociety(String name) {
    return _socirepo.getSociety(name);
  }

  Stream<List<Society>> searchSociety(String query) {
    return _socirepo.searchSociety(query);
  }

  Stream<List<Post>> getSocietyPosts(String name) {
    return _socirepo.getSocietyPosts(name);
  }

  void addMods(
      String societyname, List<String> uids, BuildContext context) async {
    final res = await _socirepo.addMods(societyname, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }
}
