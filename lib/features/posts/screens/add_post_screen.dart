import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:societysync/theme/themes.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  void goBack(BuildContext context) {
    Routemaster.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = kIsWeb ? 360 : 120;
    double iconSize = kIsWeb ? 120 : 60;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      body: Column( 
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => goBack(context),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: currentTheme.colorScheme.background,
                      elevation: 16,
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => navigateToType(context, 'image'),
                  child: SizedBox(
                    height: cardHeightWidth,
                    width: cardHeightWidth,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: currentTheme.colorScheme.background,
                      elevation: 16,
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: iconSize,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => navigateToType(context, 'text'),
                  child: SizedBox(
                    height: cardHeightWidth,
                    width: cardHeightWidth,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: currentTheme.colorScheme.background,
                      elevation: 16,
                      child: Center(
                        child: Icon(
                          Icons.font_download_outlined,
                          size: iconSize,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => navigateToType(context, 'link'),
                  child: SizedBox(
                    height: cardHeightWidth,
                    width: cardHeightWidth,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: currentTheme.colorScheme.background,
                      elevation: 16,
                      child: Center(
                        child: Icon(
                          Icons.link_outlined,
                          size: iconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
