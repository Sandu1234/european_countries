import 'package:json_annotation/json_annotation.dart';

part 'country_model.g.dart'; // This is the generated file

@JsonSerializable()
class CountryModel {
  final Name name;
  final List<String> capital;
  final Flags flags;
  final String region;
  final Map<String, String> languages;
  final int population;

  CountryModel({
    required this.name,
    required this.capital,
    required this.flags,
    required this.region,
    required this.languages,
    required this.population,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Map<String, dynamic> toJson() => {
        'name': name.toJson(), // Explicitly call toJson() on Name
        'capital': capital,
        'flags': flags.toJson(), // Explicitly call toJson() on Flags
        'region': region,
        'languages': languages,
        'population': population,
      };
}

@JsonSerializable()
class Name {
  final String common;
  final String official;

  Name({required this.common, required this.official});

  factory Name.fromJson(Map<String, dynamic> json) =>
      _$NameFromJson(json); // This is a generated method
  Map<String, dynamic> toJson() =>
      _$NameToJson(this); // This is a generated method
}

@JsonSerializable()
class Flags {
  final String png;
  final String svg;
  final String? alt;

  Flags({required this.png, required this.svg, this.alt});

  factory Flags.fromJson(Map<String, dynamic> json) =>
      _$FlagsFromJson(json); // This is a generated method
  Map<String, dynamic> toJson() =>
      _$FlagsToJson(this); // This is a generated method
}
