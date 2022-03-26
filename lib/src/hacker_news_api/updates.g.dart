// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Updates _$UpdatesFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Updates',
      json,
      ($checkedConvert) {
        final val = Updates(
          items: $checkedConvert('items',
              (v) => (v as List<dynamic>).map((e) => e as int).toList()),
          profiles: $checkedConvert('profiles',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdatesToJson(Updates instance) => <String, dynamic>{
      'items': instance.items,
      'profiles': instance.profiles,
    };
