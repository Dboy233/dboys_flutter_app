import 'package:dboy_flutter_app/net/pexels/bean/photo.dart';

///精选照片请求数据体
/// page : 1
/// per_page : 1
/// photos : [{"id":2880507,"width":4000,"height":6000,"url":"https://www.pexels.com/photo/woman-in-white-long-sleeved-top-and-skirt-standing-on-field-2880507/","photographer":"Deden Dicky Ramdhani","photographer_url":"https://www.pexels.com/@drdeden88","photographer_id":1378810,"avg_color":"#7E7F7B","src":{"original":"https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg","large2x":"https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940","large":"https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&h=650&w=940","medium":"https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&h=350","small":"https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&h=130","portrait":"https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800","landscape":"https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200","tiny":"https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"},"liked":false}]
/// next_page : "https://api.pexels.com/v1/curated/?page=2&per_page=1"

class CuratedPhotos {
  CuratedPhotos({
      int? page, 
      int? perPage, 
      List<Photo> photos = const [],
      String? nextPage,}){
    _page = page;
    _perPage = perPage;
    _photos = photos;
    _nextPage = nextPage;
}

  CuratedPhotos.fromJson(dynamic json) {
    _page = json['page'];
    _perPage = json['per_page'];
    if (json['photos'] != null) {
      _photos = [];
      json['photos'].forEach((v) {
        _photos.add(Photo.fromJson(v));
      });
    }
    _nextPage = json['next_page'];
  }
  int? _page;
  int? _perPage;
  List<Photo> _photos = [];
  String? _nextPage;

  int? get page => _page;
  int? get perPage => _perPage;
  List<Photo> get photos => _photos;
  String? get nextPage => _nextPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = _page;
    map['per_page'] = _perPage;
    map['photos'] = _photos.map((v) => v.toJson()).toList();
    map['next_page'] = _nextPage;
    return map;
  }
}
