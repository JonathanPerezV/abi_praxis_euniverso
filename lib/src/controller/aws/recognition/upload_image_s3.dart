import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';

class UploadImageS3 {
  final String _url = dotenv.env["ws_upload"]!;
  final usrpfrc = UserPreferences();

  Future<String> uploadImage(File image, context,
      {String? folder, String? bucket, String? name, String? cedula}) async {
    String result = "error";

    String identification = cedula ?? await usrpfrc.getUserIdentification();

    debugPrint("CÉDULA: $identification");

    final fileBytes = image.readAsBytesSync();

    final fileBase64 = base64Encode(fileBytes);

    debugPrint("base64: $fileBase64");

    try {
      final request = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "file": fileBase64,
            "bucket_name": bucket ?? "nesec-rekognition-aws",
            "object_name": name ?? identification,
            "extension": "jpg",
            "folder": folder ?? "imagenes/$identification",
            "method": "insert"
          }));

      if (request.statusCode > 199 && request.statusCode < 300) {
        final decode = jsonDecode(request.body);
        final res = decode["status"];

        if (res == "ok") {
          result = decode["url"];
        }
      } else {
        Navigator.pop(context);
        scaffoldMessenger(context, "No se pudo actualizar la imagen",
            icon: const Icon(Icons.error, color: Colors.red));
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }

    return result;
  }
}
