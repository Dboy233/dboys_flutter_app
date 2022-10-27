import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:dboy_flutter_app/database/bean/qr_data.dart';
import 'package:dboy_flutter_app/page/qr/page/qr_details/view.dart';
import 'package:dboy_flutter_app/routers/route_keys.dart';
import 'package:dboy_flutter_app/util/comm_tools.dart';
import 'package:dboy_flutter_app/util/location_util.dart';
import 'package:dboy_flutter_app/util/qr_coding_format.dart';
import 'package:dboy_flutter_app/widget/location_loading_dialog.dart';
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
        (element) => element.name == Get.parameters[RouteKeys.TYPE]);
    return Scaffold(
      appBar: AppBar(
        title: const Text("CREATE"),
        centerTitle: true,
      ),
      body: _checkTypeWidget(type),
    );
  }

  ///根据类型不同，展示不同的创建内容
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
        return CreateGeoQr();
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
        "创建${type.label}二维码",
        style: TextStyle(color: Colors.black87, fontSize: 60.sp),
      ),
    );
  }
}

///基本样式通用EditText
Widget _commEditText(
  String label,
  ValueChanged<String> onChange, {
  TextInputType textInputType = TextInputType.text,
  TextInputAction textInputAction = TextInputAction.next,
  TextEditingController? controller,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      controller: controller,
      decoration:
          InputDecoration(border: const OutlineInputBorder(), labelText: label),
      keyboardType: textInputType,
      textInputAction: textInputAction,
      style: TextStyle(color: Colors.black87, fontSize: contentFontSize),
      onChanged: onChange,
    ),
  );
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
        _createQrButton(
          () {
            if (_text.isEmpty) {
              return null;
            }
            return QrData.create(QrType.text, _text);
          },
        )
      ],
    );
  }
}

///邮箱
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

///url地址
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

///wifi
class CreateWifiQr extends StatefulWidget {
  const CreateWifiQr({Key? key}) : super(key: key);

  @override
  State<CreateWifiQr> createState() => _CreateWifiQrState();
}

///wifi State
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

///电话
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

///短信
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

///创建定位二维码
class CreateGeoQr extends StatefulWidget {
  const CreateGeoQr({super.key});

  @override
  State<CreateGeoQr> createState() => _CreateGeoQrState();
}

class _CreateGeoQrState extends State<CreateGeoQr> {
  final controller = Get.find<QrCreateTypeLogic>();

  ///我的坐标 通过定位获取
  LatLng? _myLocal;

  ///选择的 经度
  double longitude = 0;

  ///选择的 纬度
  double latitude = 0;

  ///地图控制器
  AMapController? _controllerMap;

  ///地图标记
  final marker = <Marker>{};

  @override
  void initState() {
    _location();
    super.initState();
  }

  @override
  void dispose() {
    _controllerMap?.disponse();
    super.dispose();
  }

  ///定位
  _location() async {
    var msg = await controller.initLocation((data) {
      latitude = double.parse(data["latitude"].toString());
      longitude = double.parse(data["longitude"].toString());
      _myLocal = LatLng(latitude, longitude);
      marker.clear();
      marker.add(_getMyMarker());
      setState(() {});
    });
    if (msg != null) {
      showMsg(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_myLocal == null) //没有取得定位的时候占位
          Container(
            width: double.infinity,
            height: Get.height / 2,
            color: Colors.black26,
          ),
        if (_myLocal != null) //取得定位的时候展示地图
          SizedBox(
            key: const ValueKey("高德地图-容器"),
            width: double.infinity,
            height: Get.height / 2,
            child: AMapWidget(
              key: const ValueKey("高德地图-View"),
              apiKey: AMapApiKey(
                iosKey: getGdIosKey(),
                androidKey: getGdAndroidKey(),
              ),
              initialCameraPosition: //初始展示位置
                  CameraPosition(target: _myLocal!),
              privacyStatement: const AMapPrivacyStatement(
                //能走到这里，协议肯定都同意了
                hasContains: true, hasShow: true, hasAgree: true,
              ),
              //禁止旋转
              rotateGesturesEnabled: false,
              //禁止倾斜
              tiltGesturesEnabled: false,
              //禁止显示3d建筑
              buildingsEnabled: false,
              //设置地图标记位置
              markers: Set<Marker>.of(marker),
              //点击事件
              onTap: _onMapTap,
              touchPoiEnabled: true,
              onPoiTouched: (argument) {
                if (argument.latLng != null) {
                  _onMapTap(argument.latLng!);
                }
              },
              onMapCreated: (controller) => _controllerMap = controller,
            ),
          ),
        SizedBox(
          height: 50.h,
        ),
        Text(
          """
  我的位置: 
      经度-${_myLocal?.longitude ?? 0} 
      纬度-${_myLocal?.latitude ?? 0}""",
          style: TextStyle(fontSize: contentFontSize, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          """
  选择位置: 
      经度-$longitude
      纬度-$latitude""",
          style: TextStyle(fontSize: contentFontSize, color: Colors.black),
        ),
       const SizedBox(height: 10),
        _createQrButton(() {
          if(longitude==0||latitude==0){
            return null;
          }
         return QrData.create(QrType.geo,
              QrCodingFormat.geo(longitude: "$longitude",latitude: "$latitude").toString());
        }),
      ],
    );
  }

  ///当地图点击的时候，[latLng]是坐标信息
  _onMapTap(LatLng latLng) {
    longitude = latLng.longitude;
    latitude = latLng.latitude;
    marker.clear();
    marker.add(_getMyMarker());
    marker.add(Marker(position: LatLng(latitude, longitude)));
    setState(() {});
  }

  ///获取我的位置标记
  Marker _getMyMarker() {
    return Marker(
        position: _myLocal!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: (id) {
          //点击我的位置的时候，清空标记
          longitude = _myLocal!.longitude;
          latitude = _myLocal!.latitude;
          marker.clear();
          marker.add(_getMyMarker());
          setState(() {});
        });
  }
}
