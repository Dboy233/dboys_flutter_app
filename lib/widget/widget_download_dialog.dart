import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DownloadDialog extends StatelessWidget {
  final Function()? onCancel;

  const DownloadDialog({Key? key, this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          width: 600.r,
          height: 500.r,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.r))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60.r,
              ),
              Text(
                "正在下载",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 60.sp,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 60.r,
              ),
              SizedBox(
                width: 80.r,
                height: 80.r,
                child: const CircularProgressIndicator(),
              ),
              SizedBox(
                height: 35.r,
              ),
              TextButton(
                onPressed: onCancel,
                child: Text(
                  "取消下载",
                  style: TextStyle(fontSize: 40.sp, color: Colors.red[200]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
