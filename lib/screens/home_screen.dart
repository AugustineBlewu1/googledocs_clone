import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googledocs_clone/colors.dart';
import 'package:googledocs_clone/common/widgets/loader.dart';
import 'package:googledocs_clone/models/document_model.dart';
import 'package:googledocs_clone/repository/auth_repository.dart';
import 'package:googledocs_clone/repository/document_repository.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref, BuildContext context) async {
    await ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(WidgetRef ref, BuildContext context) async {
    final token = ref.read(userProvider)?.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);

    final errorModel =
        await ref.read(documentRepositoryProvider).createDocument(
              token!,
            );

    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackbar.showSnackBar(
        SnackBar(
          content: Text(errorModel.code),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: kwhiteColor,
        actions: [
          IconButton(
            onPressed: () => createDocument(ref, context),
            icon: const Icon(
              Icons.add,
              color: kblackCOlor,
            ),
          ),
          IconButton(
            onPressed: () => signOut(ref, context),
            icon: const Icon(Icons.logout, color: kredcolor),
          ),
        ],
      ),
      body: FutureBuilder(
          future: ref.read(documentRepositoryProvider).getDocuments(
                ref.watch(userProvider)!.token!,
              ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: 600,
                child: ListView.builder(
                  itemCount: snapshot.data?.data.length,
                  itemBuilder: (context, index) {
                    print(snapshot.data!.data![index]);
                    DocumentModel document = snapshot.data!.data![index];
                    return InkWell(
                      onTap: () {
                        final navigator = Routemaster.of(context);
                        navigator
                            .push('/document/${snapshot.data!.data[index].id}');
                      },
                      child: SizedBox(
                        height: 50,
                        child: Card(
                          child: Center(
                              child: Text(
                            document.title,
                            style: const TextStyle(fontSize: 17),
                          )),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}
