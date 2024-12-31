import 'dart:convert';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/utils/function_callback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/helpers.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../utils/deviders/divider.dart';
import '../../../../../../../../../utils/expansiontile.dart';
import '../../../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../firma.dart';

class AutorizacionSc extends StatefulWidget {
  bool? edit;
  bool? ver;
  int? idSolicitud;
  ChangeColorCallback changeColorAutorizacionC;
  ExpansionTileController expController;
  MoveToTopCallback updatePixelPosition;
  FirmaCallback firmaCallback;
  bool enableExpansion;
  Color? datoAutorizacionC;
  GlobalKey gk;

  AutorizacionSc(
      {super.key,
      this.edit,
      this.ver,
      this.idSolicitud,
      required this.firmaCallback,
      required this.gk,
      required this.changeColorAutorizacionC,
      required this.enableExpansion,
      required this.updatePixelPosition,
      this.datoAutorizacionC,
      required this.expController});

  @override
  State<AutorizacionSc> createState() => _AutorizacionScState();
}

class _AutorizacionScState extends State<AutorizacionSc> {
  final op = Operations();
  //todo OPCIÓN DE AUTORIZACIÓN DE CRÉDITO
  String? firmaTitularPath;
  String currentPath = "";
  String title = "";
  String titleTiular = "Firma del Titular";

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return expansionTile(context,
        key: widget.gk,
        enabled: widget.enableExpansion,
        children: documentosAutorizacion(),
        title: "Autorización", func: (val) {
      if (val) {
        widget.updatePixelPosition(widget.gk);
      }
      //validarColorAutorizacion();
    }, color: widget.datoAutorizacionC, expController: widget.expController);
  }

  Widget documentosAutorizacion() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15)),
              width: double.infinity,
              height: 200,
              child: const SingleChildScrollView(
                child: Text(
                    "Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, Lorem Ipsum, "),
              ),
            ),
            ListTile(
              leading: const Icon(AbiPraxis.firmas, size: 20),
              trailing: validarIconoFuncion(
                title: titleTiular,
                file: firmaTitularPath,
                function: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => FirmaGeneral(
                              title: titleTiular,
                            ))).then((val) => val != null
                    ? [
                        setState(() => firmaTitularPath = val),
                        form.autorizacion
                            .updateValueAutorizacion("titular", val!),
                        validarColorAutorizacion(),
                      ]
                    : null),
              ),
              title: Text(titleTiular),
            ),
            divider(true),
          ],
        );
      });

  Widget validarIconoFuncion(
      {String? file, required Function function, required title}) {
    if (file != null) {
      return PopupMenuButton(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (val) async {
            if (val == 1) {
              setState(() {
                this.title = title;
                currentPath = file;
                widget.firmaCallback(title, file);
              });
              //eliminarFocus();
            }
            if (val == 2) {
              await function();
            }
          },
          itemBuilder: (context) {
            List<PopupMenuEntry> list = [];

            list.add(const PopupMenuItem(value: 1, child: Text("Ver firma")));
            //if (enableAllFields) {
            if (widget.ver == null) {
              list.add(const PopupMenuItem(value: 2, child: Text("Rehacer")));
            }
            //}
            return list;
          });
    } else {
      return IconButton(
          onPressed: (widget.edit != null && !widget.edit!)
              ? null
              : () async => await function(),
          icon: const Icon(Icons.arrow_forward_ios_outlined));
    }
  }

  void validarColorAutorizacion() {
    var val1 = firmaTitularPath != null;

    if (val1) {
      widget.changeColorAutorizacionC(1);
    } else {
      widget.changeColorAutorizacionC(2);
    }
  }

  void getData() async {
    final form = Provider.of<FormProvider>(context, listen: false).autorizacion;

    if (widget.idSolicitud != null) {
      final solicitud = await op.obtenerSolicitud(widget.idSolicitud!);

      if (solicitud != null) {
        final aut = jsonDecode(solicitud.autorizacion);

        final data = aut["autorizacion"];
        //titular
        if (data["titular"]?.isNotEmpty ?? false) {
          setState(() => firmaTitularPath = data["titular"]);
          form.updateValueAutorizacion("titular", firmaTitularPath);
        }
      }

      validarColorAutorizacion();
    }
  }
}
