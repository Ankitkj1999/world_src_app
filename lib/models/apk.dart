class Apk {
  int _id;
  String _apkName;
  String _description;
  String _dUrl;
  String _developer;
  String _image2,
      _icon,
      _version,
      _downloads,
      _graphicImage,
      _fileSize,
      _image1;

  Apk(
      this._apkName,
      this._description,
      this._dUrl,
      this._image2,
      this._icon,
      this._developer,
      this._graphicImage,
      this._version,
      this._fileSize,
      this._downloads,
      this._image1);

  Apk.map(dynamic obj) {
    this._id = obj['id'];
    this._apkName = obj['apkName'];
    this._description = obj['description'];
    this._image1 = obj['image1'];
    this._downloads = obj['downloads'];
    this._fileSize = obj['fileSize'];
    this._version = obj['version'];
    this._graphicImage = obj['graphicImage'];
    this._developer = obj['developer'];
    this._image2 = obj['image2'];
    this._icon = obj['icon'];
    this._dUrl = obj['dUrl'];
  }

  int get id => _id;
  String get apkName => _apkName;
  String get description => _description;
  String get dUrl => _dUrl;
  String get developer => _developer;
  String get image2 => _image2;
  String get icon => _icon;
  String get version => _version;
  String get downloads => _downloads;
  String get graphicImage => _graphicImage;
  String get fileSize => _fileSize;
  String get image1 => _image1;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['apkName'] = _apkName;
    map['description'] = _description;
    map['image1'] = _image1;
    map['downloads'] = _downloads;
    map['fileSize'] = _fileSize;
    map['version'] = _version;
    map['graphicImage'] = _graphicImage;
    map['developer'] = _developer;
    map['image2'] = _image2;
    map['icon'] = _icon;
    map['dUrl'] = _dUrl;
    return map;
  }

  Apk.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._apkName = map['apkName'];
    this._description = map['description'];
    this._image1 = map['image1'];
    this._downloads = map['downloads'];
    this._fileSize = map['fileSize'];
    this._version = map['version'];
    this._graphicImage = map['graphicImage'];
    this._developer = map['developer'];
    this._image2 = map['image2'];
    this._icon = map['icon'];
    this._dUrl = map['dUrl'];
  }
}
