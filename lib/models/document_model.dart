// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class DocumentModel {
  final String title;
  final String uid;
  final List content;
  final DateTime createdAt;
  final String? id;
  DocumentModel({
    required this.title,
    required this.uid,
    required this.content,
    required this.createdAt,
    this.id,
  });

  DocumentModel copyWith({
    String? title,
    String? uid,
    List? content,
    DateTime? createdAt,
    String? id,
  }) {
    return DocumentModel(
      title: title ?? this.title,
      uid: uid ?? this.uid,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'uid': uid,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'id': id,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      title: map['title'] ?? '',
      uid: map['uid'] ?? '',
      content: List.from((map['content'] ?? [])),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      id: map['_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) => DocumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DocumentModel(title: $title, uid: $uid, content: $content, createdAt: $createdAt, id: $id)';
  }

  @override
  bool operator ==(covariant DocumentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.uid == uid &&
      listEquals(other.content, content) &&
      other.createdAt == createdAt &&
      other.id == id;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      uid.hashCode ^
      content.hashCode ^
      createdAt.hashCode ^
      id.hashCode;
  }
}
