import 'singer.dart';

class SingersRepository {

  static List<Singer> loadSingers(Category category) {
    List<Singer> _allSingers = <Singer>[
      Singer(
        category: Category.all,
        id: 1,
        firstName: "Ed",
        lastName: "Sheeran",
        name: "Ed Sheeran",
        avatar: "karaoke_icon.png"
      ),
      Singer(
          category: Category.all,
          id: 1,
          firstName: "Ed",
          lastName: "Sheeran",
          name: "Ed Sheeran",
          avatar: "karaoke_icon.png"
      ),
      Singer(
          category: Category.all,
          id: 1,
          firstName: "Ed",
          lastName: "Sheeran",
          name: "Ed Sheeran",
          avatar: "karaoke_icon.png"
      )
    ];

    if (category == Category.all) {
      return _allSingers;
    } else {
      return _allSingers.where((p) => p.category == category).toList();
    }
  }
}