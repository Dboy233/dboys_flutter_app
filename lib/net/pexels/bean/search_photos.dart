
import 'package:dboy_flutter_app/net/pexels/bean/photo.dart';

/// total_results : 10000
/// page : 1
/// per_page : 1
/// photos : []
/// next_page : "https://api.pexels.com/v1/search/?page=2&per_page=1&query=nature"

class SearchPhotos {
  SearchPhotos({
      int? totalResults, 
      int? page, 
      int? perPage, 
      List<Photo>? photos,
      String? nextPage,}){
    _totalResults = totalResults;
    _page = page;
    _perPage = perPage;
    _photos = photos;
    _nextPage = nextPage;
}

  SearchPhotos.fromJson(dynamic json) {
    _totalResults = json['total_results'];
    _page = json['page'];
    _perPage = json['per_page'];
    if (json['photos'] != null) {
      _photos = [];
      json['photos'].forEach((v) {
        _photos?.add(Photo.fromJson(v));
      });
    }
    _nextPage = json['next_page'];
  }
  int? _totalResults;
  int? _page;
  int? _perPage;
  List<Photo>? _photos;
  String? _nextPage;

  int? get totalResults => _totalResults;
  int? get page => _page;
  int? get perPage => _perPage;
  List<Photo>? get photos => _photos;
  String? get nextPage => _nextPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_results'] = _totalResults;
    map['page'] = _page;
    map['per_page'] = _perPage;
    if (_photos != null) {
      map['photos'] = _photos?.map((v) => v.toJson()).toList();
    }
    map['next_page'] = _nextPage;
    return map;
  }

}