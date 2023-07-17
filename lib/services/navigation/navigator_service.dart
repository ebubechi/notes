import 'package:flutter/material.dart';

class NavigatorService {

  static final NavigatorService _navservice = 
      NavigatorService._instance();
  NavigatorService._instance();
  factory NavigatorService() => _navservice;


  navPush(BuildContext context, String router) {
    Navigator.of(context).pushNamed(router);
  }

  navPop(BuildContext context, dynamic value) {
    if(value != null){
      Navigator.of(context).pop(value);
    }else {
      Navigator.of(context).pop();
    }
  }
}
