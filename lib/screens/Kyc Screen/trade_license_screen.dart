import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';

class TradeLicenseScreen extends StatefulWidget {
  @override
  _TradeLicenseScreenState createState() => _TradeLicenseScreenState();
}

class _TradeLicenseScreenState extends State<TradeLicenseScreen>
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
          cameraController.description, ResolutionPreset.high,
          imageFormatGroup: Platform.isIOS
              ? ImageFormatGroup.bgra8888
              : ImageFormatGroup.jpeg,
          enableAudio: false);
      cameraController.initialize().then((value) async {
       await cameraController.lockCaptureOrientation();
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

  // Widget cameraPreview() {
  //   if (selectedCameraIndex == null) {
  //     return CircularProgressIndicator(
  //       color: AppTheme.electricBlue,
  //     );
  //   }
  //   final size = MediaQuery.of(context).size;
  //   final deviceRatio = (size.width * 0.9) / (size.height * 0.5);
  //   final aspectRatio = 3 / 4;
  //
  //   return Transform.scale(
  //     scale: cameraController.value.aspectRatio / deviceRatio,
  //     child: AspectRatio(
  //       aspectRatio: cameraController.value.aspectRatio,
  //       child: CameraPreview(
  //         cameraController,
  //       ),
  //     ),
  //   );
  // }
  Widget cameraPreview() {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / (size.height * 0.6);
    if (selectedCameraIndex == null) {
      return CircularProgressIndicator(
        color: AppTheme.electricBlue,
      );
    }

   /* return Transform.scale(
      scale: cameraController.value.aspectRatio / deviceRatio,
      child: AspectRatio(
        aspectRatio: cameraController.value.aspectRatio,
        child: CameraPreview(
          cameraController,
        ),
      ),
    );*/
    return CameraPreview(
      cameraController,
    );
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

  Widget cameraToggle() {
    if (cameras == null || cameras!.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras![selectedCameraIndex ?? 0];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: () {
              onSwitchCamera();
            },
            icon: Icon(
              getCameraLensIcons(lensDirection),
              color: Colors.white,
              size: 24,
            ),
            label: Text(
              '${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1).toUpperCase()}',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            )),
      ),
    );
  }

  void onCapture(context) async {
    if (!cameraController.value.isInitialized) {
      await cameraController.initialize();
      _initializing = false;

      return null;
    }

    if (cameraController.value.isTakingPicture) {
      print(' A capture is already pending, do nothing.');
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile picture = await cameraController.takePicture();

      debugPrint('Captured Path ' + picture.path);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => TradeLiscensePreviewScreen(imgPath: picture),
      //   ),
      // );
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.TradeLiscensePreviewScreen,
        arguments: TradeLicensePreviewArgs(
            TradeLicenseImage: picture, TradeLicensePDF: null),
      );
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
            'Scan your Trade Licence',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color(0xff666666),
        bottomNavigationBar: Container(
          height:MediaQuery.of(context).size.height *0.25,
          child: Column(
            children: [
              20.0.heightBox,
              CustomText(
                'Front side of Document',
                size: 20,
                color: Colors.white,
                bold: FontWeight.w600,
              ),
              20.0.heightBox,
              CustomText(
                'Position all 4 corners of the front clearly in the frame',
                size: 16,
                centerAlign: true,
                color: Colors.white,
                bold: FontWeight.w400,
              ),
              Container(
                width: double.maxFinite,
                //padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(bottom: 20),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      // height: MediaQuery.of(context).size.height * 0.10,
                      child: flashIcons(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: cameraControl(context),
                    ),
                    InkWell(
                      onTap: () async {
                        FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf','jpeg', 'jpg', 'png'],
                        );
                        if (result != null) {
                          PlatformFile file = result.files.first;

                          debugPrint(file.name);
                          debugPrint(file.bytes.toString());
                          debugPrint(file.size.toString());
                          debugPrint(file.extension.toString());
                          debugPrint(file.path.toString());
                          XFile? file1 = XFile(file.path.toString());
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => TradeLiscensePreviewScreen(
                          //       imgPath: file1,
                          //       path: file.path,
                          //     ),
                          //   ),
                          // );
                          if (file.extension.toString() == 'pdf') {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.TradeLiscensePreviewScreen,
                              arguments: TradeLicensePreviewArgs(
                                  TradeLicenseImage: file1,
                                  TradeLicensePDF: file.path),
                            );
                          } else if(file.extension.toString() == 'jpeg' || file.extension.toString() == 'jpg' || file.extension.toString() == 'png') {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.TradeLiscensePreviewScreen,
                              arguments: TradeLicensePreviewArgs(
                                  TradeLicenseImage: file1
                                  // TradeLicensePDF: file.path
                              ),
                            );
                          }
                           else {
                            '${file.extension.toString()} is not supported'
                                .showSnackBar(context);
                            file1 = null;

                          }
                        } else {
                          // User canceled the picker
                        }
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
          ),
        ),
        body: Material(
          color: Color(0xff666666),
          child: Stack(
            children: <Widget>[
              Container(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: cameraPreview(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 25, horizontal: 20),
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Image.asset(
                    'assets/images/kyc/icon5.png',
                    // scale: 5,
                  ),
                ),
              ),


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
