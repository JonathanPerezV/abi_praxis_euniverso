// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:abi_praxis_app/src/controller/dataBase/db.dart';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/src/models/solicitud/documentos_solicitud_model.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/credito/solicitud/forms/subirDocumentos/subir_foto.dart';
import 'package:abi_praxis_app/utils/buttons.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/expansiontile.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:abi_praxis_app/utils/function_callback.dart';
import 'package:abi_praxis_app/utils/responsive.dart';
import 'package:abi_praxis_app/utils/selectFile/select_file.dart';
import 'package:abi_praxis_app/utils/textFields/input_text_form_fields.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../../../../utils/icons/abi_praxis_icons.dart';

class DocumentosSC extends StatefulWidget {
  bool? edit;
  int? idSolicitud;
  int? idPersona;
  int? idConyuge;
  int? idGarante;
  int? idConyGarante;
  ChangeColorCallback changeColorDocumentosC;
  ExpansionTileController expController;
  MoveToTopCallback updatePixelPosition;
  bool enableExpansion;
  Color? datoDocumentoC;
  GlobalKey gk;

  DocumentosSC(
      {super.key,
      this.edit,
      this.idSolicitud,
      this.idConyuge,
      this.idPersona,
      this.idGarante,
      this.idConyGarante,
      required this.gk,
      required this.changeColorDocumentosC,
      required this.enableExpansion,
      required this.updatePixelPosition,
      this.datoDocumentoC,
      required this.expController});

  @override
  State<DocumentosSC> createState() => _DocumentosSCState();
}

class _DocumentosSCState extends State<DocumentosSC> {
  final scrollController = ScrollController();
  final file = SeleccionArchivos();
  final op = Operations();

  final _exp1 = ExpansionTileController();
  final _exp2 = ExpansionTileController();
  final _exp3 = ExpansionTileController();
  final _exp4 = ExpansionTileController();
  final _exp5 = ExpansionTileController();
  final _exp6 = ExpansionTileController();
  final _exp7 = ExpansionTileController();

  double height = 55;
  String title = "";
  bool enableVisibility = false;
  bool cedulaB = false;
  bool impuestosB = false;
  bool planillaB = false;
  bool buroB = false;
  bool justificacionB = false;
  bool excepcionB = false;
  bool otrosB = false;
  //todo VARIABLES DEL PROSPECTO - CÉDULA
  String cProspecto = "Cédula del prospecto";
  String? pathFrontalP;
  String? pathReversaP;
  String? documentoP;
  //todo VARIABLES DEL CÓNYUGE DEL PROSPECTO - CÉDULA
  String cConyuge = "Cédula del cónyuge";
  String? pathFrontalPC;
  String? pathReversaPC;
  String? documentoPC;
  //todo VARIABLES DEL GARANTE - CÉDULA
  String cGarante = "Cédula del garante";
  String? pathFrontalG;
  String? pathReversaG;
  String? documentoG;
  //todo VARIABLES DEL CÓNYUGE DEL GARANTE - CÉDULA
  String cConyGarante = "Cédula cónyuge del garante";
  String? pathFrontalGC;
  String? pathReversaGC;
  String? documentoGC;

  //todo VARIABLE IMPUESTO PREDIAL
  String impuesto = "Impuesto predial";
  String? pathImpuesto;

  //todo VARIABLE SERVICIOS BÁSICOS
  String servicio = "Planilla de servicios básicos";
  String? docPlanilla;
  String? fotoPlanilla;

  //todo VARIABLES BURO DE CRÉDITO
  String buroProspecto = "Buró de crédito - Prospecto";
  String buroGarante = "Buró de crédito - Garante";

  String? pathBuroProspecto;
  String? pathBuroGarante;

  //todo VARIABLES JUSTIFICACION
  String justificacion = "Justificación";
  String? fotoJustificacion;
  String? docJustificacion;

  //todo VARIABLES EXCEPCIONES
  String excepcion = "Excepción";
  String? fotoExcepcion;
  String? docExcepcion;

//todo VARIABLES DE OTROS DOCUMENTOS
  String otros = "Otros";
  int? tipoDoc;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return expansionTile(context,
        color: widget.datoDocumentoC,
        key: widget.gk,
        children: listTileDocs(),
        title: "Documentos", func: (val) {
      if (val) {
        widget.updatePixelPosition(widget.gk);
      }
    }, expController: widget.expController, enabled: widget.enableExpansion);
  }

  Widget listTileDocs() =>
      Consumer<FormProvider>(builder: (builder, form, child) {
        return Column(
          children: [
            //todo CÉDULA DEL PROSPECTO
            expansionTile(context, children: cedula(), title: "Cédula",
                func: (_) {
              setState(() => cedulaB = !cedulaB);
            },
                icon: cedulaB
                    ? const Icon(Icons.remove_circle_outline_sharp)
                    : const Icon(Icons.add_circle_outline_outlined),
                expController: _exp1,
                containerColor: Colors.white,
                expandColorContainer: Colors.white,
                enabled: widget.enableExpansion),
            divider(true),
            //todo IMMPUESTOS PREDIALES
            expansionTile(context,
                children: impuestos(), title: "Impuesto predial", func: (_) {
              setState(() {
                impuestosB = !impuestosB;
              });
            },
                icon: impuestosB
                    ? const Icon(Icons.remove_circle_outline_sharp)
                    : const Icon(Icons.add_circle_outline_outlined),
                containerColor: Colors.white,
                expandColorContainer: Colors.white,
                expController: _exp2,
                enabled: widget.enableExpansion),
            divider(true),
            //todo SERVICIOS BÁSICOS
            expansionTile(context,
                children: planillas(),
                title: "Planilla de servicios básicos", func: (_) {
              setState(() {
                planillaB = !planillaB;
              });
            },
                icon: planillaB
                    ? const Icon(Icons.remove_circle_outline_sharp)
                    : const Icon(Icons.add_circle_outline_outlined),
                containerColor: Colors.white,
                expandColorContainer: Colors.white,
                expController: _exp3,
                enabled: widget.enableExpansion),
            divider(true),
            //todo BURO DE CREDITO
            expansionTile(context,
                children: buroCredito(), title: "Buró de crédito", func: (_) {
              setState(() {
                buroB = !buroB;
              });
            },
                icon: buroB
                    ? const Icon(Icons.remove_circle_outline_sharp)
                    : const Icon(Icons.add_circle_outline_outlined),
                containerColor: Colors.white,
                expandColorContainer: Colors.white,
                expController: _exp4,
                enabled: widget.enableExpansion),
            divider(true),
            //todo JUSTIFICACIÓN DE ACTIVIDAD
            expansionTile(context,
                children: justificacionAct(),
                title: "Justificación de actividad económica", func: (_) {
              setState(() {
                justificacionB = !justificacionB;
              });
            },
                icon: justificacionB
                    ? const Icon(Icons.remove_circle_outline_sharp)
                    : const Icon(Icons.add_circle_outline_outlined),
                containerColor: Colors.white,
                expandColorContainer: Colors.white,
                expController: _exp5,
                enabled: widget.enableExpansion),
            divider(true),
            //todo EXCEPCIÓN
            expansionTile(context,
                children: excepcionWidget(), title: "Excepción", func: (_) {
              setState(() {
                excepcionB = !excepcionB;
              });
            },
                icon: excepcionB
                    ? const Icon(Icons.remove_circle_outline_sharp)
                    : const Icon(Icons.add_circle_outline_outlined),
                containerColor: Colors.white,
                expandColorContainer: Colors.white,
                expController: _exp6,
                enabled: widget.enableExpansion),
            divider(true),
            //todo OTROS DOCUMENTOS
            expansionTile(context, children: otrosDocumentos(), title: "Otros",
                func: (_) {
              setState(() {
                otrosB = !otrosB;
              });
            },
                icon: otrosB
                    ? const Icon(Icons.remove_circle_outline_sharp)
                    : const Icon(Icons.add_circle_outline_outlined),
                containerColor: Colors.white,
                expandColorContainer: Colors.white,
                expController: _exp7,
                enabled: widget.enableExpansion),
            divider(true),
          ],
        );
      });

  Widget cedula() => Consumer<FormProvider>(builder: (builder, form, child) {
        return Column(
          children: [
            divider(false),
            //todo CÉDULA DEL PROSPECTO
            ListTile(
              leading: const Icon(AbiPraxis.cedula, size: 20),
              trailing: validarIconoFuncion(
                  title: cProspecto,
                  pathFrontal: pathFrontalP,
                  pathReverso: pathReversaP,
                  doc: documentoP,
                  type: 1,
                  subtype: 1,
                  function: () => opcionesSubirDocumento(1, 1, cProspecto)),
              title: Text(cProspecto),
            ),
            divider(false),
            //todo CÉDULA DEL CÓNYUGE
            ListTile(
              leading: const Icon(AbiPraxis.cedula, size: 20),
              trailing: validarIconoFuncion(
                  title: cConyuge,
                  pathFrontal: pathFrontalPC,
                  pathReverso: pathReversaPC,
                  doc: documentoPC,
                  type: 1,
                  subtype: 2,
                  function: () => opcionesSubirDocumento(1, 2, cConyuge)),
              title: Text(cConyuge),
            ),
            divider(false),
            //todo CÉDULA DEL GARANTE
            ListTile(
              leading: const Icon(AbiPraxis.cedula, size: 20),
              trailing: validarIconoFuncion(
                  title: cGarante,
                  pathFrontal: pathFrontalG,
                  pathReverso: pathReversaG,
                  doc: documentoG,
                  type: 1,
                  subtype: 2,
                  function: () => opcionesSubirDocumento(1, 3, cGarante)),
              title: Text(cGarante),
            ),
            divider(false),
            //todo CÉDULA DEL CÓNYUGE DEL GARANTE
            ListTile(
              leading: const Icon(AbiPraxis.cedula, size: 20),
              trailing: validarIconoFuncion(
                  title: cConyGarante,
                  pathFrontal: pathFrontalGC,
                  pathReverso: pathReversaGC,
                  doc: documentoGC,
                  type: 1,
                  subtype: 2,
                  function: () => opcionesSubirDocumento(1, 4, cConyGarante)),
              title: Text(cConyGarante),
            ),
            divider(false),
          ],
        );
      });

  Widget impuestos() => Consumer(builder: (builder, form, child) {
        return Column(
          children: [
            divider(true),
            ListTile(
              leading: const Icon(AbiPraxis.impuesto_predial, size: 20),
              trailing: validarIconoFuncion(
                  title: impuesto,
                  doc: pathImpuesto,
                  type: 2,
                  subtype: 1,
                  function: () => opcionesSubirDocumento(2, 1, impuesto)),
              title: Text(impuesto),
            ),
          ],
        );
      });

  Widget planillas() => Column(
        children: [
          divider(true),
          ListTile(
            leading: const Icon(AbiPraxis.plantilla_servicios_basico, size: 20),
            trailing: validarIconoFuncion(
                title: servicio,
                doc: docPlanilla,
                type: 3,
                subtype: 1,
                function: () => opcionesSubirDocumento(3, 1, servicio)),
            title: Text(servicio),
          ),
        ],
      );

  Widget buroCredito() => Column(
        children: [
          divider(true),
          ListTile(
            leading: const Icon(AbiPraxis.buro_credito, size: 20),
            trailing: validarIconoFuncion(
                title: buroProspecto,
                doc: pathBuroProspecto,
                type: 4,
                subtype: 1,
                function: () => opcionesSubirDocumento(4, 1, buroProspecto)),
            title: Text(buroProspecto),
          ),
          divider(true),
          ListTile(
            leading: const Icon(AbiPraxis.buro_credito, size: 20),
            trailing: validarIconoFuncion(
                title: buroGarante,
                doc: pathBuroGarante,
                type: 4,
                subtype: 2,
                function: () => opcionesSubirDocumento(4, 2, buroGarante)),
            title: Text(buroGarante),
          ),
        ],
      );

  Widget justificacionAct() => Column(
        children: [
          divider(true),
          ListTile(
            leading: const Icon(AbiPraxis.impuesto_predial, size: 20),
            trailing: validarIconoFuncion(
                title: justificacion,
                doc: docJustificacion,
                type: 5,
                subtype: 1,
                function: () => opcionesSubirDocumento(5, 1, justificacion)),
            title: Text(justificacion),
          ),
        ],
      );

  Widget excepcionWidget() => Column(
        children: [
          divider(true),
          ListTile(
            leading: const Icon(AbiPraxis.impuesto_predial, size: 20),
            trailing: validarIconoFuncion(
                title: excepcion,
                doc: docJustificacion,
                type: 6,
                subtype: 1,
                function: () => opcionesSubirDocumento(6, 1, excepcion)),
            title: Text(excepcion),
          ),
        ],
      );

  Widget otrosDocumentos() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        var docs = form.documentos.documentos;
        return Column(
          children: [
            divider(false),
            docs.isNotEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: (height * docs.length == 220 ||
                                height * docs.length > 220)
                            ? 220
                            : height * docs.length,
                        child: ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (itemBuilder, i) {
                              return Column(
                                children: [
                                  if (i != 0) divider(true),
                                  ListTile(
                                    leading: const Icon(Icons.document_scanner),
                                    title: Text(docs[i].observacion),
                                    trailing: IconButton(
                                        onPressed: () {
                                          showPDF(docs[i].observacion,
                                              docs[i].codigoDocumento,
                                              foto: docs[i].isPdf == 1
                                                  ? null
                                                  : true);
                                        },
                                        icon: const Icon(
                                            Icons.remove_red_eye_outlined)),
                                  ),
                                ],
                              );
                            }),
                      ),
                      divider(true),
                      TextButton(
                          onPressed: () {
                            opcionesSubirDocumento(7, 1, title);
                          },
                          child: const Text("Subir foto o documento")),
                    ],
                  )
                : Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text("No tiene documentos almacenados"),
                      TextButton(
                          onPressed: () {
                            opcionesSubirDocumento(7, 1, title);
                          },
                          child: const Text("Subir foto o documento")),
                    ],
                  ),
          ],
        );
      });

  Widget validarIconoFuncion(
      {String? doc,
      String? pathFrontal,
      String? pathReverso,
      required int type,
      required int subtype,
      required Function function,
      required title}) {
    if (doc != null ||
        pathFrontal != null ||
        pathReverso != null ||
        (type == 3 && (fotoPlanilla != null || docPlanilla != null)) ||
        (type == 4 && doc != null) ||
        (type == 5 &&
            (fotoJustificacion != null || docJustificacion != null)) ||
        (type == 6 && (fotoExcepcion != null || docExcepcion != null))) {
      return PopupMenuButton(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (val) async {
            if (val == 1) {
              if (type == 1 || type == 2) {
                if (doc != null) {
                  showPDF(title, doc);
                } else {
                  funcionesSubir(subtype, title, 1,
                      type: type, frontal: pathFrontal, reverso: pathReverso);
                }
              } else if (type == 3) {
                if (docPlanilla != null) {
                  showPDF(title, docPlanilla!);
                } else {
                  funcionesSubir(subtype, title, 1,
                      type: type, foto: fotoPlanilla);
                }
              } else if (type == 4) {
                showPDF(title, doc!);
              } else if (type == 5) {
                if (docJustificacion != null) {
                  showPDF(title, docJustificacion!);
                } else {
                  funcionesSubir(subtype, title, 1,
                      type: type, foto: fotoJustificacion);
                }
              } else if (type == 6) {
                if (docExcepcion != null) {
                  showPDF(title, docExcepcion!);
                } else {
                  funcionesSubir(subtype, title, 1,
                      type: type, foto: fotoExcepcion);
                }
              }

              setState(() {
                this.title = title;
                enableVisibility = true;
              });
            } else if (val == 2) {
              opcionesSubirDocumento(type, subtype, title);
            }
          },
          itemBuilder: (context) {
            List<PopupMenuEntry> list = [];

            list.add(
                const PopupMenuItem(value: 1, child: Text("Ver documento")));
            //if (doc != null) {
            if (widget.edit == null || widget.edit!) {
              list.add(
                  const PopupMenuItem(value: 2, child: Text("Actualizar")));
            }
            //}

            return list;
          });
    } else {
      return IconButton(
          onPressed: (widget.edit != null && !widget.edit!)
              ? null
              : () async => await function(),
          icon: const Icon(Icons.add));
    }
  }

  void opcionesSubirDocumento(int type, int? subtype, String title) {
    //1 - 3 - 5 - 6 -7 AMBAS OPCIONES(TOMAR Y SUBIR)
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45))),
        showDragHandle: true,
        context: context,
        builder: (builder) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Seleccione una opción",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (type != 2 && type != 4)
                      GestureDetector(
                        onTap: () async {
                          //if (type == 1) {
                          funcionesSubir(type: type, subtype!, title, 1);
                          //}
                        },
                        child: const Column(
                          children: [
                            Icon(Icons.camera_alt, size: 60),
                            SizedBox(height: 10),
                            Text(
                              "Tomar foto",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    if (type != 2 && type != 4)
                      const SizedBox(
                        height: 90,
                        width: 2,
                        child: VerticalDivider(
                          color: Colors.grey,
                        ),
                      ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        //if (type == 1) {
                        funcionesSubir(type: type, subtype!, title, 2);
                        //}
                      },
                      child: const Column(
                        children: [
                          Icon(Icons.upload, size: 60),
                          SizedBox(height: 10),
                          Text(
                            "Subir PDF",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          );
        });
  }

  void funcionesSubir(int subtype, String title, int metodo,
      {required int type,
      String? frontal,
      String? reverso,
      String? foto,
      String? doc}) async {
    final docs = Provider.of<FormProvider>(context, listen: false).documentos;

    //todo metodo 1: foto, metodo 2: pdf
    if (type == 1) {
      if (metodo == 1) {
        final map = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => SubirFoto(
                      edit: widget.edit,
                      frontal: frontal,
                      reverso: reverso,
                      nombre: title,
                      cedula: true,
                    )));

        if (map != null) {
          if (frontal == null) Navigator.pop(context);
          scaffoldMessenger(context, "Fotos guardadas correctamente",
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ));
          switch (subtype) {
            case 1:
              setState(() {
                documentoP = null;
                pathFrontalP = map["frontal"];
                pathReversaP = map["reverso"];
              });

              //elimina todos los documentos de esta persona que sean pdf
              docs.removeDocuments(
                  idPersona: widget.idPersona!, isPdf: true, tipo: 1);

              //agrega las imágenes de la cédula frontal y reversa
              addDocumentToLocalDatabase(
                  1, widget.idPersona!, pathFrontalP!, false, title);
              addDocumentToLocalDatabase(
                  1, widget.idPersona!, pathReversaP!, false, title);
              break;
            case 2:
              setState(() {
                documentoPC = null;
                pathFrontalPC = map["frontal"];
                pathReversaPC = map["reverso"];
              });

              if (widget.idConyuge != null) {
                //elimina todos los documentos de esta persona que sean pdf
                docs.removeDocuments(
                    idPersona: widget.idConyuge!, isPdf: true, tipo: 1);

                //agrega las imágenes de la cédula frontal y reversa
                addDocumentToLocalDatabase(
                    1, widget.idConyuge!, pathFrontalPC!, false, title);
                addDocumentToLocalDatabase(
                    1, widget.idConyuge!, pathReversaPC!, false, title);
              }

              break;
            case 3:
              setState(() {
                documentoG = null;
                pathFrontalG = map["frontal"];
                pathReversaG = map["reverso"];
              });

              //elimina todos los documentos de esta persona que sean pdf
              docs.removeDocuments(
                  idPersona: widget.idGarante!, isPdf: true, tipo: 1);

              //agrega las imágenes de la cédula frontal y reversa
              addDocumentToLocalDatabase(
                  1, widget.idGarante!, pathFrontalG!, false, title);
              addDocumentToLocalDatabase(
                  1, widget.idGarante!, pathReversaG!, false, title);
              break;
            case 4:
              setState(() {
                documentoGC = null;
                pathFrontalGC = map["frontal"];
                pathReversaGC = map["reverso"];
              });

              if (widget.idConyGarante != null) {
                //elimina todos los documentos de esta persona que sean pdf
                docs.removeDocuments(
                    idPersona: widget.idConyGarante!, isPdf: true, tipo: 1);

                //agrega las imágenes de la cédula frontal y reversa
                addDocumentToLocalDatabase(
                    1, widget.idConyGarante!, pathFrontalGC!, false, title);
                addDocumentToLocalDatabase(
                    1, widget.idConyGarante!, pathReversaGC!, false, title);
              }

              break;
            default:
          }
        }
      } else {
        var doc = await file.openFileExplorer(FileType.custom, context);

        if (doc != null) {
          var newDocument = base64Encode(File(doc).readAsBytesSync());
          scaffoldMessenger(context, "Documento guardado correctamente",
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ));

          switch (subtype) {
            case 1:
              setState(() => documentoP = newDocument);
              setState(() {
                pathFrontalP = null;
                pathReversaP = null;
              });

              //elimina todas las imágenes de esta persona que no sean pdf
              docs.removeDocuments(
                  idPersona: widget.idPersona!, isPdf: false, tipo: 1);

              //agrega el documento de esta persona
              addDocumentToLocalDatabase(
                  1, widget.idPersona!, documentoP!, true, title);

              break;
            case 2:
              setState(() => documentoPC = newDocument);
              setState(() {
                pathFrontalPC = null;
                pathReversaPC = null;
              });
              if (widget.idConyuge != null) {
                //elimina todas las imágenes de esta persona que no sean pdf
                docs.removeDocuments(
                    idPersona: widget.idConyuge!, isPdf: false, tipo: 1);

                //agrega el documento de esta persona
                addDocumentToLocalDatabase(
                    1, widget.idConyuge!, documentoPC!, true, title);
              }
              break;
            case 3:
              setState(() => documentoG = newDocument);
              setState(() {
                pathFrontalG = null;
                pathReversaG = null;
              });
              //elimina todas las imágenes de esta persona que no sean pdf
              docs.removeDocuments(
                  idPersona: widget.idGarante!, isPdf: false, tipo: 1);

              //agrega el documento de esta persona
              addDocumentToLocalDatabase(
                  1, widget.idGarante!, documentoG!, true, title);
              break;
            case 4:
              setState(() => documentoGC = newDocument);
              setState(() {
                pathFrontalGC = null;
                pathReversaGC = null;
              });
              if (widget.idConyGarante != null) {
                //elimina todas las imágenes de esta persona que no sean pdf
                docs.removeDocuments(
                    idPersona: widget.idConyGarante!, isPdf: false, tipo: 1);

                //agrega el documento de esta persona
                addDocumentToLocalDatabase(
                    1, widget.idConyGarante!, documentoGC!, true, title);
              }
              break;
            default:
          }
        }
      }
    } else if (type == 2) {
      var doc = await file.openFileExplorer(FileType.custom, context);

      if (doc != null) {
        var newDocument = base64Encode(File(doc).readAsBytesSync());
        scaffoldMessenger(context, "Documento guardado correctamente",
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            ));

        setState(() => pathImpuesto = newDocument);
        //docs.updateImpustoPredial("predial", pathImpuesto);
        addDocumentToLocalDatabase(
            2, widget.idPersona!, pathImpuesto!, true, title);
      }
    } else if (type == 3) {
      if (metodo == 1) {
        final map = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    SubirFoto(nombre: title, otra: foto, cedula: false)));

        if (map != null) {
          if (foto == null) Navigator.pop(context);
          scaffoldMessenger(context, "Foto guardada correctamente",
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ));

          setState(() {
            fotoPlanilla = map["otra"];
            docPlanilla = null;
          });

          //elimina todos los documentos de esta persona que sean pdf
          docs.removeDocuments(
              idPersona: widget.idPersona!, isPdf: true, tipo: 3);

          //agrega la imagen del servicio básico
          addDocumentToLocalDatabase(
              3, widget.idPersona!, fotoPlanilla!, false, title);
        }
      } else {
        var doc = await file.openFileExplorer(FileType.custom, context);

        if (doc != null) {
          var newDocument = base64Encode(File(doc).readAsBytesSync());
          scaffoldMessenger(context, "Documento guardado correctamente",
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ));

          setState(() => docPlanilla = newDocument);
          setState(() => fotoPlanilla = null);

          //elimina todos los documentos de esta persona que sean pdf
          docs.removeDocuments(
              idPersona: widget.idPersona!, isPdf: false, tipo: 3);

          //agrega la imagen del servicio básico
          addDocumentToLocalDatabase(
              3, widget.idPersona!, docPlanilla!, true, title);
        }
      }
    } else if (type == 4) {
      var doc = await file.openFileExplorer(FileType.custom, context);

      if (doc != null) {
        var newDocument = base64Encode(File(doc).readAsBytesSync());
        scaffoldMessenger(context, "Documento guardado correctamente",
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            ));

        switch (subtype) {
          case 1:
            setState(() => pathBuroProspecto = newDocument);
            //docs.updateBuro("prospecto", pathBuroProspecto);

            //agrega la imagen del servicio básico
            addDocumentToLocalDatabase(
                4, widget.idPersona!, pathBuroProspecto!, true, title);
            break;
          case 2:
            setState(() => pathBuroGarante = newDocument);

            addDocumentToLocalDatabase(
                4, widget.idGarante!, pathBuroGarante!, true, title);
            break;
          default:
        }
      }
    } else if (type == 5) {
      if (metodo == 1) {
        final map = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    SubirFoto(nombre: title, otra: foto, cedula: false)));

        if (map != null) {
          if (foto == null) Navigator.pop(context);
          scaffoldMessenger(context, "Foto guardada correctamente",
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ));

          setState(() {
            fotoJustificacion = map["otra"];
            docJustificacion = null;
          });
          //elimino los documentos que sean pdf
          docs.removeDocuments(
              idPersona: widget.idPersona!, isPdf: true, tipo: 5);

          //ingreso la foto de la justificacion
          addDocumentToLocalDatabase(
              5, widget.idPersona!, fotoJustificacion!, false, title);
        }
      } else {
        var doc = await file.openFileExplorer(FileType.custom, context);

        if (doc != null) {
          var newDocument = base64Encode(File(doc).readAsBytesSync());
          scaffoldMessenger(context, "Documento guardado correctamente",
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ));

          setState(() => docJustificacion = newDocument);
          setState(() => fotoJustificacion = null);
          //elimino los documentos que no sean pdf
          docs.removeDocuments(
              idPersona: widget.idPersona!, isPdf: false, tipo: 5);

          //ingreso la foto de la justificacion
          addDocumentToLocalDatabase(
              5, widget.idPersona!, docJustificacion!, true, title);
        }
      }
    } else if (type == 6) {
      if (metodo == 1) {
        final map = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    SubirFoto(nombre: title, otra: foto, cedula: false)));

        if (map != null) {
          if (foto == null) Navigator.pop(context);
          scaffoldMessenger(context, "Foto guardada correctamente",
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ));

          setState(() {
            fotoExcepcion = map["otra"];
            docExcepcion = null;
          });

          //elimino los documentos de esta persona que sean pdf
          docs.removeDocuments(
              idPersona: widget.idPersona!, isPdf: true, tipo: 6);

          //agrego la nueva foto para este documento
          addDocumentToLocalDatabase(
              6, widget.idPersona!, fotoExcepcion!, false, title);
        }
      } else {
        var doc = await file.openFileExplorer(FileType.custom, context);

        if (doc != null) {
          var newDocument = base64Encode(File(doc).readAsBytesSync());
          scaffoldMessenger(context, "Documento guardado correctamente",
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ));

          setState(() => docExcepcion = newDocument);
          setState(() => fotoExcepcion = null);

          //elimino los documentos de esta persona que no sean pdf
          docs.removeDocuments(
              idPersona: widget.idPersona!, isPdf: false, tipo: 6);

          //agrego la nueva foto para este documento
          addDocumentToLocalDatabase(
              6, widget.idPersona!, docExcepcion!, true, title);
        }
      }
    } else if (type == 7) {
      final Map<String, dynamic> document = {
        "nombre": null,
        "doc": null,
        "foto": null
      };

      if (metodo == 1) {
        final map = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => SubirFoto(
                    nombre: "Otro documento", otra: foto, cedula: false)));

        if (map != null) {
          if (foto == null) Navigator.pop(context);
          scaffoldMessenger(context, "Foto guardada correctamente",
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ));

          var name = await showNameDoc(metodo);

          if (name.isNotEmpty) {
            setState(() {
              document.update("nombre", (val) => name);
              document.update("foto", (val) => map["otra"]);
            });

            addDocumentToLocalDatabase(
                6, widget.idPersona!, document["foto"], false, name);
          } else {
            scaffoldMessenger(context, "No se agregó el documento.",
                icon: const Icon(Icons.error, color: Colors.red));
          }
        }
      } else {
        var doc = await file.openFileExplorer(FileType.custom, context);

        if (doc != null) {
          var bytes = base64Encode(File(doc).readAsBytesSync());
          scaffoldMessenger(context, "Documento guardado correctamente",
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ));

          var name = await showNameDoc(metodo);

          if (name.isNotEmpty) {
            setState(() {
              document.update("nombre", (val) => name);
              document.update("doc", (val) => bytes);
            });

            addDocumentToLocalDatabase(
                6, widget.idPersona!, document["doc"], false, name);
          } else {
            scaffoldMessenger(context, "No se agregó el documento.",
                icon: const Icon(Icons.error, color: Colors.red));
          }
        }
      }
    }
  }

  void addDocumentToLocalDatabase(
      int type, int idPersona, String doc, bool isPdf, String title) async {
    final provider =
        Provider.of<FormProvider>(context, listen: false).documentos;
    final pfrc = UserPreferences();
    int idUser = await pfrc.getIdUser();

    var newDocument = DocumentosSolicitudModel(
        idSolicitud: 0,
        observacion: title,
        isPdf: isPdf ? 1 : 0,
        idPersona: idPersona,
        codigoDocumento: doc,
        tipoDocumento: type,
        usuarioCreacion: idUser,
        estado: "A");

    if (type == 2 || type == 4) {
      provider.validateExists(
          idPersona: idPersona, tipo: type, doc: newDocument);
    } else {
      provider.addDocument(newDocument);
    }
  }

  void showPDF(String title, String doc, {bool? foto}) {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        enableDrag: true,
        isScrollControlled: true,
        builder: (builder) {
          return SizedBox(
            height: Responsive.of(context).hp(70),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                Expanded(
                    child: foto != null && foto
                        ? Image.memory(base64Decode(doc))
                        : SfPdfViewer.memory(base64Decode(doc))),
                const SizedBox(height: 25),
              ],
            ),
          );
        });
  }

  Future<String> showNameDoc(int type) async {
    final txtName = TextEditingController();
    final fkey = GlobalKey<FormState>();

    return showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45))),
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
                width: double.infinity,
                height: Responsive.of(context).hp(25),
                child: SizedBox(
                  width: double.infinity,
                  child: Form(
                    key: fkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Nombre documento",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        InputTextFormFields(
                            validacion: (val) =>
                                val!.isEmpty ? "Campo obligatorio" : null,
                            controlador: txtName,
                            accionCampo: TextInputAction.done,
                            nombreCampo: "Nombre documento",
                            placeHolder: ""),
                        const SizedBox(height: 15),
                        nextButton(
                            width: 110,
                            onPressed: () {
                              if (fkey.currentState!.validate()) {
                                Navigator.pop(context);
                              } else {
                                return;
                              }
                            },
                            text: "Continuar"),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                )),
          );
        }).then((_) {
      setState(() {
        tipoDoc = type;
      });

      return txtName.text;
    });
  }

  void getData() async {
    bool firstP = false;
    bool firstCP = false;
    bool firstG = false;
    bool firstCG = false;

    final form = Provider.of<FormProvider>(context, listen: false).documentos;

    if (widget.idSolicitud != null) {
      final solicitud = await op.obtenerSolicitud(widget.idSolicitud!);

      if (solicitud != null) {
        final docs = jsonDecode(solicitud.documentos!);
        if (docs.isNotEmpty) {
          //obtener documentos del titular
          for (var doc in docs) {
            //validamos el tipo de documento que es
            var parDoc = DocumentosSolicitudModel.fromJson(doc);
            if (parDoc.tipoDocumento == 1) {
              //cedula
              //buscamos la descripción para poder asignar el path donde pertenece
              if (parDoc.observacion == cProspecto) {
                if (parDoc.isPdf == 1) {
                  setState(() {
                    pathFrontalP = null;
                    pathReversaP = null;
                    documentoP = parDoc.codigoDocumento;
                  });
                } else {
                  if (!firstP) {
                    setState(() {
                      documentoP = null;
                      pathFrontalP = parDoc.codigoDocumento;
                    });
                    firstP = true;
                  } else {
                    setState(() {
                      documentoP = null;
                      pathReversaP = parDoc.codigoDocumento;
                    });
                  }
                }
              } else if (parDoc.observacion == cConyuge) {
                if (parDoc.isPdf == 1) {
                  setState(() {
                    pathFrontalPC = null;
                    pathReversaPC = null;
                    documentoPC = parDoc.codigoDocumento;
                  });
                } else {
                  if (!firstCP) {
                    setState(() {
                      documentoPC = null;
                      pathFrontalPC = parDoc.codigoDocumento;
                    });
                    firstCP = true;
                  } else {
                    setState(() {
                      documentoPC = null;
                      pathReversaPC = parDoc.codigoDocumento;
                    });
                  }
                }
              } else if (parDoc.observacion == cGarante) {
                if (parDoc.isPdf == 1) {
                  setState(() {
                    pathFrontalG = null;
                    pathReversaG = null;
                    documentoG = parDoc.codigoDocumento;
                  });
                } else {
                  if (!firstG) {
                    setState(() {
                      documentoG = null;
                      pathFrontalG = parDoc.codigoDocumento;
                    });
                    firstG = true;
                  } else {
                    setState(() {
                      documentoG = null;
                      pathReversaG = parDoc.codigoDocumento;
                    });
                  }
                }
              } else if (parDoc.observacion == cConyGarante) {
                if (parDoc.isPdf == 1) {
                  setState(() {
                    pathFrontalGC = null;
                    pathReversaGC = null;
                    documentoGC = parDoc.codigoDocumento;
                  });
                } else {
                  if (!firstCG) {
                    setState(() {
                      documentoGC = null;
                      pathFrontalGC = parDoc.codigoDocumento;
                    });
                    firstCG = true;
                  } else {
                    setState(() {
                      documentoGC = null;
                      pathReversaGC = parDoc.codigoDocumento;
                    });
                  }
                }
              }
            } else if (parDoc.tipoDocumento == 2) {
              //impuesto predial
              setState(() {
                pathImpuesto = parDoc.codigoDocumento;
              });
            } else if (parDoc.tipoDocumento == 3) {
              //planilla de servicio básico
              if (parDoc.isPdf == 1) {
                setState(() {
                  docPlanilla = parDoc.codigoDocumento;
                  fotoPlanilla = null;
                });
              } else {
                setState(() {
                  docPlanilla = null;
                  fotoPlanilla = parDoc.codigoDocumento;
                });
              }
            } else if (parDoc.tipoDocumento == 4) {
              //buró de crédito
              if (parDoc.observacion == buroProspecto) {
                setState(() => pathBuroProspecto = parDoc.codigoDocumento);
              } else if (parDoc.observacion == buroGarante) {
                setState(() => pathBuroGarante = parDoc.codigoDocumento);
              }
            } else if (parDoc.tipoDocumento == 5) {
              //justificacion
              if (parDoc.isPdf == 1) {
                setState(() {
                  docJustificacion = parDoc.codigoDocumento;
                  fotoJustificacion = null;
                });
              } else {
                setState(() {
                  docJustificacion = null;
                  fotoJustificacion = parDoc.codigoDocumento;
                });
              }
            } else if (parDoc.tipoDocumento == 6) {
              //excepción
              if (parDoc.isPdf == 1) {
                setState(() {
                  docExcepcion = parDoc.codigoDocumento;
                  fotoExcepcion = null;
                });
              } else {
                setState(() {
                  docExcepcion = null;
                  fotoExcepcion = parDoc.codigoDocumento;
                });
              }
            } /*else if (doc.tipoDocumento == 7) {
            //cualquier otro doc
            
          }*/

            form.addDocument(parDoc);
          }
        }
      }
    }
  }
}
