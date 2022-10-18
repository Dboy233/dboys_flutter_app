import 'dart:math';

import 'package:dboy_flutter_app/net/pexels/bean/media.dart';


/// 照片信息
/// id : 2014422
/// width : 3024
/// height : 3024
/// url : "https://www.pexels.com/photo/brown-rocks-during-golden-hour-2014422/"
/// photographer : "Joey Farina"
/// photographer_url : "https://www.pexels.com/@joey"
/// photographer_id : 680589
/// avg_color : "#978E82"
/// src : {"original":"https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg","large2x":"https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940","large":"https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=650&w=940","medium":"https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=350","small":"https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=130","portrait":"https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800","landscape":"https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200","tiny":"https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"}

class Photo implements Media {
  Photo({
    int? id,
    int? width,
    int? height,
    String? url,
    String? photographer,
    String? photographerUrl,
    int? photographerId,
    String? avgColor,
    Src? src,
    bool liked = false,
  }) {
    _id = id;
    _width = width;
    _height = height;
    _url = url;
    _photographer = photographer;
    _photographerUrl = photographerUrl;
    _photographerId = photographerId;
    _avgColor = avgColor;
    _src = src;
  }

  Photo.fromJson(dynamic json) {
    _id = json['id'];
    _width = json['width'];
    _height = json['height'];
    _url = json['url'];
    _photographer = json['photographer'];
    _photographerUrl = json['photographer_url'];
    _photographerId = json['photographer_id'];
    _avgColor = json['avg_color'];
    _src = json['src'] != null ? Src.fromJson(json['src']) : null;
    _liked = json['liked'] ?? false;
    _type = json['type'] ?? "Photo";
  }

  int? _id;
  int? _width;
  int? _height;
  String? _url;
  String? _photographer;
  String? _photographerUrl;
  int? _photographerId;
  String? _avgColor;
  Src? _src;
  bool _liked = false;
  String _type = "Photo";

  int get id => _id ?? Random().nextInt(10000);

  int? get width => _width;

  int? get height => _height;

  String? get url => _url;

  String? get photographer => _photographer;

  String? get photographerUrl => _photographerUrl;

  int? get photographerId => _photographerId;

  String? get avgColor => _avgColor;

  Src? get src => _src;

  bool get liked => _liked;

  @override
  String get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['width'] = _width;
    map['height'] = _height;
    map['url'] = _url;
    map['photographer'] = _photographer;
    map['photographer_url'] = _photographerUrl;
    map['photographer_id'] = _photographerId;
    map['avg_color'] = _avgColor;
    if (_src != null) {
      map['src'] = _src?.toJson();
    }
    map['liked'] = _liked;
    map['type'] = _type;
    return map;
  }

}

/// original : "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg"
/// large2x : "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
/// large : "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=650&w=940"
/// medium : "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=350"
/// small : "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=130"
/// portrait : "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800"
/// landscape : "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200"
/// tiny : "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"

class Src {
  Src({
    String? original,
    String? large2x,
    String? large,
    String? medium,
    String? small,
    String? portrait,
    String? landscape,
    String? tiny,
  }) {
    _original = original;
    _large2x = large2x;
    _large = large;
    _medium = medium;
    _small = small;
    _portrait = portrait;
    _landscape = landscape;
    _tiny = tiny;
  }

  Src.fromJson(dynamic json) {
    _original = json['original'];
    _large2x = json['large2x'];
    _large = json['large'];
    _medium = json['medium'];
    _small = json['small'];
    _portrait = json['portrait'];
    _landscape = json['landscape'];
    _tiny = json['tiny'];
  }

  String? _original;
  String? _large2x;
  String? _large;
  String? _medium;
  String? _small;
  String? _portrait;
  String? _landscape;
  String? _tiny;

  String? get original => _original;

  String? get large2x => _large2x;

  String? get large => _large;

  String? get medium => _medium;

  String? get small => _small;

  String? get portrait => _portrait;

  String? get landscape => _landscape;

  String? get tiny => _tiny;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['original'] = _original;
    map['large2x'] = _large2x;
    map['large'] = _large;
    map['medium'] = _medium;
    map['small'] = _small;
    map['portrait'] = _portrait;
    map['landscape'] = _landscape;
    map['tiny'] = _tiny;
    return map;
  }
}
