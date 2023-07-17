import 'package:flutter/material.dart';
import 'package:notes/services/crud/notes_service.dart';

class NavigatorService {

  static final NavigatorService _navservice = 
      NavigatorService._instance();
  NavigatorService._instance();
  factory NavigatorService() => _navservice;


  navPush(BuildContext context, String router, {required DatabaseNote? note}) {
    Navigator.of(context).pushNamed(router, arguments: note);
  }

  navPop(BuildContext context, dynamic value) {
    if(value != null){
      Navigator.of(context).pop(value);
    }else {
      Navigator.of(context).pop();
    }
  }
}
