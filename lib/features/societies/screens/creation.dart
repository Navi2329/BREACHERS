import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:societysync/core/common/loader.dart';
import 'package:societysync/features/societies/controller.dart';
import 'package:societysync/responsive_widgets.dart';
import 'package:societysync/theme/themes.dart';

class Createsociety extends ConsumerStatefulWidget {
  const Createsociety({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatesocietyState();
}

class _CreatesocietyState extends ConsumerState<Createsociety> {
  final societynamecontroller = TextEditingController();

  @override
  void dispose() {
    societynamecontroller.dispose();
    super.dispose();
  }

  void createsociety(){
    ref.read(societyProvider.notifier).createSociety(societynamecontroller.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(societyProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Society"),
          centerTitle: true,
        ),
        body: isLoading ? const Loader() :
        Responsive(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 20),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Society Details",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: societynamecontroller,
                  decoration: const InputDecoration(
                    labelText: 'Society Name',
                    filled: true,
                  ),
                  maxLength: 20,
                ),
                const SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                  onPressed: () {
                    createsociety();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Pallete.blueColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  child: const Text("Create Society"),
                ),
              ],
            ),
          ),
        ));
  }
}
