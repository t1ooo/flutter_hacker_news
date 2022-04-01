import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

// --- USERS ---
/// id: The user's unique username. Case-sensitive. Required.
/// created: Creation date of the user, in Unix Time.
/// karma: The user's karma.
/// about: The user's optional self-description. HTML.
/// submitted: List of the user's stories, polls and comments.

@JsonSerializable()
class User extends Equatable {
  const User({
    required this.id,
    required this.created,
    required this.karma,
    this.about,
    this.submitted,
  });

  final String id;
  final int created;
  final int karma;
  final String? about;
  final List<int>? submitted;

  // ignore: sort_constructors_first
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [
        id,
        created,
        karma,
        about,
        submitted,
      ];
}
