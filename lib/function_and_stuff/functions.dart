import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

const miUrl = 'https://momdontgo.dev';

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

Widget bottomDevName() {
  return SizedBox(
    height: 20,
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 0,
            child: GestureDetector(
              onTap: () async {
                urlCall(miUrl);
              },
              child: const Text('Developed',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xA6111111),
                      fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            flex: 0,
            child: GestureDetector(
              onTap: () async {
                urlCall(miUrl);
              },
              child: const Text(' By {MomDontGo.Dev}',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xA6111111),
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> urlCall(String surl) async {
  final Uri url = Uri.parse(surl);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}



