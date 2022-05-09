import 'package:ad_champagne_test_task/transitionAnimation.dart';
import 'package:flutter/cupertino.dart';

class CustomNavigations {
  void getIn({required Widget widget, required BuildContext context}) {
    Navigator.push<void>(context,
        TransitionAnimation(widget: widget, curve: Curves.fastOutSlowIn));
  }

  void getOut({required Widget widget, required BuildContext context}) {
    Navigator.pushReplacement(context,
        TransitionAnimation(widget: widget, curve: Curves.easeInOutCirc));
  }
}
