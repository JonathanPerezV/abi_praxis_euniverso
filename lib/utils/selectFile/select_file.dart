// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:abi_praxis_app/utils/alerts/and_alert.dart';
import 'package:abi_praxis_app/utils/alerts/ios_alert.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:abi_praxis_app/utils/selectFile/previsualizacion.dart';
import 'package:permission_handler/permission_handler.dart';

class SeleccionArchivos {
  //todo IMÁGENES
  final iosAlert = IosAlert();
  final andAlert = AndroidAlert();
  ImagePicker imagePicker = ImagePicker();

  //todo DOCUMENTOS
  List<PlatformFile>? _paths;

  Future<String?> selectOrCaptureImage(
      ImageSource imageSource, BuildContext context,
      {CropAspectRatio? radio}) async {
    String? pathImage;

    final status = await Permission.camera.status;

    if (status.isGranted) {
      final imageFile = await imagePicker.pickImage(
          source: imageSource, preferredCameraDevice: CameraDevice.front);
      if (imageFile != null) {
       var value = await recortarImagen(imageFile.path,
            radio); /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => PreVisualizacion(
                      imageFile.path,
                      radio: radio,
                    ))).then((value) async {*/
        if (value != null) {
          pathImage = value;
        } else {
          scaffoldMessenger(context, "Acción cancelada.",
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ));
        }
        //});
      } else {
        if (imageSource == ImageSource.camera) {
          scaffoldMessenger(context, "No se tomó la foto",
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ));
        } else {
          scaffoldMessenger(context, "No seleccionó ninguna imagen",
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ));
        }
      }
    } else {
      Platform.isAndroid
          ? andAlert.alertaPermisoCamaraManual(context)
          : iosAlert.alertaPermisoCamaraManual(context);
    }

    return pathImage;
  }

  Future<String?> openFileExplorer(
      FileType? pickingType, BuildContext context) async {
    String? pathDoc;
    final status = await Permission.storage.status;
    if (status.isGranted) {
      _paths = (await FilePicker.platform.pickFiles(
              type: pickingType!,
              allowedExtensions: ['pdf'],
              allowMultiple: false,
              dialogTitle: 'Esoja su archivo'))
          ?.files;

      if (_paths != null) {
        final bytes = _paths![0].size;
        final convert = bytes / (1024 * 1024);
        final size = convert.round();

        if (size < 3) {
          pathDoc = _paths![0].path!;
        } else {
          scaffoldMessenger(context, "El peso límite de un PDF es de 2 mb.",
              icon: const Icon(
                Icons.error,
                color: Colors.red,
              ));
        }
      } else {
        scaffoldMessenger(context, "Acción cancelada.",
            icon: const Icon(
              Icons.clear,
              color: Colors.red,
            ));
      }
    } else {
      Platform.isAndroid
          ? andAlert.alertaPermisoArchivosManual(context)
          : iosAlert.alertaPermisoArchivosManual(context);
    }
    return pathDoc!;
  }

  Future<String?> recortarImagen(String path, CropAspectRatio? radio) async {
    ImageCropper imageCropper = ImageCropper();
    final recortarImagen = await imageCropper.cropImage(
      //cropStyle: CropStyle.rectangle,

      sourcePath: path,
      compressQuality: 25,
      maxHeight: 200,
      aspectRatio: radio,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recortar imagen',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          backgroundColor: Colors.white,
          activeControlsWidgetColor: Colors.grey.shade400,
          hideBottomControls: false,
          dimmedLayerColor: const Color.fromRGBO(10, 10, 10, 120),
          showCropGrid: true,
          cropFrameColor: const Color.fromRGBO(10, 10, 10, 120),
          cropGridColor: Colors.red,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          showCancelConfirmationDialog: true,
          resetAspectRatioEnabled: true,
          hidesNavigationBar: false,
          aspectRatioLockDimensionSwapEnabled: false,
          aspectRatioPickerButtonHidden: false,
          resetButtonHidden: false,
          rotateButtonsHidden: false,
          doneButtonTitle: 'Hecho',
          cancelButtonTitle: 'Cancelar',
          title: 'Recortar imagen',
        ),
      ],
    );
    if (recortarImagen != null) {
      return recortarImagen.path;
    }
    return null;
  }
}
