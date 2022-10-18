

import 'package:get/get.dart';

extension MyGetx<T> on Rx<T>{

  ///总是更新数据，不管数据是否相同
  void alwaysUpToDate(T t){
    if(value == t){
      refresh();
    }else{
      value = t;
    }
  }

}