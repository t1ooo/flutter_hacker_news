// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Item',
      json,
      ($checkedConvert) {
        final val = Item(
          id: $checkedConvert('id', (v) => v as int),
          deleted: $checkedConvert('deleted', (v) => v as bool?),
          type: $checkedConvert('type', (v) => v as String?),
          by: $checkedConvert('by', (v) => v as String?),
          time: $checkedConvert('time', (v) => v as int?),
          text: $checkedConvert('text', (v) => v as String?),
          dead: $checkedConvert('dead', (v) => v as bool?),
          parent: $checkedConvert('parent', (v) => v as int?),
          poll: $checkedConvert('poll', (v) => v as int?),
          kids: $checkedConvert('kids',
              (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
          url: $checkedConvert('url', (v) => v as String?),
          score: $checkedConvert('score', (v) => v as int?),
          title: $checkedConvert('title', (v) => v as String?),
          parts: $checkedConvert('parts', (v) => v as int?),
          descendants: $checkedConvert('descendants', (v) => v as int?),
        );
        return val;
      },
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'deleted': instance.deleted,
      'type': instance.type,
      'by': instance.by,
      'time': instance.time,
      'text': instance.text,
      'dead': instance.dead,
      'parent': instance.parent,
      'poll': instance.poll,
      'kids': instance.kids,
      'url': instance.url,
      'score': instance.score,
      'title': instance.title,
      'parts': instance.parts,
      'descendants': instance.descendants,
    };
