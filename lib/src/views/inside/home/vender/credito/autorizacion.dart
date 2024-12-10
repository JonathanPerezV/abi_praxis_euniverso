// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'dart:convert';
import 'dart:io';

import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/src/models/autorizacion/autorizacion_model.dart';
import 'package:abi_praxis_app/src/models/autorizacion/documento_aut_model.dart';
import 'package:abi_praxis_app/src/models/usuario/contactos/contactos_model.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/prospectos/agregar_prospecto.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/credito/firma.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/credito/solicitud/solicitud.dart';
import 'package:abi_praxis_app/utils/alerts/and_alert.dart';
import 'package:abi_praxis_app/utils/alerts/ios_alert.dart';
import 'package:abi_praxis_app/utils/buttons.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/expansiontile.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:abi_praxis_app/utils/list/lista_autorizacion_consulta.dart';
import 'package:abi_praxis_app/utils/loading.dart';
import 'package:abi_praxis_app/utils/textFields/input_text_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../../utils/app_bar.dart';
import '../../../../../../utils/cut/diagonal_cuts.dart';
import '../../../../../../utils/textFields/field_formater.dart';
import '../../../../../controller/dataBase/operations.dart';
import '../../../../../models/usuario/persona_model.dart';
import '../../../lateralMenu/drawer_menu.dart';

class AutorizacionConsulta extends StatefulWidget {
  int? idProducto;
  int? idAutorizacion;
  bool edit;
  bool? ver;
  AutorizacionConsulta(
      {required this.edit,
      this.idAutorizacion,
      this.ver,
      super.key,
      this.idProducto});

  @override
  State<AutorizacionConsulta> createState() => _AutorizacionConsultaState();
}

class _AutorizacionConsultaState extends State<AutorizacionConsulta> {
  final sckey = GlobalKey<ScaffoldState>();
  late DraggableScrollableController _scrollableController;
  bool loading = false;

  FocusNode? _focusNodeBus,
      _focusNodeCT,
      _focusNodeNT,
      _focusNodeAT,
      _focusNodeCCT,
      _focusNodeNCT,
      _focusNodeACT,
      _focusNodeCG,
      _focusNodeNG,
      _focusNodeAG,
      _focusNodeCCG,
      _focusNodeNCG,
      _focusNodeACG,
      _focusNodeRL,
      _focusNodeAE,
      _focusNodeSE,
      _focusNodeTF,
      _focusNodeTFN,
      _focusNodeDR,
      _focusNodeF,
      _focusNodeMT,
      _focusNodePL,
      _focusNodeCTA = FocusNode();

  final op = Operations();
  final andAlert = AndroidAlert();
  final iosAlert = IosAlert();

  Color? titularColor;
  Color? garanteColor;
  Color? actividadColor;
  Color? solicitudColor;
  Color? autorizacionColor;

  bool buscadorB = true;
  bool enableAllFields = true;
  bool hasSolicitud = true;

  //todo MODELOS PARA OBTENER DATOS
  PersonaModel? conyugeT;
  PersonaModel? garante;
  PersonaModel? conyugeG;

  //todo VARIABLES DE PERSONAS A CREAR
  int? idPersonaCProspecto;
  int? idPersonaGarante;
  int? idPersonaCGarante;

  //todo VARIABLES BUSCADOR DE PROSPECTO
  bool enabledExpansionTile = false;
  List<PersonaModel> contactos = [];
  List<PersonaModel> _searchList = [];
  bool showContacts = false;
  final txtBuscador = TextEditingController();
  int? idPersona;

  //todo TEXT EDITING CONTROLLER TITULAR
  final txtcedulaT = TextEditingController();
  final txtNombresT = TextEditingController();
  final txtApellidosT = TextEditingController();
  final txtCedulaTC = TextEditingController();
  final txtNombresTC = TextEditingController();
  final txtApellidosTC = TextEditingController();

  //todo TEXT EDITING CONTROLLER GARANTE
  final txtcedulaG = TextEditingController();
  final txtNombresG = TextEditingController();
  final txtApellidosG = TextEditingController();
  final txtCedulaGC = TextEditingController();
  final txtNombresGC = TextEditingController();
  final txtApellidosGC = TextEditingController();

  //todo FORM KEY GROUP
  final GlobalKey<FormState> _fkeyT = GlobalKey<FormState>();
  final _fkeyG = GlobalKey<FormState>();
  final _fkeyA = GlobalKey<FormState>();
  final _fkeyP = GlobalKey<FormState>();

  //todo EXPANSION TILE CONTROLLER
  final expController1 = ExpansionTileController();
  final expController2 = ExpansionTileController();
  final expController3 = ExpansionTileController();
  final expController4 = ExpansionTileController();
  final expController5 = ExpansionTileController();

  //todo OPCIÓN DE ACTIVIDAD ECONÓMICA
  Map<String, dynamic>? textRelacion;
  int? idRleacionLaboral;
  Map<String, dynamic>? textActividadE;
  String? codActividadE;
  Map<String, dynamic>? textSectorE;
  int? idSectorE;
  List<Map<String, dynamic>> recomendaciones = [];
  final txtActividadE = TextEditingController();
  final txtTiempoFunc = TextEditingController();
  final txtTelefonoAE = TextEditingController();
  final txtDireccionTAE = TextEditingController();

  //todo SOLICITUD DE PRODUCTO
  Map<String, dynamic>? textFuente;
  int? idFuente;
  final txtMontoSolicitado = TextEditingController();
  Map<String, dynamic>? textPlazo;
  int? idPlazo;
  final txtCuotaAPagar = TextEditingController();

  //todo OPCIÓN DE AUTORIZACIÓN DE CRÉDITO
  String? firmaProspectoPath;
  String? firmaGarantePath;
  String? firmaCProspectoPath;
  String? firmaCGarantePath;
  bool enableVisibility = false;
  String currentPath = "";
  String title = "";
  String titleProspecto = "Firma de prospecto";
  String titleGarante = "Firma de garante";
  String titleCProspecto = "Firma de cónyuge / conviviente\ndel prospecto";
  String titleCGarante = "Firma de cónyuge / conviviente\ndel garante";

  AutorizacionModel? aut;

  void obtenerProspectos() async {
    final personas = await op.obtenerProspectos();

    if (personas.isNotEmpty) {
      setState(() => contactos = personas);
      setState(() => _searchList = personas);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollableController = DraggableScrollableController();
    if (widget.ver != null && widget.ver!) {
      validarSolicitud();
      loading = true;
      enableAllFields = false;
      getAllData();
    }
    if (widget.edit) {
      loading = true;
      getAllData();
    } else {
      loading = true;
      obtenerProspectos();
    }

    loading = false;
  }

  void validarSolicitud() async {
    var res = await op.obtenerSolicitudXAut(widget.idAutorizacion!);
    if (res != null) {
      setState(() => hasSolicitud = true);
    } else {
      setState(() => hasSolicitud = false);
    }
  }

  void getAllData() async {
    final data = await op.obtenerAutorizacion(widget.idAutorizacion!);
    if (data != null) {
      setState(() => aut = data);
      PersonaModel? persona = await op.obtenerPersona(data.idPersona);

      if (data.idCProspecto != null) {
        conyugeT = await op.obtenerPersona(data.idCProspecto!);
        setState(() => idPersonaCProspecto = conyugeT!.idPersona);
      }

      if (data.idGarante != null) {
        garante = await op.obtenerPersona(data.idGarante!);
        setState(() => idPersonaGarante = garante!.idPersona);
      }

      if (data.idCGarante != null) {
        conyugeG = await op.obtenerPersona(data.idCGarante!);
        setState(() => idPersonaCGarante = conyugeG!.idPersona);
      }

      setState(() => enabledExpansionTile = true);
      setState(() => buscadorB = false);
      setState(() {
        //todo DATOS DEL TITULAR
        idPersona = persona!.idPersona!;
        txtcedulaT.text = persona.numeroIdentificacion ?? "";
        txtNombresT.text = persona.nombres;
        txtApellidosT.text = persona.apellidos;
        txtCedulaTC.text =
            conyugeT != null && conyugeT!.numeroIdentificacion != null
                ? conyugeT!.numeroIdentificacion!
                : "";
        txtNombresTC.text = conyugeT != null ? conyugeT!.nombres : "";
        txtApellidosTC.text = conyugeT != null ? conyugeT!.apellidos : "";
        validarColorTitular();
        //todo DATOS DEL GARANTE

        txtcedulaG.text =
            garante != null && garante!.numeroIdentificacion != null
                ? garante!.numeroIdentificacion!
                : "";
        txtNombresG.text = garante != null ? garante!.nombres : "";
        txtApellidosG.text = garante != null ? garante!.apellidos : "";
        txtCedulaGC.text =
            conyugeG != null && conyugeG!.numeroIdentificacion != null
                ? conyugeG!.numeroIdentificacion!
                : "";
        txtNombresGC.text = conyugeG != null ? conyugeG!.nombres : "";
        txtApellidosGC.text = conyugeG != null ? conyugeG!.apellidos : "";
      });
      validarColorGarante();

      //todos DATOS DE ACTIVIDAD ECONÓMICA
      if (data.relacionLaboral != null) {
        var rl = listaRelacionLab
            .where((e) => e["id"] == data.relacionLaboral!)
            .toList()[0];

        setState(() => textRelacion = rl);
        setState(() => idRleacionLaboral = rl["id"]);
      }

      if (data.codActividad != null && data.codActividad != "") {
        var a = listaActividades
            .where((e) => e["cod"] == data.codActividad)
            .toList()[0];

        setState(() => txtActividadE.text = a["nombre"]);
        setState(() => codActividadE = a["cod"]);
      }

      if (data.sectorEconomico != null) {
        var se = listaSectorE
            .where((e) => e["id"] == data.sectorEconomico!)
            .toList()[0];

        setState(() => textSectorE = se);
        setState(() => idSectorE = se["id"]);

        setState(() {
          txtTiempoFunc.text = data.tiempoFunciones ?? "";
          txtTelefonoAE.text = data.telefonoTrabajo ?? "";
          txtDireccionTAE.text = persona!.direccionTrabajo!;
        });
      }

      setState(() => txtTelefonoAE.text = data.telefonoTrabajo!);
      setState(() => txtDireccionTAE.text = persona!.direccionTrabajo ?? "");
      validarColorAE();

      //todo DATOS SOLICITUD DE PRODUCTO
      if (data.fuente != null) {
        var f = listaFuente.where((e) => e["id"] == data.fuente!).toList()[0];

        setState(() => textFuente = f);
        setState(() => idFuente = f["id"]);
      }

      setState(() => txtMontoSolicitado.text = data.monto ?? "");

      if (data.plazo != null) {
        var p = listaPlazo
            .where((e) => e["nombre"].contains("${data.plazo}"))
            .toList()[0];

        setState(() => textPlazo = p);
        setState(() => idPlazo = p["id"]);
      }

      setState(() => txtCuotaAPagar.text = data.cuota ?? "");
      validarColorSolicitarProducto();

      //todo DATOS AUTORIZACIÓN
      final docs = await op.obtenerDocsXaut(widget.idAutorizacion!);

      if (docs.isNotEmpty) {
        for (var i = 0; i < docs.length; i++) {
          if (docs[i].codDoc == "P") {
            setState(() => firmaProspectoPath = docs[i].codImg);
          }

          if (docs[i].codDoc == "G") {
            setState(() => firmaGarantePath = docs[i].codImg);
          }

          if (docs[i].codDoc == "PC") {
            setState(() => firmaCProspectoPath = docs[i].codImg);
          }

          if (docs[i].codDoc == "GC") {
            setState(() => firmaCGarantePath = docs[i].codImg);
          }
        }
      }

      validarColorAutorizacion();
    } else {
      Navigator.pop(context);
      scaffoldMessenger(context, "No se encontró la autorización.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<FormProvider>(builder: (context, form, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          key: sckey,
          appBar: MyAppBar(key: sckey).myAppBar(context: context),
          drawer: DrawerMenu(inicio: false),
          body: Stack(
            children: [options(), mostrarFirma(title, currentPath)],
          ),
        );
      }),
    );
  }

  Widget options() {
    return Column(
      children: [
        header("Productivo", AbiPraxis.productivo, context: context),
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
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
                          "Autorización de consulta",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            //todo BUSCADOR DE PROSPECTO
                            buscador(),
                            const SizedBox(height: 10),
                            //todo Formulario del titular
                            expansionTile(context,
                                enabled: enabledExpansionTile,
                                title: "Datos titular",
                                children: formularioTitular(context),
                                func: (value) {
                              if (value) cerrarTabs(1);
                              validarColorTitular();
                            },
                                color: titularColor,
                                expController: expController1),
                            const SizedBox(height: 5),
                            //todo Formulario del garante
                            expansionTile(context,
                                enabled: enabledExpansionTile,
                                children: formularioGarante(context),
                                title: "Datos garante", func: (value) {
                              if (value) cerrarTabs(2);
                              validarColorGarante();
                            },
                                color: garanteColor,
                                expController: expController2),
                            const SizedBox(height: 5),
                            //todo Formulario de la actividad económica
                            expansionTile(context,
                                enabled: enabledExpansionTile,
                                children: formularioActividadEconomica(),
                                title: "Actividad económica", func: (value) {
                              if (value) cerrarTabs(3);
                              validarColorAE();
                            },
                                color: actividadColor,
                                expController: expController3),
                            const SizedBox(height: 5),
                            //todo Formulario de solicitud de producto
                            expansionTile(context,
                                enabled: enabledExpansionTile,
                                children: formularioSolicitudP(),
                                title: "Solicitud de producto", func: (value) {
                              if (value) cerrarTabs(4);
                              validarColorSolicitarProducto();
                            },
                                color: solicitudColor,
                                expController: expController4),
                            const SizedBox(height: 5),
                            //todo Formulario de la autorización
                            expansionTile(context,
                                enabled: enabledExpansionTile,
                                children: documentosAutorizacion(),
                                title: "Autorización", func: (value) {
                              if (value) cerrarTabs(5);
                              validarColorAutorizacion();
                            },
                                color: autorizacionColor,
                                expController: expController5),
                            const SizedBox(height: 15),
                            if (enableAllFields && enabledExpansionTile)
                              buttons(),
                            if (enableAllFields || !hasSolicitud)
                              const SizedBox(height: 15),
                            if (!hasSolicitud)
                              nextButton(
                                  width: 160,
                                  onPressed: () async {
                                    setState(() => loading = true);
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => SolicitudCredito(
                                                actividadEcon: aut != null
                                                    ? aut!.actividad
                                                    : null,
                                                codActividad: aut != null
                                                    ? aut!.codActividad
                                                    : null,
                                                idPlazo: aut != null
                                                    ? aut!.plazo
                                                    : null,
                                                idRleacionLaboral: aut != null
                                                    ? aut!.relacionLaboral
                                                    : null,
                                                idSector: aut != null
                                                    ? aut!.sectorEconomico
                                                    : null,
                                                tiempoFuncionamiento:
                                                    aut != null
                                                        ? aut!.tiempoFunciones
                                                        : null,
                                                monto: aut != null
                                                    ? aut!.monto
                                                    : null,
                                                idFuente: aut != null
                                                    ? aut!.fuente
                                                    : null,
                                                idAutorizacion:
                                                    widget.idAutorizacion,
                                                idPersona: idPersona!,
                                                idPersonaConyuge:
                                                    idPersonaCProspecto,
                                                idPersonaGarante:
                                                    idPersonaGarante,
                                                idConyugeGarante:
                                                    idPersonaCGarante)));
                                    setState(() => loading = false);
                                  },
                                  text: "Empezar solicitud",
                                  background:
                                      const Color.fromRGBO(38, 72, 162, 1)),
                          ],
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: showContacts ? 1 : 0,
                        duration: const Duration(milliseconds: 500),
                        child: Visibility(
                          visible: showContacts,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 70, left: 10, right: 10),
                            width: double.infinity, //250,
                            //height: 225,
                            child: Material(
                              borderRadius: BorderRadius.circular(15),
                              elevation: 4,
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: _searchList.length,
                                    itemBuilder: (itemBuilder, i) {
                                      return InkWell(
                                        onTap: () =>
                                            selectContacto(_searchList[i]),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          color: Colors.white,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white,
                                            ),
                                            height: 45,
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Row(
                                              children: [
                                                Text(
                                                  getNamePros(
                                                          _searchList[i]
                                                              .nombres!,
                                                          _searchList[i]
                                                              .apellidos!)
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                      _searchList[i].celular1 ??
                                                          ""),
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              if (loading) loadingWidget()
            ],
          ),
        ),
      ],
    );
  }

  Widget buscador() {
    return Container(
      //padding: const EdgeInsets.only(left: 15, right: 15),
      child: InputTextFormFields(
          habilitado: buscadorB,
          focus: _focusNodeBus,
          icon: IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  showContacts = false;
                  txtBuscador.clear();
                });
              },
              icon: const Icon(Icons.cancel)),
          prefixIcon: const Icon(Icons.search),
          onChanged: (value) {
            if (value!.isNotEmpty) {
              setState(() => showContacts = true);
              buildSearchList(value);
            } else {
              setState(() => _searchList = contactos);
              setState(() => showContacts = false);
            }
          },
          inputBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          controlador: txtBuscador,
          accionCampo: TextInputAction.search,
          nombreCampo: "Buscar prospecto",
          placeHolder: "Ingrese el nombre del prospecto"),
    );
  }

  //todo FORMULARIOS Y BOTONES
  Widget formularioTitular(BuildContext context) => Form(
        key: _fkeyT,
        child: Column(
          children: [
            //todo NÚMERO DE CÉDULA
            InputTextFormFields(
                habilitado: enableAllFields,
                focus: _focusNodeCT,
                validacion: (value) =>
                    value!.isEmpty ? "Campo obligatorio*" : null,
                onChanged: (_) => validarColorTitular(),
                controlador: txtcedulaT,
                icon: IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    onPressed: () {}),
                prefixIcon: const Icon(AbiPraxis.cedula, size: 18),
                accionCampo: TextInputAction.next,
                nombreCampo: "Número de cédula",
                tipoTeclado: TextInputType.number,
                placeHolder: "Ingrese el número de cédula"),
            const SizedBox(height: 10),
            //todo NOMBRES
            InputTextFormFields(
                habilitado: enableAllFields,
                focus: _focusNodeNT,
                validacion: (value) =>
                    value!.isEmpty ? "Campo obligatorio*" : null,
                onChanged: (_) => validarColorTitular(),
                controlador: txtNombresT,
                prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                accionCampo: TextInputAction.next,
                nombreCampo: "Nombres",
                placeHolder: "Ingrese los nombres"),
            const SizedBox(height: 10),
            //todo APELLIDOS
            InputTextFormFields(
                habilitado: enableAllFields,
                focus: _focusNodeAT,
                validacion: (value) =>
                    value!.isEmpty ? "Campo obligatorio*" : null,
                onChanged: (_) => validarColorTitular(),
                controlador: txtApellidosT,
                prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                accionCampo: TextInputAction.next,
                nombreCampo: "Apellidos",
                placeHolder: "Ingrese los apellidos"),
            const SizedBox(height: 10),
            //todo CÉDULA CÓNYUGUE/CONVIVIENTE
            InputTextFormFields(
                habilitado: enableAllFields,
                focus: _focusNodeCCT,
                onChanged: (_) => validarColorTitular(),
                controlador: txtCedulaTC,
                icon: IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    onPressed: () {}),
                prefixIcon: const Icon(AbiPraxis.cedula, size: 18),
                accionCampo: TextInputAction.next,
                nombreCampo: "Cédula del cónyuge / conviviente",
                tipoTeclado: TextInputType.number,
                placeHolder: "Ingrese el número de cédula"),
            const SizedBox(height: 10),
            //todo NOMBRES CÓNYUGE
            InputTextFormFields(
                focus: _focusNodeNCT,
                onChanged: (_) => validarColorTitular(),
                controlador: txtNombresTC,
                validacion: (value) {
                  if (txtCedulaTC.text.isNotEmpty) {
                    return value!.isEmpty ? "Campo obligatorio*" : null;
                  } else {
                    return null;
                  }
                },
                prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                habilitado: enableAllFields
                    ? txtCedulaTC.text.isNotEmpty
                        ? true
                        : false
                    : false,
                accionCampo: TextInputAction.next,
                nombreCampo: "Nombre del cónyuge / conviviente",
                placeHolder: "Ingrese los nombres"),
            const SizedBox(height: 10),
            //todo APELLIDOS CONYUGE
            InputTextFormFields(
                focus: _focusNodeACT,
                onChanged: (_) => validarColorTitular(),
                controlador: txtApellidosTC,
                validacion: (value) {
                  if (txtCedulaTC.text.isNotEmpty) {
                    return value!.isEmpty ? "Campo obligatorio*" : null;
                  } else {
                    return null;
                  }
                },
                habilitado: enableAllFields
                    ? txtCedulaTC.text.isNotEmpty
                        ? true
                        : false
                    : false,
                prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                accionCampo: TextInputAction.next,
                nombreCampo: "Apellidos del cónyuge / conviviente",
                placeHolder: "Ingrese los apellidos"),
            const SizedBox(height: 10),
          ],
        ),
      );

  Widget formularioGarante(BuildContext context) => Form(
        key: _fkeyG,
        child: Column(
          children: [
            //todo NÚMERO DE CÉDULA
            InputTextFormFields(
                habilitado: enableAllFields,
                focus: _focusNodeCG,
                validacion: (value) =>
                    value!.isEmpty ? "Campo obligatorio*" : null,
                onChanged: (_) => validarColorGarante(),
                controlador: txtcedulaG,
                icon: IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    onPressed: () {}),
                prefixIcon: const Icon(AbiPraxis.cedula, size: 18),
                accionCampo: TextInputAction.next,
                nombreCampo: "Número de cédula",
                tipoTeclado: TextInputType.number,
                placeHolder: "Ingrese el número de cédula"),
            const SizedBox(height: 10),
            //todo NOMBRES
            InputTextFormFields(
                habilitado: enableAllFields,
                focus: _focusNodeNG,
                validacion: (value) =>
                    value!.isEmpty ? "Campo obligatorio*" : null,
                onChanged: (_) => validarColorGarante(),
                controlador: txtNombresG,
                prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                accionCampo: TextInputAction.next,
                nombreCampo: "Nombres",
                placeHolder: "Ingrese los nombres"),
            const SizedBox(height: 10),
            //todo APELLIDOS
            InputTextFormFields(
                habilitado: enableAllFields,
                focus: _focusNodeAG,
                validacion: (value) =>
                    value!.isEmpty ? "Campo obligatorio*" : null,
                onChanged: (_) => validarColorGarante(),
                controlador: txtApellidosG,
                prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                accionCampo: TextInputAction.next,
                nombreCampo: "Apellidos",
                placeHolder: "Ingrese los apellidos"),
            const SizedBox(height: 10),
            //todo CÉDULA CONYUGUE/CONVIVIENTE
            InputTextFormFields(
                habilitado: enableAllFields,
                focus: _focusNodeCCG,
                onChanged: (_) => validarColorGarante(),
                controlador: txtCedulaGC,
                icon: IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    onPressed: () {}),
                prefixIcon: const Icon(AbiPraxis.cedula, size: 18),
                accionCampo: TextInputAction.next,
                nombreCampo: "Cédula del cónyuge / conviviente",
                tipoTeclado: TextInputType.number,
                placeHolder: "Ingrese el número de cédula"),
            const SizedBox(height: 10),
            //todo NOMBRES CONYUGE
            InputTextFormFields(
                focus: _focusNodeNCG,
                onChanged: (_) => validarColorGarante(),
                controlador: txtNombresGC,
                validacion: (value) {
                  if (txtCedulaGC.text.isNotEmpty) {
                    return value!.isEmpty ? "Campo obligatorio*" : null;
                  } else {
                    return null;
                  }
                },
                prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                habilitado: enableAllFields
                    ? txtCedulaGC.text.isNotEmpty
                        ? true
                        : false
                    : false,
                accionCampo: TextInputAction.next,
                nombreCampo: "Nombre del cónyuge / conviviente",
                placeHolder: "Ingrese los nombres"),
            const SizedBox(height: 10),
            //todo APELLIDOS CONYUGE
            InputTextFormFields(
                focus: _focusNodeACG,
                onChanged: (_) => validarColorGarante(),
                controlador: txtApellidosGC,
                validacion: (value) {
                  if (txtCedulaGC.text.isNotEmpty) {
                    return value!.isEmpty ? "Campo obligatorio*" : null;
                  } else {
                    return null;
                  }
                },
                habilitado: enableAllFields
                    ? txtCedulaGC.text.isNotEmpty
                        ? true
                        : false
                    : false,
                prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                accionCampo: TextInputAction.next,
                nombreCampo: "Apellidos del cónyuge / conviviente",
                placeHolder: "Ingrese los apellidos"),
            const SizedBox(height: 10),
          ],
        ),
      );

  Widget formularioActividadEconomica() => Stack(
        children: [
          Form(
              key: _fkeyA,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    width: double.infinity,
                    height: 40,
                    child: Column(
                      children: [
                        const Expanded(
                            child: Row(
                          children: [
                            Icon(AbiPraxis.academia),
                            SizedBox(width: 10),
                            Text("Actividad económica principal")
                          ],
                        )),
                        divider(false, color: Colors.grey),
                      ],
                    ),
                  ),
                  //todo RELACION LABORAL
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: DropdownButtonFormField<Map<String, dynamic>>(
                        focusNode: _focusNodeRL,
                        //hint: Text("Relación laboral"),
                        validator: (value) =>
                            value == null ? "Campo obligatorio*" : null,
                        decoration: const InputDecoration(
                            label: Text("Relación laboral")),
                        value: textRelacion,
                        items: listaRelacionLab
                            .map((e) => DropdownMenuItem<Map<String, dynamic>>(
                                value: e, child: Text(e["nombre"])))
                            .toList(),
                        onChanged: enableAllFields
                            ? (value) {
                                setState(() => textRelacion = value!);
                                setState(
                                    () => idRleacionLaboral = value!["id"]);
                                validarColorAE();
                              }
                            : null),
                  ),
                  //todo ACTIVIDAD ESPECÍFICA
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: InputTextFormFields(
                        habilitado: enableAllFields,
                        focus: _focusNodeAE,
                        controlador: txtActividadE,
                        validacion: (value) =>
                            value!.isEmpty ? "Campo obligatorio*" : null,
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Actividad específica",
                        onChanged: (value) {
                          filtrarActividad(value);
                          validarColorAE();
                        },
                        placeHolder: "Ingrese la actividad que realiza"),
                  ),
                  //todo SECTOR ECONÓMICO(DESPLEGABLE)
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: DropdownButtonFormField<Map<String, dynamic>>(
                        focusNode: _focusNodeSE,
                        validator: (value) =>
                            value == null ? "Campo obligatorio*" : null,
                        //hint: Text("Relación laboral"),
                        decoration: const InputDecoration(
                            label: Text("Sector económico")),
                        value: textSectorE,
                        items: listaSectorE
                            .map((e) => DropdownMenuItem<Map<String, dynamic>>(
                                value: e, child: Text(e["nombre"])))
                            .toList(),
                        onChanged: enableAllFields
                            ? (value) {
                                setState(() => textSectorE = value!);
                                setState(() => idSectorE = value!["id"]);
                                validarColorAE();
                              }
                            : null),
                  ),
                  //todo TIEMPO DE FUNCIONAMIENTO
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: InputTextFormFields(
                        habilitado: enableAllFields,
                        focus: _focusNodeTF,
                        controlador: txtTiempoFunc,
                        validacion: (value) =>
                            value!.isEmpty ? "Campo obligatorio*" : null,
                        accionCampo: TextInputAction.next,
                        tipoTeclado: TextInputType.number,
                        onChanged: (value) => validarColorAE(),
                        nombreCampo: "Tiempo en funciones(meses)",
                        placeHolder: "Ingrese el número de meses"),
                  ),
                  //todo TELEFONO TRABAJO
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: InputTextFormFields(
                        habilitado: enableAllFields,
                        focus: _focusNodeTFN,
                        controlador: txtTelefonoAE,
                        accionCampo: TextInputAction.next,
                        tipoTeclado: TextInputType.number,
                        nombreCampo: "Teléfono de trabajo",
                        placeHolder: "Ingrese el teléfono"),
                  ),
                  //todo DIRECCIÓN DE TRABAJO
                  GestureDetector(
                    onTap: () {
                      if (txtDireccionTAE.text.isEmpty) {
                        scaffoldMessenger(context,
                            "No ha registrado la dirección del trabajo del prospecto",
                            icon:
                                const Icon(Icons.warning, color: Colors.yellow),
                            seconds: 3,
                            trailing: IconButton(
                                onPressed: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              AgregarEditarProspecto(
                                                edit: true,
                                                isClient: false,
                                                idPersona: 10,
                                              )));
                                },
                                icon: const Icon(
                                    Icons.arrow_circle_right_outlined,
                                    size: 35,
                                    color: Colors.white)));
                      }
                      FocusScope.of(context).unfocus();
                    },
                    child: AbsorbPointer(
                      absorbing: false,
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: InputTextFormFields(
                            habilitado: enableAllFields,
                            focus: _focusNodeDR,
                            onChanged: (value) => validarColorAE(),
                            validacion: (value) =>
                                value!.isEmpty ? "Campo obligatorio*" : null,
                            controlador: txtDireccionTAE,
                            accionCampo: TextInputAction.next,
                            tipoTeclado: TextInputType.number,
                            nombreCampo: "Dirección de trabajo",
                            placeHolder: "Ingrese la dirección"),
                      ),
                    ),
                  ),
                ],
              )),
          if (recomendaciones.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 150),
              height: 400,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              child: Material(
                borderRadius: BorderRadius.circular(25),
                elevation: 4,
                child: ListView.separated(
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                  itemCount: recomendaciones.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        codActividadE = recomendaciones[index]["cod"];
                        txtActividadE.text = recomendaciones[index]["nombre"];
                        recomendaciones.clear();
                      }),
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              width: double.infinity,
                              child: Text(
                                (recomendaciones[index]["nombre"]),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                          const SizedBox(height: 10)
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
        ],
      );

  Widget formularioSolicitudP() => Form(
      key: _fkeyP,
      child: Column(
        children: [
          //todo FUENTE DE AMIBANK
          DropdownButtonFormField<Map<String, dynamic>>(
              focusNode: _focusNodeF,
              padding: const EdgeInsets.only(left: 15, right: 15),
              //validator: (value) => value == null ? "Campo obligatorio*" : null,
              decoration: const InputDecoration(
                  prefixIcon: Icon(AbiPraxis.comoseentero, size: 18),
                  label: Text("¿Cómo se enteró de AMIBANK?")),
              value: textFuente,
              items: listaFuente
                  .map((e) => DropdownMenuItem<Map<String, dynamic>>(
                      value: e, child: Text(e["nombre"])))
                  .toList(),
              onChanged: enableAllFields
                  ? (value) {
                      setState(() => textFuente = value!);
                      setState(() => idFuente = value!["id"]);
                      validarColorSolicitarProducto();
                    }
                  : null),
          const SizedBox(height: 5),
          //todo MONTO SOLICITADO
          InputTextFormFields(
              habilitado: enableAllFields,
              focus: _focusNodeMT,
              prefixIcon: const Icon(AbiPraxis.monto_solicitado, size: 18),
              validacion: (value) =>
                  value!.isEmpty ? "Campo obligatorio*" : null,
              controlador: txtMontoSolicitado,
              onChanged: (_) => validarColorSolicitarProducto(),
              tipoTeclado: TextInputType.number,
              listaFormato: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandsSeparatorInputFormatter(),
                FilteringTextInputFormatter.deny(',', replacementString: '.'),
              ],
              accionCampo: TextInputAction.next,
              nombreCampo: "Monto solicitado(\$)",
              placeHolder: "Ingrese el monto solicitado"),
          const SizedBox(height: 5),
          //todo PLAZO A PAGAR
          DropdownButtonFormField<Map<String, dynamic>>(
              focusNode: _focusNodePL,
              padding: const EdgeInsets.only(left: 15, right: 15),
              validator: (value) => value == null ? "Campo obligatorio*" : null,
              decoration: const InputDecoration(
                  label: Text("Plazo"),
                  prefixIcon: Icon(AbiPraxis.plazo, size: 18)),
              value: textPlazo,
              items: listaPlazo
                  .map((e) => DropdownMenuItem<Map<String, dynamic>>(
                      value: e, child: Text(e["nombre"])))
                  .toList(),
              onChanged: enableAllFields
                  ? (value) {
                      setState(() => textPlazo = value!);
                      setState(() => idPlazo = value!["id"]);
                      validarColorSolicitarProducto();
                    }
                  : null),
          //todo CUOTA QUE PUEDE PAGAR
          const SizedBox(height: 5),
          InputTextFormFields(
              habilitado: enableAllFields,
              focus: _focusNodeCTA,
              validacion: (value) =>
                  value!.isEmpty ? "Campo obligatorio*" : null,
              controlador: txtCuotaAPagar,
              prefixIcon: const Icon(AbiPraxis.cuotaquepuedespagar, size: 18),
              accionCampo: TextInputAction.next,
              tipoTeclado: const TextInputType.numberWithOptions(decimal: true),
              //listaFormato: [FilteringTextInputFormatter.allow()],
              onChanged: (_) => validarColorSolicitarProducto(),
              listaFormato: [
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')),
              ],
              nombreCampo: "Cuota que puede pagar(\$)",
              placeHolder: "Ingrese la cuota a pagar"),
          const SizedBox(height: 5),
        ],
      ));

  Widget documentosAutorizacion() => Column(
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
                  ? [setState(() => firmaProspectoPath = val)]
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
                  ? [setState(() => firmaGarantePath = val)]
                  : null),
            ),
            title: Text(titleGarante),
          ),
          divider(true),
          ListTile(
            enabled: txtCedulaTC.text.isNotEmpty,
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
                      FocusScope.of(context).unfocus()
                    ]
                  : null),
            ),
            //subtitle: const Text("del prospecto"),
            title: Text(titleCProspecto),
          ),
          divider(true),
          ListTile(
            enabled: txtCedulaGC.text.isNotEmpty,
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
                      FocusScope.of(context).unfocus()
                    ]
                  : null),
            ),
            //subtitle: const Text("del garante"),
            title: Text(titleCGarante),
          ),
          divider(true),
        ],
      );

  Widget buttons() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              nextButton(
                  onPressed: () => widget.edit
                      ? Navigator.pop(context)
                      : validarBotonPendiente(),
                  text: widget.edit ? "Regresar" : "Pendiente",
                  width: 110,
                  background: const Color.fromRGBO(38, 72, 162, 1)),
              nextButton(
                  onPressed: () => validarBotonFinalizar(),
                  text: "Finalizar",
                  width: 110),
            ],
          ),
        ],
      );

  //todo FUNCIONES PARA CAMBIAR EL ESTADO DE COLOR DE UN FORMULARIO
  void validarColorTitular() {
    final validacion1 = txtApellidosT.text.isNotEmpty;
    final validacion2 = txtApellidosTC.text.isNotEmpty;
    final validacion3 = txtCedulaTC.text.isNotEmpty;
    final validacion4 = txtNombresT.text.isNotEmpty;
    final validacion5 = txtNombresTC.text.isNotEmpty;
    final validacion6 = txtcedulaT.text.isNotEmpty;

    if (validacion6 && validacion4 && validacion1) {
      setState(() => titularColor = Colors.green);
      if (validacion3 && (!validacion5 || !validacion2)) {
        setState(() => titularColor = Colors.yellow);
      } else {
        setState(() => titularColor = Colors.green);
      }
    } else {
      setState(() => titularColor = Colors.yellow);
    }
  }

  void validarColorGarante() {
    final validacion1 = txtApellidosG.text.isNotEmpty;
    final validacion2 = txtApellidosGC.text.isNotEmpty;
    final validacion3 = txtCedulaGC.text.isNotEmpty;
    final validacion4 = txtNombresG.text.isNotEmpty;
    final validacion5 = txtNombresGC.text.isNotEmpty;
    final validacion6 = txtcedulaG.text.isNotEmpty;

    if (validacion6 && validacion4 && validacion1) {
      setState(() => garanteColor = Colors.green);
      if (validacion3 && (!validacion5 || !validacion2)) {
        setState(() => garanteColor = Colors.yellow);
      }
    } else {
      setState(() => garanteColor = Colors.yellow);
    }
  }

  void validarColorAE() {
    final validacion1 = (textRelacion != null);
    final validacion2 = txtActividadE.text.isNotEmpty;
    final validacion3 = (textSectorE != null);
    final validacion4 = txtTiempoFunc.text.isNotEmpty;
    final validacion5 = txtDireccionTAE.text.isNotEmpty;

    if (validacion5 &&
        validacion4 &&
        validacion3 &&
        validacion2 &&
        validacion1) {
      setState(() => actividadColor = Colors.green);
    } else {
      setState(() => actividadColor = Colors.yellow);
    }
  }

  void validarColorSolicitarProducto() {
    final validacion1 = (textFuente != null);
    final validacion2 = txtMontoSolicitado.text.isNotEmpty;
    final validacion3 = (textPlazo != null);
    final validacion4 = txtCuotaAPagar.text.isNotEmpty;

    if (validacion4 && validacion3 && validacion2 && validacion1) {
      setState(() => solicitudColor = Colors.green);
    } else {
      setState(() => solicitudColor = Colors.yellow);
    }
  }

  void validarColorAutorizacion() {
    final validacion1 = (firmaProspectoPath != null);
    final validacion2 = (firmaGarantePath != null);
    final validacion3 =
        (txtCedulaTC.text.isNotEmpty && firmaCProspectoPath == null);
    final validacion4 =
        (txtCedulaGC.text.isNotEmpty && firmaCGarantePath == null);

    if (validacion1 && validacion2) {
      setState(() => autorizacionColor = Colors.green);
      if (validacion3 && validacion4) {
        setState(() => autorizacionColor = Colors.yellow);
      }
    } else {
      setState(() => autorizacionColor = Colors.yellow);
    }
  }

  void cerrarTabs(int index) {
    switch (index) {
      case 1:
        setState(() {
          expController2.collapse();
          expController3.collapse();
          expController4.collapse();
          expController5.collapse();
        });
      case 2:
        setState(() {
          expController1.collapse();
          expController3.collapse();
          expController4.collapse();
          expController5.collapse();
        });
      case 3:
        setState(() {
          expController1.collapse();
          expController2.collapse();
          expController4.collapse();
          expController5.collapse();
        });
      case 4:
        setState(() {
          expController1.collapse();
          expController2.collapse();
          expController3.collapse();
          expController5.collapse();
        });
      case 5:
        setState(() {
          expController1.collapse();
          expController2.collapse();
          expController3.collapse();
          expController4.collapse();
        });
    }
  }

  //todo FUNCIÓN PARA VALIDAR ICONO Y MOSTRAR OPCIONES DE AUTORIZACION
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
                enableVisibility = true;
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
            if (enableAllFields) {
              list.add(const PopupMenuItem(value: 2, child: Text("Rehacer")));
            }
            return list;
          });
    } else {
      return IconButton(
          onPressed: () async => await function(),
          icon: const Icon(Icons.arrow_forward_ios_outlined));
    }
  }

  //todo FUNCIÓN PARA MOSTRAR FIRMA
  Widget mostrarFirma(String title, String path) {
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
                      title,
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

  //todo VALIDACIÓN DEL BOTÓN FINALIZAR
  void validarBotonFinalizar() async {
    final pfrc = UserPreferences();
    int idPromotor = await pfrc.getIdPromotor();
    int idUser = await pfrc.getIdUser();

    if (!_fkeyT.currentState!.validate()) {
      /*scaffoldMessenger(context, "Faltan datos del titular",
          const Icon(Icons.error, color: Colors.red));*/
      scaffoldMessenger(context, "Faltan datos del titular");
      expController1.expand();
      cerrarTabs(1);
      setState(() => titularColor = Colors.red);
      return;
    }

    if (!_fkeyG.currentState!.validate()) {
      /*scaffoldMessenger(context, "Faltan datos del Garante",
          const Icon(Icons.error, color: Colors.red));*/
      scaffoldMessenger(context, "Faltan datos del garante");
      expController2.expand();
      cerrarTabs(2);
      setState(() => garanteColor = Colors.red);
      return;
    }

    if (!_fkeyA.currentState!.validate()) {
      /*scaffoldMessenger(context, "Faltan datos de la actividad económica",
          const Icon(Icons.error, color: Colors.red));*/
      scaffoldMessenger(context, "Faltan datos de la actividad económica");
      setState(() => actividadColor = Colors.red);
      expController3.expand();
      cerrarTabs(3);
      return;
    }

    if (!_fkeyP.currentState!.validate()) {
      /*scaffoldMessenger(context, "Faltan datos de la solicitud del producto",
          const Icon(Icons.error, color: Colors.red));*/
      scaffoldMessenger(context, "Faltan datos de la solicitud del producto");
      setState(() => autorizacionColor = Colors.red);
      expController4.expand();
      cerrarTabs(4);
      return;
    }

    if (firmaProspectoPath == null) {
      /*scaffoldMessenger(context, "Falta firma del prospecto",
          const Icon(Icons.error, color: Colors.red));*/
      scaffoldMessenger(context, "Falta firma del prospecto");
      setState(() => autorizacionColor = Colors.red);
      expController5.expand();
      cerrarTabs(5);
      return;
    }

    if (firmaGarantePath == null) {
      /*scaffoldMessenger(context, "Falta firma del garante",
          const Icon(Icons.error, color: Colors.red));*/
      scaffoldMessenger(context, "Falta firma del garante");
      setState(() => autorizacionColor = Colors.red);
      expController5.expand();
      cerrarTabs(5);
      return;
    }

    if (txtCedulaTC.text.isNotEmpty && firmaCProspectoPath == null) {
      /*scaffoldMessenger(context, "Falta firma del cónyuge del prospecto",
          const Icon(Icons.error, color: Colors.red));*/
      scaffoldMessenger(context, "Falta firma del cónyuge del prospecto");
      setState(() => autorizacionColor = Colors.red);
      expController5.expand();
      cerrarTabs(5);
      return;
    }

    if (txtCedulaGC.text.isNotEmpty && firmaCGarantePath == null) {
      /*scaffoldMessenger(context, "Falta firma del cónyuge del garante",
          const Icon(Icons.error, color: Colors.red));*/
      scaffoldMessenger(context, "Falta firma del cónyuge del garante");
      setState(() => autorizacionColor = Colors.red);
      expController5.expand();
      cerrarTabs(5);
      return;
    }

    setState(() => loading = true);

    final idpg = await op.insertarPersona(
        isProsp: false,
        PersonaModel(
            usuarioCreacion: idUser,
            nombres: txtNombresG.text,
            apellidos: txtApellidosG.text,
            numeroIdentificacion: txtcedulaG.text));
    setState(() => idPersonaGarante = idpg);
    debugPrint("ID PERSONA GARANTE: $idpg");

    final contact = await op.insertarContactoPersona(ContactosPersonaModel(
        idPersona: idpg, idTitular: idPersona!, tipoContacto: 2));
    debugPrint("contacto garante: $contact");

    if (txtCedulaGC.text.isNotEmpty && idPersonaCGarante == null) {
      final idpcg = await op.insertarPersona(
          isProsp: false,
          PersonaModel(
              usuarioCreacion: idUser,
              nombres: txtNombresGC.text,
              apellidos: txtApellidosGC.text,
              numeroIdentificacion: txtCedulaGC.text));
      setState(() => idPersonaCGarante = idpcg);
      debugPrint("ID PERSONA CONYUGE G: $idpcg");

      final contact = await op.insertarContactoPersona(ContactosPersonaModel(
          idPersona: idpcg, idTitular: idPersona!, tipoContacto: 3));
      debugPrint("contacto conyuge garante: $contact");
    }

    if (txtCedulaTC.text.isNotEmpty && idPersonaCProspecto == null) {
      final idpct = await op.insertarPersona(
          isProsp: false,
          PersonaModel(
              usuarioCreacion: idUser,
              nombres: txtNombresTC.text,
              apellidos: txtApellidosTC.text,
              numeroIdentificacion: txtCedulaTC.text));
      setState(() => idPersonaCProspecto = idpct);
      debugPrint("ID PERSONA CONYUGE T: $idpct");

      final contact = await op.insertarContactoPersona(ContactosPersonaModel(
          idPersona: idpct, idTitular: idPersona!, tipoContacto: 1));
      debugPrint("contacto conyuge titular: $contact");
    }

    final res = await op.actualizarCedulaPersona(idPersona!, txtcedulaT.text);
    debugPrint("Persona: ${res == 1 ? "actualizada" : "no actualizada"}");

    int estado = 2;

    final autorizacion = AutorizacionModel(
      idUsuarioCreacion: idUser,
      idPromotor: idPromotor,
      codActividad: codActividadE!,
      actividad: txtActividadE.text,
      cuota: txtCuotaAPagar.text,
      fuente: idFuente!,
      idGarante: idPersonaGarante!,
      idPersona: idPersona!,
      idCGarante: idPersonaCGarante,
      idCProspecto: idPersonaCProspecto,
      telefonoTrabajo: txtTelefonoAE.text,
      monto: txtMontoSolicitado.text,
      plazo: int.parse(textPlazo!["nombre"].toString().replaceAll("meses", "")),
      relacionLaboral: idRleacionLaboral!,
      sectorEconomico: idSectorE!,
      tiempoFunciones: txtTiempoFunc.text,
      estado: estado,
    ); //finalizado

    if (!widget.edit) {
      final idAut = await op.insertarAutorizacion(autorizacion);

      debugPrint("autorización: $idAut");

      setState(() => loading = true);

      if (idAut != 0) {
        if (firmaProspectoPath != null) {
          await subirDocumentos(idAut, idPersona!, "P", firmaProspectoPath!);
        }

        if (firmaCProspectoPath != null) {
          await subirDocumentos(
              idAut, idPersonaCProspecto!, "PC", firmaCProspectoPath!);
        }

        if (firmaGarantePath != null) {
          await subirDocumentos(
              idAut, idPersonaGarante!, "G", firmaGarantePath!);
        }

        if (firmaCGarantePath != null) {
          await subirDocumentos(
              idAut, idPersonaCGarante!, "GC", firmaCGarantePath!);
        }

        await scaffoldMessenger(
                context, "La autorización se ha generado correctamente",
                icon: const Icon(Icons.check, color: Colors.green))
            .then((val) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => SolicitudCredito(
                          idTipoProducto: widget.idProducto ?? 0,
                          idAutorizacion: idAut,
                          idPersona: idPersona!,
                          idPersonaConyuge: idPersonaCProspecto,
                          idPersonaGarante: idPersonaGarante,
                          monto: txtMontoSolicitado.text,
                          actividadEcon: txtActividadE.text,
                          codActividad: codActividadE,
                          idRleacionLaboral: idRleacionLaboral,
                          idSector: idSectorE,
                          tiempoFuncionamiento: txtTiempoFunc.text,
                          cuota: txtCuotaAPagar.text,
                          idConyugeGarante: idPersonaCGarante,
                          idFuente: idFuente,
                          idPlazo: idPlazo,
                        ))));
        debugPrint("Aquí iríamos a la segunda página");
      }
    } else {
      actualizarDatosAutorizacion();
    }
  }

  void actualizarDatosAutorizacion() async {
    PersonaModel? updateGaranteC;
    PersonaModel? updateTitularC;

    final pfrc = UserPreferences();
    int idPromotor = await pfrc.getIdPromotor();
    int idUser = await pfrc.getIdUser();

    var updateGarante = PersonaModel(
        usuarioCreacion: idUser,
        nombres: txtNombresG.text,
        apellidos: txtApellidosG.text,
        numeroIdentificacion: txtcedulaG.text);

    if (txtCedulaTC.text.isNotEmpty) {
      updateTitularC = PersonaModel(
          usuarioCreacion: idUser,
          nombres: txtNombresTC.text,
          apellidos: txtApellidosTC.text,
          numeroIdentificacion: txtCedulaTC.text);
    }

    if (txtCedulaGC.text.isNotEmpty) {
      updateGaranteC = PersonaModel(
          usuarioCreacion: idUser,
          nombres: txtNombresGC.text,
          apellidos: txtApellidosGC.text,
          numeroIdentificacion: txtCedulaGC.text);
    }

    //todo ACTUALIZAR O INSERTAR DATOS DE PERSONAS(PROSPECTO, CONYUGES Y GARANTE)
    if (garante != null) {
      await op.actualizarPersona(garante!.idPersona!, updateGarante);
    } else {
      final p = await op.insertarPersona(updateGarante);

      final contact = await op.insertarContactoPersona(ContactosPersonaModel(
          idPersona: p, idTitular: idPersona!, tipoContacto: 2));
      debugPrint("contacto garante: $contact");

      setState(() => idPersonaGarante = p);
    }

    if (conyugeT != null) {
      await op.actualizarPersona(conyugeT!.idPersona!, updateTitularC!);
    } else {
      if (txtCedulaTC.text.isNotEmpty) {
        final p = await op.insertarPersona(updateTitularC!);

        final contact = await op.insertarContactoPersona(ContactosPersonaModel(
            idPersona: p, idTitular: idPersona!, tipoContacto: 1));
        debugPrint("contacto conyuge titular: $contact");

        setState(() => idPersonaCProspecto = p);
      }
    }

    if (conyugeG != null) {
      await op.actualizarPersona(conyugeG!.idPersona!, updateGaranteC!);
    } else {
      if (txtCedulaGC.text.isNotEmpty) {
        final p = await op.insertarPersona(updateGaranteC!);

        final contact = await op.insertarContactoPersona(ContactosPersonaModel(
            idPersona: p, idTitular: idPersona!, tipoContacto: 3));
        debugPrint("contacto conyuge garante: $contact");

        setState(() => idPersonaCGarante = p);
      }
    }

    //todo ACTUALIZAR O INSERTAR DATOS DE DOCUMENTOS(FIRMAS)
    bool pathTitular = false;

    bool pathCTitular = false;

    bool pathGarante = false;

    bool pathCGarante = false;

    //realizar for y manejar por booleanos para saber cuales ya están y con esto actualizar o eliminar
    final docs = await op.obtenerDocsXaut(widget.idAutorizacion!);

    for (var i = 0; i < docs.length; i++) {
      if (docs[i].codDoc == "P") {
        setState(() => pathTitular = true);
        setState(() => idPersona = docs[i].idPersona);
        actualizarDocumento(
            docs[i].idDoc!, "P", idPersona!, firmaProspectoPath!);
      }
      if (docs[i].codDoc == "G") {
        setState(() => pathGarante = true);
        setState(() => idPersonaGarante = docs[i].idPersona);
        actualizarDocumento(
            docs[i].idDoc!, "G", idPersonaGarante!, firmaGarantePath!);
      }
      if (docs[i].codDoc == "PC") {
        setState(() => pathCTitular = true);
        setState(() => idPersonaCProspecto = docs[i].idPersona);
        actualizarDocumento(
            docs[i].idDoc!, "PC", idPersonaCProspecto!, firmaCProspectoPath!);
      }
      if (docs[i].codDoc == "GC") {
        setState(() => pathCGarante = true);
        setState(() => idPersonaCGarante = docs[i].idPersona);
        actualizarDocumento(
            docs[i].idDoc!, "GC", idPersonaCGarante!, firmaCGarantePath!);
      }
    }

    if (!pathTitular) {
      await op.insertarDocumentoAutorizacion(DocumentoAutModel(
          codDoc: "P",
          idAut: widget.idAutorizacion!,
          idPersona: idPersona!,
          codImg: firmaProspectoPath!));
    }

    if (!pathGarante) {
      await op.insertarDocumentoAutorizacion(DocumentoAutModel(
          codDoc: "G",
          idAut: widget.idAutorizacion!,
          idPersona: idPersonaGarante!,
          codImg: firmaGarantePath!));
    }

    if (txtCedulaTC.text.isNotEmpty && !pathCTitular) {
      await op.insertarDocumentoAutorizacion(DocumentoAutModel(
          codDoc: "PC",
          idAut: widget.idAutorizacion!,
          idPersona: idPersonaCProspecto!,
          codImg: firmaCProspectoPath!));
    }

    if (txtCedulaGC.text.isNotEmpty && !pathCGarante) {
      await op.insertarDocumentoAutorizacion(DocumentoAutModel(
          codDoc: "GC",
          idAut: widget.idAutorizacion!,
          idPersona: idPersonaCGarante!,
          codImg: firmaCGarantePath!));
    }

    //todo ACTUALIZAR AUTORIZACIÓN
    int estado = 2;

    final autorizacion = AutorizacionModel(
      idUsuarioCreacion: idUser,
      idPromotor: idPromotor,
      codActividad: codActividadE!,
      actividad: txtActividadE.text,
      cuota: txtCuotaAPagar.text,
      fuente: idFuente!,
      idGarante: idPersonaGarante!,
      idPersona: idPersona!,
      idCGarante: idPersonaCGarante,
      idCProspecto: idPersonaCProspecto,
      telefonoTrabajo: txtTelefonoAE.text,
      monto: txtMontoSolicitado.text,
      plazo: int.parse(textPlazo!["nombre"].toString().replaceAll("meses", "")),
      relacionLaboral: idRleacionLaboral!,
      sectorEconomico: idSectorE!,
      tiempoFunciones: txtTiempoFunc.text,
      estado: estado,
    );

    final aut =
        await op.actualizarAutorizacion(autorizacion, widget.idAutorizacion!);

    debugPrint("Autorización: ${aut != 0 ? "Actualizada" : "No actualizada"}");

    Navigator.pop(context);

    if (aut == 1) {
      scaffoldMessenger(context, "Autorización completada correctamente",
          icon: const Icon(Icons.check, color: Colors.green));
    } else {
      scaffoldMessenger(context, "No se actualizó la autorización.",
          icon: const Icon(Icons.error, color: Colors.red));
    }
  }

  void actualizarDocumento(int idDoc, String t, int ip, String p) async {
    await op.actualizarDocumentoAutorizacion(
        idDoc,
        DocumentoAutModel(
            codDoc: t,
            idAut: widget.idAutorizacion!,
            idPersona: ip,
            codImg: p));
  }

  //todo BOTÓN PENDIENTE
  void validarBotonPendiente() async {
    final pfrc = UserPreferences();
    int idPromotor = await pfrc.getIdPromotor();
    int idUser = await pfrc.getIdUser();

    if (_fkeyT.currentState!.validate()) {
      setState(() => loading = true);
      final up = await op.actualizarCedulaPersona(idPersona!, txtcedulaT.text);
      debugPrint("Persona: ${up == 1 ? "actualizada" : "no actualizada"}");

      if (txtCedulaTC.text.isNotEmpty) {
        final idptc = await op.insertarPersona(PersonaModel(
            usuarioCreacion: idUser,
            nombres: txtNombresTC.text,
            apellidos: txtApellidosTC.text,
            numeroIdentificacion: txtCedulaTC.text));
        setState(() => idPersonaCProspecto = idptc);

        final contact = await op.insertarContactoPersona(ContactosPersonaModel(
            idPersona: idptc, idTitular: idPersona!, tipoContacto: 1));
        debugPrint("contacto conyuge titular: $contact");
      }

      if (txtcedulaG.text.isNotEmpty) {
        final idpg = await op.insertarPersona(PersonaModel(
            usuarioCreacion: idUser,
            nombres: txtNombresG.text,
            apellidos: txtApellidosG.text,
            numeroIdentificacion: txtcedulaG.text));
        setState(() => idPersonaGarante = idpg);

        final contact = await op.insertarContactoPersona(ContactosPersonaModel(
            idPersona: idpg, idTitular: idPersona!, tipoContacto: 2));
        debugPrint("contacto garante: $contact");
      }

      if (txtCedulaGC.text.isNotEmpty) {
        final idpcg = await op.insertarPersona(PersonaModel(
            usuarioCreacion: idUser,
            nombres: txtNombresGC.text,
            apellidos: txtApellidosGC.text,
            numeroIdentificacion: txtCedulaGC.text));
        setState(() => idPersonaCGarante = idpcg);

        final contact = await op.insertarContactoPersona(ContactosPersonaModel(
            idPersona: idpcg, idTitular: idPersona!, tipoContacto: 3));
        debugPrint("contacto conyuge garante: $contact");
      }

      final autorizacion = AutorizacionModel(
          idUsuarioCreacion: idUser,
          idPromotor: idPromotor,
          codActividad: codActividadE,
          actividad: txtActividadE.text,
          cuota: txtCuotaAPagar.text,
          fuente: idFuente,
          idGarante: idPersonaGarante,
          idPersona: idPersona!,
          idCGarante: idPersonaCGarante,
          idCProspecto: idPersonaCProspecto,
          telefonoTrabajo: txtTelefonoAE.text,
          monto: txtMontoSolicitado.text,
          plazo: textPlazo != null
              ? int.parse(
                  textPlazo!["nombre"].toString().replaceAll("meses", ""))
              : null,
          relacionLaboral: idRleacionLaboral,
          sectorEconomico: idSectorE,
          tiempoFunciones: txtTiempoFunc.text,
          estado: 1); //PENDIENTE

      final idAut = await op.insertarAutorizacion(autorizacion);

      debugPrint("autorización: $idAut");

      if (idAut != 0) {
        if (firmaProspectoPath != null) {
          await subirDocumentos(idAut, idPersona!, "P", firmaProspectoPath!);
        }

        if (firmaCProspectoPath != null) {
          await subirDocumentos(
              idAut, idPersonaCProspecto!, "PC", firmaCProspectoPath!);
        }

        if (firmaGarantePath != null) {
          await subirDocumentos(
              idAut, idPersonaGarante!, "G", firmaGarantePath!);
        }

        if (firmaCGarantePath != null) {
          await subirDocumentos(
              idAut, idPersonaCGarante!, "GC", firmaCGarantePath!);
        }

        setState(() => loading = false);

        Navigator.pop(context);
        Navigator.pop(context);
        scaffoldMessenger(
                context, "La autorización se ha generado en estado pendiente",
                icon: const Icon(Icons.check, color: Colors.green), seconds: 4)
            .then((val) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => SolicitudCredito(
                          idTipoProducto: widget.idProducto ?? 0,
                          idAutorizacion: idAut,
                          idPersona: idPersona!,
                          idPersonaConyuge: idPersonaCProspecto,
                          idPersonaGarante: idPersonaGarante,
                          monto: txtMontoSolicitado.text,
                          actividadEcon: txtActividadE.text,
                          codActividad: codActividadE,
                          idRleacionLaboral: idRleacionLaboral,
                          idSector: idSectorE,
                          tiempoFuncionamiento: txtTiempoFunc.text,
                          cuota: txtCuotaAPagar.text,
                          idFuente: idFuente,
                          idConyugeGarante: idPersonaCGarante,
                          idPlazo: idPlazo,
                        ))));

        debugPrint("Aquí iríamos a la segunda página");
      } else {
        /* Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => SolicitudCredito(
                      idPersona: idPersona!,
                      idPersonaConyuge: idPersonaCProspecto,
                      idPersonaGarante: idPersonaGarante,
                      monto: txtMontoSolicitado.text,
                      actividadEcon: txtActividadE.text,
                      codActividad: codActividadE,
                      idRleacionLaboral: idRleacionLaboral,
                      idSector: idSectorE,
                      tiempoFuncionamiento: txtTiempoFunc.text,
                      cuota: txtCuotaAPagar.text,
                      idFuente: idFuente,
                      idPlazo: idPlazo,
                    ))); */
        scaffoldMessenger(context,
            "Ocurrió un error al generar la solicitud, inténtelo de nuevo más tarde...",
            icon: Icon(Icons.error, color: Colors.red));
      }
    } else {
      if (!widget.edit) {
        /*scaffoldMessenger(context, "Faltan datos del titular",
          const Icon(Icons.error, color: Colors.red));*/
        scaffoldMessenger(context, "Faltan datos del titular");
        expController1.expand();
        cerrarTabs(1);
        setState(() => titularColor = Colors.red);
        return;
      }
      return;
    }
  }

  Future<void> subirDocumentos(
      int idAut, int idPersona, String cod, String path) async {
    await op.insertarDocumentoAutorizacion(DocumentoAutModel(
        codDoc: cod,
        idAut: idAut,
        idPersona: idPersona,
        codImg: firmaProspectoPath!));
  }

  //todo BUSCAR ACTIVDAD ECONÓMICA
  void filtrarActividad(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        recomendaciones.clear();
      });

      return;
    }

    final list = (listaActividades
        .where((e) => e["nombre"].toLowerCase().contains(value.toLowerCase()))
        .toList());

    setState(() {
      recomendaciones = list;
    });
  }

  //todo FILTRO DE PROSPECTOS
  void buildSearchList(text) {
    if (text != "") {
      final list = contactos
          .where((element) =>
              element.nombres
                  .toLowerCase()
                  .contains(text.toString().toLowerCase()) ||
              element.apellidos
                  .toLowerCase()
                  .contains(text.toString().toLowerCase()))
          .toList();
      if (list.isNotEmpty) {
        setState(() => _searchList = list);
      } else {
        setState(() => showContacts = false);
      }
    } else {
      setState(() => _searchList = contactos);
    }
  }

  String getNamePros(String name, String lastName) {
    final listN = name.split(" ");
    final listA = lastName.split(" ");
    String apellidos = "";

    if (listA.length > 2) {
      apellidos = "${listA[0]} ${listA[1]}";
    } else {
      apellidos = listA[0];
    }

    return "${listN[0]} $apellidos";
  }

  void selectContacto(PersonaModel per) async {
    final nombres = per.nombres;
    final apellidos = per.apellidos;
    final direccionTrabajo = per.direccionTrabajo;
    final idPersona = per.idPersona;
    final cedula = per.numeroIdentificacion;

    final haveAut = await op.obtenerAutorizacionPersonaXestado(idPersona!);

    if (haveAut.isEmpty) {
      if (nombres!.isEmpty ||
          apellidos!.isEmpty ||
          (direccionTrabajo == null || direccionTrabajo.isEmpty)) {
        PersonaModel? persona = Platform.isAndroid
            ? await andAlert.actualizarDatos(context, idPersona)
            : await iosAlert.actualizarDatos(context, idPersona);
        obtenerProspectos();

        if (persona != null) {
          FocusScope.of(context).unfocus();
          expController1.expand();
          setState(() {
            this.idPersona = idPersona;
            txtcedulaT.text = persona.numeroIdentificacion ?? (cedula ?? "");
            txtBuscador.clear();
            enabledExpansionTile = true;
            txtNombresT.text = persona.nombres!;
            txtApellidosT.text = persona.apellidos!;
            txtDireccionTAE.text = persona.direccionTrabajo ?? "";
            showContacts = false;
          });
        } else {
          await Future.delayed(const Duration(seconds: 1));

          scaffoldMessenger(context, "No se actualizó el prospecto.",
              icon: const Icon(Icons.warning, color: Colors.yellow));
        }
      } else {
        FocusScope.of(context).unfocus();
        setState(() {
          this.idPersona = idPersona;
          expController1.expand();
          txtcedulaT.text = cedula ?? "";
          txtBuscador.clear();
          enabledExpansionTile = true;
          txtNombresT.text = nombres;
          txtApellidosT.text = apellidos;
          txtDireccionTAE.text = direccionTrabajo;
          showContacts = false;
        });
      }
    } else {
      FocusScope.of(context).unfocus();

      Platform.isAndroid
          ? andAlert.alertAutorizacionExiste(context)
          : iosAlert.alertAutorizacionExiste(context);
    }
  }
}
