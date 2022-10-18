
import 'package:dboy_flutter_app/net/pexels/bean/photo.dart';

import 'media.dart';

/// page : 1
/// per_page : 10
/// media : [{"type":"Phone"}]
/// total_results : 8
/// id : "pjx5sdv"

class CollectionContentsInfo {
  CollectionContentsInfo({
    int? page,
    int? perPage,
    List<Media>? media,
    int? totalResults,
    String? id,
  }) {
    _page = page;
    _perPage = perPage;
    _media = media;
    _totalResults = totalResults;
    _id = id;
  }

  CollectionContentsInfo.fromJson(dynamic json) {
    _page = json['page'];
    _perPage = json['per_page'];
    if (json['media'] != null) {
      _media = [];
      json['media'].forEach((v) {
        if (v['type'] == "Photo") {
          _media?.add(Photo.fromJson(v));
        } else {
          print("没有这个类型的数据: ${v['type']}");
          // throw UnimplementedError("没有这个类型的数据: ${v['type']}");
        }
      });
    }
    _totalResults = json['total_results'];
    _id = json['id'];
  }

  int? _page;
  int? _perPage;
  List<Media>? _media;
  int? _totalResults;
  String? _id;

  int? get page => _page;

  int? get perPage => _perPage;

  List<Media>? get media => _media;

  int? get totalResults => _totalResults;

  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = _page;
    map['per_page'] = _perPage;
    if (_media != null) {
      map['media'] = _media?.map((v){
        if(v is Photo){
         return v.toString();
        }else{
          print("没有这个type 实现 $v");
        }
      }).toList();
    }
    map['total_results'] = _totalResults;
    map['id'] = _id;
    return map;
  }
}
