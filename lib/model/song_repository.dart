import 'package:vplayer/model/singer.dart';
import 'package:vplayer/model/song.dart';

class SongsRepository {
  static List<Song> loadSingers(Singer singer) {
    Singer singer = new Singer(category: Category.all, id: 1, firstName: "Ed", lastName: "Sheeran", avatar: "karaoke_icon.png");
    List<Song> allSingers = <Song>[
      Song(
          id: 1,
          video: "http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",
          avatar: "karaoke_icon.png",
          name: "Song 1",
          singer: singer
      ),
      Song(
          id: 2,
          video: "http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",
          avatar: "karaoke_icon.png",
          name: "Song 2",
          singer: singer
      ),
      Song(
          id: 3,
          video: "http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",
          avatar: "karaoke_icon.png",
          name: "Song 3",
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