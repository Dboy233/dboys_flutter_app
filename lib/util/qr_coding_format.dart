///二维码内容格式化工具
class QrCodingFormat {
  ///文本
  static TextFormat text(String text) => TextFormat.create(text);

  ///url地址
  static UrlFormat url(String url) => UrlFormat.create(url);

  ///邮箱
  static EmailFormat email(String email) => EmailFormat.create(email);

  ///电话
  static TelFormat tel(String phone) => TelFormat.create(phone);

  ///联系人
  static ContactFormat contact({
    name = "",
    tel = "",
    email = "",
    url = "",
    area = "",
    org = "",
    til = "",
  }) =>
      ContactFormat.crate(
          name: name,
          tel: tel,
          email: email,
          url: url,
          area: area,
          org: org,
          til: til);

  ///短信
  static SmsFormat sms({String phone = "", String content = ""}) =>
      SmsFormat.create(phone: phone, content: content);

  ///定位
  static GeoFormat geo({latitude = "0", longitude = "0", height = "0"}) =>
      GeoFormat.create(
          latitude: latitude, longitude: longitude, height: height);

  ///wifi
  static WifiFormat wifi(
          {type = WifiAuthType.WEP,
          required String name,
          password = "",
          isHide = false}) =>
      WifiFormat.create(
          name: name, type: type, password: password, isHide: isHide);
}

///纯文本格式化
class TextFormat {
  String text;

  TextFormat.create(this.text);

  @override
  String toString() {
    return text;
  }
}

///Url地址格式化 http:// or  https:// 开头的文本
class UrlFormat extends TextFormat {
  UrlFormat.create(String url) : super.create(url);
}

///邮件地址格式化
class EmailFormat {
  String email;

  EmailFormat.create(this.email);

  @override
  String toString() {
    return "mailto:$email";
  }
}

///电话格式化
class TelFormat {
  String phone;

  TelFormat.create(this.phone);

  @override
  String toString() {
    return "tel:$phone";
  }
}

///联系人
class ContactFormat {
  String name;

  String tel;

  String email;

  String url;

  ///地区
  String area;

  ///组织
  String org;

  ///职位
  String til;

  ContactFormat.crate({
    this.name = "",
    this.tel = "",
    this.email = "",
    this.url = "",
    this.area = "",
    this.org = "",
    this.til = "",
  });

  @override
  String toString() {
    return "MECARD:N:$name;ADR:$area;ORG:$org;TIL:$til;TEL:$tel;EMAIL:$email;URL:$url;";
  }
}

class Address {
  final String country;
  final String area;
  final String street;

  const Address({this.country = "", this.area = "", this.street = ""});

  @override
  String toString() {
    return "$street,$area,$country";
  }
}

class SmsFormat {
  final String phone;

  final String content;

  const SmsFormat.create({this.phone = "", this.content = ""});

  @override
  String toString() {
    return "smsto:$phone:$content";
  }
}

class GeoFormat {
  final String latitude;

  final String longitude;

  final String height;

  GeoFormat.create(
      {this.latitude = "0", this.longitude = "0", this.height = "0"});

  @override
  String toString() {
    return "geo:$latitude,$longitude,$height";
  }
}

class WifiFormat {
  WifiAuthType type;

  String name;

  String password;

  bool isHide;

  WifiFormat.create(
      {this.type = WifiAuthType.WEP,
      required this.name,
      this.password = "",
      this.isHide = false});

  @override
  String toString() {
    var stringBuffer = StringBuffer();
    stringBuffer.write("WIFI:T:${type.name};S:$name;");
    if (password.isNotEmpty) {
      stringBuffer.write("P:$password;");
    }
    stringBuffer.write("H:$isHide;");
    return stringBuffer.toString();
  }
}

enum WifiAuthType {
  WAP,
  WEP,
  nopass;
}
