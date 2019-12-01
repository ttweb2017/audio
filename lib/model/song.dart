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

  String get fullVideoUrl => Karaoke.FULL_VIDEO_URL;
  String get avatarPath => Karaoke.FULL_VIDEO_URL;

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