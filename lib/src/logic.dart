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
  late bool deleted;
  late String type;
  late String by;
  late int time;
  late String text;
  late bool dead;
  late int parent;
  late int poll;
  late int kids;
  late String url;
  late int score;
  late String title;
  late int parts;
  late int descendants;
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

// --- USERS ---
/// id: The user's unique username. Case-sensitive. Required.
/// created: Creation date of the user, in Unix Time.
/// karma: The user's karma.
/// about: The user's optional self-description. HTML.
/// submitted: List of the user's stories, polls and comments.
class User {
  late String about;
  late int created;
  late int delay;
  late String id;
  late int karma;
  late List<int> submitted;
}

/* 
{
  "items" : [ 8423305, 8420805, 8423379, 8422504, 8423178, 8423336, 8422717, 8417484, 8423378, 8423238, 8423353, 8422395, 8423072, 8423044, 8423344, 8423374, 8423015, 8422428, 8423377, 8420444, 8423300, 8422633, 8422599, 8422408, 8422928, 8394339, 8421900, 8420902, 8422087 ],
  "profiles" : [ "thefox", "mdda", "plinkplonk", "GBond", "rqebmm", "neom", "arram", "mcmancini", "metachris", "DubiousPusher", "dochtman", "kstrauser", "biren34", "foobarqux", "mkehrt", "nathanm412", "wmblaettler", "JoeAnzalone", "rcconf", "johndbritton", "msie", "cktsai", "27182818284", "kevinskii", "wildwood", "mcherm", "naiyt", "matthewmcg", "joelhaus", "tshtf", "MrZongle2", "Bogdanp" ]
}
 */
class Updates {
  late List<int> items;
  late List<String> profiles;
}

// -- HackerNews APIClient --

class HackerNewsEndpoint {
  static const String item = '/v0/item/<id>';
  static const String user = '/v0/user/';
  static const String maxitem = '/v0/maxitem';
  static const String topstorie = '/v0/topstorie';
  static const String newstories = '/v0/newstories';
  static const String beststories = '/v0/beststories';
  static const String askstories = '/v0/askstories';
  static const String showstories = '/v0/showstories';
  static const String jobstories = '/v0/jobstories';
  static const String updates = '/v0/updates';
}

abstract class HackerNewsClient {
  // /v0/item/<id>
  Future<Item> item(int id);

  // /v0/user/
  Future<User> user();

  // /v0/maxitem
  Future<int> maxitem();

  // /v0/topstorie
  Future<List<int>> topstorie();

  // /v0/newstories
  Future<List<int>> newstories();

  // /v0/beststories
  Future<List<int>> beststories();

  // /v0/askstories
  Future<List<int>> askstories();

  // /v0/showstories
  Future<List<int>> showstories();

  // /v0/jobstories
  Future<List<int>> jobstories();

  // /v0/updates
  Future<Future<Updates>> updates();
}
