import 'dart:async';
import 'dart:ui';

import 'package:ciprrd_service/sql/connection.dart';
import 'package:flutter/services.dart';

import 'sql/models.dart';




abstract class Service {
  final String id;
  final User user;

  Service(this.id, this.user);
}

abstract class ServicePlugin {
  static const MethodChannel channel = const MethodChannel("");

  static Future<bool> initialize() async{
    Connection.getInstance().open("CIPRRDDB");
    final callback = PluginUtilities.getCallbackHandle(null);

    return true;
  }

  static Future<bool> registerService(Service service, void Function(List<String> id, User user) callback){

  }

  static Future<bool> removeService(Service service){

  }

  static Future<bool> removeServiceById(String id) async{

  }


}