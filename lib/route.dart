import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:societysync/features/posts/screens/add_post_screen.dart';
import 'package:societysync/features/posts/screens/add_post_type_screen.dart';
import 'package:societysync/features/posts/screens/comments_screen.dart';
import 'package:societysync/features/profile/edit_profile_screen.dart';
import 'package:societysync/features/profile/user_profile_screen.dart';
import 'package:societysync/features/societies/screens/add_mods.dart';
import 'package:societysync/features/societies/screens/creation.dart';
import 'package:societysync/features/societies/screens/edit.dart';
import 'package:societysync/features/societies/screens/mod.dart';
import 'package:societysync/features/societies/screens/society_screen.dart';
import 'package:societysync/screens/comments.dart';
import 'package:societysync/features/home/screens/home.dart';
import 'package:societysync/features/auth/screens/login.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-Society': (_) => const MaterialPage(child: Createsociety()),
  '/comments': (_) => const MaterialPage(child: CommentSection()),
   '/r/:name': (route) => MaterialPage(
          child: SocietyScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '/mod-tools/:name': (routeData) => MaterialPage(
          child: ModTools(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/edit-society/:name': (routeData) => MaterialPage(
          child: EditSociety(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/add-mods/:name': (routeData) => MaterialPage(
          child: AddMods(
            name: routeData.pathParameters['name']!,
          ),
        ),
'/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/add-post/:type': (routeData) => MaterialPage(
          child: AddPostTypeScreen(
            type: routeData.pathParameters['type']!,
          ),
        ),
    '/post/:postId/comments': (route) => MaterialPage(
          child: CommentsScreen(
            postId: route.pathParameters['postId']!,
          ),
        ),
    '/add-post': (routeData) => const MaterialPage(
          child: AddPostScreen(),
        ),
});
