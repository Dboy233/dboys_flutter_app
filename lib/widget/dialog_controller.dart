//目的是让Dialog自己关闭自己，有时候Dialog 的弹出在一个异步操作之后
abstract class BaseDialogController {
  ///关闭
  void dismiss();

}

class DialogController extends BaseDialogController {
  BaseDialogController? _dialog;

  void setImpWidget(BaseDialogController dialog) {
    _dialog = dialog;
  }

  @override
  void dismiss() {
    _dialog?.dismiss();
    _dialog = null;
  }


}
