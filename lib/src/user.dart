// --- USERS ---
/// id: The user's unique username. Case-sensitive. Required.
/// created: Creation date of the user, in Unix Time.
/// karma: The user's karma.
/// about: The user's optional self-description. HTML.
/// submitted: List of the user's stories, polls and comments.
class User {
  late String id;
  late int created;
  late int karma;
  String? about;
  int? delay;
  List<int>? submitted;
}
