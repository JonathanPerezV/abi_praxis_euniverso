import 'dart:convert';

import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../../utils/app_bar.dart';
import '../../../lateralMenu/drawer_menu.dart';

class FirmaGeneral extends StatefulWidget {
  String title;
  FirmaGeneral({super.key, required this.title});

  @override
  State<FirmaGeneral> createState() => _FirmaGeneralState();
}

class _FirmaGeneralState extends State<FirmaGeneral> {
  final sckey = GlobalKey<ScaffoldState>();
  DrawingController _drawingController = DrawingController();
  late ScreenshotController _screenshotController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    _drawingController = DrawingController(
        config:
            DrawConfig(contentType: Type, color: Colors.black, strokeWidth: 2));

    _screenshotController = ScreenshotController();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<FormProvider>(builder: (context, form, child) {
        return Material(
          child: Scaffold(
            backgroundColor: Colors.white,
            key: sckey,
            //appBar: MyAppBar(key: sckey).myAppBar(),
            drawer: DrawerMenu(),
            body: options(),
          ),
        );
      }),
    );
  }

  Widget options() => Stack(
        children: [
          Column(
            children: [
              header(widget.title, AbiPraxis.firmas,
                  context: context, back: false),
              const SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 65,
                child: Screenshot(
                  controller: _screenshotController,
                  child: DrawingBoard(
                    controller: _drawingController,
                    background: Container(
                        margin: const EdgeInsets.only(left: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.black),
                            color: Colors.white),
                        width: MediaQuery.of(context).size.width - 40,
                        height: MediaQuery.of(context).size.height - 75),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                onPressed: () {
                  setState(() {
                    _drawingController.clear();
                  });
                },
                child: const Icon(Icons.refresh, color: Colors.white),
              )),
          Positioned(
              bottom: 10,
              left: 10,
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                onPressed: () async {
                  final res = await _screenshotController.capture();
                  final bas64 = base64Encode(res!);

                  Navigator.pop(context, bas64);
                },
                child: const Icon(Icons.done, color: Colors.white),
              ))
        ],
      );
}
