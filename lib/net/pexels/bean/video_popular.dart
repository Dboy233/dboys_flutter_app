import 'package:dboy_flutter_app/net/pexels/bean/Video.dart';

/// page : 1
/// per_page : 1
/// total_results : 4089
/// url : "https://www.pexels.com/search/videos/Nature/"
/// videos : []

class VideoPopular {
  VideoPopular({
    num? page,
    num? perPage,
    num? totalResults,
    String? url,
    List<Video>? videos,
    String? nextPage,
  }) {
    _page = page;
    _perPage = perPage;
    _totalResults = totalResults;
    _url = url;
    _videos = videos;
  }

  VideoPopular.fromJson(dynamic json) {
    _page = json['page'];
    _perPage = json['per_page'];
    _totalResults = json['total_results'];
    _url = json['url'];
    _nextPage = json['next_page'];
    if (json['videos'] != null) {
      _videos = [];
      json['videos'].forEach((v) {
        _videos?.add(Video.fromJson(v));
      });
    }
  }

  num? _page;
  num? _perPage;
  num? _totalResults;
  String? _url;
  List<Video>? _videos;
  String? _nextPage;

  num? get page => _page;
  num? get perPage => _perPage;
  num? get totalResults => _totalResults;
  String? get url => _url;
  List<Video> get videos => _videos ?? [];
  String? get nextPage => _nextPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = _page;
    map['per_page'] = _perPage;
    map['total_results'] = _totalResults;
    map['url'] = _url;
    if (_videos != null) {
      map['videos'] = _videos?.map((v) => v.toJson()).toList();
    }
    map['next_page'] = _nextPage;
    return map;
  }
}
