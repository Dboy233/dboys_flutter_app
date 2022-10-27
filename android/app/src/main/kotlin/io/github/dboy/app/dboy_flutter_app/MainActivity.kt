package io.github.dboy.app.dboy_flutter_app

import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val appInfo: ApplicationInfo =
            packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA)
        Log.d("测试", "获取应用中的key=" + appInfo.metaData.getString("com.amap.api.v2.apikey"))
    }
}
