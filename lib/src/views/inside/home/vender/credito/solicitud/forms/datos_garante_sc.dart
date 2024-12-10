// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/utils/list/lista_autorizacion_consulta.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../utils/buttons.dart';
import '../../../../../../../../utils/deviders/divider.dart';
import '../../../../../../../../utils/expansiontile.dart';
import '../../../../../../../../utils/flushbar.dart';
import '../../../../../../../../utils/function_callback.dart';
import '../../../../../../../../utils/geolocator/geolocator.dart';
import '../../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../../../../../../../utils/list/lista_solicitud.dart';
import '../../../../../../../../utils/paisesHabiles/paises.dart';
import '../../../../../../../../utils/paisesHabiles/retornar_resultados.dart';
import '../../../../../../../../utils/responsive.dart';
import '../../../../../../../../utils/textFields/field_formater.dart';
import '../../../../../../../../utils/textFields/input_text_form_fields.dart';
import '../../../../../../../controller/preferences/user_preferences.dart';
import '../../../../../../../models/usuario/persona_model.dart';

class DatosGaranteCredito extends StatefulWidget {
  bool? edit;
  int idGarante;
  int? idSolicitud;
  Color? datosPersonalesG;
  Color? datosNacimientoC;
  Color? datosIdentificacionC;
  Color? datosResidenciaC;
  Color? datosEducacionC;
  Color? actEconoPrinC;
  Color? actEconoSecC;
  Color? datosSitEconC;
  Color? datosEstadoCivilC;
  final GlobalKey gk;
  final GlobalKey<FormState> formKey;
  final GlobalKey<FormState> fNGkey;
  final GlobalKey<FormState> fIGkey;
  final GlobalKey<FormState> fRGkey;
  final GlobalKey<FormState> fEGkey;
  final GlobalKey<FormState> fAEGkey;
  final GlobalKey<FormState> fSEGkey;
  final GlobalKey<FormState> fECGkey;
  final ExpansionTileController expController;
  bool enableExpansion;
  VoidCallback startLoading;
  VoidCallback stopLoading;
  MoveToTopCallback updatePixelPosition;
  ChangeColorCallback changeColorDatosPersonales;
  ChangeColorCallback changeColorNac;
  ChangeColorCallback changeColorIden;
  ChangeColorCallback changeColorRes;
  ChangeColorCallback changeColorEduc;
  ChangeColorCallback changeColorActPrin;
  ChangeColorCallback changeColorActSec;
  ChangeColorCallback changeColorSitEco;
  ChangeColorCallback changeColorEstCiv;
  DatosGaranteCredito({
    super.key,
    this.idSolicitud,
    this.edit,
    required this.updatePixelPosition,
    required this.gk,
    required this.formKey,
    required this.enableExpansion,
    required this.fAEGkey,
    required this.fECGkey,
    required this.fEGkey,
    required this.fIGkey,
    required this.fNGkey,
    required this.fRGkey,
    required this.fSEGkey,
    required this.idGarante,
    required this.startLoading,
    required this.stopLoading,
    required this.expController,
    required this.changeColorActPrin,
    required this.changeColorActSec,
    required this.changeColorDatosPersonales,
    required this.changeColorEduc,
    required this.changeColorEstCiv,
    required this.changeColorIden,
    required this.changeColorNac,
    required this.changeColorRes,
    required this.changeColorSitEco,
    this.actEconoPrinC,
    this.actEconoSecC,
    this.datosEducacionC,
    this.datosEstadoCivilC,
    this.datosIdentificacionC,
    this.datosNacimientoC,
    this.datosPersonalesG,
    this.datosResidenciaC,
    this.datosSitEconC,
  });

  @override
  State<DatosGaranteCredito> createState() => _DatosGaranteCreditoState();
}

class _DatosGaranteCreditoState extends State<DatosGaranteCredito> {
  final op = Operations();

  final _fDepGkey = GlobalKey<FormState>();
  List<Map<String, dynamic>> recomendaciones = [];

  //todo VARIABLES DE DATOS PERSONALES GARANTE
  final txtNombresG = TextEditingController();
  final txtApellidosG = TextEditingController();
  final txtCelular1G = TextEditingController();
  final txtCelular2G = TextEditingController();
  final txtTelefonoG = TextEditingController();
  final txtCorreoG = TextEditingController();
  //todo nacimiento
  List<String> listPaises = ['ECUADOR', 'OTRO'];
  String? pais;
  final txtPaisG = TextEditingController();

  List<Map<String, dynamic>> listaProvincias = [];
  String? provincia;
  bool provinciasVisible = false;
  final txtProvinciaG = TextEditingController();
  String? hintTextProvincia;

  List<String> listaCiudades = [];
  String? ciudad;
  bool ciudadesVisible = false;
  final txtCiudadG = TextEditingController();
  String? hintTextCiudad;

  bool otroPais = false;
  final txtFechaNacG = TextEditingController();
  final txtEdadG = TextEditingController();
  Map<String, dynamic>? generoG;
  String? textGeneroG;
  Map<String, dynamic>? etniaG;
  String? textEtniaG;
  bool enableOtraEtniaG = false;
  final txtOtraEtiniaG = TextEditingController();
  //todo identificación
  final txtCedulaG = TextEditingController();
  final txtRucG = TextEditingController();
  final txtPasaporteG = TextEditingController();
  final txtFechaExpPasaporteG = TextEditingController();
  final txtFechaCadPasaporteG = TextEditingController();
  final txtFechaEntradaG = TextEditingController();
  Map<String, dynamic>? estadoMigratorioG;
  String? textEstadoMigratorioG;
  //todo residencia
  String? paisRes;
  final txtPaisResG = TextEditingController();
  List<Map<String, dynamic>> listaProvinciasRes = [];
  String? provinciaRes;
  bool provinciasResVisible = false;
  final txtProvinciaResG = TextEditingController();
  String? hintTextProvinciaRes;
  List<String> listaCiudadesRes = [];
  String? ciudadRes;
  bool ciudadesResVisible = false;
  final txtCiudadResG = TextEditingController();
  String? hintTextCiudadRes;
  bool otroPaisRes = false;

  final txtParroquiaResG = TextEditingController();
  final txtBarrioResG = TextEditingController();
  final txtDireccionG = TextEditingController();
  String? latitudRG;
  String? longitudRG;
  Map<String, dynamic>? tipoViviendaG;
  String? textTipoViviendaG;
  bool enableValorG = false;
  final txtValorVG = TextEditingController();
  final txtTiempoViviendaG = TextEditingController();
  Map<String, dynamic>? sectorG;
  String? textSectorG;
  //todo educación
  Map<String, dynamic>? estudioG;
  String? textEstudioG;
  Map<String, dynamic>? profesionG;
  String? textProsfesionG;
  bool enableOtraProfesionG = false;
  final txtOtraProfesionG = TextEditingController();
  //todo actividad económica principal
  bool independienteG = false;
  bool dependienteG = false;
  bool otraActiVG = false;
  Map<String, dynamic>? relacionLaboralG;
  String? textRelacionLaboralG;
  Map<String, dynamic>? tipoNegocioG;
  String? textNegocioG;
  final txtExpNegocioG = TextEditingController();
  Map<String, dynamic>? sectorNegocioG;
  String? textSectorNegocioG;
  final txtActividadG = TextEditingController();
  final txtCodigoActividadG = TextEditingController();
  bool actividadG = false;
  final txtNombreNegocioG = TextEditingController();
  final txtRucNegocioG = TextEditingController();
  final txtNumEmpleadosG = TextEditingController();
  final txtNumEmpleadosContratarG = TextEditingController();
  Map<String, dynamic>? tipoLocalG;
  String? textTipoLocalG;
  final txtprovinciaNegocioG = TextEditingController();
  final txtciudadNegocioG = TextEditingController();
  final txtParroquiaNegocioG = TextEditingController();
  final txtBarrioNegocioG = TextEditingController();
  final txtDireccionNegocioG = TextEditingController();
  String? latitudTG;
  String? longitudTG;
  final txtReferenciaNegocioG = TextEditingController();
  Map<String, dynamic>? origenIngresoG;
  String? textOrigenIngresoG;
  final txtInicioTrabajoG = TextEditingController();
  final txtCorreoTrabajoG = TextEditingController();
  final txtTelefonoTrabajoG = TextEditingController();
  final txtCargoG = TextEditingController();
  final txtInicioTrabajoAntG = TextEditingController();
  final txtSalidaTrabajoAntG = TextEditingController();
  Map<String, dynamic>? otraActividadEcG;
  String? textOtraActividadEconG;
  final txtInfoOtraActividadEconG = TextEditingController();
  //todo actividad económica secundaria
  bool independiente2G = false;
  bool dependiente2G = false;
  bool otraActiV2G = false;
  Map<String, dynamic>? relacionLaboral2G;
  String? textRelacionLaboral2G;
  Map<String, dynamic>? tipoNegocio2G;
  String? textNegocio2G;
  final txtExpNegocio2G = TextEditingController();
  Map<String, dynamic>? sectorNegocio2G;
  String? textSectorNegocio2G;
  final txtActividad2G = TextEditingController();
  final txtCodigoActividad2G = TextEditingController();
  bool actividad2G = false;
  final txtNombreNegocio2G = TextEditingController();
  final txtRucNegocio2G = TextEditingController();
  final txtNumEmpleados2G = TextEditingController();
  final txtNumEmpleadosContratar2G = TextEditingController();
  Map<String, dynamic>? tipoLocal2G;
  String? textTipoLocal2G;
  final txtprovinciaNegocio2G = TextEditingController();
  final txtciudadNegocio2G = TextEditingController();
  final txtParroquiaNegocio2G = TextEditingController();
  final txtBarrioNegocio2G = TextEditingController();
  final txtDireccionNegocio2G = TextEditingController();
  String? latitudT2G;
  String? longitudT2G;
  final txtReferenciaNegocio2G = TextEditingController();
  Map<String, dynamic>? origenIngreso2G;
  String? textOrigenIngreso2G;
  final txtInicioTrabajo2G = TextEditingController();
  final txtCorreoTrabajo2G = TextEditingController();
  final txtTelefonoTrabajo2G = TextEditingController();
  final txtCargo2G = TextEditingController();
  final txtInicioTrabajoAnt2G = TextEditingController();
  final txtSalidaTrabajoAnt2G = TextEditingController();
  Map<String, dynamic>? otraActividadEc2G;
  String? textOtraActividadEcon2G;
  final txtInfoOtraActividadEcon2G = TextEditingController();
  //todo situación financiera
  final txtSueldoG = TextEditingController();
  final txtVentasG = TextEditingController();
  final txtOtrosIngresosG = TextEditingController();
  final txtInfoOtrosIngresosG = TextEditingController();
  final txtTotalIngresosG = TextEditingController();
  final txtGastosPersonalesG = TextEditingController();
  final txtGastosOperacionalesG = TextEditingController();
  final txtOtrosGastosG = TextEditingController();
  final txtInfoOtrosGastosG = TextEditingController();
  final txtTotalEgresosG = TextEditingController();
  final txtSaldoDisponibleG = TextEditingController();
  final txtEfectivoCajaG = TextEditingController();
  final txtDineroBancosG = TextEditingController();
  final txtCuentasxCobrarG = TextEditingController();
  final txtInventariosG = TextEditingController();
  final txtPropiedadesG = TextEditingController();
  final txtVehiculosG = TextEditingController();
  final txtOtrosPatriG = TextEditingController();
  final txtInfoOtrosPatriG = TextEditingController();
  final txtTotalActivosG = TextEditingController();
  final txtPasivoCortoG = TextEditingController();
  final txtPasivoLargoG = TextEditingController();
  final txtTotalPasivosG = TextEditingController();
  final txtPatrimonioG = TextEditingController();
  //todo estado civil
  Map<String, dynamic>? estadoCivilG;
  String? textEstadoCivilG;
  final txtNombreDepG = TextEditingController();
  final txtApellidosDepG = TextEditingController();
  final txtFechaNacDepG = TextEditingController();
  Map<String, dynamic>? parentescoVG;
  bool enableOtrosParG = false;
  final txtInfoOtroParenG = TextEditingController();
  final txtCedulaDepG = TextEditingController();

  //todo expansion tile datos personales
  final expdpNacimientoG = ExpansionTileController();
  bool expanNacG = false;
  final expdpIdentificacionG = ExpansionTileController();
  bool expanIdentG = false;
  final expdpResidenciaG = ExpansionTileController();
  bool expanResG = false;
  final expdpEducacionG = ExpansionTileController();
  bool expanEducG = false;
  final expdpActiEconG = ExpansionTileController();
  bool expanActiEG = false;
  final expdpActiEcon2G = ExpansionTileController();
  bool expanActiE2G = false;
  final expdpSitFinanG = ExpansionTileController();
  bool expanSitFinanG = false;
  final expdpEstadoCivG = ExpansionTileController();
  bool expanEstCG = false;

  void obtenerDatosPersona() async {
    final op = Operations();

    if (widget.idGarante != 0) {
      final data = await op.obtenerPersona(widget.idGarante);
      final form = Provider.of<FormProvider>(context, listen: false).garante;

      if (data != null) {
        setState(() {
          //todo datos personales
          txtCedulaG.text = data.numeroIdentificacion!;
          form.updateValueIdentificacion("cedula", txtCedulaG.text);
          txtRucG.text = "${txtCedulaG.text}001";
          form.updateValueIdentificacion("ruc_id", txtRucG.text);
          txtNombresG.text = data.nombres;
          form.updateValuegarante("nombres", txtNombresG.text);
          txtApellidosG.text = data.apellidos;
          form.updateValuegarante("apellidos", txtApellidosG.text);
          txtCelular1G.text = data.celular1 ?? "";
          form.updateValuegarante("celular1", txtCelular1G.text);
          txtCelular2G.text = data.celular2 ?? "";
          form.updateValuegarante("celular2", txtCelular2G.text);
          txtCorreoG.text = data.mail ?? "";
          form.updateValuegarante("correo", txtCorreoG.text);
          //todo datos nacimiento
          form.updateValueNacimiento("fecha", txtFechaNacG.text);
          //todo datos identificacion
          txtCedulaG.text = data.numeroIdentificacion ?? "";
          form.updateValueIdentificacion("cedula", txtCedulaG.text);
          txtRucG.text =
              txtCedulaG.text.isNotEmpty ? "${txtCedulaG.text}001" : "";
          form.updateValueIdentificacion("ruc_id", txtRucG.text);
        });

        validarColorDatosPersonalesG();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerDatosPersona();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return expansionTile(context,
        key: widget.gk,
        children: formularioDatosPersonalesGarante(),
        title: "Datos garante",
        validateFields: widget.formKey.currentState != null
            ? widget.formKey.currentState!.validate()
            : null, func: (val) {
      if (val) {
        widget.updatePixelPosition(widget.gk);
      }
    },
        expController: widget.expController,
        enabled: widget.enableExpansion,
        color: widget.datosPersonalesG);
  }

  //todo DE AQUI PARA ABAJO ES -TODO DATOS DEL GARANTE
  Widget formularioDatosPersonalesGarante() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Form(
            key: widget.formKey,
            child: Column(
              children: [
                //todo NOMBRES
                InputTextFormFields(
                    habilitado: false,
                    onChanged: (val) {
                      validarColorDatosPersonalesG();
                      form.garante.updateValuegarante("nombres", val);
                    },
                    prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    controlador: txtNombresG,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Nombres",
                    placeHolder: ""),
                //todo APELLIDOS
                InputTextFormFields(
                    habilitado: false,
                    onChanged: (val) {
                      validarColorDatosPersonalesG();
                      form.garante.updateValuegarante("apellidos", val);
                    },
                    prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    controlador: txtApellidosG,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Apellidos",
                    placeHolder: ""),
                //todo CELULAR 1
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    onChanged: (val) {
                      validarColorDatosPersonalesG();
                      form.garante.updateValuegarante("celular1", val);
                    },
                    tipoTeclado: TextInputType.phone,
                    prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    controlador: txtCelular1G,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Celular 1",
                    placeHolder: ""),
                //todo CELULAR 2
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    onChanged: (val) {
                      form.garante.updateValuegarante("celular2", val);
                    },
                    tipoTeclado: TextInputType.phone,
                    prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                    controlador: txtCelular2G,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Celular 2",
                    placeHolder: ""),
                //todo TELÉFONO CONVENCIONAL
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    onChanged: (val) {
                      form.garante.updateValuegarante("telefono", val);
                    },
                    tipoTeclado: TextInputType.phone,
                    prefixIcon: const Icon(AbiPraxis.telefono, size: 18),
                    controlador: txtTelefonoG,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Teléfono convencional",
                    placeHolder: ""),
                //todo CORREO ELECTRÓNICO
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    onChanged: (val) {
                      validarColorDatosPersonalesG();
                      form.garante.updateValuegarante("correo", val);
                    },
                    tipoTeclado: TextInputType.emailAddress,
                    prefixIcon:
                        const Icon(AbiPraxis.correo_electronico_1, size: 18),
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    controlador: txtCorreoG,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Correo electrónico",
                    placeHolder: ""),
                //todo EXPANSIONTILE NACIMIENTO
                Form(key: widget.fNGkey, child: expansionNacimientoGarante()),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE IDENTIFICACION
                Form(
                    key: widget.fIGkey,
                    child: expansionIdentificacionGarante()),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE RESIDENCIA
                Form(key: widget.fRGkey, child: expansionResidenciaGarante()),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE EDUCACIÓN
                Form(key: widget.fEGkey, child: expansionEducacionGarante()),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE ACTIVIDAD ECONOMICA PRINCIPAL
                Form(key: widget.fAEGkey, child: expasionActEcon1Garante()),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE ACTIVIDAD ECONOMICA SECUNDARIA
                expansionActEcon2Garante(),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE SITUACIÓN FINANCIERA
                Form(
                    key: widget.fSEGkey,
                    child: expansionSitFinancieraGarante()),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE ESTADO CIVIL
                Form(key: widget.fECGkey, child: expansionEstadoCivilGarante()),
              ],
            ));
      });

  Widget expansionNacimientoGarante() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.nacimiento, size: 18),
          color: widget.datosNacimientoC,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanNacG
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Nacimiento",
          func: (_) {
            setState(() => expanNacG = !expanNacG);
          },
          expController: expdpNacimientoG,
          enabled: widget.enableExpansion,
          children: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                divider(false, color: Colors.grey),
                //todo PAIS
                DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "País",
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    value: pais,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obligatorio *';
                      } else {
                        return null;
                      }
                    },
                    items: listPaises.map((e) {
                      return DropdownMenuItem(
                          value: e.toUpperCase(), child: Text(e.toUpperCase()));
                    }).toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (value) async {
                            setState(() {
                              pais = value;

                              if (provincia != null || ciudad != null) {
                                provincia = null;
                                ciudad = null;
                              }
                              if (pais != "ECUADOR") {
                                setState(() {
                                  txtPaisG.clear();
                                  txtProvinciaG.clear();
                                  txtCiudadG.clear();
                                });
                                setState(() => otroPais = true);
                              } else {
                                setState(() => otroPais = false);
                              }
                              form.garante.updateValueNacimiento("pais", pais!);
                              provinciasVisible = true;
                              ciudadesVisible = true;
                            });
                            funcionPais(pais);
                          }),

                if (otroPais) ...[
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      controlador: txtPaisG,
                      capitalization: TextCapitalization.characters,
                      tipoTeclado: TextInputType.text,
                      prefixIcon: const Icon(Icons.location_city),
                      onChanged: (val) =>
                          form.garante.updateValueNacimiento("pais", val),
                      accionCampo: TextInputAction.next,
                      validacion: (value) {
                        if (value!.isEmpty) {
                          return "Campo obligatorio";
                        } else {
                          return null;
                        }
                      },
                      nombreCampo: "País",
                      placeHolder: "Ej: Guatemala")
                ],
                SizedBox(height: 5),
                //todo PROVINCIA
                Visibility(
                  visible: provinciasVisible,
                  child: AbsorbPointer(
                    absorbing:
                        hintTextProvincia != 'cargando...' ? false : true,
                    child: !otroPais
                        ? DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: "Provincia",
                              prefixIcon: const Icon(Icons.location_city),
                            ),
                            value: provincia,
                            validator: (value) {
                              if (pais != null) {
                                if (value == null || value.isEmpty) {
                                  return 'Llene este campo para continuar';
                                } else {
                                  return null;
                                }
                              } else {
                                return null;
                              }
                            },
                            menuMaxHeight: 300,
                            enableFeedback: false,
                            hint: Text(hintTextProvincia ?? 'Seleccione'),
                            items: listaProvincias.map((e) {
                              return DropdownMenuItem<String>(
                                value: e['nombre'].toUpperCase(),
                                child: Text("${e['nombre'].toUpperCase()}"),
                              );
                            }).toList(),
                            onChanged: (widget.edit != null && !widget.edit!)
                                ? null
                                : (value) async {
                                    setState(() {
                                      provincia = value;

                                      ciudad = null;
                                    });

                                    form.garante.updateValueNacimiento(
                                        "provincia", provincia);
                                    ciudadesVisible = true;

                                    funcionProvincia(provincia!);
                                  })
                        : InputTextFormFields(
                            habilitado: (widget.edit != null && !widget.edit!)
                                ? false
                                : true,
                            capitalization: TextCapitalization.characters,
                            controlador: txtProvinciaG,
                            tipoTeclado: TextInputType.text,
                            prefixIcon: const Icon(Icons.location_city),
                            accionCampo: TextInputAction.next,
                            onChanged: (val) => form.garante
                                .updateValueNacimiento("provincia", val),
                            validacion: (value) {
                              if (value!.isEmpty) {
                                return "Campo obligatorio";
                              } else {
                                return null;
                              }
                            },
                            nombreCampo: "Provincia",
                            placeHolder: "Ej: Guayas"),
                  ),
                ),
                SizedBox(height: 5),
                //todo CIUDAD
                Visibility(
                  visible: ciudadesVisible,
                  child: AbsorbPointer(
                    absorbing: hintTextCiudad != 'cargando...' ? false : true,
                    child: !otroPais
                        ? DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: "Ciudad",
                              prefixIcon: Icon(Icons.location_city),
                            ),
                            validator: (value) {
                              if (provincia != null) {
                                if (value == null || value.isEmpty) {
                                  return 'Llene este campo para continuar';
                                } else {
                                  return null;
                                }
                              } else {
                                return null;
                              }
                            },
                            menuMaxHeight: 300,
                            enableFeedback: false,
                            value: ciudad,
                            items: listaCiudades.map((e) {
                              return DropdownMenuItem<String>(
                                value: e.toUpperCase(),
                                child: Text(e.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (widget.edit != null && !widget.edit!)
                                ? null
                                : (value) async {
                                    setState(() {
                                      ciudad = value;
                                    });

                                    form.garante.updateValueNacimiento(
                                        "ciudad", ciudad);
                                  })
                        : InputTextFormFields(
                            habilitado: (widget.edit != null && !widget.edit!)
                                ? false
                                : true,
                            capitalization: TextCapitalization.characters,
                            controlador: txtCiudadG,
                            onChanged: (val) => form.garante
                                .updateValueNacimiento("ciudad", val),
                            tipoTeclado: TextInputType.text,
                            prefixIcon: const Icon(Icons.location_city),
                            accionCampo: TextInputAction.next,
                            validacion: (value) {
                              if (value!.isEmpty) {
                                return "Campo obligatorio";
                              } else {
                                return null;
                              }
                            },
                            nombreCampo: "Ciudad",
                            placeHolder: "Guayaquil"),
                  ),
                ),
                SizedBox(height: 5),
                //todo FECHA NACIMIENTO
                Row(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: true,
                        child: InputTextFormFields(
                            validacion: (value) =>
                                value!.isEmpty ? "Campo obligatorio" : null,
                            onChanged: (val) {
                              validarColorNacimientoG();
                              form.garante.updateValueNacimiento("fecha", val);
                            },
                            controlador: txtFechaNacG,
                            accionCampo: TextInputAction.done,
                            nombreCampo: "Fecha de nacimiento",
                            placeHolder: ""),
                      ),
                    ),
                    IconButton(
                        onPressed: (widget.edit != null && !widget.edit!)
                            ? null
                            : () async {
                                await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime.now())
                                    .then((val) {
                                  if (val != null) {
                                    setState(() {
                                      txtFechaNacG.text =
                                          DateFormat("yyyy-MM-dd").format(val);
                                    });
                                    txtEdadG.text =
                                        AgeCalculator.age(val).years.toString();

                                    validarColorNacimientoG();
                                    form.garante.updateValueNacimiento(
                                        "fecha", txtFechaNacG.text);
                                    form.garante.updateValueNacimiento(
                                        "edad", txtEdadG.text);
                                  }
                                });
                              },
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
                //todo EDAD
                InputTextFormFields(
                    tipoTeclado: TextInputType.number,
                    controlador: txtEdadG,
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    accionCampo: TextInputAction.next,
                    habilitado: false,
                    nombreCampo: "Edad",
                    placeHolder: ""),
                //todo Género
                DropdownButtonFormField(
                    validator: (value) => value == null || value.isEmpty
                        ? "Campo obligatorio"
                        : null,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const InputDecoration(label: Text("Género")),
                    value: generoG,
                    items: generos
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            if (val != null) {
                              setState(() => generoG = val);
                              setState(() => textGeneroG = val["nombre"]);
                            }
                            validarColorNacimientoG();
                            form.garante.updateValueNacimiento(
                                "genero", val!["nombre"]);
                          }),
                //todo ETNIA
                DropdownButtonFormField(
                    validator: (value) => value == null || value.isEmpty
                        ? "Campo obligatorio"
                        : null,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const InputDecoration(label: Text("Etnia")),
                    value: etniaG,
                    items: etnias
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() => etniaG = val);
                            setState(() => textEtniaG = val!["nombre"]);
                            if (val != null && val["nombre"] != "Otro") {
                              setState(() => textEtniaG = val["nombre"]);
                            } else {
                              setState(() => enableOtraEtniaG = true);
                            }
                            validarColorNacimientoG();
                            form.garante
                                .updateValueNacimiento("etnia", val!["nombre"]);
                          }),
                //todo OTRA ETNIA
                if (enableOtraEtniaG)
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      controlador: txtOtraEtiniaG,
                      tipoTeclado: TextInputType.number,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => textEtniaG = val);
                        }
                        validarColorNacimientoG();
                        form.garante.updateValueNacimiento("otra_etnia", val);
                      },
                      validacion: (value) =>
                          value!.isEmpty ? "Campo obligatorio" : null,
                      accionCampo: TextInputAction.next,
                      nombreCampo: "Otra etnia",
                      placeHolder: ""),
              ],
            ),
          ),
        );
      });

  Widget expansionIdentificacionGarante() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
            leading: const Icon(AbiPraxis.identificacion, size: 18),
            color: widget.datosIdentificacionC,
            containerColor: Colors.white,
            expandColorContainer: Colors.white,
            icon: expanIdentG
                ? const Icon(Icons.remove_circle_outline_sharp)
                : const Icon(Icons.add_circle_outline_outlined),
            context,
            title: "Identificación", func: (_) {
          setState(() => expanIdentG = !expanIdentG);
        },
            expController: expdpIdentificacionG,
            enabled: widget.enableExpansion,
            children: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    divider(false),
                    //todo CÉDULA
                    InputTextFormFields(
                        habilitado: (widget.edit != null && !widget.edit!)
                            ? false
                            : true,
                        tipoTeclado: TextInputType.number,
                        controlador: txtCedulaG,
                        onChanged: (val) {
                          validarColorIdentificacionG();
                          setState(() {
                            txtRucG.text = "${val}001";
                          });
                          form.garante.updateValueIdentificacion("cedula", val);
                        },
                        validacion: (value) =>
                            value!.isEmpty ? "Campo obligatorio" : null,
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Número de cédula",
                        placeHolder: ""),
                    //todo NÚMERO DE RUC
                    InputTextFormFields(
                        habilitado: (widget.edit != null && !widget.edit!)
                            ? false
                            : true,
                        tipoTeclado: TextInputType.number,
                        controlador: txtRucG,
                        onChanged: (val) {
                          validarColorIdentificacionG();
                          form.garante.updateValueIdentificacion("ruc_id", val);
                        },
                        validacion: (value) =>
                            value!.isEmpty ? "Campo obligatorio" : null,
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Número de RUC",
                        placeHolder: ""),
                    //todo NÚMERO DE PASAPORTE
                    InputTextFormFields(
                        habilitado: (widget.edit != null && !widget.edit!)
                            ? false
                            : true,
                        onChanged: (val) {
                          validarColorIdentificacionG();
                          form.garante
                              .updateValueIdentificacion("pasaporte", val);
                          setState(() {});
                          if (val!.isEmpty) {
                            setState(() {
                              txtFechaEntradaG.clear();
                              form.garante.updateValueIdentificacion(
                                  "fecha_entrada", null);

                              txtFechaCadPasaporteG.clear();
                              form.garante.updateValueIdentificacion(
                                  "fecha_cad_p", null);

                              txtFechaExpPasaporteG.clear();
                              form.garante.updateValueIdentificacion(
                                  "fecha_exp_p", null);

                              estadoMigratorioG = null;
                              form.garante.updateValueIdentificacion(
                                  "estado_migratorio", null);
                            });
                          }
                        },
                        controlador: txtPasaporteG,
                        validacion: (val) {
                          if (pais != null && pais == "ECUADOR") {
                            return null;
                          } else if (txtPaisG.text.isNotEmpty &&
                              txtPaisG.text.toLowerCase() == "ecuador") {
                            return null;
                          } else {
                            return "Campo obligatorio";
                          }
                        },
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Número de pasaporte",
                        placeHolder: ""),
                    //todo CAMPOS DE PASAPORTE
                    if (txtPasaporteG.text.isNotEmpty) ...[
                      //todo FECHA EXPEDICIÓN
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: true,
                              child: InputTextFormFields(
                                  validacion: (val) =>
                                      txtPasaporteG.text.isNotEmpty &&
                                              val!.isEmpty
                                          ? "Campo obligatorio"
                                          : null,
                                  controlador: txtFechaExpPasaporteG,
                                  accionCampo: TextInputAction.next,
                                  nombreCampo: "Fecha expedición pasaporte",
                                  placeHolder: ""),
                            ),
                          ),
                          IconButton(
                              onPressed: (widget.edit != null && !widget.edit!)
                                  ? null
                                  : () async {
                                      await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(
                                                  DateTime.now().year - 15),
                                              lastDate: DateTime.now())
                                          .then((val) {
                                        if (val != null) {
                                          setState(() {
                                            txtFechaExpPasaporteG.text =
                                                DateFormat("yyyy-MM-dd")
                                                    .format(val);
                                          });

                                          validarColorIdentificacionG();
                                          form.garante
                                              .updateValueIdentificacion(
                                                  "fecha_exp_p",
                                                  txtFechaExpPasaporteG.text);
                                        }
                                      });
                                    },
                              icon: const Icon(Icons.calendar_month))
                        ],
                      ),
                      //todo FECHA DE CADUCIDAD
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: true,
                              child: InputTextFormFields(
                                  validacion: (val) =>
                                      txtPasaporteG.text.isNotEmpty &&
                                              val!.isEmpty
                                          ? "Campo obligatorio"
                                          : null,
                                  controlador: txtFechaCadPasaporteG,
                                  accionCampo: TextInputAction.next,
                                  nombreCampo: "Fecha caducidad de pasaporte",
                                  placeHolder: ""),
                            ),
                          ),
                          IconButton(
                              onPressed: (widget.edit != null && !widget.edit!)
                                  ? null
                                  : () async {
                                      await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(
                                                  DateTime.now().year - 5),
                                              lastDate: DateTime(
                                                  DateTime.now().year + 15))
                                          .then((val) {
                                        if (val != null) {
                                          setState(() {
                                            txtFechaCadPasaporteG.text =
                                                DateFormat("yyyy-MM-dd")
                                                    .format(val);
                                          });

                                          validarColorIdentificacionG();
                                          form.garante
                                              .updateValueIdentificacion(
                                                  "fecha_cad_p",
                                                  txtFechaCadPasaporteG.text);
                                        }
                                      });
                                    },
                              icon: const Icon(Icons.calendar_month))
                        ],
                      ),
                      //todo FECHA DE ENTRADA
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: true,
                              child: InputTextFormFields(
                                  validacion: (val) =>
                                      txtPasaporteG.text.isNotEmpty &&
                                              val!.isEmpty
                                          ? "Campo obligatorio"
                                          : null,
                                  controlador: txtFechaEntradaG,
                                  accionCampo: TextInputAction.next,
                                  nombreCampo: "Fecha de entrada",
                                  placeHolder: ""),
                            ),
                          ),
                          IconButton(
                              onPressed: (widget.edit != null && !widget.edit!)
                                  ? null
                                  : () async {
                                      await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(
                                                  DateTime.now().year - 5),
                                              lastDate: DateTime(
                                                  DateTime.now().year + 15))
                                          .then((val) {
                                        if (val != null) {
                                          setState(() {
                                            txtFechaEntradaG.text =
                                                DateFormat("yyyy-MM-dd")
                                                    .format(val);
                                          });

                                          validarColorIdentificacionG();
                                          form.garante
                                              .updateValueIdentificacion(
                                                  "fecha_entrada",
                                                  txtFechaEntradaG.text);
                                        }
                                      });
                                    },
                              icon: const Icon(Icons.calendar_month))
                        ],
                      ),
                      //todo ESTADO MIGRATORIO
                      DropdownButtonFormField(
                          padding: const EdgeInsets.only(left: 10),
                          validator: (val) => txtPasaporteG.text.isNotEmpty &&
                                  (val == null || val.isEmpty)
                              ? "Campo obligatorio"
                              : null,
                          decoration: const InputDecoration(
                              label: Text("Estado migratorio")),
                          value: estadoMigratorioG,
                          items: estadoM
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e["nombre"])))
                              .toList(),
                          onChanged: (widget.edit != null && !widget.edit!)
                              ? null
                              : (Map<String, dynamic>? val) {
                                  setState(() =>
                                      textEstadoMigratorioG = val!["nombre"]);
                                  setState(() => estadoMigratorioG = val);
                                  validarColorIdentificacionG();
                                  form.garante.updateValueIdentificacion(
                                      "estado_migratorio", val!["nombre"]);
                                })
                    ]
                  ],
                )));
      });

  Widget expansionResidenciaGarante() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.recidencia, size: 18),
          color: widget.datosResidenciaC,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanResG
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Residencia",
          func: (_) {
            setState(() => expanResG = !expanResG);
          },
          expController: expdpResidenciaG,
          enabled: widget.enableExpansion,
          children: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                divider(false),
                //todo PAIS
                DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "País",
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    value: paisRes,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obligatorio *';
                      } else {
                        return null;
                      }
                    },
                    items: listPaises.map((e) {
                      return DropdownMenuItem(
                          value: e.toUpperCase(), child: Text(e.toUpperCase()));
                    }).toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (value) async {
                            setState(() {
                              paisRes = value;

                              if (provinciaRes != null || ciudadRes != null) {
                                provinciaRes = null;
                                ciudadRes = null;
                              }
                              if (paisRes != "ECUADOR") {
                                setState(() {
                                  txtPaisResG.clear();
                                  txtProvinciaResG.clear();
                                  txtCiudadResG.clear();
                                });
                                setState(() => otroPaisRes = true);
                              } else {
                                setState(() => otroPaisRes = false);
                              }
                              form.garante
                                  .updateValueResidencia("pais", paisRes!);
                              provinciasResVisible = true;
                              ciudadesResVisible = true;
                            });
                            funcionPaisRes(paisRes);
                          }),

                if (otroPaisRes) ...[
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      controlador: txtPaisResG,
                      capitalization: TextCapitalization.characters,
                      tipoTeclado: TextInputType.text,
                      prefixIcon: const Icon(Icons.location_city),
                      onChanged: (val) =>
                          form.garante.updateValueResidencia("pais", val),
                      accionCampo: TextInputAction.next,
                      validacion: (value) {
                        if (value!.isEmpty) {
                          return "Campo obligatorio";
                        } else {
                          return null;
                        }
                      },
                      nombreCampo: "País",
                      placeHolder: "Ej: Guatemala")
                ],
                SizedBox(height: 5),
                //todo PROVINCIA
                Visibility(
                  visible: provinciasResVisible,
                  child: AbsorbPointer(
                    absorbing:
                        hintTextProvincia != 'cargando...' ? false : true,
                    child: !otroPaisRes
                        ? DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: "Provincia",
                              prefixIcon: const Icon(Icons.location_city),
                            ),
                            value: provinciaRes,
                            validator: (value) {
                              if (paisRes != null) {
                                if (value == null || value.isEmpty) {
                                  return 'Llene este campo para continuar';
                                } else {
                                  return null;
                                }
                              } else {
                                return null;
                              }
                            },
                            menuMaxHeight: 300,
                            enableFeedback: false,
                            hint: Text(hintTextProvinciaRes ?? 'Seleccione'),
                            items: listaProvinciasRes.map((e) {
                              return DropdownMenuItem<String>(
                                value: e['nombre'].toUpperCase(),
                                child: Text("${e['nombre'].toUpperCase()}"),
                              );
                            }).toList(),
                            onChanged: (widget.edit != null && !widget.edit!)
                                ? null
                                : (value) async {
                                    setState(() {
                                      provinciaRes = value;

                                      ciudadRes = null;
                                    });

                                    form.garante.updateValueResidencia(
                                        "provincia", provinciaRes);
                                    ciudadesResVisible = true;

                                    funcionProvinciaRes(provinciaRes!);
                                  })
                        : InputTextFormFields(
                            habilitado: (widget.edit != null && !widget.edit!)
                                ? false
                                : true,
                            capitalization: TextCapitalization.characters,
                            controlador: txtProvinciaResG,
                            tipoTeclado: TextInputType.text,
                            prefixIcon: const Icon(Icons.location_city),
                            accionCampo: TextInputAction.next,
                            onChanged: (val) => form.garante
                                .updateValueResidencia("provincia", val),
                            validacion: (value) {
                              if (value!.isEmpty) {
                                return "Campo obligatorio";
                              } else {
                                return null;
                              }
                            },
                            nombreCampo: "Provincia",
                            placeHolder: "Ej: Guayas"),
                  ),
                ),
                SizedBox(height: 5),
                //todo CIUDAD
                Visibility(
                  visible: ciudadesResVisible,
                  child: AbsorbPointer(
                    absorbing:
                        hintTextCiudadRes != 'cargando...' ? false : true,
                    child: !otroPaisRes
                        ? DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: "Ciudad",
                              prefixIcon: Icon(Icons.location_city),
                            ),
                            validator: (value) {
                              if (provinciaRes != null) {
                                if (value == null || value.isEmpty) {
                                  return 'Llene este campo para continuar';
                                } else {
                                  return null;
                                }
                              } else {
                                return null;
                              }
                            },
                            menuMaxHeight: 300,
                            enableFeedback: false,
                            value: ciudadRes,
                            items: listaCiudadesRes.map((e) {
                              return DropdownMenuItem<String>(
                                value: e.toUpperCase(),
                                child: Text(e.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (widget.edit != null && !widget.edit!)
                                ? null
                                : (value) async {
                                    setState(() {
                                      ciudadRes = value;
                                    });

                                    form.garante.updateValueResidencia(
                                        "ciudad", ciudadRes);
                                  })
                        : InputTextFormFields(
                            habilitado: (widget.edit != null && !widget.edit!)
                                ? false
                                : true,
                            capitalization: TextCapitalization.characters,
                            controlador: txtCiudadResG,
                            onChanged: (val) => form.garante
                                .updateValueResidencia("ciudad", val),
                            tipoTeclado: TextInputType.text,
                            prefixIcon: const Icon(Icons.location_city),
                            accionCampo: TextInputAction.next,
                            validacion: (value) {
                              if (value!.isEmpty) {
                                return "Campo obligatorio";
                              } else {
                                return null;
                              }
                            },
                            nombreCampo: "Ciudad",
                            placeHolder: "Guayaquil"),
                  ),
                ),
                SizedBox(height: 5),
                //todo PARROQUIA
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    onChanged: (val) {
                      validarColorResidenciaG();
                      form.garante.updateValueResidencia("parroquia", val);
                    },
                    controlador: txtParroquiaResG,
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Parroquia",
                    placeHolder: ""),
                //todo BARRIO
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    onChanged: (val) {
                      validarColorResidenciaG();
                      form.garante.updateValueResidencia("barrio", val);
                    },
                    controlador: txtBarrioResG,
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Barrio",
                    placeHolder: ""),
                //todo DIRECCIÓN
                InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  onChanged: (val) {
                    validarColorResidenciaG();
                    form.garante.updateValueResidencia("direccion", val);
                  },
                  controlador: txtDireccionG,
                  validacion: (value) =>
                      value!.isEmpty ? "Campo obligatorio" : null,
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Dirección",
                  placeHolder: "",
                  icon: (widget.edit != null && !widget.edit!)
                      ? null
                      : IconButton(
                          onPressed: () async {
                            /*if (txtDireccion.text.isEmpty) {
                            scaffoldMessenger(context,
                                "Debe ingresar la dirección del domicilio para poder geolocalizar.",
                                icon: const Icon(Icons.error, color: Colors.red));
                            return;
                          }*/
                            widget.startLoading();

                            var res = await GeolocatorConfig()
                                .requestPermission(context);

                            if (res != null) {
                              var loc = await Geolocator.getCurrentPosition();

                              setState(() {
                                latitudRG = loc.latitude.toString();
                                longitudRG = loc.longitude.toString();
                              });

                              form.garante
                                  .updateValueResidencia("latitud", latitudRG);
                              form.garante.updateValueResidencia(
                                  "longitud", longitudRG);

                              debugPrint("$latitudRG, $longitudRG");

                              scaffoldMessenger(context,
                                  "Se han guardado las coordenadas de su ubicación actual",
                                  icon: const Icon(Icons.check,
                                      color: Colors.green));
                            } else {
                              scaffoldMessenger(context,
                                  "Ocurrió un error, no hemos podido guardar su ubicación actual",
                                  icon: const Icon(Icons.error,
                                      color: Colors.red));
                            }

                            widget.stopLoading();
                          },
                          icon: latitudRG != null && longitudRG != null
                              ? const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                )
                              : const Icon(Icons.add_location_alt)),
                ),
                //todo TIPO DE VIVIENDA
                DropdownButtonFormField(
                    padding: const EdgeInsets.only(left: 10),
                    value: tipoViviendaG,
                    decoration:
                        const InputDecoration(label: Text("Tipo de vivienda")),
                    items: tiposVivienda
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() => tipoViviendaG = val);
                            setState(() => textTipoViviendaG = val!["nombre"]);
                            if (val!["id"] == 1 || val["id"] == 2) {
                              setState(() => enableValorG = true);
                            } else {
                              setState(() => enableValorG = false);
                              setState(() => txtValorVG.clear());
                            }
                            validarColorResidenciaG();
                            form.garante.updateValueResidencia(
                                "tipo_vivienda", val["nombre"]);
                          }),
                //todo VALOR
                if (enableValorG)
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      controlador: txtValorVG,
                      onChanged: (val) {
                        validarColorResidenciaG();
                        form.garante.updateValueResidencia("valor", val);
                      },
                      validacion: (value) {
                        if (tipoViviendaG!["id"] == 1 ||
                            tipoViviendaG!["id"] == 2) {
                          if (value!.isEmpty) {
                            return "Campo obligatorio";
                          } else {
                            return null;
                          }
                        } else {
                          return null;
                        }
                      },
                      tipoTeclado: TextInputType.number,
                      listaFormato: [
                        ThousandsSeparatorInputFormatter(),
                        FilteringTextInputFormatter.deny(',',
                            replacementString: '.'),
                      ],
                      accionCampo: TextInputAction.next,
                      nombreCampo: "Valor (\$)",
                      placeHolder: ""),
                //todo TIEMPO EN VIVIENDA
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    onChanged: (val) {
                      validarColorResidenciaG();
                      form.garante
                          .updateValueResidencia("tiempo_vivienda", val);
                    },
                    tipoTeclado: TextInputType.number,
                    controlador: txtTiempoViviendaG,
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Tiempo en vivienda actual (años)",
                    placeHolder: ""),
                //todo SECTOR
                DropdownButtonFormField(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const InputDecoration(label: Text("Sector")),
                    value: sectorG,
                    items: sectores
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() => textSectorG = val!["nombre"]);
                            setState(() => sectorG = val);
                            validarColorResidenciaG();
                            form.garante.updateValueResidencia(
                                "sector", val!["nombre"]);
                          })
              ],
            ),
          ),
        );
      });

  Widget expansionEducacionGarante() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.educacion, size: 18),
          color: widget.datosEducacionC,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanEducG
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Educación",
          func: (_) {
            setState(() => expanEducG = !expanEducG);
          },
          expController: expdpEducacionG,
          enabled: widget.enableExpansion,
          children: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                divider(false),
                //todo NIVEL DE ESTUDIO
                DropdownButtonFormField(
                    validator: (value) => value == null || value.isEmpty
                        ? "Campo obligatorio"
                        : null,
                    padding: const EdgeInsets.only(left: 10),
                    decoration:
                        const InputDecoration(label: Text("Nivel de estudios")),
                    value: estudioG,
                    items: estudios
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() {
                              estudioG = val;
                              textEstudioG = val!["nombre"];
                            });
                            validarColorEducacionG();
                            form.garante.updateValueEducacion(
                                "estudio", val!["nombre"]);
                          }),
                //todo PROFESIÓN
                DropdownButtonFormField(
                    validator: (value) => value == null || value.isEmpty
                        ? "Campo obligatorio"
                        : null,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const InputDecoration(label: Text("Profesión")),
                    value: profesionG,
                    items: profesiones
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() {
                              profesionG = val;
                              textProsfesionG = val!["nombre"];
                              if (val["id"] == 11) {
                                enableOtraProfesionG = true;
                              } else {
                                enableOtraProfesionG = false;
                                txtOtraProfesionG.clear();
                              }
                            });
                            validarColorEducacionG();
                            form.garante.updateValueEducacion(
                                "profesion", val!["nombre"]);
                          }),
                //todo OTRA PROFESIÓN
                if (enableOtraProfesionG)
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      onChanged: (val) {
                        validarColorEducacionG();
                        form.garante
                            .updateValueEducacion("otra_profesion", val);
                      },
                      controlador: txtOtraProfesionG,
                      validacion: (value) {
                        if (enableOtraProfesionG &&
                            txtOtraProfesionG.text.isEmpty) {
                          return "Campo obligatorio";
                        } else {
                          return null;
                        }
                      },
                      accionCampo: TextInputAction.done,
                      nombreCampo: "Otra profesión",
                      placeHolder: ""),
              ],
            ),
          ),
        );
      });

  Widget expasionActEcon1Garante() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
            leading: const Icon(AbiPraxis.actividad_economica, size: 18),
            color: widget.actEconoPrinC,
            containerColor: Colors.white,
            expandColorContainer: Colors.white,
            icon: expanActiEG
                ? const Icon(Icons.remove_circle_outline_sharp)
                : const Icon(Icons.add_circle_outline_outlined),
            context,
            title: "Act. Económica principal", func: (_) {
          setState(() => expanActiEG = !expanActiEG);
        },
            expController: expdpActiEconG,
            enabled: widget.enableExpansion,
            children: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Stack(
                children: [
                  Column(
                    children: [
                      divider(false),
                      //todo RELACIÓN LABORAL
                      DropdownButtonFormField(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: const InputDecoration(
                              label: Text("Relación laboral")),
                          validator: (value) => value == null || value.isEmpty
                              ? "Campo obligatorio"
                              : null,
                          value: relacionLaboralG,
                          items: relaciones
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e["nombre"])))
                              .toList(),
                          onChanged: (widget.edit != null && !widget.edit!)
                              ? null
                              : (Map<String, dynamic>? val) {
                                  setState(() {
                                    relacionLaboralG = val;
                                    textRelacionLaboralG = val!["nombre"];
                                  });
                                  if (val!["id"] == 1) {
                                    setState(() {
                                      independienteG = true;
                                      dependienteG = false;
                                      otraActiVG = false;
                                    });
                                  } else if (val["id"] == 2) {
                                    setState(() {
                                      independienteG = false;
                                      dependienteG = true;
                                      otraActiVG = false;
                                    });
                                  } else if (val["id"] == 3) {
                                    setState(() {
                                      independienteG = false;
                                      dependienteG = false;
                                      otraActiVG = true;
                                    });
                                  }
                                  form.garante.updateValueActEconomica(
                                      "relacion_laboral", val["nombre"]);
                                }),
                      if (!otraActiVG)
                        //todo ACTIVIDAD ESPECÍFICA
                        InputTextFormFields(
                          habilitado: (widget.edit != null && !widget.edit!)
                              ? false
                              : true,
                          controlador: txtActividadG,
                          onChanged: (val) {
                            filtrarActividad(val);
                            validarColorActEconPrincG();
                            form.garante
                                .updateValueActEconomica("actividad", val);
                          },
                          validacion: (val) => independienteG && val!.isEmpty
                              ? "Campo obligatorio"
                              : null,
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Actividad específica",
                          placeHolder: "",
                        ),
                      //todo CÓDIGO ACTIVIDAD ESPECÍFICA
                      if (!otraActiVG)
                        InputTextFormFields(
                          onChanged: (val) {
                            validarColorActEconPrincG();
                            form.garante
                                .updateValueActEconomica("codigo_act", val);
                          },
                          habilitado: false,
                          controlador: txtCodigoActividadG,
                          /*validacion: (val) =>
                        independiente && val!.isEmpty ? "Campo obligatorio" : null,*/
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Código de la actividad",
                          placeHolder: "",
                        ),
                      if (independienteG) opcionesIndependienteG(),
                      if (dependienteG) opcionesDependienteG(),
                      if (otraActiVG) opcionesOtraActividadG(),
                    ],
                  ),
                  if (recomendaciones.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 100),
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
                                txtCodigoActividadG.text =
                                    recomendaciones[index]["cod"];
                                txtActividadG.text =
                                    recomendaciones[index]["nombre"];
                                recomendaciones.clear();
                              }),
                              child: Column(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      width: double.infinity,
                                      child: Text(
                                        (recomendaciones[index]["nombre"]),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
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
              ),
            ));
      });

  //todo ACTIVIDAD ECONOMICA PRINCIPAL - INDEPENDIENTE
  Widget opcionesIndependienteG() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo TIPO DE NEGOCIO
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Tipo de negocio")),
                value: tipoNegocioG,
                validator: (val) =>
                    independienteG && (val == null || val.isEmpty)
                        ? "Campo obligatorio"
                        : null,
                items: negocios
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e["nombre"])))
                    .toList(),
                onChanged: (widget.edit != null && !widget.edit!)
                    ? null
                    : (Map<String, dynamic>? val) {
                        setState(() {
                          tipoNegocioG = val;
                          textNegocioG = val!["nombre"];
                        });
                        validarColorActEconPrincG();
                        form.garante.updateValueActEconomica(
                            "tipo_negocio", val!["nombre"]);
                      }),
            //todo EXPERIENCIA DE NEGOCIO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("tiempo_negocio", val);
                },
                controlador: txtExpNegocioG,
                validacion: (val) =>
                    independienteG && val!.isEmpty ? "Campo obligatorio" : null,
                tipoTeclado: TextInputType.number,
                accionCampo: TextInputAction.next,
                nombreCampo: "Experiencia en el negocio (meses)",
                placeHolder: ""),
            //todo SECTOR NEGOCIO
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration: const InputDecoration(label: Text("Sector")),
                value: sectorNegocioG,
                validator: (val) =>
                    independienteG && (val == null || val.isEmpty)
                        ? "Campo obligatorio"
                        : null,
                items: sectores
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e["nombre"])))
                    .toList(),
                onChanged: (widget.edit != null && !widget.edit!)
                    ? null
                    : (Map<String, dynamic>? val) {
                        setState(() {
                          sectorNegocioG = val;
                          textSectorNegocioG = val!["nombre"];
                        });
                        validarColorActEconPrincG();
                        form.garante
                            .updateValueActEconomica("sector", val!["nombre"]);
                      }),

            //todo CERTIFICADO AMBIENTAL
            ListTile(
              title: const Text("Actividad require certificado ambiental"),
              trailing: Checkbox(
                  value: actividadG,
                  onChanged: (widget.edit != null && !widget.edit!)
                      ? null
                      : (val) {
                          setState(() => actividadG = !actividadG);
                          form.garante
                              .updateValueActEconomica("certificado", "$val");
                        }),
            ),
            divider(true, color: Colors.grey),
            //todo NOMBRE / RAZÓN SOCIAL
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("nombre", val);
                },
                controlador: txtNombreNegocioG,
                validacion: (value) => independienteG & value!.isEmpty
                    ? "Campo obligatorio"
                    : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Nombre o Razón Social",
                placeHolder: ""),
            //todo RUC / RISE
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("ruc", val);
                },
                tipoTeclado: TextInputType.number,
                controlador: txtRucNegocioG,
                validacion: (value) => independienteG & value!.isEmpty
                    ? "Campo obligatorio"
                    : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "RUC / RISE",
                placeHolder: ""),
            //todo NO. EMPLEADOS
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("num_empleados", val);
                },
                tipoTeclado: TextInputType.number,
                controlador: txtNumEmpleadosG,
                validacion: (value) => independienteG & value!.isEmpty
                    ? "Campo obligatorio"
                    : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "No. Empleados",
                placeHolder: ""),

            //todo TIPO DE LOCAL
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration: const InputDecoration(label: Text("Tipo de local")),
                value: tipoLocalG,
                validator: (val) =>
                    independienteG && (val == null || val.isEmpty)
                        ? "Campo obligatorio"
                        : null,
                items: tipoLocales
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e["nombre"])))
                    .toList(),
                onChanged: (widget.edit != null && !widget.edit!)
                    ? null
                    : (Map<String, dynamic>? val) {
                        setState(() {
                          tipoLocalG = val;
                          textTipoLocalG = val!["nombre"];
                        });
                        validarColorActEconPrincG();
                        form.garante.updateValueActEconomica(
                            "tipo_local", val!["nombre"]);
                      }),
            datosUbicacionNegocioG(),
          ],
        );
      });

  //todo ACTIVIDAD ECONOMICA PRINCIPAL - DEPENDIENTE
  Widget opcionesDependienteG() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo ORIGEN DE INGRESOS
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Origen de ingresos")),
                value: origenIngresoG,
                validator: (value) =>
                    dependienteG && (value == null || value.isEmpty)
                        ? "Campo obligatorio"
                        : null,
                items: ingresos
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e["nombre"])))
                    .toList(),
                onChanged: (widget.edit != null && !widget.edit!)
                    ? null
                    : (Map<String, dynamic>? val) {
                        setState(() {
                          origenIngresoG = val;
                          textOrigenIngresoG = val!["nombre"];
                        });
                        validarColorActEconPrincG();
                        form.garante.updateValueActEconomica(
                            "origen_ingresos", val!["nombre"]);
                      }),
            //todo NOMBRE / RAZÓN SOCIAL
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("nombre", val);
                },
                controlador: txtNombreNegocioG,
                validacion: (value) =>
                    dependienteG & value!.isEmpty ? "Campo obligatorio" : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Nombre o Razón Social de la empresa",
                placeHolder: ""),
            //todo RUC / RISE
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("ruc", val);
                },
                tipoTeclado: TextInputType.number,
                controlador: txtRucNegocioG,
                validacion: (value) =>
                    dependienteG & value!.isEmpty ? "Campo obligatorio" : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "RUC / RISE",
                placeHolder: ""),
            //todo FECHA INICIO TRABAJO
            Row(
              children: [
                Expanded(
                  child: AbsorbPointer(
                    absorbing: true,
                    child: InputTextFormFields(
                        validacion: (value) => dependienteG & value!.isEmpty
                            ? "Campo obligatorio"
                            : null,
                        controlador: txtInicioTrabajoG,
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Fecha de inicio de trabajo",
                        placeHolder: ""),
                  ),
                ),
                IconButton(
                    onPressed: (widget.edit != null && !widget.edit!)
                        ? null
                        : () async {
                            await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now())
                                .then((date) {
                              if (date != null) {
                                var parse =
                                    DateFormat("yyyy-MM-dd").format(date);

                                setState(() => txtInicioTrabajoG.text = parse);
                                validarColorActEconPrincG();
                                form.garante.updateValueActEconomica(
                                    "inicio_trabajo", txtInicioTrabajoG.text);
                              }
                            });
                          },
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
            //todo TIEMPO DE TRABAJO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("tiempo_negocio", val);
                },
                controlador: txtExpNegocioG,
                validacion: (val) =>
                    dependienteG && val!.isEmpty ? "Campo obligatorio" : null,
                tipoTeclado: TextInputType.number,
                accionCampo: TextInputAction.next,
                nombreCampo: "Tiempo de trabajo (meses)",
                placeHolder: ""),
            //todo CORREO ELECTRÓNICO TRABAJO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("correo", val);
                },
                tipoTeclado: TextInputType.emailAddress,
                controlador: txtCorreoTrabajoG,
                accionCampo: TextInputAction.next,
                nombreCampo: "Correo electrónico de trabajo",
                placeHolder: ""),
            //todo TELÉFONO TRABAJO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("telefono", val);
                },
                controlador: txtTelefonoTrabajoG,
                tipoTeclado: TextInputType.number,
                accionCampo: TextInputAction.next,
                nombreCampo: "Teléfono de trabajo",
                placeHolder: ""),
            //todo CARGO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("cargo", val);
                },
                controlador: txtCargoG,
                validacion: (value) =>
                    value!.isEmpty ? "Campo obligatorio" : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Cargo",
                placeHolder: ""),

            //todo FECHA INICIO TRABAJO ANTERIOR
            Row(
              children: [
                Expanded(
                  child: AbsorbPointer(
                    absorbing: true,
                    child: InputTextFormFields(
                        validacion: (value) => dependienteG & value!.isEmpty
                            ? "Campo obligatorio"
                            : null,
                        controlador: txtInicioTrabajoAntG,
                        accionCampo: TextInputAction.done,
                        nombreCampo: "Fecha de inicio trabajo anterior",
                        placeHolder: ""),
                  ),
                ),
                IconButton(
                    onPressed: (widget.edit != null && !widget.edit!)
                        ? null
                        : () async {
                            await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now())
                                .then((date) {
                              if (date != null) {
                                var parse =
                                    DateFormat("yyyy-MM-dd").format(date);
                                setState(
                                    () => txtInicioTrabajoAntG.text = parse);
                                validarColorActEconPrincG();
                                form.garante.updateValueActEconomica(
                                    "inicio_trabajo_ant",
                                    txtInicioTrabajoAntG.text);
                              }
                            });
                          },
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
            //todo FECHA SALIDA TRABAJO ANTERIOR
            Row(
              children: [
                Expanded(
                  child: AbsorbPointer(
                    absorbing: true,
                    child: InputTextFormFields(
                        validacion: (value) => dependienteG & value!.isEmpty
                            ? "Campo obligatorio"
                            : null,
                        controlador: txtSalidaTrabajoAntG,
                        accionCampo: TextInputAction.done,
                        nombreCampo: "Fecha de salida trabajo anterior",
                        placeHolder: ""),
                  ),
                ),
                IconButton(
                    onPressed: (widget.edit != null && !widget.edit!)
                        ? null
                        : () async {
                            await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now())
                                .then((date) {
                              if (date != null) {
                                var parse =
                                    DateFormat("yyyy-MM-dd").format(date);
                                setState(
                                    () => txtSalidaTrabajoAntG.text = parse);
                                validarColorActEconPrincG();
                                form.garante.updateValueActEconomica(
                                    "salida_trabajo_ant",
                                    txtSalidaTrabajoAntG.text);
                              }
                            });
                          },
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
            datosUbicacionNegocioG(),
          ],
        );
      });

  //todo OTRA ACTIVIDAD ECONÓMICA
  Widget opcionesOtraActividadG() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo OTRA ACTIVIDAD ECONÓMICA
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Otra actividad")),
                value: otraActividadEcG,
                validator: (value) =>
                    otraActiVG && (value == null || value.isEmpty)
                        ? "Campo obligatorio"
                        : null,
                items: otraActvEcon
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e["nombre"])))
                    .toList(),
                onChanged: (widget.edit != null && !widget.edit!)
                    ? null
                    : (Map<String, dynamic>? val) {
                        setState(() {
                          otraActividadEcG = val;
                          textOtraActividadEconG = val!["nombre"];
                        });
                        validarColorActEconPrincG();
                        form.garante.updateValueActEconomica(
                            "otra_actividad", val!["nombre"]);
                      }),
            //todo ESPECIFIQUE OTRA ACTIVIDAD
            if (textOtraActividadEconG == "Otros")
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  onChanged: (val) {
                    validarColorActEconPrincG();
                    form.garante.updateValueActEconomica("info_actividad", val);
                  },
                  controlador: txtInfoOtraActividadEconG,
                  validacion: (val) =>
                      otraActiVG && val!.isEmpty ? "Campo obligatorio" : null,
                  accionCampo: TextInputAction.done,
                  nombreCampo: "Especifique actividad",
                  placeHolder: "")
          ],
        );
      });

  Widget datosUbicacionNegocioG() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo PROVINCIA
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("provincia", val);
                },
                controlador: txtprovinciaNegocioG,
                validacion: (value) =>
                    (independienteG || dependienteG) && value!.isEmpty
                        ? "Campo obligatorio"
                        : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Provincia",
                placeHolder: ""),
            //todo CIUDAD
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("ciudad", val);
                },
                controlador: txtciudadNegocioG,
                validacion: (value) =>
                    (independienteG || dependienteG) && value!.isEmpty
                        ? "Campo obligatorio"
                        : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Ciudad / Cantón",
                placeHolder: ""),
            //todo PARROQUIA
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("parroquia", val);
                },
                controlador: txtParroquiaNegocioG,
                validacion: (value) =>
                    (independienteG || dependienteG) && value!.isEmpty
                        ? "Campo obligatorio"
                        : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Parroquia",
                placeHolder: ""),
            //todo BARRIO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("barrio", val);
                },
                controlador: txtBarrioNegocioG,
                validacion: (value) =>
                    (independienteG || dependienteG) && value!.isEmpty
                        ? "Campo obligatorio"
                        : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Barrio",
                placeHolder: ""),
            //todo DIRECCIÓN
            InputTextFormFields(
              habilitado: (widget.edit != null && !widget.edit!) ? false : true,
              onChanged: (val) {
                validarColorActEconPrincG();
                form.garante.updateValueActEconomica("direccion", val);
              },
              controlador: txtDireccionNegocioG,
              validacion: (value) =>
                  (independienteG || dependienteG) && value!.isEmpty
                      ? "Campo obligatorio"
                      : null,
              accionCampo: TextInputAction.next,
              nombreCampo: "Dirección",
              placeHolder: "",
              icon: IconButton(
                  onPressed: (widget.edit != null && !widget.edit!)
                      ? null
                      : () async {
                          /*if (txtDireccionNegocio.text.isEmpty) {
                        scaffoldMessenger(context,
                            "Debe ingresar la dirección del negocio para poder geolocalizar.",
                            icon: const Icon(Icons.error, color: Colors.red));
                        return;
                      }*/
                          widget.startLoading();

                          var res = await GeolocatorConfig()
                              .requestPermission(context);

                          if (res != null) {
                            var loc = await Geolocator.getCurrentPosition();

                            setState(() {
                              latitudTG = loc.latitude.toString();
                              longitudTG = loc.longitude.toString();
                            });

                            form.garante
                                .updateValueActEconomica("latitud", latitudTG);
                            form.garante.updateValueActEconomica(
                                "longitud", longitudTG);

                            await op.actualizarGeolocalizacionPersona(
                                widget.idGarante,
                                2,
                                latitudTG!,
                                longitudTG!,
                                txtDireccionNegocioG.text);

                            debugPrint("$latitudTG, $longitudTG");

                            scaffoldMessenger(context,
                                "Se han guardado las coordenadas de tu ubicación actual",
                                icon: const Icon(Icons.check,
                                    color: Colors.green));
                          } else {
                            scaffoldMessenger(context,
                                "Ocurrió un error, no hemos podido guardar tu ubicación actual",
                                icon:
                                    const Icon(Icons.error, color: Colors.red));
                          }

                          widget.stopLoading();
                        },
                  icon: latitudTG != null && longitudTG != null
                      ? const Icon(
                          Icons.location_on,
                          color: Colors.green,
                        )
                      : const Icon(Icons.add_location_alt)),
            ),
            //todo REFERENCIA
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante.updateValueActEconomica("referencia", val);
                },
                controlador: txtReferenciaNegocioG,
                validacion: (value) =>
                    (independienteG || dependienteG) && value!.isEmpty
                        ? "Campo obligatorio"
                        : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Referencia",
                placeHolder: ""),
          ],
        );
      });

  Widget expansionActEcon2Garante() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
            leading: const Icon(AbiPraxis.actividad_economica, size: 18),
            color: widget.actEconoSecC,
            containerColor: Colors.white,
            expandColorContainer: Colors.white,
            icon: expanActiE2G
                ? const Icon(Icons.remove_circle_outline_sharp)
                : const Icon(Icons.add_circle_outline_outlined),
            context,
            title: "Act. Económica secundaria", func: (_) {
          setState(() => expanActiE2G = !expanActiE2G);
        },
            expController: expdpActiEcon2G,
            enabled: widget.enableExpansion,
            children: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Stack(
                children: [
                  Column(
                    children: [
                      divider(false),
                      //todo RELACIÓN LABORAL
                      DropdownButtonFormField(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: const InputDecoration(
                              label: Text("Relación laboral")),
                          /*validator: (value) => value == null || value.isEmpty
                          ? "Campo obligatorio"
                          : null,*/
                          value: relacionLaboral2G,
                          items: relaciones
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e["nombre"])))
                              .toList(),
                          onChanged: (widget.edit != null && !widget.edit!)
                              ? null
                              : (Map<String, dynamic>? val) {
                                  setState(() {
                                    relacionLaboral2G = val;
                                    textRelacionLaboral2G = val!["nombre"];
                                  });
                                  if (val!["id"] == 1) {
                                    setState(() {
                                      independiente2G = true;
                                      dependiente2G = false;
                                      otraActiV2G = false;
                                    });
                                  } else if (val["id"] == 2) {
                                    setState(() {
                                      independiente2G = false;
                                      dependiente2G = true;

                                      otraActiV2G = false;
                                    });
                                  } else if (val["id"] == 3) {
                                    setState(() {
                                      independiente2G = false;
                                      dependiente2G = false;

                                      otraActiV2G = true;
                                    });
                                  }
                                  form.garante.updateValueActEconomicaSec(
                                      "relacion_laboral", val["nombre"]);
                                }),
                      if (!otraActiV2G)
                        InputTextFormFields(
                          habilitado: (widget.edit != null && !widget.edit!)
                              ? false
                              : true,
                          controlador: txtActividad2G,
                          onChanged: (val) {
                            filtrarActividad(val);
                            form.garante
                                .updateValueActEconomicaSec("actividad", val);
                          },
                          /*validacion: (val) =>
                    independiente2 && val!.isEmpty ? "Campo obligatorio" : null,*/
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Actividad específica",
                          placeHolder: "",
                        ),
                      //todo CÓDIGO ACTIVIDAD ESPECÍFICA
                      if (!otraActiV2G)
                        InputTextFormFields(
                          habilitado: false,
                          controlador: txtCodigoActividad2G,
                          onChanged: (val) => form.garante
                              .updateValueActEconomicaSec("codigo_act", val),
                          /*validacion: (val) =>
                    independiente2 && val!.isEmpty ? "Campo obligatorio" : null,*/
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Código de la actividad",
                          placeHolder: "",
                        ),
                      if (independiente2G) opcionesIndependiente2G(),
                      if (dependiente2G) opcionesDependiente2G(),
                      if (otraActiV2G) opcionesOtraActividad2G(),
                    ],
                  ),
                  if (recomendaciones.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 100),
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
                                txtCodigoActividad2G.text =
                                    recomendaciones[index]["cod"];
                                txtActividad2G.text =
                                    recomendaciones[index]["nombre"];
                                recomendaciones.clear();
                              }),
                              child: Column(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      width: double.infinity,
                                      child: Text(
                                        (recomendaciones[index]["nombre"]),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
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
              ),
            ));
      });

  //todo ACTIVIDAD ECONOMICA SECUNDARIA - INDEPENDIENTE
  Widget opcionesIndependiente2G() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo TIPO DE NEGOCIO
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Tipo de negocio")),
                value: tipoNegocio2G,
                /*validator: (val) => independiente2 && (val == null || val.isEmpty)
                      ? "Campo obligatorio"
                      : null,*/
                items: negocios
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e["nombre"])))
                    .toList(),
                onChanged: (widget.edit != null && !widget.edit!)
                    ? null
                    : (Map<String, dynamic>? val) {
                        setState(() {
                          tipoNegocio2G = val;
                          textNegocio2G = val!["nombre"];
                        });

                        form.garante.updateValueActEconomicaSec(
                            "tipo_negocio", val!["nombre"]);
                      }),
            //todo EXPERIENCIA DE NEGOCIO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtExpNegocio2G,
                onChanged: (val) => form.garante
                    .updateValueActEconomicaSec("tiempo_negocio", val),
                /*validacion: (val) =>
                      independiente && val!.isEmpty ? "Campo obligatorio" : null,*/
                tipoTeclado: TextInputType.number,
                accionCampo: TextInputAction.next,
                nombreCampo: "Experiencia en el negocio (meses)",
                placeHolder: ""),
            //todo SECTOR NEGOCIO
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration: const InputDecoration(label: Text("Sector")),
                value: sectorNegocio2G,
                /*validator: (val) => independiente2 && (val == null || val.isEmpty)
                      ? "Campo obligatorio"
                      : null,*/
                items: sectores
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e["nombre"])))
                    .toList(),
                onChanged: (widget.edit != null && !widget.edit!)
                    ? null
                    : (Map<String, dynamic>? val) {
                        setState(() {
                          sectorNegocio2G = val;
                          textSectorNegocio2G = val!["nombre"];
                        });
                        form.garante.updateValueActEconomicaSec(
                            "sector", val!["nombre"]);
                      }),

            //todo CERTIFICADO AMBIENTAL
            ListTile(
              title: const Text("Actividad require certificado ambiental"),
              trailing: Checkbox(
                  value: actividad2G,
                  onChanged: (widget.edit != null && !widget.edit!)
                      ? null
                      : (val) {
                          setState(() => actividad2G = !actividad2G);
                          form.garante.updateValueActEconomicaSec(
                              "certificado", val.toString());
                        }),
            ),
            divider(true, color: Colors.grey),
            //todo NOMBRE / RAZÓN SOCIAL
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtNombreNegocio2G,
                onChanged: (val) =>
                    form.garante.updateValueActEconomicaSec("nombre", val),
                /*validacion: (value) =>
                      independiente2 && value!.isEmpty ? "Campo obligatorio" : null,*/
                accionCampo: TextInputAction.next,
                nombreCampo: "Nombre o Razón Social",
                placeHolder: ""),
            //todo RUC / RISE
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                tipoTeclado: TextInputType.number,
                controlador: txtRucNegocio2G,
                onChanged: (val) =>
                    form.garante.updateValueActEconomicaSec("ruc", val),
                /*validacion: (value) =>
                      independiente2 && value!.isEmpty ? "Campo obligatorio" : null,*/
                accionCampo: TextInputAction.next,
                nombreCampo: "RUC / RISE",
                placeHolder: ""),
            //todo NO. EMPLEADOS
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                tipoTeclado: TextInputType.number,
                controlador: txtNumEmpleados2G,
                onChanged: (val) => form.garante
                    .updateValueActEconomicaSec("num_empleados", val),
                /*validacion: (value) =>
                      independiente2 && value!.isEmpty ? "Campo obligatorio" : null,*/
                accionCampo: TextInputAction.next,
                nombreCampo: "No. Empleados",
                placeHolder: ""),

            //todo TIPO DE LOCAL
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration: const InputDecoration(label: Text("Tipo de local")),
                value: tipoLocal2G,
                /*validator: (val) => independiente2 && (val == null || val.isEmpty)
                      ? "Campo obligatorio"
                      : null,*/
                items: tipoLocales
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e["nombre"])))
                    .toList(),
                onChanged: (widget.edit != null && !widget.edit!)
                    ? null
                    : (Map<String, dynamic>? val) {
                        setState(() {
                          tipoLocal2G = val;
                          textTipoLocal2G = val!["nombre"];
                        });
                        form.garante.updateValueActEconomicaSec(
                            "tipo_local", val!["nombre"]);
                      }),
            datosUbicacionNegocio2G(),
          ],
        );
      });

  //todo ACTIVIDAD ECONOMICA PRINCIPAL - DEPENDIENTE
  Widget opcionesDependiente2G() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo ORIGEN DE INGRESOS
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Origen de ingresos")),
                value: origenIngreso2G,
                /*validator: (value) =>
                      dependiente2 && (value == null || value.isEmpty)
                          ? "Campo obligatorio"
                          : null,*/
                items: ingresos
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e["nombre"])))
                    .toList(),
                onChanged: (widget.edit != null && !widget.edit!)
                    ? null
                    : (Map<String, dynamic>? val) {
                        setState(() {
                          origenIngreso2G = val;
                          textOrigenIngreso2G = val!["nombre"];
                        });
                        form.garante.updateValueActEconomicaSec(
                            "origen_ingresos", val!["nombre"]);
                      }),
            //todo NOMBRE / RAZÓN SOCIAL
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtNombreNegocio2G,
                onChanged: (val) =>
                    form.garante.updateValueActEconomicaSec("nombre", val),
                /*validacion: (value) =>
                      dependiente2 & value!.isEmpty ? "Campo obligatorio" : null,
                  accionCampo: TextInputAction.next,*/
                nombreCampo: "Nombre o Razón Social de la empresa",
                placeHolder: ""),
            //todo RUC / RISE
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                tipoTeclado: TextInputType.number,
                controlador: txtRucNegocio2G,
                onChanged: (val) =>
                    form.garante.updateValueActEconomicaSec("ruc", val),
                /*validacion: (value) =>
                      dependiente2 & value!.isEmpty ? "Campo obligatorio" : null,*/
                accionCampo: TextInputAction.next,
                nombreCampo: "RUC / RISE",
                placeHolder: ""),
            //todo FECHA INICIO TRABAJO
            Row(
              children: [
                Expanded(
                  child: InputTextFormFields(
                      controlador: txtInicioTrabajo2G,
                      habilitado: false,
                      accionCampo: TextInputAction.next,
                      nombreCampo: "Fecha de inicio de trabajo",
                      placeHolder: ""),
                ),
                IconButton(
                    onPressed: (widget.edit != null && !widget.edit!)
                        ? null
                        : () async {
                            await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now())
                                .then((date) {
                              if (date != null) {
                                var parse =
                                    DateFormat("yyyy-MM-dd").format(date);

                                setState(() => txtInicioTrabajo2G.text = parse);
                                form.garante.updateValueActEconomicaSec(
                                    "inicio_trabajo", txtInicioTrabajo2G.text);
                              }
                            });
                          },
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
            //todo TIEMPO DE TRABAJO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtExpNegocio2G,
                /*validacion: (val) =>
                      dependiente2 && val!.isEmpty ? "Campo obligatorio" : null,*/
                onChanged: (val) => form.garante
                    .updateValueActEconomicaSec("tiempo_negocio", val),
                tipoTeclado: TextInputType.number,
                accionCampo: TextInputAction.next,
                nombreCampo: "Tiempo de trabajo (meses)",
                placeHolder: ""),
            //todo CORREO ELECTRÓNICO TRABAJO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                tipoTeclado: TextInputType.emailAddress,
                onChanged: (val) =>
                    form.garante.updateValueActEconomicaSec("correo", val),
                controlador: txtCorreoTrabajo2G,
                accionCampo: TextInputAction.next,
                nombreCampo: "Correo electrónico de trabajo",
                placeHolder: ""),
            //todo TELÉFONO TRABAJO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtTelefonoTrabajo2G,
                onChanged: (val) =>
                    form.garante.updateValueActEconomicaSec("telefono", val),
                tipoTeclado: TextInputType.number,
                accionCampo: TextInputAction.next,
                nombreCampo: "Teléfono de trabajo",
                placeHolder: ""),
            //todo CARGO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtCargo2G,
                onChanged: (val) =>
                    form.garante.updateValueActEconomicaSec("cargo", val),
                /*validacion: (value) =>
                      dependiente2 && value!.isEmpty ? "Campo obligatorio" : null,*/
                accionCampo: TextInputAction.next,
                nombreCampo: "Cargo",
                placeHolder: ""),

            //todo FECHA INICIO TRABAJO ANTERIOR
            Row(
              children: [
                Expanded(
                  child: InputTextFormFields(
                      habilitado: false,
                      controlador: txtInicioTrabajoAnt2G,
                      accionCampo: TextInputAction.done,
                      nombreCampo: "Fecha de inicio trabajo anterior",
                      placeHolder: ""),
                ),
                IconButton(
                    onPressed: (widget.edit != null && !widget.edit!)
                        ? null
                        : () async {
                            await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now())
                                .then((date) {
                              if (date != null) {
                                var parse =
                                    DateFormat("yyyy-MM-dd").format(date);
                                setState(
                                    () => txtInicioTrabajoAnt2G.text = parse);
                                form.garante.updateValueActEconomicaSec(
                                    "inicio_trabajo_ant",
                                    txtInicioTrabajoAnt2G.text);
                              }
                            });
                          },
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
            //todo FECHA SALIDA TRABAJO ANTERIOR
            Row(
              children: [
                Expanded(
                  child: InputTextFormFields(
                      habilitado: false,
                      controlador: txtSalidaTrabajoAnt2G,
                      accionCampo: TextInputAction.done,
                      nombreCampo: "Fecha de salida trabajo anterior",
                      placeHolder: ""),
                ),
                IconButton(
                    onPressed: (widget.edit != null && !widget.edit!)
                        ? null
                        : () async {
                            await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now())
                                .then((date) {
                              if (date != null) {
                                var parse =
                                    DateFormat("yyyy-MM-dd").format(date);
                                setState(
                                    () => txtSalidaTrabajoAnt2G.text = parse);
                                form.garante.updateValueActEconomicaSec(
                                    "salida_trabajo_ant",
                                    txtSalidaTrabajoAnt2G.text);
                              }
                            });
                          },
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
            datosUbicacionNegocio2G(),
          ],
        );
      });

  //todo OTRA ACTIVIDAD ECONÓMICA
  Widget opcionesOtraActividad2G() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo OTRA ACTIVIDAD ECONÓMICA
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Otra actividad")),
                value: otraActividadEc2G,
                validator: (value) =>
                    otraActiV2G && (value == null || value.isEmpty)
                        ? "Campo obligatorio"
                        : null,
                items: otraActvEcon
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e["nombre"])))
                    .toList(),
                onChanged: (widget.edit != null && !widget.edit!)
                    ? null
                    : (Map<String, dynamic>? val) {
                        setState(() {
                          otraActividadEc2G = val;
                          textOtraActividadEcon2G = val!["nombre"];
                        });
                        form.garante.updateValueActEconomicaSec(
                            "otra_actividad", val!["nombre"]);
                        validarColorActEconPrincG();
                      }),
            //todo ESPECIFIQUE OTRA ACTIVIDAD
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrincG();
                  form.garante
                      .updateValueActEconomicaSec("info_actividad", val);
                },
                controlador: txtInfoOtraActividadEcon2G,
                validacion: (val) =>
                    otraActiV2G && val!.isEmpty ? "Campo obligatorio" : null,
                accionCampo: TextInputAction.done,
                nombreCampo: "Especifique actividad",
                placeHolder: "")
          ],
        );
      });

  Widget datosUbicacionNegocio2G() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo PROVINCIA
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtprovinciaNegocio2G,
                onChanged: (val) =>
                    form.garante.updateValueActEconomicaSec("provincia", val),
                /*validacion: (value) =>
                      (independiente2 || dependiente2) && value!.isEmpty
                          ? "Campo obligatorio"
                          : null,*/
                accionCampo: TextInputAction.next,
                nombreCampo: "Provincia",
                placeHolder: ""),
            //todo CIUDAD
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtciudadNegocio2G,
                onChanged: (val) =>
                    form.garante.updateValueActEconomicaSec("ciudad", val),
                /*validacion: (value) =>
                      (independiente2 || dependiente2) && value!.isEmpty
                          ? "Campo obligatorio"
                          : null,*/
                accionCampo: TextInputAction.next,
                nombreCampo: "Ciudad / Cantón",
                placeHolder: ""),
            //todo PARROQUIA
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtParroquiaNegocio2G,
                onChanged: (val) =>
                    form.garante.updateValueActEconomicaSec("parroquia", val),
                /*validacion: (value) =>
                      (independiente2 || dependiente2) && value!.isEmpty
                          ? "Campo obligatorio"
                          : null,*/
                accionCampo: TextInputAction.next,
                nombreCampo: "Parroquia",
                placeHolder: ""),
            //todo BARRIO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtBarrioNegocio2G,
                onChanged: (val) =>
                    form.garante.updateValueActEconomicaSec("barrio", val),
                /*validacion: (value) =>
                      (independiente2 || dependiente2) && value!.isEmpty
                          ? "Campo obligatorio"
                          : null,*/
                accionCampo: TextInputAction.next,
                nombreCampo: "Barrio",
                placeHolder: ""),
            //todo DIRECCIÓN
            InputTextFormFields(
              habilitado: (widget.edit != null && !widget.edit!) ? false : true,
              controlador: txtDireccionNegocio2G,
              onChanged: (val) =>
                  form.garante.updateValueActEconomicaSec("direccion", val),
              /*validacion: (value) =>
                    (independiente2 || dependiente2) && value!.isEmpty
                        ? "Campo obligatorio"
                        : null,*/
              accionCampo: TextInputAction.next,
              nombreCampo: "Dirección",
              placeHolder: "",
              icon: IconButton(
                  onPressed: (widget.edit != null && !widget.edit!)
                      ? null
                      : () async {
                          /*if (txtDireccionNegocio.text.isEmpty) {
                        scaffoldMessenger(context,
                            "Debe ingresar la dirección del negocio para poder geolocalizar.",
                            icon: const Icon(Icons.error, color: Colors.red));
                        return;
                      }*/
                          widget.startLoading();

                          var res = await GeolocatorConfig()
                              .requestPermission(context);

                          if (res != null) {
                            var loc = await Geolocator.getCurrentPosition();

                            setState(() {
                              latitudT2G = loc.latitude.toString();
                              longitudT2G = loc.longitude.toString();
                            });

                            form.garante.updateValueActEconomicaSec(
                                "latitud", latitudT2G);
                            form.garante.updateValueActEconomicaSec(
                                "longitud", longitudT2G);

                            debugPrint("$latitudT2G, $longitudT2G");

                            scaffoldMessenger(context,
                                "Se han guardado las coordenadas de tu ubicación actual",
                                icon: const Icon(Icons.check,
                                    color: Colors.green));
                          } else {
                            scaffoldMessenger(context,
                                "Ocurrió un error, no hemos podido guardar tu ubicación actual",
                                icon:
                                    const Icon(Icons.error, color: Colors.red));
                          }

                          widget.stopLoading();
                        },
                  icon: latitudT2G != null && longitudT2G != null
                      ? const Icon(
                          Icons.location_on,
                          color: Colors.green,
                        )
                      : const Icon(Icons.add_location_alt)),
            ),
            //todo REFERENCIA
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtReferenciaNegocio2G,
                onChanged: (val) =>
                    form.garante.updateValueActEconomicaSec("referencia", val),
                /*validacion: (value) =>
                      (independiente2 || dependiente2) && value!.isEmpty
                          ? "Campo obligatorio"
                          : null,*/
                accionCampo: TextInputAction.next,
                nombreCampo: "Referencia",
                placeHolder: ""),
          ],
        );
      });

  Widget expansionSitFinancieraGarante() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.estado_situacion_financiera, size: 18),
          color: widget.datosSitEconC,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanSitFinanG
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Situación económica",
          func: (_) {
            setState(() => expanSitFinanG = !expanSitFinanG);
          },
          expController: expdpSitFinanG,
          enabled: widget.enableExpansion,
          children: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                divider(false),
                //todo SUELDO
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtSueldoG,
                    onChanged: (val) {
                      var sueldo = double.parse((val!.isNotEmpty ? val : "0"));
                      var venta = double.parse(
                          txtVentasG.text.isNotEmpty ? txtVentasG.text : "0");
                      var otros = double.parse(txtOtrosIngresosG.text.isNotEmpty
                          ? txtOtrosIngresosG.text
                          : "0");

                      setState(() => txtTotalIngresosG.text =
                          (sueldo + venta + otros).toString());

                      calcularSaldoDisponibleG();
                      validarColorSitEconomG();
                    },
                    tipoTeclado: TextInputType.number,
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      //ThousandsSeparatorInputFormatter(),
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Sueldo (\$)",
                    placeHolder: ""),
                //todo VENTAS
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtVentasG,
                    tipoTeclado: TextInputType.number,
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    onChanged: (val) {
                      var sueldo = double.parse(
                          (txtSueldoG.text.isNotEmpty ? txtSueldoG.text : "0"));
                      var venta = double.parse(val!.isNotEmpty ? val : "0");

                      setState(() => txtTotalIngresosG.text =
                          (sueldo + venta).toStringAsFixed(2));
                      calcularSaldoDisponibleG();
                      validarColorSitEconomG();
                    },
                    listaFormato: [
                      //ThousandsSeparatorInputFormatter(),
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Ventas (\$)",
                    placeHolder: ""),
                //todo OTROS INGRESOS
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    icon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.info)),
                    controlador: txtOtrosIngresosG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      var sueldo = double.parse(
                          (txtSueldoG.text.isNotEmpty ? txtSueldoG.text : "0"));
                      var venta = double.parse(
                          txtVentasG.text.isNotEmpty ? txtVentasG.text : "0");
                      var otros = double.parse(val!.isNotEmpty ? val : "0");

                      setState(() => txtTotalIngresosG.text =
                          (sueldo + venta + otros).toStringAsFixed(2));
                      calcularSaldoDisponibleG();
                      validarColorSitEconomG();
                    },
                    /*validacion: (value) =>
                          value!.isEmpty ? "Campo obligatorio" : null,*/
                    listaFormato: [
                      //ThousandsSeparatorInputFormatter(),
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Otros ingresos (\$)",
                    placeHolder: ""),
                //todo INFO OTROS INGRESOS
                if (txtOtrosIngresosG.text.isNotEmpty)
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      onChanged: (val) {
                        validarColorSitEconomG();

                        form.garante
                            .updateValueSitEcon("info_otro_ingreso", val);
                      },
                      controlador: txtInfoOtrosIngresosG,
                      validacion: (val) {
                        if (txtOtrosIngresosG.text.isNotEmpty && val!.isEmpty) {
                          return "Campo obligatorio";
                        } else {
                          return null;
                        }
                      },
                      accionCampo: TextInputAction.next,
                      nombreCampo: "Especifique origen de otros ingresos",
                      placeHolder: ""),
                //todo TOTAL DE INGRESOS
                InputTextFormFields(
                    habilitado: false,
                    controlador: txtTotalIngresosG,
                    tipoTeclado: TextInputType.number,
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      //ThousandsSeparatorInputFormatter(),
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Total de ingresos (\$)",
                    placeHolder: ""),
                //todo GASTOS PERSONALES
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    icon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.info)),
                    controlador: txtGastosPersonalesG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      var gp = double.parse(txtGastosPersonalesG.text.isNotEmpty
                          ? txtGastosPersonalesG.text
                          : "0");
                      var go = double.parse(
                          txtGastosOperacionalesG.text.isNotEmpty
                              ? txtGastosOperacionalesG.text
                              : "0");

                      var oe = double.parse(txtOtrosGastosG.text.isNotEmpty
                          ? txtOtrosGastosG.text
                          : "0");

                      setState(() => txtTotalEgresosG.text =
                          (gp + go + oe).toStringAsFixed(2));
                      calcularSaldoDisponibleG();
                      validarColorSitEconomG();
                    },
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      //ThousandsSeparatorInputFormatter(),
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Gastos personales (\$)",
                    placeHolder: ""),
                //todo GASTOS OPERACIONALES
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    icon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.info)),
                    controlador: txtGastosOperacionalesG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      var gp = double.parse(txtGastosPersonalesG.text.isNotEmpty
                          ? txtGastosPersonalesG.text
                          : "0");
                      var go = double.parse(
                          txtGastosOperacionalesG.text.isNotEmpty
                              ? txtGastosOperacionalesG.text
                              : "0");

                      var oe = double.parse(txtOtrosGastosG.text.isNotEmpty
                          ? txtOtrosGastosG.text
                          : "0");

                      setState(() => txtTotalEgresosG.text =
                          (gp + go + oe).toStringAsFixed(2));
                      calcularSaldoDisponibleG();
                      validarColorSitEconomG();
                    },
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      //ThousandsSeparatorInputFormatter(),
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Gastos operacionales (\$)",
                    placeHolder: ""),
                //todo OTROS EGRESOS
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtOtrosGastosG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      var gp = double.parse(txtGastosPersonalesG.text.isNotEmpty
                          ? txtGastosPersonalesG.text
                          : "0");
                      var go = double.parse(
                          txtGastosOperacionalesG.text.isNotEmpty
                              ? txtGastosOperacionalesG.text
                              : "0");

                      var oe = double.parse(txtOtrosGastosG.text.isNotEmpty
                          ? txtOtrosGastosG.text
                          : "0");

                      setState(() => txtTotalEgresosG.text =
                          (gp + go + oe).toStringAsFixed(2));
                      calcularSaldoDisponibleG();
                      validarColorSitEconomG();
                    },
                    /*validacion: (value) =>
                          value!.isEmpty ? "Campo obligatorio" : null,*/
                    listaFormato: [
                      //ThousandsSeparatorInputFormatter(),
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Otros egresos (\$)",
                    placeHolder: ""),
                //todo ESPECIFICAR OTROS EGRESOS
                if (txtOtrosGastosG.text.isNotEmpty)
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      onChanged: (val) {
                        validarColorSitEconomG();
                        form.garante
                            .updateValueSitEcon("info_otro_egreso", val);
                      },
                      controlador: txtInfoOtrosGastosG,
                      validacion: (val) {
                        if (txtOtrosGastosG.text.isNotEmpty && val!.isEmpty) {
                          return "Campo obligatorio";
                        } else {
                          return null;
                        }
                      },
                      accionCampo: TextInputAction.next,
                      nombreCampo: "Especifique origen de otros egresos",
                      placeHolder: ""),
                //todo TOTAL DE EGRESOS
                InputTextFormFields(
                    habilitado: false,
                    controlador: txtTotalEgresosG,
                    tipoTeclado: TextInputType.number,
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Total de egresos (\$)",
                    placeHolder: ""),
                //todo SALDO DISPONIBLE
                InputTextFormFields(
                    controlador: txtSaldoDisponibleG,
                    habilitado: false,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Saldo disponible (\$)",
                    placeHolder: ""),
                //todo EFECTIVO EN CAJA
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtEfectivoCajaG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivosG();
                      validarColorSitEconomG();
                    },
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Efectivo en caja (\$)",
                    placeHolder: ""),

                //todo DINERO DEN BANCO
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtDineroBancosG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivosG();

                      validarColorSitEconomG();
                    },
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Dinero en bancos (\$)",
                    placeHolder: ""),
                //todo CUENTAS POR COBRAR
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtCuentasxCobrarG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivosG();

                      validarColorSitEconomG();
                    },
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Cuentas por cobrar (\$)",
                    placeHolder: ""),
                //todo INVENTARIOS
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtInventariosG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivosG();
                      validarColorSitEconomG();
                    },
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Inventarios (\$)",
                    placeHolder: ""),
                //todo PROPIEDADES
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtPropiedadesG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivosG();
                      validarColorSitEconomG();
                    },
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Propiedades (\$)",
                    placeHolder: ""),
                //todo VEHÍCULOS
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtVehiculosG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivosG();
                      validarColorSitEconomG();
                    },
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Vehículos (\$)",
                    placeHolder: ""),
                //todo OTROS PATRIMONIOS
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtOtrosPatriG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivosG();
                      validarColorSitEconomG();
                    },
                    /*validacion: (value) =>
                          value!.isEmpty ? "Campo obligatorio" : null,*/
                    listaFormato: [
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Otros patrimonios (\$)",
                    placeHolder: ""),
                //todo INFO OTROS PATRIMONIOS
                if (txtOtrosPatriG.text.isNotEmpty)
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      onChanged: (val) {
                        validarColorSitEconomG();
                        form.garante
                            .updateValueSitEcon("info_otro_activo", val);
                      },
                      controlador: txtInfoOtrosPatriG,
                      validacion: (val) {
                        if (txtOtrosPatriG.text.isNotEmpty && val!.isEmpty) {
                          return "Campo obligatorio";
                        } else {
                          return null;
                        }
                      },
                      accionCampo: TextInputAction.next,
                      nombreCampo: "Especifique origen de otros patrimonios",
                      placeHolder: ""),
                //todo TOTAL DE ACTIVOS
                InputTextFormFields(
                    habilitado: false,
                    controlador: txtTotalActivosG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (_) {
                      calcularPatrimonioG();
                      validarColorSitEconomG();
                    },
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      ThousandsSeparatorInputFormatter(),
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Total de activos (\$)",
                    placeHolder: ""),
                //todo PASIVO CORTO
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtPasivoCortoG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularPasivosG();
                      calcularPatrimonioG();
                      validarColorSitEconomG();
                    },
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Pasivo corto plazo (\$)",
                    placeHolder: ""),
                //todo PASIVO LARGO
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtPasivoLargoG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularPasivosG();
                      calcularPatrimonioG();
                      validarColorSitEconomG();
                    },
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Pasivo largo plazo (\$)",
                    placeHolder: ""),
                //todo TOTAL PASIVOS
                InputTextFormFields(
                    habilitado: false,
                    controlador: txtTotalPasivosG,
                    tipoTeclado: TextInputType.number,
                    onChanged: (_) {
                      calcularPatrimonioG();
                      validarColorSitEconomG();
                    },
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      ThousandsSeparatorInputFormatter(),
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Total de pasivos (\$)",
                    placeHolder: ""),
                //todo PATRIMONIO
                InputTextFormFields(
                    onChanged: (_) => validarColorSitEconomG(),
                    habilitado: false,
                    controlador: txtPatrimonioG,
                    tipoTeclado: TextInputType.number,
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    listaFormato: [
                      ThousandsSeparatorInputFormatter(),
                      FilteringTextInputFormatter.deny(',',
                          replacementString: '.'),
                    ],
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Patrimonio (\$)",
                    placeHolder: ""),
              ],
            ),
          ),
        );
      });

  Widget expansionEstadoCivilGarante() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.estado_civil, size: 18),
          color: widget.datosEstadoCivilC,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanEstCG
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Estado civil",
          func: (_) {
            setState(() => expanEstCG = !expanEstCG);
          },
          expController: expdpEstadoCivG,
          enabled: widget.enableExpansion,
          children: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                divider(false),
                //todo ESTADO CIVIL
                DropdownButtonFormField(
                    value: estadoCivilG,
                    validator: (val) =>
                        val == null ? "Campo obligatorio" : null,
                    decoration:
                        const InputDecoration(label: Text("Estado civil")),
                    items: estadosCiviles
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() {
                              estadoCivilG = val;
                              textEstadoCivilG = val!["nombre"];
                            });
                            validarColorEstCivilG();
                            form.garante.updateValueEstadoCivil(
                                "estado_civil", val!["nombre"]);
                          }),
                //todo NO DEPENDIENTES
                InkWell(
                  onTap: () => viewListDependientesG(),
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    width: double.infinity,
                    height: 50,
                    //margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          "Dependientes (${form.garante.getDependientes.length})",
                          style: const TextStyle(fontSize: 16),
                        )),
                        Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey.shade800,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });

  void viewListDependientesG() => showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45))),
      builder: (builder) {
        return Consumer<FormProvider>(builder: (context, form, child) {
          return SizedBox(
            width: double.infinity,
            height: Responsive.of(context).hp(75),
            child: Padding(
              padding: MediaQuery.of(context).viewInsets.flipped,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Text(
                          "Dependientes",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                          child: ListView.builder(
                              itemCount: form.garante.getDependientes.length,
                              itemBuilder: (itemBuilder, i) {
                                List<PersonaModel> dependientesG =
                                    form.garante.getDependientes;
                                return Card(
                                    child: Slidable(
                                        key: UniqueKey(),
                                        direction: Axis.horizontal,
                                        startActionPane: ActionPane(
                                            extentRatio: 0.35,
                                            motion: const DrawerMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (_) {
                                                  Navigator.pop(context);

                                                  widget.startLoading();
                                                  form.garante
                                                      .removeDependiente(i);

                                                  scaffoldMessenger(context,
                                                      "Dependiente eliminado de la lista",
                                                      icon: const Icon(
                                                          Icons.check,
                                                          color: Colors.green));

                                                  widget.stopLoading();
                                                },
                                                flex: 1,
                                                autoClose: true,
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.red,
                                                icon: Icons.delete,
                                              ),
                                            ]),
                                        child: ListTile(
                                          title: Row(
                                            children: [
                                              Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "${dependientesG[i].nombres!.split(" ")[0]} ${dependientesG[i].apellidos!.split(" ")[0]}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ],
                                          ),
                                          trailing: Text(dependientesG[i]
                                                  .numeroIdentificacion ??
                                              ""),
                                        )));
                              }))
                    ],
                  ),
                  Positioned(
                      bottom: 25,
                      right: 25,
                      child: FloatingActionButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        backgroundColor: Colors.black,
                        onPressed: (widget.edit != null && !widget.edit!)
                            ? null
                            : () => [
                                  Navigator.pop(context),
                                  showModalAgregarDependienteG()
                                ],
                        child: const Icon(Icons.add, color: Colors.white),
                      ))
                ],
              ),
            ),
          );
        });
      });

  void calcularSaldoDisponibleG() {
    var garante = Provider.of<FormProvider>(context, listen: false).garante;
    var sueldo =
        double.parse(txtSueldoG.text.isNotEmpty ? txtSueldoG.text : "0");
    var ventas =
        double.parse(txtVentasG.text.isNotEmpty ? txtVentasG.text : "0");
    var otroI = double.parse(
        txtOtrosIngresosG.text.isNotEmpty ? txtOtrosIngresosG.text : "0");

    var totalIngresos = (sueldo + ventas + otroI);
    setState(() => txtTotalIngresosG.text = totalIngresos.toString());

    var gp = double.parse(
        txtGastosPersonalesG.text.isNotEmpty ? txtGastosPersonalesG.text : "0");
    var go = double.parse(txtGastosOperacionalesG.text.isNotEmpty
        ? txtGastosOperacionalesG.text
        : "0");
    var oe = double.parse(
        txtOtrosGastosG.text.isNotEmpty ? txtOtrosGastosG.text : "0");

    var totalEgresos = (gp + go + oe);
    setState(() => txtTotalEgresosG.text = totalEgresos.toString());

    var saldo = (totalIngresos - totalEgresos).toStringAsFixed(2);

    setState(() => txtSaldoDisponibleG.text = saldo.isEmpty ? "0.0" : saldo);
    garante.updateValueSitEcon("sueldo", sueldo.toStringAsFixed(2));
    garante.updateValueSitEcon("ventas", ventas.toStringAsFixed(2));
    garante.updateValueSitEcon("otro_ingreso", otroI.toStringAsFixed(2));
    garante.updateValueSitEcon(
        "total_ingreso", totalIngresos.toStringAsFixed(2));
    garante.updateValueSitEcon("gastos_personales", gp.toStringAsFixed(2));
    garante.updateValueSitEcon("gastos_operacionales", go.toStringAsFixed(2));
    garante.updateValueSitEcon("otro_egreso", oe.toStringAsFixed(2));
    garante.updateValueSitEcon("total_egreso", totalEgresos.toStringAsFixed(2));
    garante.updateValueSitEcon("saldo", saldo);
  }

  void calcularActivosG() {
    var garante = Provider.of<FormProvider>(context, listen: false).garante;
    var ec = double.parse(
        txtEfectivoCajaG.text.isNotEmpty ? txtEfectivoCajaG.text : "0");

    var db = double.parse(
        txtDineroBancosG.text.isNotEmpty ? txtDineroBancosG.text : "0");

    var cc = double.parse(
        txtCuentasxCobrarG.text.isNotEmpty ? txtCuentasxCobrarG.text : "0");

    var i = double.parse(
        txtInventariosG.text.isNotEmpty ? txtInventariosG.text : "0");

    var p = double.parse(
        txtPropiedadesG.text.isNotEmpty ? txtPropiedadesG.text : "0");

    var v =
        double.parse(txtVehiculosG.text.isNotEmpty ? txtVehiculosG.text : "0");

    var o = double.parse(
        txtOtrosPatriG.text.isNotEmpty ? txtOtrosPatriG.text : "0");

    var suma = (ec + db + cc + i + p + v + o).toStringAsFixed(2);

    setState(() => txtTotalActivosG.text = suma.isEmpty ? "0.0" : suma);
    garante.updateValueSitEcon("efectivo", ec.toStringAsFixed(2));
    garante.updateValueSitEcon("banco", db.toStringAsFixed(2));
    garante.updateValueSitEcon("cuentas", cc.toStringAsFixed(2));
    garante.updateValueSitEcon("inventarios", i.toStringAsFixed(2));
    garante.updateValueSitEcon("propiedades", p.toStringAsFixed(2));
    garante.updateValueSitEcon("vehiculos", v.toStringAsFixed(2));
    garante.updateValueSitEcon("otro_activo", o.toStringAsFixed(2));
    garante.updateValueSitEcon("total_activo", ec.toStringAsFixed(2));
  }

  void calcularPasivosG() {
    var garante = Provider.of<FormProvider>(context, listen: false).garante;
    var pc = double.parse(
        txtPasivoCortoG.text.isNotEmpty ? txtPasivoCortoG.text : "0");

    var pl = double.parse(
        txtPasivoLargoG.text.isNotEmpty ? txtPasivoLargoG.text : "0");

    var suma = (pc + pl).toStringAsFixed(2);

    setState(() => txtTotalPasivosG.text = suma.isEmpty ? "0.0" : suma);
    garante.updateValueSitEcon("pasivo_corto", pc.toStringAsFixed(2));
    garante.updateValueSitEcon("pasivo_largo", pl.toStringAsFixed(2));
    garante.updateValueSitEcon("total_pasivo", suma);
  }

  void calcularPatrimonioG() {
    var garante = Provider.of<FormProvider>(context, listen: false).garante;
    var a = double.parse(
        txtTotalActivosG.text.isNotEmpty ? txtTotalActivosG.text : "0");

    var p = double.parse(
        txtTotalPasivosG.text.isNotEmpty ? txtTotalPasivosG.text : "0");

    var res = (a - p).toStringAsFixed(2);

    setState(() => txtPatrimonioG.text = res.isEmpty ? "0.0" : res);
    garante.updateValueSitEcon("patrimonio", res);
  }

  void validarColorDatosPersonalesG() {
    var val1 = txtNombresG.text.isNotEmpty;
    var val2 = txtApellidosG.text.isNotEmpty;
    var val3 = txtCelular1G.text.isNotEmpty;
    var val4 = txtCorreoG.text.isNotEmpty;

    if (val1 && val2 && val3 && val4) {
      widget.changeColorDatosPersonales(1);
    } else {
      widget.changeColorDatosPersonales(2);
    }

    validarColorNacimientoG();
    validarColorIdentificacionG();
    validarColorResidenciaG();
    validarColorEducacionG();
    validarColorActEconPrincG();
    validarColorActEconSec();
    validarColorSitEconomG();
    validarColorEstCivilG();
  }

  void validarColorNacimientoG() {
    var val1 = (txtPaisG.text.isNotEmpty || pais != null);
    var val2 = (txtProvinciaG.text.isNotEmpty || provincia != null);
    var val3 = (txtCiudadG.text.isNotEmpty || ciudad != null);
    var val4 = txtFechaNacG.text.isNotEmpty;
    var val5 = (generoG != null);
    var val6 = (etniaG != null);

    if (val1 && val2 && val3 && val4 && val5 && val6) {
      widget.changeColorNac(1);
    } else {
      widget.changeColorNac(2);
    }
  }

  void validarColorIdentificacionG() {
    var val1 = txtCedulaG.text.isNotEmpty;
    var val2 = txtRucG.text.isNotEmpty;
    var val3 = txtPasaporteG.text.isNotEmpty;
    var val4 = txtFechaExpPasaporteG.text.isNotEmpty;
    var val5 = txtFechaCadPasaporteG.text.isNotEmpty;
    var val6 = txtFechaEntradaG.text.isNotEmpty;
    var val7 = (estadoMigratorioG != null);

    if (val3) {
      if (val1 && val2 && val4 && val5 && val6 && val7) {
        widget.changeColorIden(1);
      } else {
        widget.changeColorIden(2);
      }
    } else {
      if (val1 && val2) {
        widget.changeColorIden(1);
      } else {
        widget.changeColorIden(2);
      }
    }
  }

  void validarColorResidenciaG() {
    var val1 = (txtPaisResG.text.isNotEmpty || paisRes != null);
    var val2 = (txtProvinciaResG.text.isNotEmpty || provinciaRes != null);
    var val3 = (txtCiudadResG.text.isNotEmpty || ciudadRes != null);
    var val4 = txtParroquiaResG.text.isNotEmpty;
    var val5 = txtBarrioResG.text.isNotEmpty;
    var val6 = txtDireccionG.text.isNotEmpty;
    var val7 = (tipoViviendaG != null);
    var val8 = txtTiempoViviendaG.text.isNotEmpty;
    var val9 = (sectorG != null);
    var val10 = txtValorVG.text.isNotEmpty;

    if (val7 && (tipoViviendaG!["id"] == 1 || tipoViviendaG!["id"] == 2)) {
      if (val1 &&
          val2 &&
          val3 &&
          val4 &&
          val5 &&
          val6 &&
          val7 &&
          val8 &&
          val9 &&
          val10) {
        widget.changeColorRes(1);
      } else {
        widget.changeColorRes(2);
      }
    } else {
      if (val1 &&
          val2 &&
          val3 &&
          val4 &&
          val5 &&
          val6 &&
          val7 &&
          val8 &&
          val9) {
        widget.changeColorRes(1);
      } else {
        widget.changeColorRes(2);
      }
    }
  }

  void validarColorEducacionG() {
    var val1 = (estudioG != null);
    var val2 = (profesionG != null);
    var val3 = txtOtraProfesionG.text.isNotEmpty;

    if (val2 && profesionG!["id"] == 11) {
      if (val1 && val3) {
        widget.changeColorEduc(1);
      } else {
        widget.changeColorEduc(2);
      }
    } else {
      if (val1 && val2) {
        widget.changeColorEduc(1);
      } else {
        widget.changeColorEduc(2);
      }
    }
  }

  void validarColorSitEconomG() {
    var val1 = txtSueldoG.text.isNotEmpty;
    var val2 = txtVentasG.text.isNotEmpty;
    var val3 = txtOtrosIngresosG.text.isNotEmpty;
    var val4 = txtInfoOtrosIngresosG.text.isNotEmpty;
    var val5 = txtGastosPersonalesG.text.isNotEmpty;
    var val6 = txtGastosOperacionalesG.text.isNotEmpty;
    var val7 = txtOtrosGastosG.text.isNotEmpty;
    var val8 = txtInfoOtrosGastosG.text.isNotEmpty;
    var val9 = txtEfectivoCajaG.text.isNotEmpty;
    var val10 = txtDineroBancosG.text.isNotEmpty;
    var val11 = txtCuentasxCobrarG.text.isNotEmpty;
    var val12 = txtInventariosG.text.isNotEmpty;
    var val13 = txtPropiedadesG.text.isNotEmpty;
    var val14 = txtVehiculosG.text.isNotEmpty;
    var val15 = txtOtrosPatriG.text.isNotEmpty;
    var val16 = txtInfoOtrosPatriG.text.isNotEmpty;
    var val17 = txtPasivoCortoG.text.isNotEmpty;
    var val18 = txtPasivoLargoG.text.isNotEmpty;

    if ((val3 && !val4) || (val7 && !val8) || (val15 && !val16)) {
      widget.changeColorSitEco(2);
    } else {
      widget.changeColorSitEco(1);
    }
    if (val1 &&
        val2 &&
        val5 &&
        val6 &&
        val9 &&
        val10 &&
        val11 &&
        val12 &&
        val13 &&
        val14 &&
        val17 &&
        val18) {
      widget.changeColorSitEco(1);
    } else {
      widget.changeColorSitEco(2);
    }
  }

  void validarColorActEconPrincG() {
    var val1 = relacionLaboralG;
    //todo INDEPENDIENTE
    var val2 = (tipoNegocioG != null);
    var val3 = txtExpNegocioG.text.isNotEmpty;
    var val4 = (sectorNegocioG != null);
    var val5 = txtActividadG.text.isNotEmpty;
    //var val6 = txtCodigoActividad.text.isNotEmpty;
    var val7 = txtNombreNegocioG.text.isNotEmpty;
    var val8 = txtRucNegocioG.text.isNotEmpty;
    var val9 = txtNumEmpleadosG.text.isNotEmpty;
    var val11 = (tipoLocalG != null);
    var val12 = txtprovinciaNegocioG.text.isNotEmpty;
    var val13 = txtciudadNegocioG.text.isNotEmpty;
    var val14 = txtParroquiaNegocioG.text.isNotEmpty;
    var val15 = txtBarrioNegocioG.text.isNotEmpty;
    var val16 = txtDireccionNegocioG.text.isNotEmpty;
    var val17 = txtReferenciaNegocioG.text.isNotEmpty;
    //todo DEPENDIENTE
    var val18 = (origenIngresoG != null);
    //nombre negocio
    //ruc
    var val19 = txtInicioTrabajoG.text.isNotEmpty;
    //experiencia negocio
    var val20 = txtCargoG.text.isNotEmpty;
    var val21 = txtInicioTrabajoAntG.text.isNotEmpty;
    var val22 = txtSalidaTrabajoAntG.text.isNotEmpty;
    //provincia
    //ciudad
    //parroquia
    //barrio
    //direccion
    //referencia
    //todo OTROS
    var val23 = (otraActividadEcG != null);
    var val24 =
        (otraActividadEcG != null && otraActividadEcG!["nombre"] != "Otros");
    var val25 = txtInfoOtraActividadEconG.text.isNotEmpty;

    if (val1 == null) {
      widget.changeColorActPrin(2);
    } else {
      switch (val1["id"]) {
        case 1:
          if (val2 &&
              val3 &&
              val4 &&
              val5 &&
              val7 &&
              val8 &&
              val9 &&
              val11 &&
              val12 &&
              val13 &&
              val14 &&
              val15 &&
              val16 &&
              val17) {
            widget.changeColorActPrin(1);
          } else {
            widget.changeColorActPrin(2);
          }
          break;
        case 2:
          if (val18 &&
              val7 &&
              val8 &&
              val19 &&
              val3 &&
              val20 &&
              val21 &&
              val22 &&
              val12 &&
              val13 &&
              val14 &&
              val15 &&
              val16 &&
              val17) {
            widget.changeColorActPrin(1);
          } else {
            widget.changeColorActPrin(2);
          }
          break;
        case 3:
          if (val23 && val24) {
            widget.changeColorActPrin(1);
          } else if ((val23 && !val24) && val25) {
            widget.changeColorActPrin(1);
          } else {
            widget.changeColorActPrin(2);
          }
          break;
        default:
      }
    }
  }

  void validarColorEstCivilG() {
    var val1 = (estadoCivilG != null);

    if (val1) {
      widget.changeColorEstCiv(1);
    } else {
      widget.changeColorEstCiv(2);
    }
  }

  void validarColorActEconSec() {
    widget.changeColorActSec(1);
  }

  void showModalAgregarDependienteG() async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45))),
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (builder) {
          return StatefulBuilder(builder: (context, state) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                width: double.infinity,
                child: Form(
                  key: _fDepGkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Agregar dependiente",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      InputTextFormFields(
                          /* validacion: (val) =>
                            val!.isEmpty ? "Campo obligatorio" : null,*/
                          controlador: txtCedulaDepG,
                          tipoTeclado: TextInputType.number,
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Cédula",
                          placeHolder: ""),
                      InputTextFormFields(
                          validacion: (val) =>
                              val!.isEmpty ? "Campo obligatorio" : null,
                          controlador: txtNombreDepG,
                          capitalization: TextCapitalization.words,
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Nombres",
                          placeHolder: ""),
                      InputTextFormFields(
                          validacion: (val) =>
                              val!.isEmpty ? "Campo obligatorio" : null,
                          capitalization: TextCapitalization.words,
                          controlador: txtApellidosDepG,
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Apellidos",
                          placeHolder: ""),
                      DropdownButtonFormField(
                          validator: (val) => val == null || val.isEmpty
                              ? "Campo obligatorio"
                              : null,
                          decoration:
                              const InputDecoration(label: Text("Parentesco")),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          value: parentescoVG,
                          items: parentesco
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e["nombre"])))
                              .toList(),
                          onChanged: (val) {
                            state(() {
                              parentescoVG = val;
                              if (parentescoVG!["id"] == 9) {
                                enableOtrosParG = true;
                              }
                            });
                          }),
                      if (enableOtrosParG)
                        InputTextFormFields(
                            controlador: txtInfoOtroParenG,
                            validacion: (val) =>
                                parentescoVG != null && val!.isEmpty
                                    ? "Campo obligatorio"
                                    : null,
                            accionCampo: TextInputAction.next,
                            nombreCampo: "Especifíque otro parentesco",
                            placeHolder: ""),
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: true,
                              child: InputTextFormFields(
                                  validacion: (val) =>
                                      val!.isEmpty ? "Campo obligatorio" : null,
                                  controlador: txtFechaNacDepG,
                                  accionCampo: TextInputAction.next,
                                  nombreCampo: "Fecha de nacimiento",
                                  placeHolder: ""),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () async {
                              await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime.now())
                                  .then((val) {
                                if (val != null) {
                                  state(() {
                                    txtFechaNacDepG.text =
                                        DateFormat("yyyy-MM-dd").format(val);
                                  });
                                }
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 25),
                      nextButton(
                          onPressed: () async {
                            var form = Provider.of<FormProvider>(this.context,
                                listen: false);
                            final pfrc = UserPreferences();
                            int idUser = await pfrc.getIdUser();

                            if (!_fDepGkey.currentState!.validate()) {
                              return;
                            } else {
                              var newDep = PersonaModel(
                                  usuarioCreacion: idUser,
                                  numeroIdentificacion: txtCedulaDepG.text,
                                  nombres: txtNombreDepG.text,
                                  apellidos: txtApellidosDepG.text,
                                  parentesco:
                                      (parentescoVG!["id"] ?? 0).toString(),
                                  fechaNacimiento: txtFechaNacDepG.text);

                              form.garante.addDependiente(newDep);

                              Navigator.pop(context);

                              scaffoldMessenger(
                                  context, "Dependiente agregado correctamente",
                                  icon: const Icon(Icons.check,
                                      color: Colors.green));
                            }
                          },
                          text: "Agregar",
                          width: 150),
                      const SizedBox(height: 35),
                    ],
                  ),
                ),
              ),
            );
          });
        }).then((_) {
      setState(() {
        txtCedulaDepG.clear();
        txtNombreDepG.clear();
        txtApellidosDepG.clear();
        parentescoVG = null;
        txtInfoOtroParenG.clear();
        txtFechaNacDepG.clear();
        enableOtrosParG = false;
      });
    });
  }

  void funcionPais(String? pais) async {
    listaProvincias.clear();
    if (pais == 'ECUADOR') {
      final provincias = listaProvinciasEcuador['provincias'];
      for (var item in provincias) {
        setState(() {
          listaProvincias.add(item);
        });
      }
      setState(() {
        hintTextProvincia = null;
      });
    }
  }

  void funcionProvincia(String provincia) async {
    if (pais == 'ECUADOR') {
      final res = obtenerCiudadesEcuadorDe(provincia);
      listaCiudades = res;
    }
  }

  void funcionPaisRes(String? pais) async {
    listaProvinciasRes.clear();
    if (paisRes == 'ECUADOR') {
      final provinciasRes = listaProvinciasEcuador['provincias'];
      for (var item in provinciasRes) {
        setState(() {
          listaProvinciasRes.add(item);
        });
      }
      setState(() {
        hintTextProvinciaRes = null;
      });
    }
  }

  void funcionProvinciaRes(String provincia) async {
    if (paisRes == 'ECUADOR') {
      final res = obtenerCiudadesEcuadorDe(provincia);
      listaCiudadesRes = res;
    }
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

  //todo SI EL ID DE LA SOLICITUD NO ESTÁ NULA OBTENGO DATOS
  void getData() async {
    final form = Provider.of<FormProvider>(context, listen: false).garante;

    if (widget.idSolicitud != null) {
      final solicitud = await op.obtenerSolicitud(widget.idSolicitud!);

      if (solicitud != null) {
        final datosPersonales = jsonDecode(solicitud.datosGarante);
        final nac = datosPersonales["nacimiento"];
        final iden = datosPersonales["identificacion"];
        final res = datosPersonales["residencia"];
        final educ = datosPersonales["educacion"];
        final actP = datosPersonales["actividad_principal"];
        final actS = datosPersonales["actividad_secundaria"];
        final eco = datosPersonales["economia"];
        final ec = datosPersonales["estado_civil"];

        //todo NACIMIENTO
        if (nac["pais"]?.isNotEmpty ?? false) {
          if (nac["pais"] == "ECUADOR") {
            pais = nac["pais"];
            funcionPais(pais);
            provinciasVisible = true;
            provincia = nac["provincia"];
            funcionProvincia(provincia!);
            ciudadesVisible = true;
            ciudad = nac["ciudad"];
          } else {
            txtPaisG.text = nac["pais"];
            provinciasVisible = true;
            txtProvinciaG.text = nac["provincia"];
            ciudadesVisible = true;
            txtCiudadG.text = nac["ciudad"];
          }

          form.updateValueNacimiento("pais", pais ?? txtPaisG.text);
          txtProvinciaG.text = nac["provincia"];
          form.updateValueNacimiento(
              "provincia", provincia ?? txtProvinciaG.text);
          txtCiudadG.text = nac["ciudad"] ?? "";
          form.updateValueNacimiento("ciudad", ciudad ?? txtCiudadG.text);
        }
        //fecha nacimiento
        if (nac["fecha"]?.isNotEmpty ?? false) {
          setState(() => txtFechaNacG.text = nac["fecha"]);
          form.updateValueNacimiento("fecha", txtFechaNacG.text);
        }

        //edad
        if (nac["edad"]?.isNotEmpty ?? false) {
          setState(() => txtEdadG.text = nac["edad"]);
          form.updateValueNacimiento("edad", txtEdadG.text);
        }

        //genero
        if (nac["genero"]?.isNotEmpty ?? false) {
          var g = generos.where((e) => nac["genero"] == e["nombre"]).first;

          setState(() => generoG = g);
          form.updateValueNacimiento("genero", g["nombre"]);
        }

        //etnia
        if (nac["etnia"]?.isNotEmpty ?? false) {
          var e = etnias.where((e) => nac["etnia"] == e["nombre"]).first;

          setState(() => etniaG = e);
          form.updateValueNacimiento("etnia", e["nombre"]);

          //otra etnia
          if (e["nombre"] == "Otro") {
            if (nac["otra_etnia"] != null && nac["otra_etnia"] != "") {
              setState(() => txtOtraEtiniaG.text = nac["otra_etnia"]);
              form.updateValueNacimiento("otra_etnia", txtOtraEtiniaG.text);
            }
          }
        }
        validarColorNacimientoG();

        //todo IDENTIFICACIÓN obviamos cédula y ruc porque eso se busca por id persona arriba
        //pasaporte
        if (iden["pasaporte"]?.isNotEmpty ?? false) {
          setState(() => txtPasaporteG.text = iden["pasaporte"]);
          form.updateValueIdentificacion("pasaporte", txtPasaporteG.text);
        }
        //fecha expiracion
        if (iden["fecha_exp_p"]?.isNotEmpty ?? false) {
          setState(() => txtFechaExpPasaporteG.text = iden["fecha_exp_p"]);
          form.updateValueIdentificacion(
              "fecha_exp_p", txtFechaExpPasaporteG.text);
        }
        //fecha caducidad
        if (iden["fecha_cad_p"]?.isNotEmpty ?? false) {
          setState(() => txtFechaCadPasaporteG.text = iden["fecha_cad_p"]);
          form.updateValueIdentificacion(
              "fecha_cad_p", txtFechaCadPasaporteG.text);
        }
        //fecha entrada
        if (iden["fecha_entrada"]?.isNotEmpty ?? false) {
          setState(() => txtFechaEntradaG.text = iden["fecha_entrada"]);
          form.updateValueIdentificacion(
              "fecha_entrada", txtFechaEntradaG.text);
        }
        //estado migratorio
        if (iden["estado_migratorio"]?.isNotEmpty ?? false) {
          var e = estadoM
              .where((e) => iden["estado_migratorio"] == e["nombre"])
              .first;

          setState(() => estadoMigratorioG = e);
          form.updateValueIdentificacion("estado_migratorio", e["nombre"]);
        }
        validarColorIdentificacionG();

        //todo RESIDENCIA
        if (res["pais"]?.isNotEmpty ?? false) {
          if (res["pais"] == "ECUADOR") {
            paisRes = res["pais"];
            funcionPaisRes(paisRes);
            provinciasResVisible = true;
            provinciaRes = res["provincia"];
            funcionProvinciaRes(provinciaRes!);
            ciudadesResVisible = true;
            ciudadRes = res["ciudad"];
          } else {
            txtPaisResG.text = res["pais"];
            provinciasResVisible = true;
            txtProvinciaResG.text = res["provincia"];
            ciudadesResVisible = true;
            txtCiudadResG.text = res["ciudad"];
          }

          form.updateValueResidencia("pais", paisRes ?? txtPaisResG.text);
          txtProvinciaResG.text = res["provincia"];
          form.updateValueResidencia(
              "provincia", provinciaRes ?? txtProvinciaResG.text);
          txtCiudadResG.text = res["ciudad"];
          form.updateValueResidencia("ciudad", ciudadRes ?? txtCiudadResG.text);
        }

        //parroquia
        if (res["parroquia"]?.isNotEmpty ?? false) {
          setState(() => txtParroquiaResG.text = res["parroquia"]);
          form.updateValueResidencia("parroquia", txtParroquiaResG.text);
        }
        //barrio
        if (res["barrio"]?.isNotEmpty ?? false) {
          setState(() => txtBarrioResG.text = res["barrio"]);
          form.updateValueResidencia("barrio", txtBarrioResG.text);
        }
        //direccion
        if (res["direccion"]?.isNotEmpty ?? false) {
          setState(() => txtDireccionG.text = res["direccion"]);
          form.updateValueResidencia("direccion", txtDireccionG.text);
        }
        //latitud y longitud
        if (res["latitud"]?.isNotEmpty ?? false) {
          setState(() => latitudRG = res["latitud"]);
          setState(() => longitudRG = res["longitud"]);
          form.updateValueResidencia("latitud", latitudRG);
          form.updateValueResidencia("longitud", longitudRG);
        }
        //tipo_vivienda
        if (res["tipo_vivienda"]?.isNotEmpty ?? false) {
          var v = tiposVivienda
              .where((e) => res["tipo_vivienda"] == e["nombre"])
              .first;

          setState(() => tipoViviendaG = v);
          form.updateValueResidencia("tipo_vivienda", v["nombre"]);
        }
        //valor
        if (res["valor"]?.isNotEmpty ?? false) {
          setState(() => txtValorVG.text = res["valor"]);
          form.updateValueResidencia("valor", txtValorVG.text);
        }
        //tiempo vivienda
        if (res["tiempo_vivienda"]?.isNotEmpty ?? false) {
          setState(() => txtTiempoViviendaG.text = res["tiempo_vivienda"]);
          form.updateValueResidencia(
              "tiempo_vivienda", txtTiempoViviendaG.text);
        }
        //sector
        if (res["sector"]?.isNotEmpty ?? false) {
          var s = sectores.where((e) => res["sector"] == e["nombre"]).first;

          setState(() => sectorG = s);
          form.updateValueResidencia("sector", s["nombre"]);
        }
        validarColorResidenciaG();

        //todo EDUCACION
        //estudio
        if (educ["estudio"]?.isNotEmpty ?? false) {
          var e = estudios.where((e) => educ["estudio"] == e["nombre"]).first;
          setState(() => estudioG = e);
          form.updateValueEducacion("estudio", e["nombre"]);
        }
        //profesion
        if (educ["profesion"]?.isNotEmpty ?? false) {
          var p =
              profesiones.where((e) => educ["profesion"] == e["nombre"]).first;

          setState(() => profesionG = p);
          form.updateValueEducacion("profesion", p["nombre"]);

          if (p["nombre"] == "Otras") {
            if (educ["otra_profesion"] != null &&
                educ["otra_profesion"] != "") {
              setState(() => txtOtraProfesionG.text = educ["otra_profesion"]);
              form.updateValueEducacion(
                  "otra_profesion", txtOtraProfesionG.text);
            }
          }
        }
        validarColorEducacionG();

        //todo ACTIVIDAD ECONOMICA PRINCIPAL
        //relacion laboral
        if (actP["relacion_laboral"]?.isNotEmpty ?? false) {
          var r = relaciones
              .where((e) => actP["relacion_laboral"] == e["nombre"])
              .first;

          setState(() => relacionLaboralG = r);
          if (r["id"] == 1) {
            setState(() => independienteG = true);
          } else if (r["id"] == 2) {
            setState(() => dependienteG = true);
          } else if (r["id"] == 3) {
            setState(() => otraActiVG = true);
          }
          form.updateValueActEconomica("relacion_laboral", r["nombre"]);
        }
        //tipo negocio
        if (actP["tipo_negocio"]?.isNotEmpty ?? false) {
          var t =
              negocios.where((e) => actP["tipo_negocio"] == e["nombre"]).first;

          setState(() => tipoNegocioG = t);
          form.updateValueActEconomica("tipo_negocio", t["nombre"]);
        }
        //tiempo negocio
        if (actP["tiempo_negocio"]?.isNotEmpty ?? false) {
          setState(() => txtExpNegocioG.text = actP["tiempo_negocio"]);
          form.updateValueActEconomica("tiempo_negocio", txtExpNegocioG.text);
        }
        //sector
        if (actP["sector"]?.isNotEmpty ?? false) {
          var s = sectores.where((e) => actP["sector"] == e["nombre"]).first;
          setState(() => sectorNegocioG = s);
          form.updateValueActEconomica("sector", s["nombre"]);
        }
        //actividad
        if (actP["actividad"]?.isNotEmpty ?? false) {
          setState(() => txtActividadG.text = actP["actividad"]);
          form.updateValueActEconomica("actividad", txtActividadG.text);
        }
        //codigo actividad
        if (actP["codigo_act"]?.isNotEmpty ?? false) {
          setState(() => txtCodigoActividadG.text = actP["codigo_act"]);
          form.updateValueActEconomica("codigo_act", txtCodigoActividadG.text);
        }
        //nombre
        if (actP["nombre"]?.isNotEmpty ?? false) {
          setState(() => txtNombreNegocioG.text = actP["nombre"]);
          form.updateValueActEconomica("nombre", txtNombreNegocioG.text);
        }
        //ruc
        if (actP["ruc"]?.isNotEmpty ?? false) {
          setState(() => txtRucNegocioG.text = actP["ruc"]);
          form.updateValueActEconomica("ruc", txtRucNegocioG.text);
        }
        //num_empleados
        if (actP["num_empleados"]?.isNotEmpty ?? false) {
          setState(() => txtNumEmpleadosG.text = actP["num_empleados"]);
          form.updateValueActEconomica("num_empleados", txtNumEmpleadosG.text);
        }
        //num empleados contratar
        if (actP["num_empleados_contratar"]?.isNotEmpty ?? false) {
          setState(() =>
              txtNumEmpleadosContratarG.text = actP["num_empleados_contratar"]);
          form.updateValueActEconomica(
              "num_empleados_contratar", txtNumEmpleadosContratarG.text);
        }
        //tipo local
        if (actP["tipo_local"]?.isNotEmpty ?? false) {
          var t =
              tipoLocales.where((e) => actP["tipo_local"] == e["nombre"]).first;

          setState(() => tipoLocalG = t);
          form.updateValueActEconomica("tipo_local", t["nombre"]);
        }
        //provincia
        if (actP["provincia"]?.isNotEmpty ?? false) {
          setState(() => txtprovinciaNegocioG.text = actP["provincia"]);
          form.updateValueActEconomica("provincia", txtprovinciaNegocioG.text);
        }
        //ciudad
        if (actP["ciudad"]?.isNotEmpty ?? false) {
          setState(() => txtciudadNegocioG.text = actP["ciudad"]);
          form.updateValueActEconomica("ciudad", txtciudadNegocioG.text);
        }
        //parroquia
        if (actP["parroquia"]?.isNotEmpty ?? false) {
          setState(() => txtParroquiaNegocioG.text = actP["parroquia"]);
          form.updateValueActEconomica("parroquia", txtParroquiaNegocioG.text);
        }
        //barrio
        if (actP["barrio"]?.isNotEmpty ?? false) {
          setState(() => txtBarrioNegocioG.text = actP["barrio"]);
          form.updateValueActEconomica("barrio", txtBarrioNegocioG.text);
        }
        //direccion
        if (actP["direccion"]?.isNotEmpty ?? false) {
          setState(() => txtDireccionNegocioG.text = actP["direccion"]);
          form.updateValueActEconomica("direccion", txtDireccionNegocioG.text);
        }
        //latitud
        if (actP["latitud"]?.isNotEmpty ?? false) {
          setState(() => latitudTG = actP["latitud"]);
          setState(() => longitudTG = actP["longitud"]);
          form.updateValueActEconomica("latitud", latitudTG);
          form.updateValueActEconomica("longitud", longitudTG);
        }
        //referencia
        if (actP["referencia"]?.isNotEmpty ?? false) {
          setState(() => txtReferenciaNegocioG.text = actP["referencia"]);
          form.updateValueActEconomica(
              "referencia", txtReferenciaNegocioG.text);
        }
        //origen_ingresos
        if (actP["origen_ingresos"]?.isNotEmpty ?? false) {
          var o = ingresos
              .where((e) => actP["origen_ingresos"] == e["nombre"])
              .first;
          setState(() => origenIngresoG = o);
          form.updateValueActEconomica("origen_ingresos", o["nombre"]);
        }
        //inicio trabajo
        if (actP["inicio_trabajo"]?.isNotEmpty ?? false) {
          setState(() => txtInicioTrabajoG.text = actP["inicio_trabajo"]);
          form.updateValueActEconomica(
              "inicio_trabajo", txtInicioTrabajoG.text);
        }
        //correo
        if (actP["correo"]?.isNotEmpty ?? false) {
          setState(() => txtCorreoTrabajoG.text = actP["correo"]);
          form.updateValueActEconomica("correo", txtCorreoTrabajoG.text);
        }
        //telefono
        if (actP["telefono"]?.isNotEmpty ?? false) {
          setState(() => txtTelefonoTrabajoG.text = actP["telefono"]);
          form.updateValueActEconomica("telefono", txtTelefonoTrabajoG.text);
        }
        //cargo
        if (actP["cargo"]?.isNotEmpty ?? false) {
          setState(() => txtCargoG.text = actP["cargo"]);
          form.updateValueActEconomica("cargo", txtCargoG.text);
        }
        //inicio_trabajo_ant
        if (actP["inicio_trabajo_ant"]?.isNotEmpty ?? false) {
          setState(
              () => txtInicioTrabajoAntG.text = actP["inicio_trabajo_ant"]);
          form.updateValueActEconomica(
              "inicio_trabajo_ant", txtInicioTrabajoAntG.text);
        }
        //salida_trabajo_ant
        if (actP["salida_trabajo_ant"]?.isNotEmpty ?? false) {
          setState(
              () => txtSalidaTrabajoAntG.text = actP["salida_trabajo_ant"]);
          form.updateValueActEconomica(
              "salida_trabajo_ant", txtSalidaTrabajoAntG.text);
        }
        //otra_actividad
        if (actP["otra_actividad"]?.isNotEmpty ?? false) {
          var o = otraActvEcon
              .where((e) => actP["otra_actividad"] == e["nombre"])
              .first;

          setState(() => otraActividadEcG = o);
          form.updateValueActEconomica("otra_actividad", o["nombre"]);

          if (o["nombre"] == "Otros") {
            if (actP["info_actividad"]?.isNotEmpty ?? false) {
              setState(() =>
                  txtInfoOtraActividadEconG.text = actP["info_actividad"]);

              form.updateValueActEconomica(
                  "info_actividad", txtInfoOtraActividadEconG.text);
            }
          }
        }

        validarColorActEconPrincG();
        //todo ACTIVIDAD ECONOMICA SECUNDARIA
        //relacion laboral
        if (actS["relacion_laboral"]?.isNotEmpty ?? false) {
          var r = relaciones
              .where((e) => actS["relacion_laboral"] == e["nombre"])
              .first;

          setState(() => relacionLaboral2G = r);
          if (r["id"] == 1) {
            setState(() => independiente2G = true);
          } else if (r["id"] == 2) {
            setState(() => dependiente2G = true);
          } else if (r["id"] == 3) {
            setState(() => otraActiV2G = true);
          }
          form.updateValueActEconomicaSec("relacion_laboral", r["nombre"]);
        }
        //tipo negocio
        if (actS["tipo_negocio"]?.isNotEmpty ?? false) {
          var t =
              negocios.where((e) => actS["tipo_negocio"] == e["nombre"]).first;

          setState(() => tipoNegocio2G = t);
          form.updateValueActEconomicaSec("tipo_negocio", t["nombre"]);
        }
        //tiempo negocio
        if (actS["tiempo_negocio"]?.isNotEmpty ?? false) {
          setState(() => txtExpNegocio2G.text = actS["tiempo_negocio"]);
          form.updateValueActEconomicaSec(
              "tiempo_negocio", txtExpNegocio2G.text);
        }
        //sector
        if (actS["sector"]?.isNotEmpty ?? false) {
          var s = sectores.where((e) => actS["sector"] == e["nombre"]).first;
          setState(() => sectorNegocio2G = s);
          form.updateValueActEconomicaSec("sector", s["nombre"]);
        }
        //actividad
        if (actS["actividad"]?.isNotEmpty ?? false) {
          setState(() => txtActividad2G.text = actS["actividad"]);
          form.updateValueActEconomicaSec("actividad", txtActividad2G.text);
        }
        //codigo actividad
        if (actS["codigo_act"]?.isNotEmpty ?? false) {
          setState(() => txtCodigoActividad2G.text = actS["codigo_act"]);
          form.updateValueActEconomicaSec(
              "codigo_act", txtCodigoActividad2G.text);
        }
        //nombre
        if (actS["nombre"]?.isNotEmpty ?? false) {
          setState(() => txtNombreNegocio2G.text = actS["nombre"]);
          form.updateValueActEconomicaSec("nombre", txtNombreNegocio2G.text);
        }
        //ruc
        if (actS["ruc"]?.isNotEmpty ?? false) {
          setState(() => txtRucNegocio2G.text = actS["ruc"]);
          form.updateValueActEconomicaSec("ruc", txtRucNegocio2G.text);
        }
        //num_empleados
        if (actS["num_empleados"]?.isNotEmpty ?? false) {
          setState(() => txtNumEmpleados2G.text = actS["num_empleados"]);
          form.updateValueActEconomicaSec(
              "num_empleados", txtNumEmpleados2G.text);
        }
        //num empleados contratar
        if (actS["num_empleados_contratar"]?.isNotEmpty ?? false) {
          setState(() => txtNumEmpleadosContratar2G.text =
              actS["num_empleados_contratar"]);
          form.updateValueActEconomicaSec(
              "num_empleados_contratar", txtNumEmpleadosContratar2G.text);
        }
        //tipo local
        if (actS["tipo_local"]?.isNotEmpty ?? false) {
          var t =
              tipoLocales.where((e) => actS["tipo_local"] == e["nombre"]).first;

          setState(() => tipoLocal2G = t);
          form.updateValueActEconomicaSec("tipo_local", t["nombre"]);
        }
        //provincia
        if (actS["provincia"]?.isNotEmpty ?? false) {
          setState(() => txtprovinciaNegocio2G.text = actS["provincia"]);
          form.updateValueActEconomicaSec(
              "provincia", txtprovinciaNegocio2G.text);
        }
        //ciudad
        if (actS["ciudad"]?.isNotEmpty ?? false) {
          setState(() => txtciudadNegocio2G.text = actS["ciudad"]);
          form.updateValueActEconomicaSec("ciudad", txtciudadNegocio2G.text);
        }
        //parroquia
        if (actS["parroquia"]?.isNotEmpty ?? false) {
          setState(() => txtParroquiaNegocio2G.text = actS["parroquia"]);
          form.updateValueActEconomicaSec(
              "parroquia", txtParroquiaNegocio2G.text);
        }
        //barrio
        if (actS["barrio"]?.isNotEmpty ?? false) {
          setState(() => txtBarrioNegocio2G.text = actS["barrio"]);
          form.updateValueActEconomicaSec("barrio", txtBarrioNegocio2G.text);
        }
        //direccion
        if (actS["direccion"]?.isNotEmpty ?? false) {
          setState(() => txtDireccionNegocio2G.text = actS["direccion"]);
          form.updateValueActEconomicaSec(
              "direccion", txtDireccionNegocio2G.text);
        }
        //latitud
        if (actS["latitud"]?.isNotEmpty ?? false) {
          setState(() => latitudT2G = actS["latitud"]);
          setState(() => longitudT2G = actS["longitud"]);
          form.updateValueActEconomicaSec("latitud", latitudT2G);
          form.updateValueActEconomicaSec("longitud", longitudT2G);
        }
        //referencia
        if (actS["referencia"]?.isNotEmpty ?? false) {
          setState(() => txtReferenciaNegocio2G.text = actS["referencia"]);
          form.updateValueActEconomicaSec(
              "referencia", txtReferenciaNegocio2G.text);
        }
        //origen_ingresos
        if (actS["origen_ingresos"]?.isNotEmpty ?? false) {
          var o = ingresos
              .where((e) => actS["origen_ingresos"] == e["nombre"])
              .first;
          setState(() => origenIngreso2G = o);
          form.updateValueActEconomicaSec("origen_ingresos", o["nombre"]);
        }
        //inicio trabajo
        if (actS["inicio_trabajo"]?.isNotEmpty ?? false) {
          setState(() => txtInicioTrabajo2G.text = actS["inicio_trabajo"]);
          form.updateValueActEconomicaSec(
              "inicio_trabajo", txtInicioTrabajo2G.text);
        }
        //correo
        if (actS["correo"]?.isNotEmpty ?? false) {
          setState(() => txtCorreoTrabajo2G.text = actS["correo"]);
          form.updateValueActEconomicaSec("correo", txtCorreoTrabajo2G.text);
        }
        //telefono
        if (actS["telefono"]?.isNotEmpty ?? false) {
          setState(() => txtTelefonoTrabajo2G.text = actS["telefono"]);
          form.updateValueActEconomicaSec(
              "telefono", txtTelefonoTrabajo2G.text);
        }
        //cargo
        if (actS["cargo"]?.isNotEmpty ?? false) {
          setState(() => txtCargo2G.text = actS["cargo"]);
          form.updateValueActEconomicaSec("cargo", txtCargo2G.text);
        }
        //inicio_trabajo_ant
        if (actS["inicio_trabajo_ant"]?.isNotEmpty ?? false) {
          setState(
              () => txtInicioTrabajoAnt2G.text = actS["inicio_trabajo_ant"]);
          form.updateValueActEconomicaSec(
              "inicio_trabajo_ant", txtInicioTrabajoAnt2G.text);
        }
        //salida_trabajo_ant
        if (actS["salida_trabajo_ant"]?.isNotEmpty ?? false) {
          setState(
              () => txtSalidaTrabajoAnt2G.text = actS["salida_trabajo_ant"]);
          form.updateValueActEconomicaSec(
              "salida_trabajo_ant", txtSalidaTrabajoAnt2G.text);
        }
        //otra_actividad
        if (actS["otra_actividad"]?.isNotEmpty ?? false) {
          var o = otraActvEcon
              .where((e) => actS["otra_actividad"] == e["nombre"])
              .first;

          setState(() => otraActividadEc2G = o);
          form.updateValueActEconomicaSec("otra_actividad", o["nombre"]);

          if (o["nombre"] == "Otros") {
            if (actS["info_actividad"]?.isNotEmpty ?? false) {
              setState(() =>
                  txtInfoOtraActividadEcon2G.text = actS["info_actividad"]);

              form.updateValueActEconomicaSec(
                  "info_actividad", txtInfoOtraActividadEcon2G.text);
            }
          }
        }

        validarColorActEconSec();

        //todo Situación Económica
        //sueldo
        if (eco["sueldo"]?.isNotEmpty ?? false) {
          setState(() => txtSueldoG.text = eco["sueldo"]);
        }
        //ventas
        if (eco["ventas"]?.isNotEmpty ?? false) {
          setState(() => txtVentasG.text = eco["ventas"]);
        }
        //otro ingreso
        if (eco["otro_ingreso"]?.isNotEmpty ?? false) {
          setState(() => txtOtrosIngresosG.text = eco["otro_ingreso"]);
        }
        //info otro ingreso
        if (eco["info_otro_ingreso"]?.isNotEmpty ?? false) {
          setState(() => txtInfoOtrosIngresosG.text = eco["info_otro_ingreso"]);
        }

        //gastos personales
        if (eco["gastos_personales"]?.isNotEmpty ?? false) {
          setState(() => txtGastosPersonalesG.text = eco["gastos_personales"]);
        }
        //gastos operacionales
        if (eco["gastos_operacionales"]?.isNotEmpty ?? false) {
          setState(
              () => txtGastosOperacionalesG.text = eco["gastos_operacionales"]);
        }
        //otro egreso
        if (eco["otro_egreso"]?.isNotEmpty ?? false) {
          setState(() => txtOtrosGastosG.text = eco["otro_egreso"]);
        }
        //info otro egreso
        if (eco["info_otro_egreso"]?.isNotEmpty ?? false) {
          setState(() => txtInfoOtrosGastosG.text = eco["otro_egreso"]);
        }

        //calcular saldo disponible
        /*if ((eco["sueldo"]?.isNotEmpty ?? false) &&
            (eco["gastos_personales"]?.isNotEmpty ?? false)) {*/
        calcularSaldoDisponibleG();
        //}

        //efecotivo
        if (eco["efectivo"]?.isNotEmpty ?? false) {
          setState(() => txtEfectivoCajaG.text = eco["efectivo"]);
        }
        //banco
        if (eco["banco"]?.isNotEmpty ?? false) {
          setState(() => txtDineroBancosG.text = eco["banco"]);
        }
        //cuentas
        if (eco["cuentas"]?.isNotEmpty ?? false) {
          setState(() => txtCuentasxCobrarG.text = eco["cuentas"]);
        }
        //inventarios
        if (eco["inventarios"]?.isNotEmpty ?? false) {
          setState(() => txtInventariosG.text = eco["inventarios"]);
        }
        //propiedades
        if (eco["propiedades"]?.isNotEmpty ?? false) {
          setState(() => txtPropiedadesG.text = eco["propiedades"]);
        }
        //vehiculos
        if (eco["vehiculos"]?.isNotEmpty ?? false) {
          setState(() => txtVehiculosG.text = eco["vehiculos"]);
        }
        //otros activos
        if (eco["otro_activo"]?.isNotEmpty ?? false) {
          setState(() => txtOtrosPatriG.text = eco["otro_activo"]);
        }
        //info otro activo
        if (eco["info_otro_activo"]?.isNotEmpty ?? false) {
          setState(() => txtInfoOtrosPatriG.text = eco["info_otro_activo"]);
        }
        //calcular activos
        calcularActivosG();
        //pasivo corto
        if (eco["pasivo_corto"]?.isNotEmpty ?? false) {
          setState(() => txtPasivoCortoG.text = eco["pasivo_corto"]);
        }
        //pasivo largo
        if (eco["pasivo_largo"]?.isNotEmpty ?? false) {
          setState(() => txtPasivoLargoG.text = eco["pasivo_largo"]);
        }
        //calcular pasivos
        calcularPasivosG();
        //calcular patrimonio
        calcularPatrimonioG();
        validarColorSitEconomG();

        //todo ESTADO CIVIL
        if (ec["estado_civil"]?.isNotEmpty ?? false) {
          var e = estadosCiviles
              .where((e) => ec["estado_civil"] == e["nombre"])
              .first;

          setState(() => estadoCivilG = e);
          form.updateValueEstadoCivil("estado_civil", e["nombre"]);
        }
        //dependientes
        if (ec["dependientes"].isNotEmpty) {
          var personas = ec["dependientes"] as List<PersonaModel>;

          for (var persona in personas) {
            form.addDependiente(persona);
          }
        }
        validarColorEstCivilG();
      } else {
        debugPrint("No se encontraron solicitudes...");
      }
    }
  }
}
