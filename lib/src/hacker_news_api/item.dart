import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

/// ITEMS
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
/// parts: A list of refinald pollopts, in display order.
/// descendants: In the case of stories or polls, the total comment count.

/* {
  "by" : "norvig",
  "id" : 2921983,
  "kids" : [ 2922097, 2922429, 2924562, 2922709, 2922573, 2922140, 2922141 ],
  "parent" : 2921506,
  "text" : "Aw shucks, guys ... you make me blush with your compliments.<p>Tell you what, Ill make a deal: I'll keep writing if you keep reading. K?",
  "time" : 1314211127,
  "type" : "comment"
} */

@JsonSerializable()
class Item extends Equatable {
  const Item({
    required this.id,
    this.deleted,
    this.type,
    this.by,
    this.time,
    this.text,
    this.dead,
    this.parent,
    this.poll,
    this.kids,
    this.url,
    this.score,
    this.title,
    this.parts,
    this.descendants,
  });

  final int id;
  final bool? deleted;
  final String? type;
  final String? by;
  final int? time;
  final String? text;
  final bool? dead;
  final int? parent;
  final int? poll;
  final List<int>? kids;
  final String? url;
  final int? score;
  final String? title;
  final int? parts;
  final int? descendants;

  // ignore: sort_constructors_first
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  @override
  List<Object?> get props => [
        id,
        deleted,
        type,
        by,
        time,
        text,
        dead,
        parent,
        poll,
        kids,
        url,
        score,
        title,
        parts,
        descendants,
      ];
}
