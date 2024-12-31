import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/buttons.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:abi_praxis_app/utils/responsive.dart';
import 'package:abi_praxis_app/utils/selectFile/select_file.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SubirFoto extends StatefulWidget {
  bool? edit;
  String nombre;
  String? frontal;
  String? reverso;
  String? otra;
  bool cedula;
  SubirFoto(
      {super.key,
      this.edit,
      required this.nombre,
      this.frontal,
      this.reverso,
      this.otra,
      required this.cedula});

  @override
  State<SubirFoto> createState() => _SubirFotoState();
}

class _SubirFotoState extends State<SubirFoto> {
  late MyAppBar appBar;
  final _sckey = GlobalKey<ScaffoldState>();

  Uint8List? frontal;
  Uint8List? reverso;
  Uint8List? otraFoto;

  final file = SeleccionArchivos();

  @override
  void initState() {
    super.initState();
    frontal = widget.frontal != null ? base64Decode(widget.frontal!) : null;
    reverso = widget.reverso != null ? base64Decode(widget.reverso!) : null;
    otraFoto = widget.otra != null ? base64Decode(widget.otra!) : null;
    appBar = MyAppBar(key: _sckey);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(builder: (context, form, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        key: _sckey,
        drawer: DrawerMenu(),
        appBar: appBar.myAppBar(context: context),
        body: options(),
      );
    });
  }

  Widget options() => Column(
        children: [
          header(widget.nombre, AbiPraxis.cedula,
              context: context, fontSize: 19),
          Expanded(
            child: SingleChildScrollView(
              child: widget.cedula
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (widget.edit != null && !widget.edit!)
                              ? null
                              : () async {
                                  final path = await file.selectOrCaptureImage(
                                      ImageSource.camera, context);

                                  if (path != null) {
                                    var toBytes = File(path).readAsBytesSync();
                                    setState(() => frontal = toBytes);
                                  }

                                  debugPrint("frontal: $path");
                                },
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(25)),
                            height: 215,
                            child: frontal == null
                                ? const Center(
                                    child: Text(
                                      "FOTO CÉDULA FRONTAL \nPulse aquí",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.memory(
                                      frontal!,
                                      fit: BoxFit.fill,
                                    )),
                          ),
                        ),
                        GestureDetector(
                          onTap: (widget.edit != null && !widget.edit!)
                              ? null
                              : () async {
                                  final path = await file.selectOrCaptureImage(
                                      ImageSource.camera, context);

                                  if (path != null) {
                                    var toBytes = File(path).readAsBytesSync();
                                    setState(() => reverso = toBytes);
                                  }

                                  debugPrint("reverso: $path");
                                },
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(25)),
                            height: 215,
                            child: reverso == null
                                ? const Center(
                                    child: Text(
                                      "FOTO CÉDULA REVERSO \nPulse aquí",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.memory(
                                      reverso!,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                          ),
                        )
                      ],
                    )
                  :
                  //todo SUBIR OTRA FOTO QUE NO SEA CÉDULA
                  GestureDetector(
                      onTap: (widget.edit != null && !widget.edit!)
                          ? null
                          : () async {
                              final path = await file.selectOrCaptureImage(
                                  ImageSource.camera, context);

                              if (path != null) {
                                var toBytes = File(path).readAsBytesSync();
                                setState(() => otraFoto = toBytes);
                              }

                              debugPrint("reverso: $path");
                            },
                      child: Container(
                        margin:
                            const EdgeInsets.only(left: 55, right: 55, top: 15),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(25)),
                        height: Responsive.of(context).hp(65),
                        child: otraFoto == null
                            ? const Center(
                                child: Text(
                                  "Subir foto",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.memory(
                                  otraFoto!,
                                  fit: BoxFit.fill,
                                ),
                              ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          if (widget.edit == null || widget.edit!)
            nextButton(
                onPressed: () {
                  Map<String, dynamic> map = {
                    "frontal": null,
                    "reverso": null,
                    "otra": null
                  };

                  if (widget.cedula) {
                    if (frontal != null && reverso != null) {
                      setState(() => map["frontal"] = base64Encode(frontal!));
                      setState(() => map["reverso"] = base64Encode(reverso!));

                      Navigator.pop(context, map);
                    } else {
                      scaffoldMessenger(context,
                          "Por favor, tome foto de ambos lados de la cédula.",
                          icon:
                              const Icon(Icons.warning, color: Colors.yellow));
                    }
                  } else {
                    if (otraFoto != null) {
                      setState(() => map["otra"] = base64Encode(otraFoto!));

                      Navigator.pop(context, map);
                    } else {
                      scaffoldMessenger(context,
                          "Por favor, tome la foto de una planilla de servicios básicos.",
                          icon:
                              const Icon(Icons.warning, color: Colors.yellow));
                    }
                  }
                },
                text: widget.frontal != null ? "Actualizar fotos" : "Continuar",
                width: 150),
          const SizedBox(height: 10),
        ],
      );
}
