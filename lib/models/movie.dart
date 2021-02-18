class Movie {
  int _id;
  String _movieName;
  String _description;
  String _urlName;
  //int _ind;
  String _image;
  //dynamic _data2;
  String _imdb,
      _year,
      _quality,
      _size,
      _country,
      _language,
      _altdown,
      _t720p,
      _t1080p;

  Movie(
      this._movieName,
      this._description,
      this._urlName,
      this._imdb,
      this._year,
      this._image,
      this._t1080p,
      this._t720p,
      this._country,
      this._quality,
      this._language,
      this._size,
      this._altdown);

  Movie.map(dynamic obj) {
    this._id = obj['id'];
    this._movieName = obj['movieName'];
    this._description = obj['description'];
    this._altdown = obj['altdown'];
    this._size = obj['size'];
    this._language = obj['language'];
    this._quality = obj['quality'];
    this._country = obj['country'];
    this._t720p = obj['t720p'];
    this._t1080p = obj['t1080p'];
    this._image = obj['image'];
    this._imdb = obj['imdb'];
    //this._data2 = obj['data2'];
    this._year = obj['year'];
    this._urlName = obj['urlName'];
    //this._ind = obj['ind'];
  }

  int get id => _id;
  String get movieName => _movieName;
  String get description => _description;
  String get urlName => _urlName;
  //int get ind => _ind;
  String get image => _image;
  //dynamic get data2 async => _data2;
  String get imdb => _imdb;
  String get year => _year;
  String get quality => _quality;
  String get size => _size;
  String get country => _country;
  String get language => _language;
  String get altdown => _altdown;
  String get t720 => _t720p;
  String get t1080 => _t1080p;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['movieName'] = _movieName;
    map['description'] = _description;
    map['altdown'] = _altdown;
    map['size'] = _size;
    map['language'] = _language;
    map['quality'] = _quality;
    map['country'] = _country;
    map['t720p'] = _t720p;
    map['t1080p'] = _t1080p;
    map['image'] = _image;
    map['imdb'] = _imdb;
    //map['data2'] = _data2;
    map['year'] = _year;
    map['urlName'] = _urlName;
    //map['ind'] = _ind;
    return map;
  }

  Movie.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._movieName = map['movieName'];
    this._description = map['description'];
    this._altdown = map['altdown'];
    this._size = map['size'];
    this._language = map['language'];
    this._quality = map['quality'];
    this._country = map['country'];
    this._t720p = map['t720p'];
    this._t1080p = map['t1080p'];
    this._image = map['image'];
    this._imdb = map['imdb'];
    //this._data2 = map['data2'];
    this._year = map['year'];
    this._urlName = map['urlName'];
    //this._ind = map['ind'];
  }
}
