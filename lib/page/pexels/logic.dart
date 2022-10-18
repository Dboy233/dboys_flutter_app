import 'package:get/get.dart';

class PexelsLogic extends GetxController {

  var _currentIndex = 0;

  String currentIndexUpDateId = "currentIndex";

  int getCurrentIndex(){
    return _currentIndex;
  }

  void changePageIndex(index){
    _currentIndex = index;
    update(['currentIndex']);
  }


}
