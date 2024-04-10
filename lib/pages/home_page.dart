import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:img_to_text/pages/result_scan.dart';
import 'package:permission_handler/permission_handler.dart';

import '../function_and_stuff/functions.dart';

class HomePage extends StatefulWidget{

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState<T extends HomePage> extends State<T> with WidgetsBindingObserver {
  String pageTitle = "CAMERA";
  late final Future<void> _future;
  bool _isGranted = false;
  CameraController? cameraController;
  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _requestCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopCamara();
    textRecognizer.close();
    super.dispose();
  }

  void didChangeAppLifeCycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      stopCamara();
    } else if (state == AppLifecycleState.resumed && cameraController != null &&
        cameraController!.value.isInitialized) {
      startCamara();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot){
          return Stack(
            children: [
              if(_isGranted)
                FutureBuilder<List<CameraDescription>>(
                  future: availableCameras(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _initCameraController(snapshot.data!);
                      return Center(
                          child: CameraPreview(cameraController!));
                    } else {
                      return const Center(child: LinearProgressIndicator());
                    }
                  },
                )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Snack_Message(context, 'Scanear texto');
          _scan();
        },
        tooltip: 'Open Camara',
        child: const Icon(Icons.text_fields, size: 40),
      ),
    );
  }



  Future<void> _requestCamera() async {
    final status = await Permission.camera.request();
    _isGranted = status == PermissionStatus.granted;
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (cameraController != null) {
      return;
    }

    CameraDescription? camera;

    for (var i = 0; 1 < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      selectedCamera(camera);
    }
  }

  Future<void> selectedCamera(CameraDescription camera) async {
    cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);

    await cameraController!.initialize();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  void startCamara(){
    if (cameraController != null){
      selectedCamera(cameraController!.description);
    }
  }

  void stopCamara(){
    if (cameraController != null){
      cameraController!.dispose();
    }
  }

  Future<void> _scan() async {
    if (cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final picture = await cameraController!.takePicture();

      final file = File(picture.path);

      final inputImage = InputImage.fromFile(file);

      final recognizerText = await textRecognizer.processImage(inputImage);

      await navigator.push(MaterialPageRoute(
        builder: (context) => ResultPage(text: recognizerText.text),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}