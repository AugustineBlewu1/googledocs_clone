import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googledocs_clone/constant.dart';
import 'package:googledocs_clone/models/error_model.dart';
import 'package:googledocs_clone/models/user_model.dart';
import 'package:googledocs_clone/repository/local_storage.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository()));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorageRepository localStorageRepository})
      : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel err =
        ErrorModel(data: 'Some unexpected error occured', code: null);

    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName ?? '',
          profilePic: user.photoUrl ?? '',
          uid: '',
          token: '',
        );

        final response = await _client.post(
          Uri.parse('$host/api/signup'),
          body: userAcc.toJson(),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        );

        switch (response.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
                uid: json.decode(response.body)['user']['_id'],
                token: json.decode(response.body)['token']);
            err = ErrorModel(data: newUser, code: null);
            _localStorageRepository.setToken(newUser.token!);
            break;

          default:
        }
      }
    } catch (e) {
      err = ErrorModel(data: e.toString(), code: 400);
    }

    return err;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel err =
        ErrorModel(data: 'Some unexpected error occured', code: null);

    try {
      String? token = await _localStorageRepository.getToken();
      if (token != null) {
        final response = await _client.get(
          Uri.parse('$host/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            "x-auth-token": token
          },
        );
        switch (response.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(jsonEncode(
              jsonDecode(response.body)['user'],
            )).copyWith(
              token: token,
            );
            err = ErrorModel(data: newUser, code: 200);
            _localStorageRepository.setToken(newUser.token!);
            break;
          default:
        }
      }
    } catch (e) {
      err = ErrorModel(data: e.toString(), code: 400);
    }

    return err;
  }

    signOut() async{
    await _googleSignIn.signOut();
    _localStorageRepository.setToken('');
   

  }
}
