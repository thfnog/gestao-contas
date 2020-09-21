// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dartlang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DartLang _$DartLangFromJson(Map<String, dynamic> json) {
  return DartLang(
    name: json['name'] as String,
//    version: json['version'] == null ? null : Version.fromJson(json['version'] as  Map<String, dynamic>),
    message: json['message'] as String
  );
}

Map<String, dynamic> _$DartLangToJson(DartLang instance) => <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
      'message': instance.message,
    };
