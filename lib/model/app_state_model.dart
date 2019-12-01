import 'dart:math';

import 'package:flutter/foundation.dart' as foundation;
import 'package:vplayer/model/singer_repository.dart';
import 'package:vplayer/model/song.dart';
import 'package:vplayer/model/song_repository.dart';

import 'singer.dart';

class AppStateModel extends foundation.ChangeNotifier {
  // All the available singers.
  List<Singer> _availableSingers;

  // All the available songs
  List<Song> _availableSongs;

  // The currently selected category of singers.
  Category _selectedCategory = Category.all;

  Category get selectedCategory {
    return _selectedCategory;
  }

  // The currently selected category of singers.
  Singer _selectedSinger;

  Singer get selectedSinger {
    return _selectedSinger;
  }

  // Returns a copy of the list of available singers, filtered by category.
  List<Singer> getSingers() {
    if (_availableSingers == null) {
      return [];
    }

    if (_selectedCategory == Category.all) {
      return List.from(_availableSingers);
    } else {
      return _availableSingers.where((p) {
        return p.category == _selectedCategory;
      }).toList();
    }
  }

  // Checks if songs is empty
  void checkSongs(){
    if (_availableSongs == null) {
      loadSongs();
    }
  }

  // Checks if singers is empty
  void checkSingers(){
    if (_availableSingers == null) {
      loadSingers();
    }
  }

  // Returns a copy of the list of available songs, filtered by category.
  List<Song> getSongs(){
    if (_availableSongs == null) {
      return [];
    }

    if (_selectedSinger == null) {
      return List.from(_availableSongs);
    } else {
      return _availableSongs.where((p) {
        return p.singer == _selectedSinger;
      }).toList();
    }
  }

  List<Song> getPopularSongs(){
    if (_availableSongs == null) {
      return [];
    }

    return _availableSongs.where((p) {
      int random = new Random().nextInt(_availableSongs.length * 2);

      return _availableSongs.asMap().containsKey(random);
    }).toList();
  }

  // Search the singer catalog
  List<Singer> search(String searchTerms) {
    return getSingers().where((singer) {
      return singer.name.toLowerCase().contains(searchTerms.toLowerCase());
    }).toList();
  }

  // Search the song
  List<Song> searchSong(String searchTerms) {
    return getSongs().where((song) {
      return song.name.toLowerCase().contains(searchTerms.toLowerCase())
          || song.singer.name.toLowerCase().contains(searchTerms.toLowerCase());
    }).toList();
  }

  List<Song> searchSongBySinger(Singer singer){
    return getSongs().where((song) {
      return song.singer.id == singer.id;
    }).toList();
  }
  // Returns the singer instance matching the provided id.
  Singer getSingerById(int id) {
    return _availableSingers.firstWhere((p) => p.id == id);
  }

  // Returns the song instance matching the provided id.
  Song getSongById(int id) {
    return _availableSongs.firstWhere((p) => p.id == id);
  }

  // Loads the list of available singers from the repo.
  void loadSingers() async {
    //_availableSingers = SingersRepository.loadSingers(Category.all);
    _availableSingers = await _fetchSingers();
    notifyListeners();
  }

  void loadSongs() async {
    _availableSongs = await _fetchSongs();
    notifyListeners();
  }

  void loadData(){
    // Load Singers list
    loadSingers();

    // Load Songs
    loadSongs();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }

  void setSinger(Singer newSinger) {
    _selectedSinger = newSinger;
    notifyListeners();
  }

  //Method to get singer list from server
  Future<List<Singer>> _fetchSingers() async {
    List<Singer> singerList = List<Singer>();

    singerList = SingersRepository.loadSingers(_selectedCategory);

    return singerList;
  }

  //Method to get song list from server
  Future<List<Song>> _fetchSongs() async {
    List<Song> songList = List<Song>();

    songList = SongsRepository.loadSingers(_selectedSinger);

    return songList;
  }
}