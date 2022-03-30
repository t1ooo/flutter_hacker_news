// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => $checkedCreate(
      'User',
      json,
      ($checkedConvert) {
        final val = User(
          id: $checkedConvert('id', (v) => v as String),
          created: $checkedConvert('created', (v) => v as int),
          karma: $checkedConvert('karma', (v) => v as int),
          about: $checkedConvert('about', (v) => v as String?),
          submitted: $checkedConvert('submitted',
              (v) => (v as List<dynamic>?)?.map((e) => e as int).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'created': instance.created,
      'karma': instance.karma,
      'about': instance.about,
      'submitted': instance.submitted,
    };
