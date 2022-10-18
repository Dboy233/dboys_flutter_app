/// id : 2499611
/// width : 1080
/// height : 1920
/// url : "https://www.pexels.com/video/2499611/"
/// image : "https://images.pexels.com/videos/2499611/free-video-2499611.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb"
/// full_res : ""
/// tags : ["",""]
/// duration : 22
/// user : {"id":680589,"name":"Joey Farina","url":"https://www.pexels.com/@joey"}
/// video_files : [{"id":125004,"quality":"hd","file_type":"video/mp4","width":1080,"height":1920,"fps":23.976,"link":"https://player.vimeo.com/external/342571552.hd.mp4?s=6aa6f164de3812abadff3dde86d19f7a074a8a66&profile_id=175&oauth2_token_id=57447761"},{"id":125005,"quality":"sd","file_type":"video/mp4","width":540,"height":960,"fps":23.976,"link":"https://player.vimeo.com/external/342571552.sd.mp4?s=e0df43853c25598dfd0ec4d3f413bce1e002deef&profile_id=165&oauth2_token_id=57447761"},{"id":125006,"quality":"sd","file_type":"video/mp4","width":240,"height":426,"fps":23.976,"link":"https://player.vimeo.com/external/342571552.sd.mp4?s=e0df43853c25598dfd0ec4d3f413bce1e002deef&profile_id=139&oauth2_token_id=57447761"}]
/// video_pictures : [{"id":308178,"picture":"https://static-videos.pexels.com/videos/2499611/pictures/preview-0.jpg","nr":0},{"id":308179,"picture":"https://static-videos.pexels.com/videos/2499611/pictures/preview-1.jpg","nr":1},{"id":308180,"picture":"https://static-videos.pexels.com/videos/2499611/pictures/preview-2.jpg","nr":2},{"id":308181,"picture":"https://static-videos.pexels.com/videos/2499611/pictures/preview-3.jpg","nr":3}]

class Video {
  Video({
    num? id,
    num? width,
    num? height,
    String? url,
    String? image,
    String? fullRes,
    List<String>? tags,
    num? duration,
    User? user,
    List<VideoFiles>? videoFiles,
    List<VideoPictures>? videoPictures,
  }) {
    _id = id;
    _width = width;
    _height = height;
    _url = url;
    _image = image;
    _fullRes = fullRes;
    _tags = tags;
    _duration = duration;
    _user = user;
    _videoFiles = videoFiles;
    _videoPictures = videoPictures;
  }

  Video.fromJson(dynamic json) {
    _id = json['id'];
    _width = json['width'];
    _height = json['height'];
    _url = json['url'];
    _image = json['image'];
    _fullRes = json['full_res'];
    _tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    _duration = json['duration'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['video_files'] != null) {
      _videoFiles = [];
      json['video_files'].forEach((v) {
        _videoFiles?.add(VideoFiles.fromJson(v));
      });
    }
    if (json['video_pictures'] != null) {
      _videoPictures = [];
      json['video_pictures'].forEach((v) {
        _videoPictures?.add(VideoPictures.fromJson(v));
      });
    }
  }

  num? _id;
  num? _width;
  num? _height;
  String? _url;
  String? _image;
  String? _fullRes;
  List<String>? _tags;
  num? _duration;
  User? _user;
  List<VideoFiles>? _videoFiles;
  List<VideoPictures>? _videoPictures;
  Video copyWith({
    num? id,
    num? width,
    num? height,
    String? url,
    String? image,
    String? fullRes,
    List<String>? tags,
    num? duration,
    User? user,
    List<VideoFiles>? videoFiles,
    List<VideoPictures>? videoPictures,
  }) =>
      Video(
        id: id ?? _id,
        width: width ?? _width,
        height: height ?? _height,
        url: url ?? _url,
        image: image ?? _image,
        fullRes: fullRes ?? _fullRes,
        tags: tags ?? _tags,
        duration: duration ?? _duration,
        user: user ?? _user,
        videoFiles: videoFiles ?? _videoFiles,
        videoPictures: videoPictures ?? _videoPictures,
      );
  num? get id => _id;
  num? get width => _width;
  num? get height => _height;
  String? get url => _url;
  String? get image => _image;
  String? get fullRes => _fullRes;
  List<String>? get tags => _tags;
  num? get duration => _duration;
  User? get user => _user;
  List<VideoFiles>? get videoFiles => _videoFiles;
  List<VideoPictures>? get videoPictures => _videoPictures;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['width'] = _width;
    map['height'] = _height;
    map['url'] = _url;
    map['image'] = _image;
    map['full_res'] = _fullRes;
    map['tags'] = _tags;
    map['duration'] = _duration;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_videoFiles != null) {
      map['video_files'] = _videoFiles?.map((v) => v.toJson()).toList();
    }
    if (_videoPictures != null) {
      map['video_pictures'] = _videoPictures?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 308178
/// picture : "https://static-videos.pexels.com/videos/2499611/pictures/preview-0.jpg"
/// nr : 0

class VideoPictures {
  VideoPictures({
    num? id,
    String? picture,
    num? nr,
  }) {
    _id = id;
    _picture = picture;
    _nr = nr;
  }

  VideoPictures.fromJson(dynamic json) {
    _id = json['id'];
    _picture = json['picture'];
    _nr = json['nr'];
  }

  num? _id;
  String? _picture;
  num? _nr;
  VideoPictures copyWith({
    num? id,
    String? picture,
    num? nr,
  }) =>
      VideoPictures(
        id: id ?? _id,
        picture: picture ?? _picture,
        nr: nr ?? _nr,
      );
  num? get id => _id;
  String? get picture => _picture;
  num? get nr => _nr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['picture'] = _picture;
    map['nr'] = _nr;
    return map;
  }
}

/// id : 125004
/// quality : "hd"
/// file_type : "video/mp4"
/// width : 1080
/// height : 1920
/// fps : 23.976
/// link : "https://player.vimeo.com/external/342571552.hd.mp4?s=6aa6f164de3812abadff3dde86d19f7a074a8a66&profile_id=175&oauth2_token_id=57447761"

class VideoFiles {
  VideoFiles({
    num? id,
    String? quality,
    String? fileType,
    num? width,
    num? height,
    num? fps,
    String? link,
  }) {
    _id = id;
    _quality = quality;
    _fileType = fileType;
    _width = width;
    _height = height;
    _fps = fps;
    _link = link;
  }

  VideoFiles.fromJson(dynamic json) {
    _id = json['id'];
    _quality = json['quality'];
    _fileType = json['file_type'];
    _width = json['width'];
    _height = json['height'];
    _fps = json['fps'];
    _link = json['link'];
  }

  num? _id;
  String? _quality;
  String? _fileType;
  num? _width;
  num? _height;
  num? _fps;
  String? _link;

  VideoFiles copyWith({
    num? id,
    String? quality,
    String? fileType,
    num? width,
    num? height,
    num? fps,
    String? link,
  }) =>
      VideoFiles(
        id: id ?? _id,
        quality: quality ?? _quality,
        fileType: fileType ?? _fileType,
        width: width ?? _width,
        height: height ?? _height,
        fps: fps ?? _fps,
        link: link ?? _link,
      );
  num? get id => _id;
  String? get quality => _quality;
  String? get fileType => _fileType;
  num? get width => _width;
  num? get height => _height;
  num? get fps => _fps;
  String? get link => _link;
  //尺寸
  int get size => (width! * height!).toInt();

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['quality'] = _quality;
    map['file_type'] = _fileType;
    map['width'] = _width;
    map['height'] = _height;
    map['fps'] = _fps;
    map['link'] = _link;
    return map;
  }
}

/// id : 680589
/// name : "Joey Farina"
/// url : "https://www.pexels.com/@joey"

class User {
  User({
    num? id,
    String? name,
    String? url,
  }) {
    _id = id;
    _name = name;
    _url = url;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _url = json['url'];
  }

  num? _id;
  String? _name;
  String? _url;
  User copyWith({
    num? id,
    String? name,
    String? url,
  }) =>
      User(
        id: id ?? _id,
        name: name ?? _name,
        url: url ?? _url,
      );
  num? get id => _id;
  String? get name => _name;
  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['url'] = _url;
    return map;
  }
}
