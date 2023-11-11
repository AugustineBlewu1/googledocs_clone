import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googledocs_clone/models/error_model.dart';
import 'package:googledocs_clone/repository/auth_repository.dart';
import 'package:googledocs_clone/router.dart';
import 'package:googledocs_clone/screens/home_screen.dart';
import 'package:googledocs_clone/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();
      print(errorModel!.toMap());
    if (errorModel!.code != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    }
    // final user = await ref.watch(authRepositoryProvider).getUserData();
    // ref.read(userProvider.notifier).update((state) => user);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final user = ref.watch(userProvider);
        print(user?.toMap());
        if (user != null && user.token!.isNotEmpty) {
          return loginRoute;
        }
        return loggedOutRoute;
      }),
    );
  }
}
