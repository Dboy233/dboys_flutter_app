import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 500.w,
      child: Column(
        children: [
          SizedBox(height: 250.h),
          Container(
            height: 300.r,
            width: 300.r,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        'https://avatars.githubusercontent.com/u/37604230?v=4'))),
          ),
          SizedBox(height: 45.h),
          Text(
            'Dboy233',
            style: TextStyle(
                color: const Color(0xff0d0f1a),
                fontSize: 60.sp,
                fontWeight: FontWeight.w100),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () {
              launchUrl(Uri.https('github.com', 'Dboy233'));
            },
            child: Text(
              'https://github.com/Dboy233',
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 30.h),
          _getItem(
            Icon(
              Icons.home,
              size: 60.r,
              color: Colors.black54,
            ),
            "Home",
            () {
              Navigator.pop(context);
            },
          ),
          _getItem(
            Image.asset(
              'images/icon_github.png',
              color: Colors.black54,
              width: 60.r,
              height: 60.r,
            ),
            "Github",
            () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _getItem(Widget icon, String info, VoidCallback onTap) {
    return ListTile(
      key: ValueKey(info),
      onTap: onTap,
      title: Text(
        info,
        style: TextStyle(color: Colors.black54, fontSize: 40.sp),
      ),
      leading: icon,
    );
  }
}
