// --- ITEMS ---
/// id: The item's unique id.
/// deleted: true if the item is deleted.
/// type: The type of item. One of "job", "story", "comment", "poll", or "pollopt".
/// by: The username of the item's author.
/// time: Creation date of the item, in Unix Time.
/// text: The comment, story or poll text. HTML.
/// dead: true if the item is dead.
/// parent: The comment's parent: either another comment or the relevant story.
/// poll: The pollopt's associated poll.
/// kids: The ids of the item's comments, in ranked display order.
/// url: The URL of the story.
/// score: The story's score, or the votes for a pollopt.
/// title: The title of the story, poll or job. HTML.
/// parts: A list of related pollopts, in display order.
/// descendants: In the case of stories or polls, the total comment count.

class Item {
  late int id;
  bool? deleted;
  String? type;
  String? by;
  int? time;
  String? text;
  bool? dead;
  int? parent;
  int? poll;
  int? kids;
  String? url;
  int? score;
  String? title;
  int? parts;
  int? descendants;
}
