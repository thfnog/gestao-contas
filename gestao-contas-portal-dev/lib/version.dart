import 'package:json_annotation/json_annotation.dart';
import 'package:reflected_mustache/mustache.dart';

//part 'version.g.dart';

@mustache
@JsonSerializable()
class Version {
  int major;
  int minor;

  Version({this.major, this.minor});
//
//  factory Version.fromJson(Map<String, dynamic> json) => _$VersionFromJson(json);
//
//  Map<String, dynamic> toJson() => _$VersionToJson(this);
}