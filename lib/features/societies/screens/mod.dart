import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModTools extends StatelessWidget {
  final String name;
  const ModTools({
    Key? key,
    required this.name,
  }) : super(key: key);

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/edit-society/$name');
  }

  void navigateToAddMods(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tools'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text('Add Moderators'),
            onTap: () => navigateToAddMods(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit society'),
            onTap: () => navigateToModTools(context),
          ),
        ],
      ),
    );
  }
}
