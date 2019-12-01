import 'package:vplayer/model/singer.dart';
import 'package:vplayer/model/song.dart';

class SongsRepository {
  static List<Song> loadSingers(Singer singer) {
    Singer singer = new Singer(category: Category.all, id: 1, firstName: "Ed", lastName: "Sheeran", avatar: "");
    List<Song> allSingers = <Song>[
      Song(
          id: 1,
          video: "",
          avatar: "",
          name: "",
          singer: singer
      ),
      Song(
          id: 2,
          video: "",
          avatar: "",
          name: "",
          singer: singer
      ),
      Song(
          id: 3,
          video: "",
          avatar: "",
          name: "",
          singer: singer
      )
    ];

    if (singer == null) {
      return allSingers;
    } else {
      return allSingers.where((p) => p.singer == singer).toList();
    }
  }
}