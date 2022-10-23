import 'package:dboy_flutter_app/database/bean/qr_data.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_details/view.dart';
import 'package:dboy_flutter_app/routers/route_keys.dart';
import 'package:dboy_flutter_app/util/qr_coding_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'logic.dart';

///内容文本大小
final contentFontSize = 65.sp;

class QrCreateTypePage extends GetWidget<QrCreateTypeLogic> {
  const QrCreateTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    QrType? type = QrType.values.toList().firstWhereOrNull(
        (element) => element.enumName == Get.parameters[RouteKeys.TYPE]);
    return Scaffold(
      appBar: AppBar(
        title: const Text("CREATE"),
        centerTitle: true,
      ),
      body: _checkTypeWidget(type),
    );
  }

  Widget _checkTypeWidget(QrType? qrType) {
    switch (qrType) {
      case QrType.text:
        return CreateTextQr();
      case QrType.email:
        return CreateEmailQr();
      case QrType.contactInfo:
        return CreateContactQr();
      case QrType.url:
        return CreateUrlQr();
      case QrType.wifi:
        return const CreateWifiQr();
      case QrType.phone:
        return CreatePhoneQr();
      case QrType.sms:
        return CreateSmsQr();
      case QrType.geo:
      case QrType.driverLicense:
      default:
        return const Center(child: Text("紧张刺激的开发中，可能不支持此类型"));
    }
  }
}

///通用标题
class QrTypeTitle extends StatelessWidget {
  final QrType type;

  const QrTypeTitle({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(type.iconData, color: type.color),
      title: Text(
        "创建${type.name}二维码",
        style: TextStyle(color: Colors.black87, fontSize: 60.sp),
      ),
    );
  }
}

typedef OnCreate = QrData? Function();

///通用底部创建按钮
Widget _createQrButton(OnCreate onCreate) {
  return Center(
    child: FloatingActionButton(
      onPressed: () {
        var qrData = onCreate.call();
        if (qrData == null) {
          return;
        }
        Get.to(
          QrDetails(qrData: qrData),
          transition: Transition.cupertino,
        );
      },
      child: const Icon(Icons.add),
    ),
  );
}

///创建文本Qr
class CreateTextQr extends GetView<QrCreateTypeLogic> {
  CreateTextQr({super.key});

  var _text = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QrTypeTitle(type: QrType.text),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              constraints:
                  BoxConstraints.expand(width: double.infinity, height: 0.2.sh),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.multiline,
            maxLength: 100,
            maxLines: 10,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              _text = value;
              Get.log(_text);
            },
          ),
        ),
        Center(
          child: FloatingActionButton(
            onPressed: () {
              if (_text.isEmpty) {
                return;
              }
              var qrData = QrData.create(QrType.text, _text);
              Get.to(
                QrDetails(qrData: qrData),
                transition: Transition.cupertino,
              );
            },
            child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }
}

class CreateEmailQr extends GetView<QrCreateTypeLogic> {
  var _email = "";

  CreateEmailQr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QrTypeTitle(type: QrType.email),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: '输入邮箱地址',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              _email = value;
            },
          ),
        ),
        _createQrButton(() {
          if (_email.isEmpty) {
            return null;
          }
          return QrData.create(
              QrType.email, QrCodingFormat.email(_email).toString());
        }),
      ],
    );
  }
}

///联系人
class CreateContactQr extends StatelessWidget {
  var name = "";
  var phone = "";
  var email = "";
  var url = "";
  var area = "";
  var org = "";
  var til = "";

  CreateContactQr({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const QrTypeTitle(type: QrType.contactInfo),
        //姓名
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "姓名"),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              name = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "电话"),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              phone = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "邮箱"),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              email = value;
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Url"),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              url = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "地区"),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              area = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "组织"),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              org = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "职位"),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              til = value;
            },
          ),
        ),
        _createQrButton(
          () {
            var content = QrCodingFormat.contact(
              name: name,
              email: email,
              url: url,
              tel: phone,
              area: area,
              org: org,
              til: til,
            );
            return QrData.create(QrType.contactInfo, content.toString());
          },
        ),
      ],
    );
  }
}

class CreateUrlQr extends StatelessWidget {
  String url = "";

  CreateUrlQr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QrTypeTitle(type: QrType.url),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: '网站地址',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              url = value;
            },
          ),
        ),
        _createQrButton(() {
          if (url.isEmpty) {
            return null;
          }
          if (!url.startsWith("http://")) {
            url = "http://$url";
          }
          return QrData.create(QrType.url, QrCodingFormat.url(url).toString());
        }),
      ],
    );
  }
}

class CreateWifiQr extends StatefulWidget {
  const CreateWifiQr({Key? key}) : super(key: key);

  @override
  State<CreateWifiQr> createState() => _CreateWifiQrState();
}

class _CreateWifiQrState extends State<CreateWifiQr> {
  WifiAuthType? type = WifiAuthType.Wpa;

  var ssidName = "";
  var password = "";
  List<DropdownMenuItem<WifiAuthType>> _getItem() => WifiAuthType.values
      .toList()
      .map<DropdownMenuItem<WifiAuthType>>(
          (type) => DropdownMenuItem<WifiAuthType>(
                value: type,
                child: Text(type.type,
                    style: TextStyle(
                        color: Colors.black87, fontSize: contentFontSize)),
              ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QrTypeTitle(type: QrType.wifi),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                "认证类型",
                style:
                    TextStyle(color: Colors.black87, fontSize: contentFontSize),
              ),
              SizedBox(
                width: 80.w,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<WifiAuthType>(
                  value: type,
                  items: _getItem(),
                  onChanged: (value) {
                    setState(() {
                      type = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "名称"),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              ssidName = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "密码"),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              password = value;
            },
          ),
        ),
        _createQrButton(() {
          if (ssidName.isEmpty || password.isEmpty) {
            return null;
          }
          var wifi = QrCodingFormat.wifi(
              name: ssidName, password: password, type: type);
          return QrData.create(QrType.wifi, wifi.toString());
        })
      ],
    );
  }
}

class CreatePhoneQr extends StatelessWidget {
  String phone = '';

  CreatePhoneQr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QrTypeTitle(type: QrType.email),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: '输入手机号',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              phone = value;
            },
          ),
        ),
        _createQrButton(() {
          if (phone.isEmpty) {
            return null;
          }
          return QrData.create(
              QrType.phone, QrCodingFormat.tel(phone).toString());
        }),
      ],
    );
  }
}

class CreateSmsQr extends StatelessWidget {
  String phone = "";
  String content = "";

  CreateSmsQr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QrTypeTitle(type: QrType.email),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: '输入手机号',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              phone = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              constraints:
                  BoxConstraints.expand(width: double.infinity, height: 0.2.sh),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.multiline,
            maxLength: 100,
            maxLines: 10,
            style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
            onChanged: (value) {
              content = value;
            },
          ),
        ),
        _createQrButton(() {
          if (phone.isEmpty || content.isEmpty) {
            return null;
          }
          return QrData.create(QrType.sms,
              QrCodingFormat.sms(phone: phone, content: content).toString());
        }),
      ],
    );
  }
}
