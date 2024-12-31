// ignore_for_file: prefer_null_aware_operators, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:abi_praxis_app/main.dart';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/calendar_model.dart';
import 'package:abi_praxis_app/src/models/solicitud/soliciutd_credito_model.dart';
import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/vender/credito/solicitud/forms/autorizacion_sc.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/vender/credito/solicitud/forms/datos_beneficiario.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/vender/credito/solicitud/forms/datos_personales_sc.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/vender/credito/solicitud/forms/suscripciones.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/alerts/and_alert.dart';
import 'package:abi_praxis_app/utils/alerts/ios_alert.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/cut/diagonal_cuts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../utils/buttons.dart';
import '../../../../../../../../utils/flushbar.dart';
import '../../../../../../../../utils/header.dart';
import '../../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../../../../../../../utils/loading.dart';

class SolicitudCredito extends StatefulWidget {
  int? idSolicitud;
  int? idTipoProducto;
  bool? edit;
  bool? ver;

  SolicitudCredito(
      {this.idTipoProducto, this.edit, this.idSolicitud, this.ver, super.key});

  @override
  State<SolicitudCredito> createState() => _SolicitudCreditoState();
}

class _SolicitudCreditoState extends State<SolicitudCredito> {
  final _scrollController = ScrollController();
  int? idAutorizacion;
  String? contrato;
  late DraggableScrollableController _scrollableController;
  bool enableVisibility = false;
  String titulo = "";
  String path = "";
  int? idPersona;

  //todo GLOBAL KEYS
  final gk1 = GlobalKey();
  final gk2 = GlobalKey();
  final gk3 = GlobalKey();
  final gk4 = GlobalKey();

  final _scKey = GlobalKey<ScaffoldState>();
  //todo TITULAR
  final _fDPkey = GlobalKey<FormState>();
  final _fBkey = GlobalKey<FormState>();
  final _fSPkey = GlobalKey<FormState>();

  bool loading = false;
  //todo EXPANSION TILE VARIABLES
  bool enabledExpansion = true;
  //todo VALIDACION COLORES DATOS PERSONALES
  Color? datosPersonalesC;
  Color? datosPersonalesB;
  Color? suscripcionesC;
  Color? documentosC;
  Color? autorizacionC;

  final _exp1 = ExpansionTileController();
  final _exp2 = ExpansionTileController();
  final _exp3 = ExpansionTileController();
  final _exp4 = ExpansionTileController();

  void startLoading() {
    setState(() {
      loading = true;
    });
  }

  void stopLoading() {
    setState(() {
      loading = false;
    });
  }

  void verFirma(String? titulo, String? path) {
    if (titulo != null && path != null) {
      setState(() {
        enableVisibility = true;
        this.titulo = titulo;
        this.path = path;
      });
    } else {
      setState(() {
        enableVisibility = false;
        this.titulo = "";
        this.path = "";
      });
    }
  }

  //todo FUNCIONES PARA CAMBIAR DE COLOR DE LOS DATOS PERSONALES DEL TITULAR
  void changeColorDatosPersonales(int type) {
    if (type == 1) {
      setState(() => datosPersonalesC = Colors.green);
    } else {
      setState(() => datosPersonalesC = Colors.yellow);
    }
  }

  void changeColorBeneficiario(int type) {
    if (type == 1) {
      setState(() => datosPersonalesB = Colors.green);
    } else {
      setState(() => datosPersonalesB = Colors.yellow);
    }
  }

  void changeColorSuscripciones(int type) {
    if (type == 1) {
      setState(() {
        suscripcionesC = Colors.green;
      });
    } else {
      setState(() {
        suscripcionesC = Colors.yellow;
      });
    }
  }

  //todo FUNCION PARA CAMBIAR DE COLOR DE DOCUMENTOS
  void changeColorDocumento(int type) {
    setState(() => documentosC = Colors.green);
  }

  void changeColorAutorizacion(int type) {
    if (type == 1) {
      setState(() => autorizacionC = Colors.green);
    } else {
      setState(() => autorizacionC = Colors.yellow);
    }
  }

  void updatePixelPosition(GlobalKey key) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        final position = box.localToGlobal(Offset.zero,
            ancestor: context.findRenderObject());
        _scrollController.animateTo(
          _scrollController.offset +
              position.dy -
              AppBar().preferredSize.height -
              125, // Ajusta con la posición actual del scroll
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void getData() async {
    if (widget.idSolicitud != null) {
      final sol = await op.obtenerSolicitud(widget.idSolicitud!);

      if (sol != null) {
        setState(() => idPersona = sol.idPersona);
        setState(() => contrato = sol.codigoContrato);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollableController = DraggableScrollableController();
    getData();
    var form = Provider.of<FormProvider>(context, listen: false);

    Future.delayed(const Duration(milliseconds: 500))
        .then((_) => form.limpiarDatos());

    if ((widget.edit == null || !widget.edit!) &&
        (widget.ver == null || !widget.ver!)) {
      Future.delayed(const Duration(seconds: 1)).then((_) async {
        var numContrato = (Platform.isAndroid
            ? await AndroidAlert().alertCodigoContrato(context)
            : await IosAlert().alertCodigoContrato(context));

        if (numContrato.isNotEmpty) {
          setState(() => contrato = numContrato);
        } else {
          Navigator.pop(context);
          scaffoldMessenger(context,
              "Debe ingresar el código del contrato físico para continuar.",
              icon: const Icon(Icons.error, color: Colors.red), seconds: 3);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var form = Provider.of<FormProvider>(context, listen: false);
        form.limpiarDatos();
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Consumer<FormProvider>(builder: (context, form, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            key: _scKey,
            drawer: DrawerMenu(inicio: false),
            appBar: MyAppBar(key: _scKey).myAppBar(context: context),
            body: Stack(
              children: [
                options(),
                if (loading) loadingWidget(text: "Obteniendo datos...")
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget options() {
    return Column(
      children: [
        header("Productivo", AbiPraxis.productivo, context: context),
        Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Text(
                      "Contrato:",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 1),
                    InkWell(
                      onTap: () async {
                        var numContrato = (Platform.isAndroid
                            ? await AndroidAlert()
                                .alertCodigoContrato(context, num: contrato)
                            : await IosAlert()
                                .alertCodigoContrato(context, num: contrato));

                        if (numContrato.isNotEmpty) {
                          setState(() => contrato = numContrato);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color.fromRGBO(38, 72, 162, 1),
                        ),
                        width: 60,
                        height: 25,
                        child: Center(
                            child: Text(
                          contrato ?? "_ _ _ _ _ _",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ClipPath(
                clipper: DiagonalClipper(),
                child: Container(
                  //margin: const EdgeInsets.only(right: 15),
                  width: 245,
                  height: 35,
                  alignment: Alignment.center,
                  color: const Color.fromRGBO(93, 97, 98, 1),
                  child: const Text(
                    "Solicitud suscripción EU",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        listExpansions(),
      ],
    );
  }

  Widget listExpansions() => Expanded(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  //todo DATOS PERSONALES
                  DatosPersonalesCredito(
                    edit: widget.edit,
                    ver: widget.ver,
                    idSolicitud: widget.idSolicitud,
                    gk: gk1,
                    changeColorDatosPersonales: changeColorDatosPersonales,
                    formKey: _fDPkey,
                    enableExpansion: enabledExpansion,
                    expController: _exp1,
                    startLoading: startLoading,
                    stopLoading: stopLoading,
                    datosPersonalesC: datosPersonalesC,
                    updatePixelPosition: updatePixelPosition,
                  ),
                  //todo DATOS BENEFICIARIO
                  DatosBeneficiario(
                    ver: widget.ver,
                    idSolicitud: widget.idSolicitud,
                    gk: gk2,
                    formKey: _fBkey,
                    enableExpansion: enabledExpansion,
                    startLoading: startLoading,
                    stopLoading: stopLoading,
                    expController: _exp2,
                    changeColorDatosBeneficiario: changeColorBeneficiario,
                    updatePixelPosition: updatePixelPosition,
                    datosPersonalesC: datosPersonalesB,
                  ),
                  //todo PLANES DE SUSCRIPCIÓN
                  PlanesSuscripcion(
                    ver: widget.ver,
                    idSolicitud: widget.idSolicitud,
                    changeColorSuscripciones: changeColorSuscripciones,
                    enableExpansion: enabledExpansion,
                    expController: _exp3,
                    formKey: _fSPkey,
                    gk: gk3,
                    startLoading: startLoading,
                    stopLoading: stopLoading,
                    suscripcionesC: suscripcionesC,
                    updatePixelPosition: updatePixelPosition,
                  ),
                  //todo DOCUMENTOS
                  /*  DocumentosSC(
                    edit: widget.edit,
                    idSolicitud: widget.idSolicitud,
                    gk: gk7,
                    updatePixelPosition: updatePixelPosition,
                    datoDocumentoC: documentosC,
                    changeColorDocumentosC: changeColorDocumento,
                    enableExpansion: enabledExpansion,
                    expController: _exp7,
                    /*   idPersona: widget.idPersona,
                    idGarante: widget.idPersonaGarante,
                    idConyuge: widget.idPersonaConyuge,
                    idConyGarante: widget.idPersonaGarante, */
                  ), */
                  //todo AUTORIZACIÓN
                  AutorizacionSc(
                      ver: widget.ver,
                      firmaCallback: verFirma,
                      edit: widget.edit,
                      idSolicitud: widget.idSolicitud,
                      gk: gk4,
                      changeColorAutorizacionC: changeColorAutorizacion,
                      enableExpansion: enabledExpansion,
                      updatePixelPosition: updatePixelPosition,
                      datoAutorizacionC: autorizacionC,
                      expController: _exp4),
                  //todo BUTTONS
                  const SizedBox(height: 15),
                  buttons(),
                ],
              ),
            ),
            mostrarFirma(),
          ],
        ),
      );

  Widget buttons() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.idSolicitud == null)
                nextButton(
                    onPressed: () => guardarSolicitudPendiente(),
                    text: /*widget.edit ? "Regresar" :*/ "Pendiente",
                    width: 110,
                    background: const Color.fromRGBO(38, 72, 162, 1)),
              nextButton(
                  onPressed: () => validarFormulario(),
                  text: "Finalizar",
                  width: 110),
            ],
          ),
          /*  nextButton(
              onPressed: () {
                final form = Provider.of<FormProvider>(context, listen: false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => ViewPDF(
                                solicitud: SolicitudCreditoModel(
                              usuarioCreacion: 0,
                              idPromotor: 0,
                              idPersona: idPersona ?? 0,
                              codigoContrato: contrato,
                              datosSuscripcion: form.suscripciones.toJson(),
                              datosBeneficiario: form.beneficiario.toJson(),
                              datosPersonales: form.titular.toJson(),
                              documentos:
                                  jsonEncode(form.documentos.documentos),
                              autorizacion: form.autorizacion.toJson(),
                              idTipoProducto: widget.idTipoProducto ?? 1,
                              estado: 2,
                            ))));
              },
              text: "Generar PDF") */
        ],
      );

  void validarFormulario() async {
    final pfrc = UserPreferences();
    final idPromotor = await pfrc.getIdPromotor();
    final idUser = await pfrc.getIdUser();
    final form = Provider.of<FormProvider>(context, listen: false);
    final db = Operations();

    //todo VALIDAR DATOS PARA PODER INGRESAR LOS DATOS O ACTUALIZAR
    if (!validarDatosTitular()) return;
    if (!validarDatosBeneficiario()) return;
    if (!validarDatosSuscripciones()) return;

    if (form.autorizacion.getValueAutorizacion("titular") == null) {
      scaffoldMessenger(context, "Falta firma del titular");
      _exp4.expand();
      cerrarTabs(4);
      setState(() => autorizacionC = Colors.red);
      return;
    }

    //todo VALIDAR DOCUMENTOS SUBIDOS
    setState(() => documentosC = Colors.yellow);
    //todo VALIDAR AUTORIZACIONES
    setState(() => autorizacionC = Colors.yellow);

    if (idPersona == null) {
      final person = PersonaModel(
          usuarioCreacion: 1,
          nombres: form.beneficiario.getValueBeneficiario("nombres") ?? "",
          apellidos: form.beneficiario.getValueBeneficiario("apellidos") ?? "",
          celular1: form.beneficiario.getValueBeneficiario("celular1"),
          celular2: form.beneficiario.getValueBeneficiario("celular2"),
          numeroIdentificacion:
              form.beneficiario.getValueBeneficiario("numero_identificacion"),
          estado: "A");

      final idP = await db.insertarPersona(person, isProsp: true);

      setState(() => idPersona = idP);
    }

    final agenda = CalendarModel(
        usuarioCreacion: 1,
        categoriaProducto: 4,
        gestion: 3,
        idPersona: idPersona!,
        lugarReunion:
            form.beneficiario.getValueBeneficiario("direccion_entrega") ?? "",
        medioContacto: 1,
        producto: 5,
        resultadoReunion: 0,
        fechaReunion: DateFormat("yyyy-MM-dd").format(DateTime.now()),
        latitud: form.beneficiario.getValueBeneficiario("latitud"),
        longitud: form.beneficiario.getValueBeneficiario("longitud"),
        horaInicio: DateFormat("HH:mm").format(DateTime.now()),
        horaFin: DateFormat("HH:mm")
            .format(DateTime.now().add(const Duration(minutes: 15))),
        estado: 0,
        idPromotor: idPromotor);

    await op.insertarAgenda(agenda);

    final solicitud = SolicitudCreditoModel(
        idPersona: idPersona!,
        codigoContrato: contrato,
        idTipoProducto: widget.idTipoProducto ?? 0,
        usuarioCreacion: idUser,
        idPromotor: idPromotor,
        datosPersonales: form.titular.toJson(),
        datosSuscripcion: form.suscripciones.toJson(),
        datosBeneficiario: form.beneficiario.toJson(),
        documentos: jsonEncode(form.documentos.documentos),
        autorizacion: form.autorizacion.toJson(),
        estado: 2);

    setState(() => loading = true);
    var res = 0;

    if (widget.edit == null || widget.idSolicitud == null) {
      res = await op.insertarSolicitud(solicitud);
    } else {
      res = await op.actualizarSolicitud(solicitud, widget.idSolicitud!);
    }

    var listDocuments = form.documentos.documentos;

    if (listDocuments.isNotEmpty) {
      for (var doc in listDocuments) {
        //actualizo id de la solicitud al id ingresado
        if (doc.idDocumento != null) {
          var update =
              await op.actualizarDocumentoSolicitud(doc, doc.idDocumento!);
          debugPrint(
              "documento de la solicitud: ${update == 1 ? "ACTUALIZADO" : "NO ACTUALIZADO"}");
        } else {
          doc.idSolicitud = res;
          var insertDoc = await op.insertarDocumentoSolicitud(doc);

          debugPrint(
              "documento de la solicitud: ${insertDoc != 0 ? "AGREGADO" : "NO AGREGADO"}");
        }
      }
    }

    setState(() => loading = false);

    if (res != 0) {
      Navigator.pop(context);
      scaffoldMessenger(context, "Solicitud guardada correctamente",
          icon: const Icon(Icons.check, color: Colors.green));
    } else {
      scaffoldMessenger(
          context, "No se generó la solicitud, inténtelo de nuevo más tarde",
          icon: const Icon(Icons.error, color: Colors.red));
    }
  }

  bool validarDatosTitular() {
    bool ok = false;
    //todo validamos el estado del formulario de datos personasles, si está lleno avanza, caso contrario regresa error campos obligatorios
    if (!_fDPkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos del titular");
      _exp1.expand();
      cerrarTabs(1);
      setState(() => datosPersonalesC = Colors.red);

      return false;
    } else {
      setState(() => ok = true);
    }

    return ok;
  }

  bool validarDatosBeneficiario() {
    bool ok = false;

    if (!_fBkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos del beneficiario");
      _exp2.expand();
      cerrarTabs(2);
      setState(() => datosPersonalesB = Colors.red);

      return false;
    } else {
      setState(() => ok = true);
    }
    return ok;
  }

  bool validarDatosSuscripciones() {
    bool ok = false;
    if (!_fSPkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos de la suscripción");
      _exp3.expand();
      cerrarTabs(3);
      setState(() => suscripcionesC = Colors.red);

      return false;
    } else {
      setState(() => ok = true);
    }

    return ok;
  }

  void guardarSolicitudPendiente() async {
    final pfrc = UserPreferences();
    final idPromotor = await pfrc.getIdPromotor();
    final idUser = await pfrc.getIdUser();
    final form = Provider.of<FormProvider>(context, listen: false);
    final db = Operations();

    //todo validamos los datos necesarios para poder realizar la inserción de la solicitud en estado pendiente
    if (!validarDatosTitular()) return;
    if (!validarDatosBeneficiario()) return;
    setState(() => loading = true);

    //todo creamos y guardamos al beneficiario en la base de datos local
    final person = PersonaModel(
        usuarioCreacion: 1,
        nombres: form.beneficiario.getValueBeneficiario("nombres") ?? "",
        apellidos: form.beneficiario.getValueBeneficiario("apellidos") ?? "",
        celular1: form.beneficiario.getValueBeneficiario("celular1"),
        celular2: form.beneficiario.getValueBeneficiario("celular2"),
        numeroIdentificacion:
            form.beneficiario.getValueBeneficiario("numero_identificacion"),
        estado: "A");

    final idP = await db.insertarPersona(person, isProsp: true);

    setState(() => idPersona = idP);

    //todo creamos y guardamos la solicitud en estado pendiente
    final solicitud = SolicitudCreditoModel(
        codigoContrato: contrato,
        usuarioCreacion: idUser,
        idPersona: idPersona!,
        idPromotor: idPromotor,
        idTipoProducto: 1,
        datosPersonales: form.titular.toJson(),
        datosSuscripcion: form.suscripciones.toJson(),
        datosBeneficiario: form.beneficiario.toJson(),
        documentos: jsonEncode(form.documentos.documentos),
        autorizacion: form.autorizacion.toJson(),
        estado: 1);

    var res = await op.insertarSolicitud(solicitud);

    setState(() => loading = false);

    if (res != 0) {
      Navigator.pop(context);
      scaffoldMessenger(context, "Solicitud guardada con estado pendiente",
          icon: const Icon(Icons.check, color: Colors.green));
    } else {
      scaffoldMessenger(
          context, "No se generó la solicitud, inténtelo de nuevo más tarde",
          icon: const Icon(Icons.error, color: Colors.red));
    }
  }

  void cerrarTabs(int index) {
    switch (index) {
      case 1:
        setState(() {
          _exp2.collapse();
          _exp3.collapse();
          _exp4.collapse();
        });
      case 2:
        setState(() {
          _exp1.collapse();
          _exp3.collapse();
          _exp4.collapse();
        });
      case 3:
        setState(() {
          _exp1.collapse();
          _exp2.collapse();
          _exp4.collapse();
        });
      case 4:
        setState(() {
          _exp1.collapse();
          _exp2.collapse();
          _exp3.collapse();
        });
    }
  }

  //todo FUNCIÓN PARA MOSTRAR FIRMA
  Widget mostrarFirma() {
    return Visibility(
      visible: enableVisibility,
      child: DraggableScrollableSheet(
          shouldCloseOnMinExtent: true,
          controller: _scrollableController,
          maxChildSize: 0.4,
          minChildSize: 0.15,
          initialChildSize: 0.20,
          builder: (builder, scroll) {
            return Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 15,
                        color: Colors.black,
                        blurStyle: BlurStyle.outer)
                  ]),
              child: SingleChildScrollView(
                controller: scroll,
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: 40,
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () {
                            setState(() => enableVisibility = false);
                          },
                          icon: const Icon(Icons.close, color: Colors.black)),
                    ),
                    Text(
                      titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    if (path.isNotEmpty) Image.memory(base64Decode(path))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
