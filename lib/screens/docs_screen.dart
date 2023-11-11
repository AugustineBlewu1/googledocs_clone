import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:googledocs_clone/colors.dart';
import 'package:googledocs_clone/common/widgets/logger.dart';
import 'package:googledocs_clone/models/document_model.dart';
import 'package:googledocs_clone/models/error_model.dart';
import 'package:googledocs_clone/repository/auth_repository.dart';
import 'package:googledocs_clone/repository/socket_repository.dart';

import '../repository/document_repository.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String? id;
  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController controllertitle =
      TextEditingController(text: 'Untitled Document');
  quill.QuillController? _controller;
  ErrorModel? err;
  SocketRepository socketRepository = SocketRepository();

  void updateTitle(
    WidgetRef ref,
    String title,
  ) async {
    var snackbar = ScaffoldMessenger.of(context);
    final result = await ref.read(documentRepositoryProvider).updateTitle(
        token: ref.read(userProvider)?.token, id: widget.id, title: title);
    logger.e(result.toJson());
    if (result.code != null) {
      snackbar.showSnackBar(SnackBar(
        content: Text(result.data),
      ));
    }
  }

  fetchDocumentData() async {
    err = await ref
        .read(documentRepositoryProvider)
        .getDocumentById(token: ref.read(userProvider)?.token, id: widget.id);

    if (err?.data != null) {
      controllertitle.text = (err?.data as DocumentModel).title;
      _controller = quill.QuillController(
        document: err!.data.content.isEmpty
            ? quill.Document()
            : quill.Document.fromDelta(quill.Delta.fromJson(err!.data.content)),
        selection: const TextSelection.collapsed(offset: 0),
      );
      setState(() {});
    }

    _controller?.document.changes.listen((change) {
      if (change.item3 == quill.ChangeSource.LOCAL) {
        Map<String, dynamic> map = {'delta': change.item2, 'room': widget.id};
        socketRepository.typing(map);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    socketRepository.joinRoom(widget.id!);
    fetchDocumentData();

    socketRepository.changeListener((data) {
      _controller?.compose(
          quill.Delta.fromJson(data['delta']),
          _controller?.selection ?? const TextSelection.collapsed(offset: 0),
          quill.ChangeSource.REMOTE);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: kGreyColor,
                    width: 0.1,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: kwhiteColor,
          elevation: 0,
          actions: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.lock,
                      size: 16,
                      color: kwhiteColor,
                    ),
                    label: const Text('Share'),
                    style: ElevatedButton.styleFrom(
                      primary: kblueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )))
          ],
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/docs-logo.png",
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                      controller: controllertitle,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kblueColor, width: 2),
                          // borderRadius: BorderRadius.circular(10),
                        ),
                        hintStyle: TextStyle(
                          color: kblackCOlor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) => updateTitle(ref, value),
                      onEditingComplete: () =>
                          updateTitle(ref, controllertitle.text)),
                )
              ],
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              quill.QuillToolbar.basic(controller: _controller!),
              Expanded(
                child: SizedBox(
                  width: 759,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: quill.QuillEditor.basic(
                        controller: _controller!,
                        readOnly: false, // true for view only mode
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    controllertitle.dispose();
    super.dispose();
  }
}
