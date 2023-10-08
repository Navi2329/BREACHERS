import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:societysync/core/common/error.dart';
import 'package:societysync/core/common/loader.dart';
import 'package:societysync/features/societies/controller.dart';

class SearchsocietyDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchsocietyDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchSocietyProvider(query)).when(
          data: (societies) => ListView.builder(
            itemCount: societies.length,
            itemBuilder: (BuildContext context, int index) {
              final society = societies[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(society.avatar),
                ),
                title: Text('r/${society.name}'),
                onTap: () => navigateToSociety(context, society.name),
              );
            },
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }

  void navigateToSociety(BuildContext context, String societyName) {
    Routemaster.of(context).push('/r/$societyName');
  }
}
