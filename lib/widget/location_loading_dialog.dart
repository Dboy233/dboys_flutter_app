import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dialog_controller.dart';

class LocationLoadingDialog extends StatefulWidget {
  ///
  DialogController? controller;

  LocationLoadingDialog({Key? key, this.controller}) : super(key: key);

  @override
  State<LocationLoadingDialog> createState() => _LocationLoadingDialogState();
}

class _LocationLoadingDialogState extends State<LocationLoadingDialog>
    with BaseDialogController, TickerProviderStateMixin {
  //动画控制器
  late AnimationController _slideController;

  //非线性动画
  late CurvedAnimation _curvedAnimation;
  @override
  void initState() {
    widget.controller?.setImpWidget(this);

    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..repeat(reverse: true);

    _curvedAnimation =
        CurvedAnimation(parent: _slideController, curve: Curves.decelerate);

    super.initState();
  }

  @override
  void dispose() {
    widget.controller == null;
    _curvedAnimation.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'images/img_earth.png',
              width: 150,
              height: 150,
            ),
          ),
          Center(
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, -0.3),
                end: const Offset(0, -1),
              ).animate(_curvedAnimation),
              child: const Icon(
                Icons.location_on,
                size: 50,
                color: Colors.yellow,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 180),
              child: Text(
                '正在定位...',
                style: TextStyle(fontSize: 60.sp, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dismiss() {
    Navigator.of(context).pop();
  }
}
