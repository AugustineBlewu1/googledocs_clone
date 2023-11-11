// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ErrorModel {
  final dynamic data;
  final dynamic code;

  ErrorModel({
    required this.data,
    required this.code,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      data: json['data'],
      code: json['code'],
    );
  }

  ErrorModel copyWith({
    dynamic data,
    dynamic code,
  }) {
    return ErrorModel(
      data: data ?? this.data,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data,
      'code': code,
    };
  }

  factory ErrorModel.fromMap(Map<String, dynamic> map) {
    return ErrorModel(
      data: map['data'] as dynamic,
      code: map['code'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'ErrorModel(data: $data, code: $code)';

  @override
  bool operator ==(covariant ErrorModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.data == data &&
      other.code == code;
  }

  @override
  int get hashCode => data.hashCode ^ code.hashCode;
}
