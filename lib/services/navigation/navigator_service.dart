import 'package:flutter/material.dart';

class NavigationService {

  static final NavigationService _navservice = 
      NavigationService._instance();
  NavigationService._instance();
  factory NavigationService() => _navservice;


  navPush(BuildContext context, String router) {
    Navigator.of(context).pushNamed(router);
  }

  navPop(BuildContext context, String router) {
    Navigator.of(context).pop();
  }
}
