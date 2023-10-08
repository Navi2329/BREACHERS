import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class Failure {
  final String message;
  Failure(this.message);
}

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);

  return image;
}

enum ThemeMode {
  light,
  dark,
}

enum UserKarma {
  comment(1),
  textPost(2),
  linkPost(3),
  imagePost(3),
  awardPost(5),
  deletePost(-1);

  final int karma;
  const UserKarma(this.karma);
}