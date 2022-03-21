import 'dart:convert';



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

/* 
{
  "by" : "dhouston",
  "descendants" : 71,
  "id" : 8863,
  "kids" : [ 8952, 9224, 8917, 8884, 8887, 8943, 8869, 8958, 9005, 9671, 8940, 9067, 8908, 9055, 8865, 8881, 8872, 8873, 8955, 10403, 8903, 8928, 9125, 8998, 8901, 8902, 8907, 8894, 8878, 8870, 8980, 8934, 8876 ],
  "score" : 111,
  "time" : 1175714200,
  "title" : "My YC app: Dropbox: Throw away your USB drive",
  "type" : "story",
  "url" : "http://www.getdropbox.com/u/2/screencast.html"
}
 */
class Story {
  late String by;
  late int descendants;
  late int id;
  late List<int> kids;
  late int score;
  late int time;
  late String title;
  late String type;
  late String url;
}

/* 
{
  "by" : "norvig",
  "id" : 2921983,
  "kids" : [ 2922097, 2922429, 2924562, 2922709, 2922573, 2922140, 2922141 ],
  "parent" : 2921506,
  "text" : "Aw shucks, guys ... you make me blush with your compliments.<p>Tell you what, Ill make a deal: I'll keep writing if you keep reading. K?",
  "time" : 1314211127,
  "type" : "comment"
}
 */
class Comment {
  late String by;
  late int id;
  late List<int> kids;
  late int parent;
  late String text;
  late int time;
  late String type;
}

/* 
{
  "by" : "tel",
  "descendants" : 16,
  "id" : 121003,
  "kids" : [ 121016, 121109, 121168 ],
  "score" : 25,
  "text" : "<i>or</i> HN: the Next Iteration<p>I get the impression that with Arc being released a lot of people who never had time for HN before are suddenly dropping in more often. (PG: what are the numbers on this? ...",
  "time" : 1203647620,
  "title" : "Ask HN: The Arc Effect",
  "type" : "story"
}
 */
class Ask {
  late String by;
  late int descendants;
  late int id;
  late List<int> kids;
  late int score;
  late String text;
  late int time;
  late String title;
  late String type;
}

/* 
{
  "by" : "justin",
  "id" : 192327,
  "score" : 6,
  "text" : "Justin.tv is the biggest live video site online. We serve hundreds of thousands of video streams a day, ...",
  "time" : 1210981217,
  "title" : "Justin.tv is looking for a Lead Flash Engineer!",
  "type" : "job",
  "url" : ""
}
 */
class Job {
  late String by;
  late int id;
  late int score;
  late String text;
  late int time;
  late String title;
  late String type;
  late String url;
}

/* 
{
  "by" : "pg",
  "descendants" : 54,
  "id" : 126809,
  "kids" : [ 126822, 126823, 126993, 126824, 126934, 127411, 126888, 127681, 126818, 126816, 126854, 127095, 126861, 127313, 127299, 126859, 126852, 126882, 126832, 127072, 127217, 126889, 127535, 126917, 126875 ],
  "parts" : [ 126810, 126811, 126812 ],
  "score" : 46,
  "text" : "",
  "time" : 1204403652,
  "title" : "Poll: What would happen if News.YC had explicit support for polls?",
  "type" : "poll"
}
 */

class Poll {
  late String by;
  late int descendants;
  late int id;
  late List<int> kids;
  late List<int> parts;
  late int score;
  late String text;
  late int time;
  late String title;
  late String type;
}

/* 
{
  "by" : "pg",
  "id" : 160705,
  "poll" : 160704,
  "score" : 335,
  "text" : "Yes, ban them; I'm tired of seeing Valleywag stories on News.YC.",
  "time" : 1207886576,
  "type" : "pollopt"
}
 */

class Pollopt {
  late String by;
  late int id;
  late int poll;
  late int score;
  late String text;
  late int time;
  late String type;
}


// -- HackerNews APIClient --

class HackerNewsURI {
  static const String base = 'https://hacker-news.firebaseio.com';
  static const String item = '/v0/item/<id>';
  static const String user = '/v0/user/';
  static const String maxitem = '/v0/maxitem';
  static const String topstories = '/v0/topstories';
  static const String newstories = '/v0/newstories';
  static const String beststories = '/v0/beststories';
  static const String askstories = '/v0/askstories';
  static const String showstories = '/v0/showstories';
  static const String jobstories = '/v0/jobstories';
  static const String updates = '/v0/updates';
}

abstract class HackerNewsClient {
  Future<Item> item(int id);
  Future<User> user();
  Future<int> maxitem();
  Future<List<int>> topstories();
  Future<List<int>> newstories();
  Future<List<int>> beststories();
  Future<List<int>> askstories();
  Future<List<int>> showstories();
  Future<List<int>> jobstories();
  Future<Future<Updates>> updates();
}

class HackerNewsClientImpl implements HackerNewsClient {
  final Client client;

  HackerNewsClientImpl(this.client);

  @override
  Future<List<int>> askstories() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.askstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<int>;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<List<int>> beststories() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.beststories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<int>;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<List<int>> jobstories() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.jobstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<int>;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<List<int>> newstories() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.newstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<int>;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<List<int>> showstories() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.showstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<int>;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<List<int>> topstories() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.topstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<int>;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<Item> item(int id)  async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.topstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<int> maxitem()  async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.topstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as int;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<Updates> updates() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.topstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return Updates.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<User> user()  async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.topstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load askstories');
    }
  }
}
