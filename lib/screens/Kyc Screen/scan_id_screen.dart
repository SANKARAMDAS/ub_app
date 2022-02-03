import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanIdScreen extends StatefulWidget {
  @override
  _ScanIdScreenState createState() => _ScanIdScreenState();
}

class _ScanIdScreenState extends State<ScanIdScreen>
    with WidgetsBindingObserver {
  late CameraController cameraController;
  List? cameras;
  int? selectedCameraIndex;
  String? imgPath;
  bool mode = false;

  bool _initializing= false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    // if (!cameraController.value.isInitialized) {
    //   return;
    // }
    debugPrint(state.toString());
    if(_initializing){
      return;
    }
    if (state == AppLifecycleState.inactive) {
      setState(() {
        selectedCameraIndex = null;
      });
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        selectedCameraIndex = null;
      });
      // if (!cameraController.value.isInitialized) {

      cameraController = CameraController(
        cameraController.description, ResolutionPreset.ultraHigh,
        imageFormatGroup:
            Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.jpeg,
        enableAudio: false,
      );
      cameraController.initialize().then((value) async {
        await cameraController.lockCaptureOrientation();
        cameraController.setFlashMode(FlashMode.off);


        setState(() {
          selectedCameraIndex = 0;
        });
      });
      // } else {
      //   setState(() {
      //     selectedCameraIndex = 0;
      //   });
      // }
    }
  }

  initCamera(CameraDescription cameraDescription) async {
    cameraController = CameraController(
        cameraDescription, ResolutionPreset.ultraHigh,
        imageFormatGroup:
            Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.jpeg,
        enableAudio: false);

    /* cameraController.addListener(() {
      // if (mounted) {
      //   setState(() {});
      // }
      try {
        cameraController.setFlashMode(FlashMode.always);
      } catch (exc, stack) {}
      // setState(() {});
    }); */

    /*  if (cameraController.value.hasError) {
      print('Camera Error ${cameraController.value.errorDescription}');
    } */

    // if (mounted) {
    //   setState(() {});
    // }
  }

  /// Display camera preview

  Widget cameraPreview() {
    final size = MediaQuery.of(context).size;
    final deviceRatio = (size.width * 0.5)/ (size.height * 0.3);


    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    if (selectedCameraIndex == null) {
      return CircularProgressIndicator(
        color: AppTheme.electricBlue,
      );
    }
    /*return Transform.scale(
      scale: cameraController.value.aspectRatio / deviceRatio,
      child: Center(
        child: AspectRatio(
          aspectRatio: cameraController.value.aspectRatio,
          child: ,
        ),
      ),
    );*/
    return CameraPreview(cameraController);


  }

  Widget cameraControl(context) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            GestureDetector(
              child: Image.asset(
                'assets/icons/myprofile/capture.png',
                width: 80,
                // height: 70,
              ),
              // tooltip: 'Tap to take a picture',
              // backgroundColor: Colors.white,
              onTap: () {
                onCapture(context);
              },
            ),
            // Image.asset(
            //   AppAssets.kycDelete,
            //   height:40,
            // ),
          ],
        ),
      ),
    );
  }

  void onCapture(context) async {
    if (!cameraController.value.isInitialized) {  
     await cameraController.initialize();
     _initializing = false;

     return null;
    }
    await cameraController.setFlashMode(FlashMode.off);

    if (cameraController.value.isTakingPicture) {
      print(' A capture is already pending, do nothing.');
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile picture = await cameraController.takePicture();

      debugPrint('Captured Path ' + picture.path.toString());
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.EmiratesIdPreviewScreen,
        arguments: EmiratesPreviewArgs(
          EmiratesImage: picture.path.toString(),
        ),
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => EmiratesIdPreviewScreen(imgPath: picture),
      //   ),
      // );
    } catch (e) {
      showCameraException(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializing = true;
    WidgetsBinding.instance?.addObserver(this);

    availableCameras().then((value) {
      cameras = value;
      if (cameras!.length > 0) {
        // setState(() {
        selectedCameraIndex = 0;
        // });
        initCamera(cameras![selectedCameraIndex!]);
        try {
          cameraController.initialize().then((_) async {
            if (!mounted) {
              return;
            }
            await cameraController.lockCaptureOrientation();
            setState(() {});
          });
        } catch (e) {
          showCameraException(e);
        }
      } else {
        print('No camera available');
      }
    }).catchError((e) {
      print('Error : ${e.code}');
    });
  }

  Widget flashIcons() {
    return GestureDetector(
      child: Image.asset(
        'assets/icons/myprofile/torch.png',
        height: 40,
      ),
      onTap: () async {
        if (mode == false) {
          await cameraController.setFlashMode(FlashMode.torch);
          setState(() {
            mode = true;
          });
        } else {
          await cameraController.setFlashMode(FlashMode.off);
          setState(() {
            mode = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoutes.manageKyc3Route);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Scan your Emirates ID',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // leading: InkWell(
          //   onTap: () {
          //     Navigator.pushReplacementNamed(
          //         context, AppRoutes.manageKyc3Route);
          //   },
          //   child: Icon(
          //     Icons.chevron_left,
          //     color: Colors.white,
          //     size: 32,
          //   ),
          // ),
        ),
        backgroundColor: Color(0xff666666),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height *0.28,
          child:Column(
          children: [
            20.0.heightBox,
            CustomText(
              'Backside of your Emirates ID',
              size: 20,
              color: Colors.white,
              bold: FontWeight.w600,
            ),
            20.0.heightBox,
            CustomText(
              'Position all 4 corners of the front\nclearly in the frame',
              size: 16,
              centerAlign: true,
              color: Colors.white,
              bold: FontWeight.w400,
            ),
            Container(
              width: double.infinity,
              //padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 20),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  flashIcons(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: cameraControl(context),
                  ),
                  InkWell(
                    onTap: () async {
                      if(!(await Permission.storage.isGranted)){
                        final status = await Permission.storage.request();
                        if (status != PermissionStatus.granted) return;
                      }
                      final picker = ImagePicker();

                      final PickedFile? pickedFile = await picker.getImage(
                          source: ImageSource.gallery);
                      debugPrint(
                          'Captured Path ' + pickedFile!.path.toString());
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.EmiratesIdPreviewScreen,
                        arguments: EmiratesPreviewArgs(
                          EmiratesImage: pickedFile.path.toString(),
                        ),
                      );
                      
                    },
                    child: Image.asset(
                      'assets/icons/myprofile/preview.png',
                      height: 40,
                    ),
                  ),
                  // Spacer(),
                ],
              ),
            )
          ],
        ) ,),
        body: Material(
          color: Color(0xff666666),
          child: Stack(
            children: <Widget>[
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: cameraPreview(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.14,
                  ),
                  padding:
                     const EdgeInsets.symmetric(horizontal: 60),
                  child: Image.asset(
                    AppAssets.cameraEdges,
                    scale: 5,
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }

  getCameraLensIcons(lensDirection) {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return CupertinoIcons.photo_camera;
      default:
        return Icons.device_unknown;
    }
  }

  onSwitchCamera() {
    selectedCameraIndex = selectedCameraIndex! < cameras!.length - 1
        ? selectedCameraIndex! + 1
        : 0;
    CameraDescription selectedCamera = cameras![selectedCameraIndex!];
    initCamera(selectedCamera);
  }

  showCameraException(e) {
    String errorText = 'Error ${e.code} \nError message: ${e.description}';
    print(errorText);
  }
}
