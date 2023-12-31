import 'package:flutter/material.dart';
import 'package:googledocs_clone/screens/docs_screen.dart';
import 'package:googledocs_clone/screens/home_screen.dart';
import 'package:googledocs_clone/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LoginScreen()),
});
final loginRoute = RouteMap(routes: {
  '/': (route) => const  MaterialPage(child: HomeScreen()),
  '/document/:id': (route) => MaterialPage(child: DocumentScreen(id: route.pathParameters['id'] ?? '',),)
});