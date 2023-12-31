import 'package:json_annotation/json_annotation.dart';

part 'updates.g.dart';

/* 
{
  "items" : [ 8423305, 8420805, 8423379, 8422504, 8423178, 8423336, 8422717, 8417484, 8423378, 8423238, 8423353, 8422395, 8423072, 8423044, 8423344, 8423374, 8423015, 8422428, 8423377, 8420444, 8423300, 8422633, 8422599, 8422408, 8422928, 8394339, 8421900, 8420902, 8422087 ],
  "profiles" : [ "thefox", "mdda", "plinkplonk", "GBond", "rqebmm", "neom", "arram", "mcmancini", "metachris", "DubiousPusher", "dochtman", "kstrauser", "biren34", "foobarqux", "mkehrt", "nathanm412", "wmblaettler", "JoeAnzalone", "rcconf", "johndbritton", "msie", "cktsai", "27182818284", "kevinskii", "wildwood", "mcherm", "naiyt", "matthewmcg", "joelhaus", "tshtf", "MrZongle2", "Bogdanp" ]
}
 */

@JsonSerializable()
class Updates {
  Updates({
    required this.items,
    required this.profiles,
  });

  final List<int> items;
  final List<String> profiles;

  // ignore: sort_constructors_first
  factory Updates.fromJson(Map<String, dynamic> json) =>
      _$UpdatesFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatesToJson(this);
}
