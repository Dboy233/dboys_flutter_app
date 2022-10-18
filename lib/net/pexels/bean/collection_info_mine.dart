
import 'collection_info.dart';

/// collections : []
/// page : 2
/// per_page : 1
/// total_results : 5
/// next_page : "https://api.pexels.com/v1/collections/?page=3&per_page=1"
/// prev_page : "https://api.pexels.com/v1/collections/?page=1&per_page=1"
///我的搜藏列表
class CollectionInfoMine {
  CollectionInfoMine({
      List<CollectionInfo>? collections,
      int? page, 
      int? perPage, 
      int? totalResults, 
      String? nextPage, 
      String? prevPage,}){
    _collections = collections;
    _page = page;
    _perPage = perPage;
    _totalResults = totalResults;
    _nextPage = nextPage;
    _prevPage = prevPage;
}

  CollectionInfoMine.fromJson(dynamic json) {
    if (json['collections'] != null) {
      _collections = [];
      json['collections'].forEach((v) {
        _collections?.add(CollectionInfo.fromJson(v));
      });
    }
    _page = json['page'];
    _perPage = json['per_page'];
    _totalResults = json['total_results'];
    _nextPage = json['next_page'];
    _prevPage = json['prev_page'];
  }
  List<CollectionInfo>? _collections;
  int? _page;
  int? _perPage;
  int? _totalResults;
  String? _nextPage;
  String? _prevPage;

  List<CollectionInfo>? get collections => _collections;
  int? get page => _page;
  int? get perPage => _perPage;
  int? get totalResults => _totalResults;
  String? get nextPage => _nextPage;
  String? get prevPage => _prevPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_collections != null) {
      map['collections'] = _collections?.map((v) => v.toJson()).toList();
    }
    map['page'] = _page;
    map['per_page'] = _perPage;
    map['total_results'] = _totalResults;
    map['next_page'] = _nextPage;
    map['prev_page'] = _prevPage;
    return map;
  }

}