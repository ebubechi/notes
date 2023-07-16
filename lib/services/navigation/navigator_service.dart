import 'package:flutter/material.dart';

class NavigatorService {

  static final NavigatorService _navservice = 
      NavigatorService._instance();
  NavigatorService._instance();
  factory NavigatorService() => _navservice;


  navPush(BuildContext context, String router) {
    Navigator.of(context).pushNamed(router);
  }

  navPop(BuildContext context, String router) {
    Navigator.of(context).pop();
  }
}
