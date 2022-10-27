import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

enum QrType {
  ///纯文本
  text(label: "文本", iconData: Icons.text_snippet, color: Color(0xffc798a6)),

  ///邮件
  email(label: '邮件', iconData: Icons.email, color: Color(0xff7edaad)),

  ///联系人
  contactInfo(
      label: '联系人', iconData: Icons.contact_phone, color: Color(0xff6ac1ae)),

  ///网站
  url(label: '网址', iconData: Icons.web, color: Color(0xff93d5ea)),

  ///wifi
  wifi(label: 'wifi', iconData: Icons.wifi_outlined, color: Color(0xfff56976)),

  ///isb条码
  isbn(label: '条码', iconData: Icons.code, color: Color(0xff86e273)),

  ///手机号
  phone(label: '手机号', iconData: Icons.phone, color: Color(0xffd79cdd)),

  ///产品
  product(label: '产品', iconData: Icons.shopping_cart, color: Color(0xffe97e7a)),

  ///短信
  sms(label: 'SMS', iconData: Icons.sms, color: Color(0xff65d2de)),

  ///坐标
  geo(label: "坐标", iconData: Icons.location_on, color: Color(0xff6577d4)),

  ///日历
  calendarEvent(
      label: '日历', iconData: Icons.calendar_month, color: Color(0xffb56cd1)),

  ///驾照
  driverLicense(
      label: "驾照", iconData: Icons.drive_eta_rounded, color: Color(0xffd9e2c9)),

  ///未知类型
  unknown(label: '未知', iconData: Icons.question_mark, color: Colors.black54);

  final String label;

  ///系统icon数据
  final IconData? iconData;

  ///本地icon数据
  final String? localData;

  ///颜色
  final Color color;

  const QrType({
    required this.label,
    required this.color,
    this.iconData,
    this.localData,
  });
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

  ///日期
  @Property(type: PropertyType.date)
  DateTime? date;

  QrData({
    this.typeIndex = 0,
    this.orgData = "",
    this.date,
  });

  QrData.create(QrType type, String orgData)
      : this(
          typeIndex: type.index,
          orgData: orgData,
          date: DateTime.now(),
        );

  @override
  String toString() {
    return 'QrData{id: $id, type: $type, orgData: $orgData,  date: $date}';
  }
}
