import 'dart:convert';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/helpers.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../utils/deviders/divider.dart';
import '../../../../../../../../utils/expansiontile.dart';
import '../../../../../../../../utils/function_callback.dart';
import '../../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../firma.dart';

class AutorizacionSc extends StatefulWidget {
  bool? edit;
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
  String? firmaProspectoPath;
  String? firmaGarantePath;
  String? firmaCProspectoPath;
  String? firmaCGarantePath;
  String currentPath = "";
  String title = "";
  String titleProspecto = "Firma de prospecto";
  String titleGarante = "Firma de garante";
  String titleCProspecto = "Firma de cónyuge / conviviente\ndel prospecto";
  String titleCGarante = "Firma de cónyuge / conviviente\ndel garante";

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
                title: titleProspecto,
                file: firmaProspectoPath,
                function: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => FirmaGeneral(
                              title: titleProspecto,
                            ))).then((val) => val != null
                    ? [
                        setState(() => firmaProspectoPath = val),
                        form.autorizacion
                            .updateValueAutorizacion("prospecto", val!)
                      ]
                    : null),
              ),
              title: Text(titleProspecto),
            ),
            divider(true),
            ListTile(
              leading: const Icon(AbiPraxis.firmas, size: 20),
              //trailing: const Icon(Icons.arrow_forward_ios_outlined),
              trailing: validarIconoFuncion(
                title: titleGarante,
                file: firmaGarantePath,
                function: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => FirmaGeneral(
                              title: titleGarante,
                            ))).then((val) => val != null
                    ? [
                        setState(() => firmaGarantePath = val),
                        form.autorizacion
                            .updateValueAutorizacion("garante", val)
                      ]
                    : null),
              ),
              title: Text(titleGarante),
            ),
            divider(true),
            ListTile(
              leading: const Icon(AbiPraxis.firmas, size: 20),
              trailing: validarIconoFuncion(
                title: titleCProspecto,
                file: firmaCProspectoPath,
                function: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => FirmaGeneral(
                              title: titleCProspecto,
                            ))).then((val) => val != null
                    ? [
                        setState(() => firmaCProspectoPath = val),
                        form.autorizacion
                            .updateValueAutorizacion("conyuge", val!)
                      ]
                    : null),
              ),
              //subtitle: const Text("del prospecto"),
              title: Text(titleCProspecto),
            ),
            divider(true),
            ListTile(
              leading: const Icon(AbiPraxis.firmas, size: 20),
              trailing: validarIconoFuncion(
                title: titleCGarante,
                file: firmaCGarantePath,
                function: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => FirmaGeneral(
                              title: titleCGarante,
                            ))).then((val) => val != null
                    ? [
                        setState(() => firmaCGarantePath = val),
                        form.autorizacion
                            .updateValueAutorizacion("conyuge_garante", val)
                      ]
                    : null),
              ),
              //subtitle: const Text("del garante"),
              title: Text(titleCGarante),
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
            if (widget.edit == null || widget.edit!) {
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

  void getData() async {
    final form = Provider.of<FormProvider>(context, listen: false).autorizacion;

    if (widget.idSolicitud != null) {
      final solicitud = await op.obtenerSolicitud(widget.idSolicitud!);

      if (solicitud != null) {
        final aut = jsonDecode(solicitud.autorizacion);

        final data = aut["autorizacion"];
        //prospecto
        if (data["prospecto"]?.isNotEmpty ?? false) {
          setState(() => firmaProspectoPath = data["prospecto"]);
          form.updateValueAutorizacion("prospecto", firmaProspectoPath);
        }
        //conyuge
        if (data["conyuge"]?.isNotEmpty ?? false) {
          setState(() => firmaCProspectoPath = data["conyuge"]);
          form.updateValueAutorizacion("conyuge", firmaCProspectoPath);
        }
        //garante
        if (data["garante"]?.isNotEmpty ?? false) {
          setState(() => firmaGarantePath = data["garante"]);
          form.updateValueAutorizacion("garante", firmaGarantePath);
        }
        //conyuge garante
        if (data["conyuge_garante"]?.isNotEmpty ?? false) {
          setState(() => firmaCGarantePath = data["conyuge_garante"]);
          form.updateValueAutorizacion("conyuge_garante", firmaCGarantePath);
        }
      }
    }
  }
}
