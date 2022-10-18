/// id : "8xntbhr"
/// title : "Hello Spring"
/// description : "Baby chicks, rabbits & pretty flowers. What's not to love?"
/// private : false
/// media_count : 130
/// photos_count : 121
/// videos_count : 9
///收藏条目数据信息
class CollectionInfo {
  CollectionInfo({
    String? id,
    String? title,
    String? description,
    bool? private,
    int? mediaCount,
    int? photosCount,
    int? videosCount,
  }) {
    _id = id;
    _title = title;
    _description = description;
    _private = private;
    _mediaCount = mediaCount;
    _photosCount = photosCount;
    _videosCount = videosCount;
  }

  CollectionInfo.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    _private = json['private'];
    _mediaCount = json['media_count'];
    _photosCount = json['photos_count'];
    _videosCount = json['videos_count'];
  }

  String? _id;
  String? _title;
  String? _description;
  bool? _private;
  int? _mediaCount;
  int? _photosCount;
  int? _videosCount;

  String? get id => _id;

  String? get title => _title;

  String? get description => _description == null
      ? null
      : _description!.trim().isEmpty
          ? null
          : _description;

  bool? get private => _private;

  int? get mediaCount => _mediaCount;

  int? get photosCount => _photosCount;

  int? get videosCount => _videosCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['private'] = _private;
    map['media_count'] = _mediaCount;
    map['photos_count'] = _photosCount;
    map['videos_count'] = _videosCount;
    return map;
  }
}
