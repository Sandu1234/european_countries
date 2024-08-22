import 'package:json_annotation/json_annotation.dart';

part 'country_model.g.dart'; // This is the generated file

@JsonSerializable()
class CountryModel {
  final Name name;
  final List<String> capital;
  final Flags flags;
  final String region;
  final Map<String, String>? languages; // Nullable field
  final int population;

  CountryModel({
    required this.name,
    required this.capital,
    required this.flags,
    required this.region,
    this.languages, // Nullable field
    required this.population,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryModelToJson(this);
}

@JsonSerializable()
class Name {
  final String common;
  final String? official; // Nullable field

  Name({required this.common, this.official}); // Nullable field

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);

  Map<String, dynamic> toJson() => _$NameToJson(this);
}

@JsonSerializable()
class Flags {
  final String png;
  final String svg;
  final String? alt;

  Flags({required this.png, required this.svg, this.alt});

  factory Flags.fromJson(Map<String, dynamic> json) => _$FlagsFromJson(json);

  Map<String, dynamic> toJson() => _$FlagsToJson(this);
}
