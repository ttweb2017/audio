import 'package:flutter/foundation.dart';
import 'package:vplayer/Karaoke.dart';
import 'package:vplayer/model/singer.dart';

class Song {
  const Song({
    @required this.singer,
    @required this.id,
    @required this.avatar,
    @required this.name,
    @required this.video,
  })  : assert(singer != null),
        assert(id != null),
        assert(name != null),
        assert(avatar != null);

  final int id;
  final Singer singer;
  final String avatar;
  final String name;
  final String video;

  String get fullFakeVideoUrl => Karaoke.FULL_FAKE_VIDEO_URL;
  String get fullVideoUrl => Karaoke.VIDEO_PATH + '/$video';
  String get partiallyVideo => Karaoke.PARTLY_VIDEO_URL + "/" + video;
  String get fullStreamVideo => Karaoke.FULL_VIDEO_URL + "/" + video;
  String get avatarPath => Karaoke.SONG_LOCAL_AVATAR_PATH;
  String get avatarUrl => Karaoke.SONG_AVATAR_PATH + "/" + avatar;
  String get avatarPackage => Karaoke.SONG_AVATAR_PACKAGE;

  @override
  String toString() => '$name (id=$id)';

  factory Song.fromJson(Map<String, dynamic> json) {

    return Song(
      singer: Singer.fromJson(json['singer']),
      id: json['id'],
      avatar: json['image'],
      name: json['name'],
      video: json['video']
    );
  }
}