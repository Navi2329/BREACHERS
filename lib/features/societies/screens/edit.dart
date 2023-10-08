import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:societysync/core/common/error.dart';
import 'package:societysync/core/common/loader.dart';
import 'package:societysync/core/constants/constants.dart';
import 'package:societysync/core/type.dart';
import 'package:societysync/features/societies/controller.dart';
import 'package:societysync/models/society.dart';
import 'package:societysync/responsive_widgets.dart';
import 'package:societysync/theme/themes.dart';

class EditSociety extends ConsumerStatefulWidget {
  final String name;
  const EditSociety({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditSociety> {
  File? bannerFile;
  File? profileFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save(Society community) {
    ref.read(societyProvider.notifier).editsociety(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          society: community,
          profileWebFile: profileWebFile,
          bannerWebFile: bannerWebFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(societyProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(societybynameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor: currentTheme.colorScheme.background,
            appBar: AppBar(
              title: const Text('Edit Community'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => save(community),
                  child: const Text('Save'),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Responsive(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: selectBannerImage,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    dashPattern: const [10, 4],
                                    strokeCap: StrokeCap.round,
                                    color: currentTheme.textTheme.bodyMedium!.color!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: bannerWebFile != null
                                          ? Image.memory(bannerWebFile!)
                                          : bannerFile != null
                                              ? Image.file(bannerFile!)
                                              : community.banner.isEmpty || community.banner == Constants.bannerDefault
                                                  ? const Center(
                                                      child: Icon(
                                                        Icons.camera_alt_outlined,
                                                        size: 40,
                                                      ),
                                                    )
                                                  : Image.network(community.banner),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: selectProfileImage,
                                    child: profileWebFile != null
                                        ? CircleAvatar(
                                            backgroundImage: MemoryImage(profileWebFile!),
                                            radius: 32,
                                          )
                                        : profileFile != null
                                            ? CircleAvatar(
                                                backgroundImage: FileImage(profileFile!),
                                                radius: 32,
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(community.avatar),
                                                radius: 32,
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
        );
  }
}
