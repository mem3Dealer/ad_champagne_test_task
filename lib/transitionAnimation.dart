import 'package:flutter/cupertino.dart';

class TransitionAnimation extends PageRouteBuilder {
  final Widget widget;
  final Curve curve;
  TransitionAnimation({required this.widget, required this.curve})
      : super(
            transitionDuration: const Duration(milliseconds: 1000),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation = CurvedAnimation(parent: animation, curve: curve);
              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: Alignment.center,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            });
}
