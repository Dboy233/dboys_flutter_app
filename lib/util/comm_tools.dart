import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

//显示消息信息
SnackbarController showMsg(String msg) {
  return Get.showSnackbar(GetSnackBar(
    backgroundColor: Colors.blue,
    messageText: Text(
      msg,
      style: const TextStyle(color: Colors.white),
    ),
    duration: const Duration(seconds: 2),
  ));
}

///如果 传入[width]则返回缩放后的height高度
///如果 传入[height]则返回缩放后的width宽度
double zoom(int orgWidth, int orgHeight,
    {double width = 0, double height = 0}) {
  if (width == 0 && height == 0) {
    throw Exception("width 和 height必须有一个");
  }
  if (width != 0) {
    return (width / orgWidth) * orgHeight;
  }
  if (height != 0) {
    return (height / orgHeight) * orgWidth;
  }
  return 0;
}

///随机颜色方法
Color randomColor({
  bool randomA = false, //是否随机透明度
  bool randomR = true, //是否随机R通道
  bool randomG = true, //是否随机G通道
  bool randomB = true, //是否随机B通道
  int minA = 100, //A通道最小随机值
  int minR = 100, //R通道最小随机值
  int minG = 100, //G通道最小随机值
  int minB = 100, //B通道最小随机值
}) {
  var random = Random();
  int r = randomR ? (255 - random.nextInt(255 - minR)) : 255;
  int g = randomG ? (255 - random.nextInt(255 - minG)) : 255;
  int b = randomB ? (255 - random.nextInt(255 - minB)) : 255;
  int a = randomA ? (255 - random.nextInt(255 - minA)) : 255;
  return Color.fromARGB(a, r, g, b);
}

///取颜色的互补色
Color repairColor(Color color) {
  var alpha = color.alpha;
  var red = color.red;
  var green = color.green;
  var blue = color.blue;
  return Color.fromARGB(alpha, 255 - red, 255 - green, 255 - blue);
}
