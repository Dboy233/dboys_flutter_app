import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

enum QrType {
  ///纯文本
  text(name: "文本", iconData: Icons.text_snippet,color: Color(0xffc798a6)),

  ///邮件
  email(name: '邮件', iconData: Icons.email,color: Color(0xff7edaad)),

  ///联系人
  contactInfo(name: '联系人', iconData: Icons.contact_phone,color: Color(0xff6ac1ae)),

  ///网站
  url(name: '网址', iconData: Icons.web,color: Color(0xff93d5ea)),

  ///wifi
  wifi(name: 'wifi', iconData: Icons.wifi_outlined,color: Color(0xfff56976)),

  ///isb条码
  isbn(name: '条码', iconData: Icons.code,color: Color(0xff86e273)),

  ///手机号
  phone(name: '手机号', iconData: Icons.phone,color: Color(0xffd79cdd)),

  ///产品
  product(name: '产品', iconData: Icons.shopping_cart,color: Color(0xffe97e7a)),

  ///短信
  sms(name: 'SMS', iconData: Icons.sms,color: Color(0xff65d2de)),

  ///坐标
  geo(name: "坐标", iconData: Icons.location_on,color: Color(0xff6577d4)),

  ///日历
  calendarEvent(name: '日历', iconData: Icons.calendar_month,color: Color(0xffb56cd1)),

  ///驾照
  driverLicense(name: "驾照", iconData: Icons.drive_eta_rounded,color: Color(0xffd9e2c9)),

  ///未知类型
  unknown(name: '未知', iconData: Icons.question_mark,color: Colors.black54);

  final String? name;

  ///系统icon数据
  final IconData? iconData;

  ///本地icon数据
  final String? localData;

  final Color? color;

  const QrType({this.name, this.iconData, this.localData,this.color});
}

@Entity()
class QrData {
  @Id()
  int id = 0;

  int typeIndex = 0;

  ///类型
  QrType get type => QrType.values[typeIndex];

  set type(QrType qrType) => typeIndex = qrType.index;

  ///原始数据
  String orgData = "";

  ///经过格式化语义化的数据
  String data = "";

  ///日期
  @Property(type: PropertyType.date)
  DateTime? date;

  QrData();

  @override
  String toString() {
    return 'QrData{id: $id, type: $type, orgData: $orgData, data: $data, date: $date}';
  }
}
