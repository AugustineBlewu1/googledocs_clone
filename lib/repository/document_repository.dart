import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googledocs_clone/common/widgets/logger.dart';
import 'package:googledocs_clone/models/document_model.dart';
import 'package:googledocs_clone/models/error_model.dart';
import 'package:http/http.dart';

import '../constant.dart';

final documentRepositoryProvider = Provider((ref) => DocumentRepository(
      client: Client(),
    ));

class DocumentRepository {
  final Client _client;

  DocumentRepository({required Client client}) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel err =
        ErrorModel(data: 'Some unexpected error occured', code: null);

    try {
      var response = await _client.post(Uri.parse('$host/document/create'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
          body: jsonEncode({
            'createdAt': DateTime.now().microsecondsSinceEpoch,
          }));

      switch (response.statusCode) {
        case 200:
          err = ErrorModel(
              data: DocumentModel.fromJson(response.body), code: null);
          break;
        default:
          err = ErrorModel(data: response.body, code: response.statusCode);
      }
    } catch (e) {
      err = ErrorModel(data: e.toString(), code: 400);
    }
    return err;
  }
  Future<ErrorModel> updateTitle({String? token, String? id, String? title}) async {
    ErrorModel err =
        ErrorModel(data: 'Some unexpected error occured', code: null);

    try {
      var response = await _client.post(Uri.parse('$host/document/title'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!,

          },
          body: jsonEncode({
            'title': title,
            'id': id,
          }));

      switch (response.statusCode) {
        case 200:
          err = ErrorModel(
              data: DocumentModel.fromJson(response.body), code: null);
          break;
        default:
          err = ErrorModel(data: response.body, code: response.statusCode);
      }
    } catch (e) {
      err = ErrorModel(data: e.toString(), code: 400);
    }
    return err;
  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel err =
        ErrorModel(data: 'Some unexpected error occured', code: null);

    try {
      final response = await _client.get(
        Uri.parse("$host/document/me"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );

      switch (response.statusCode) {
        case 200:
          List<DocumentModel> documents = [];

          var docum = jsonDecode(response.body);

          for (var i = 0; i < docum.length; i++) {
            logger.e(docum[i]);
            documents.add(DocumentModel.fromMap(docum[i]));
          }

          logger.v(docum);
          err = ErrorModel(data: documents, code: null);
          break;
        default:
          err = ErrorModel(data: response.body, code: response.statusCode);
      }
    } catch (e) {
      err = ErrorModel(data: e.toString(), code: 400);
    }
    return err;
  }



  
  Future<ErrorModel> getDocumentById({String? token, String? id}) async {
    ErrorModel err =
        ErrorModel(data: 'Some unexpected error occured', code: null);

    try {
      final response = await _client.get(
        Uri.parse("$host/document/$id"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      switch (response.statusCode) {
        case 200:
          DocumentModel document = DocumentModel.fromMap(jsonDecode(response.body));
          err = ErrorModel(data: document, code: null);
          break;
        default:
          throw Exception('This document does not exist, Please create a new document');
      }
    } catch (e) {
      err = ErrorModel(data: e.toString(), code: 400);
    }
    return err;
  }
}
