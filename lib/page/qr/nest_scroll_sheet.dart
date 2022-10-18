import 'dart:async';

import 'package:flutter/material.dart';

typedef ChildBuild = Widget Function(
    ScrollController scrollController, bool scrollBan);

class NestScrollSheet extends StatefulWidget {
  ChildBuild childBuild;

  NestScrollSheet(this.childBuild, {Key? key}) : super(key: key);

  @override
  State<NestScrollSheet> createState() => _NestScrollSheetState();
}

class _NestScrollSheetState extends State<NestScrollSheet> {
  final ScrollController _scrollController = ScrollController();

  /// 用来发送事件 改变弹框高度的stream
  final StreamController<double> _streamController =
      StreamController<double>.broadcast();

  /// 列表弹起的正常高度
  double _totalHeight = 400;

  /// 记录手指按下的位置
  double _pointerDy = 0;

  @override
  void dispose() {
    _streamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      initialData: _totalHeight,
      builder: (context, snapshot) {
        double currentHeight = snapshot.data ?? _totalHeight;
        return Listener(
          onPointerMove: (event) {
            // 触摸事件过程 手指一直在屏幕上且发生距离滑动
            if (_scrollController.offset != 0) {
              // 只有列表滚动到顶部时才触发下拉动画效果
              print("onPointerMove:${_scrollController.offset}");
              return;
            }
            double distance = event.position.dy - _pointerDy;
            if (distance.abs() > 0) {
              // 获取手指滑动的距离，计算弹框实时高度，并发送事件
              double _currentHeight = _totalHeight - distance;
              if (_currentHeight > _totalHeight) {
                return;
              }
              _streamController.sink.add(_currentHeight);
            }
          },
          onPointerUp: (event) {
            // 触摸事件结束 手指离开屏幕
            // 这里认为滑动超过一半就认为用户要退出了，值可以根据实际体验修改
            if (currentHeight < (_totalHeight * 0.5)) {
              Navigator.pop(context);
            } else {
              _streamController.sink.add(_totalHeight);
            }
          },
          onPointerDown: (event) {
            // 触摸事件开始 手指开始接触屏幕
            _pointerDy = event.position.dy + _scrollController.offset;
          },
          child: widget.childBuild(
              _scrollController, currentHeight != _totalHeight),
        );
      },
    );
  }
}
