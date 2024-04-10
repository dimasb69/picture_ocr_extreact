import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';



CamStatus_Value()async {
  var cam_stat = await Permission.camera.status;
  return cam_stat;
}

CameraPermissionRequest(context) async{
  var statusC = await CamStatus_Value();
  if (statusC == PermissionStatus.denied) {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      Snack_Message(context, 'Permisos de camara: PermissionStatus.granted');
    }
  }else if(statusC == PermissionStatus.permanentlyDenied) {
    Snack_Message(context, 'Permisos de camara: ${statusC.toString()}');
    delay(2);
    await openAppSettings();

  }else{
    //Snack_Message(context, 'Permisos de camara: ${statusC.toString()}');
  }
}

delay (sec)async{
  await Future.delayed(Duration(seconds: sec));
}


Snack_Message (context, text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}



