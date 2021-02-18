class Music {
  int _id;
  String _musicName;
  String _songLyrics;
  String _mp3Download;
  String _image;
  String _artistName, _year, _altdown;

  Music(this._musicName, this._songLyrics, this._mp3Download, this._artistName,
      this._year, this._image, this._altdown);

  Music.map(dynamic obj) {
    this._id = obj['id'];
    this._musicName = obj['musicName'];
    this._songLyrics = obj['songLyrics'];
    this._altdown = obj['altdown'];
    this._image = obj['image'];
    this._artistName = obj['artistName'];
    //this._data2 = obj['data2'];
    this._year = obj['year'];
    this._mp3Download = obj['mp3Download'];
    //this._ind = obj['ind'];
  }

  int get id => _id;
  String get musicName => _musicName;
  String get songLyrics => _songLyrics;
  String get mp3Download => _mp3Download;
  //int get ind => _ind;
  String get image => _image;
  //dynamic get data2 async => _data2;
  String get altdown => _altdown;
  String get artistName => _artistName;
  String get year => _year;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['musicName'] = _musicName;
    map['songLyrics'] = _songLyrics;
    map['altdown'] = _altdown;
    map['image'] = _image;
    map['artistName'] = _artistName;
    //map['data2'] = _data2;
    map['year'] = _year;
    map['mp3Download'] = _mp3Download;
    //map['ind'] = _ind;
    return map;
  }

  Music.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._musicName = map['musicName'];
    this._songLyrics = map['songLyrics'];
    this._altdown = map['altdown'];
    this._image = map['image'];
    this._artistName = map['artistName'];
    this._year = map['year'];
    this._mp3Download = map['mp3Download'];
  }
}
