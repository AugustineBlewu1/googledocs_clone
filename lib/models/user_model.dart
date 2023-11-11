// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? email;
  String? name;
  String? profilePic;
  String? uid;
  String? token;
  UserModel({
    this.email,
    this.name,
    this.profilePic,
    this.uid,
    this.token,
  });

  UserModel copyWith({
    String? email,
    String? name,
    String? profilePic,
    String? uid,
    String? token,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] != null ? map['email'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      profilePic: map['profilePic'] != null ? map['profilePic'] as String : null,
      uid: map['_id'] != null ? map['_id'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, profilePic: $profilePic, uid: $uid, token: $token)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.name == name &&
      other.profilePic == profilePic &&
      other.uid == uid &&
      other.token == token;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      name.hashCode ^
      profilePic.hashCode ^
      uid.hashCode ^
      token.hashCode;
  }
}
