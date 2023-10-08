import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:societysync/core/constants/firebase_constants.dart';
import 'package:societysync/core/providers/firebase_provider.dart';
import 'package:societysync/core/type.dart';
import 'package:societysync/models/post.dart';
import 'package:societysync/models/society.dart';

final societyRepoProvider = Provider<SocietyRepo>((ref) {
  return SocietyRepo(firestore: ref.watch(firestoreProvider));
});

class SocietyRepo {
  final FirebaseFirestore _firestore;
  SocietyRepo({required FirebaseFirestore firestore}) : _firestore = firestore;

  FutureVoid createSociety(society) async {
    try {
      var societydoc = await _societyCollection.doc(society.name).get();
      if (societydoc.exists) {
        throw 'Society already exists';
      }
      return right(_societyCollection.doc(society.name).set(society.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinSociety(String societyName, String userId) async {
    try {
      return right(_societyCollection.doc(societyName).update({
        'members': FieldValue.arrayUnion([userId]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveSociety(String societyName, String userId) async {
    try {
      return right(_societyCollection.doc(societyName).update({
        'members': FieldValue.arrayRemove([userId]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Society>> getUserSocieties(String id) {
    return _societyCollection
        .where('members', arrayContains: id)
        .snapshots()
        .map((event) {
      List<Society> societies = [];
      for (var doc in event.docs) {
        societies.add(Society.fromMap(doc.data() as Map<String, dynamic>));
      }
      return societies;
    });
  }

  Stream<Society> getSociety(String name) {
    return _societyCollection.doc(name).snapshots().map((event) => Society.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editSociety(Society society) async {
    try {
      return right(_societyCollection.doc(society.name).update(society.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Society>> searchSociety(String query) {
    return _societyCollection
        .where('name', isGreaterThanOrEqualTo: query.isEmpty ? 0 : query, isLessThan: query.isEmpty ? null : query.substring(0,query.length-1)+String.fromCharCode(query.codeUnitAt(query.length-1)+1),)
        .snapshots()
        .map((event) {
      List<Society> societies = [];
      for (var doc in event.docs) {
        societies.add(Society.fromMap(doc.data() as Map<String, dynamic>));
      }
      return societies;
    });
  }

  FutureVoid addMods(String societyname, List<String> uids) async {
    try {
      return right(_societyCollection.doc(societyname).update({
        'mods': uids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

    Stream<List<Post>> getSocietyPosts(String name) {
    return _posts.where('societyName', isEqualTo: name).orderBy('createdAt', descending: true).snapshots().map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  CollectionReference get _societyCollection =>
      _firestore.collection(FirebaseConstants.societiesCollection);
  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);
}
