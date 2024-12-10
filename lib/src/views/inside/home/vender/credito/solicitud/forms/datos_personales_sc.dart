// ignore_for_file: prefer_null_aware_operators, unused_local_variable, use_build_context_synchronously
import 'dart:convert';

import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/utils/function_callback.dart';
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
import '../../../../../../../../utils/geolocator/geolocator.dart';
import '../../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../../../../../../../utils/list/lista_autorizacion_consulta.dart';
import '../../../../../../../../utils/list/lista_solicitud.dart';
import '../../../../../../../../utils/paisesHabiles/paises.dart';
import '../../../../../../../../utils/paisesHabiles/retornar_resultados.dart';
import '../../../../../../../../utils/responsive.dart';
import '../../../../../../../../utils/textFields/field_formater.dart';
import '../../../../../../../../utils/textFields/input_text_form_fields.dart';
import '../../../../../../../controller/preferences/user_preferences.dart';
import '../../../../../../../models/usuario/persona_model.dart';

class DatosPersonalesCredito extends StatefulWidget {
  bool? edit;
  int idPersona;
  int? idSolicitud;
  Color? datosPersonalesC;
  Color? datosNacimientoC;
  Color? datosIdentificacionC;
  Color? datosResidenciaC;
  Color? datosEducacionC;
  Color? actEconoPrinC;
  Color? actEconoSecC;
  Color? datosSitEconC;
  Color? datosEstadoCivilC;
  GlobalKey gk;
  final GlobalKey<FormState> formKey;
  final GlobalKey<FormState> fNkey;
  final GlobalKey<FormState> fIkey;
  final GlobalKey<FormState> fRkey;
  final GlobalKey<FormState> fEkey;
  final GlobalKey<FormState> fAEkey;
  final GlobalKey<FormState> fSEkey;
  final GlobalKey<FormState> fECkey;
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
  String? actividadEconomica;
  String? codigoActividad;
  int? idRelacionLaboral;
  int? idSector;
  String? tiempoFunciones;
  int? idSectorEc;
  DatosPersonalesCredito(
      {super.key,
      this.edit,
      this.idSolicitud,
      required this.gk,
      required this.formKey,
      required this.enableExpansion,
      required this.fAEkey,
      required this.fECkey,
      required this.fEkey,
      required this.fIkey,
      required this.fNkey,
      required this.fRkey,
      required this.fSEkey,
      required this.idPersona,
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
      required this.updatePixelPosition,
      this.actEconoPrinC,
      this.actEconoSecC,
      this.datosEducacionC,
      this.datosEstadoCivilC,
      this.datosIdentificacionC,
      this.datosNacimientoC,
      this.datosPersonalesC,
      this.datosResidenciaC,
      this.datosSitEconC,
      this.actividadEconomica,
      this.codigoActividad,
      this.idRelacionLaboral,
      this.idSector,
      this.tiempoFunciones});

  @override
  State<DatosPersonalesCredito> createState() => _DatosPersonalesCreditoState();
}

class _DatosPersonalesCreditoState extends State<DatosPersonalesCredito> {
  final op = Operations();
  final _fDkey = GlobalKey<FormState>();
  List<Map<String, dynamic>> recomendaciones = [];

  //todo expansion tile datos personales
  final expdpNacimiento = ExpansionTileController();
  bool expanNac = false;
  final expdpIdentificacion = ExpansionTileController();
  bool expanIdent = false;
  final expdpResidencia = ExpansionTileController();
  bool expanRes = false;
  final expdpEducacion = ExpansionTileController();
  bool expanEduc = false;
  final expdpActiEcon = ExpansionTileController();
  bool expanActiE = false;
  final expdpActiEcon2 = ExpansionTileController();
  bool expanActiE2 = false;
  final expdpSitFinan = ExpansionTileController();
  bool expanSitFinan = false;
  final expdpEstadoCiv = ExpansionTileController();
  bool expanEstC = false;
  //todo VARIABLES DE DATOS PERSONALES
  final txtNombres = TextEditingController();
  final txtApellidos = TextEditingController();
  final txtCelular1 = TextEditingController();
  final txtCelular2 = TextEditingController();
  final txtTelefono = TextEditingController();
  final txtCorreo = TextEditingController();
  //todo nacimiento
  List<String> listPaises = ['ECUADOR', 'OTRO'];
  String? pais;
  final txtPais = TextEditingController();

  List<Map<String, dynamic>> listaProvincias = [];
  String? provincia;
  bool provinciasVisible = false;
  final txtProvincia = TextEditingController();
  String? hintTextProvincia;

  List<String> listaCiudades = [];
  String? ciudad;
  bool ciudadesVisible = false;
  final txtCiudad = TextEditingController();
  String? hintTextCiudad;

  bool otroPais = false;
  final txtFechaNac = TextEditingController();
  final txtEdad = TextEditingController();
  Map<String, dynamic>? genero;
  String? textGenero;
  Map<String, dynamic>? etnia;
  String? textEtnia;
  bool enableOtraEtnia = false;
  final txtOtraEtinia = TextEditingController();
  //todo identificación
  final txtCedula = TextEditingController();
  final txtRuc = TextEditingController();
  final txtPasaporte = TextEditingController();
  final txtFechaExpPasaporte = TextEditingController();
  final txtFechaCadPasaporte = TextEditingController();
  final txtFechaEntrada = TextEditingController();
  Map<String, dynamic>? estadoMigratorio;
  String? textEstadoMigratorio;
  //todo residencia
  String? paisRes;
  final txtPaisRes = TextEditingController();
  List<Map<String, dynamic>> listaProvinciasRes = [];
  String? provinciaRes;
  bool provinciasResVisible = false;
  final txtProvinciaRes = TextEditingController();
  String? hintTextProvinciaRes;
  List<String> listaCiudadesRes = [];
  String? ciudadRes;
  bool ciudadesResVisible = false;
  final txtCiudadRes = TextEditingController();
  String? hintTextCiudadRes;
  bool otroPaisRes = false;

  final txtParroquiaRes = TextEditingController();
  final txtBarrioRes = TextEditingController();
  final txtDireccion = TextEditingController();
  String? latitudR;
  String? longitudR;
  Map<String, dynamic>? tipoVivienda;
  String? textTipoVivienda;
  bool enableValor = false;
  final txtValorV = TextEditingController();
  final txtTiempoVivienda = TextEditingController();
  Map<String, dynamic>? sector;
  String? textSector;
  //todo educación
  Map<String, dynamic>? estudio;
  String? textEstudio;
  Map<String, dynamic>? profesion;
  String? textProsfesion;
  bool enableOtraProfesion = false;
  final txtOtraProfesion = TextEditingController();
  //todo actividad económica principal
  bool independiente = false;
  bool dependiente = false;
  bool otraActiV = false;
  Map<String, dynamic>? relacionLaboral;
  String? textRelacionLaboral;

  Map<String, dynamic>? tipoNegocio;
  String? textNegocio;
  final txtExpNegocio = TextEditingController();
  Map<String, dynamic>? sectorNegocio;
  String? textSectorNegocio;
  final txtActividad = TextEditingController();
  final txtCodigoActividad = TextEditingController();
  bool actividad = false;
  final txtNombreNegocio = TextEditingController();
  final txtRucNegocio = TextEditingController();
  final txtNumEmpleados = TextEditingController();
  final txtNumEmpleadosContratar = TextEditingController();
  Map<String, dynamic>? tipoLocal;
  String? textTipoLocal;
  final txtprovinciaNegocio = TextEditingController();
  final txtciudadNegocio = TextEditingController();
  final txtParroquiaNegocio = TextEditingController();
  final txtBarrioNegocio = TextEditingController();
  final txtDireccionNegocio = TextEditingController();
  String? latitudT;
  String? longitudT;
  final txtReferenciaNegocio = TextEditingController();
  Map<String, dynamic>? origenIngreso;
  String? textOrigenIngreso;
  final txtInicioTrabajo = TextEditingController();
  final txtCorreoTrabajo = TextEditingController();
  final txtTelefonoTrabajo = TextEditingController();
  final txtCargo = TextEditingController();
  final txtInicioTrabajoAnt = TextEditingController();
  final txtSalidaTrabajoAnt = TextEditingController();
  Map<String, dynamic>? otraActividadEc;
  String? textOtraActividadEcon;
  final txtInfoOtraActividadEcon = TextEditingController();
  //todo actividad económica secundaria
  bool independiente2 = false;
  bool dependiente2 = false;
  bool otraActiV2 = false;
  Map<String, dynamic>? relacionLaboral2;
  String? textRelacionLaboral2;
  Map<String, dynamic>? tipoNegocio2;
  String? textNegocio2;
  final txtExpNegocio2 = TextEditingController();
  Map<String, dynamic>? sectorNegocio2;
  String? textSectorNegocio2;
  final txtActividad2 = TextEditingController();
  final txtCodigoActividad2 = TextEditingController();
  bool actividad2 = false;
  final txtNombreNegocio2 = TextEditingController();
  final txtRucNegocio2 = TextEditingController();
  final txtNumEmpleados2 = TextEditingController();
  final txtNumEmpleadosContratar2 = TextEditingController();
  Map<String, dynamic>? tipoLocal2;
  String? textTipoLocal2;
  final txtprovinciaNegocio2 = TextEditingController();
  final txtciudadNegocio2 = TextEditingController();
  final txtParroquiaNegocio2 = TextEditingController();
  final txtBarrioNegocio2 = TextEditingController();
  final txtDireccionNegocio2 = TextEditingController();
  String? latitudT2;
  String? longitudT2;
  final txtReferenciaNegocio2 = TextEditingController();
  Map<String, dynamic>? origenIngreso2;
  String? textOrigenIngreso2;
  final txtInicioTrabajo2 = TextEditingController();
  final txtCorreoTrabajo2 = TextEditingController();
  final txtTelefonoTrabajo2 = TextEditingController();
  final txtCargo2 = TextEditingController();
  final txtInicioTrabajoAnt2 = TextEditingController();
  final txtSalidaTrabajoAnt2 = TextEditingController();
  Map<String, dynamic>? otraActividadEc2;
  String? textOtraActividadEcon2;
  final txtInfoOtraActividadEcon2 = TextEditingController();
  //todo situación financiera
  final txtSueldo = TextEditingController();
  final txtVentas = TextEditingController();
  final txtOtrosIngresos = TextEditingController();
  final txtInfoOtrosIngresos = TextEditingController();
  final txtTotalIngresos = TextEditingController();
  final txtGastosPersonales = TextEditingController();
  final txtGastosOperacionales = TextEditingController();
  final txtOtrosGastos = TextEditingController();
  final txtInfoOtrosGastos = TextEditingController();
  final txtTotalEgresos = TextEditingController();
  final txtSaldoDisponible = TextEditingController();
  final txtEfectivoCaja = TextEditingController();
  final txtDineroBancos = TextEditingController();
  final txtCuentasxCobrar = TextEditingController();
  final txtInventarios = TextEditingController();
  final txtPropiedades = TextEditingController();
  final txtVehiculos = TextEditingController();
  final txtOtrosPatri = TextEditingController();
  final txtInfoOtrosPatri = TextEditingController();
  final txtTotalActivos = TextEditingController();
  final txtPasivoCorto = TextEditingController();
  final txtPasivoLargo = TextEditingController();
  final txtTotalPasivos = TextEditingController();
  final txtPatrimonio = TextEditingController();
  //todo estado civil
  Map<String, dynamic>? estadoCivil;
  String? textEstadoCivil;
  final txtNombreDep = TextEditingController();
  final txtApellidosDep = TextEditingController();
  final txtFechaNacDep = TextEditingController();
  Map<String, dynamic>? parentescoV;
  bool enableOtrosPar = false;
  final txtInfoOtroParen = TextEditingController();
  final txtCedulaDep = TextEditingController();

  void obtenerDatosPersona() async {
    final op = Operations();
    final data = await op.obtenerPersona(widget.idPersona);
    final form = Provider.of<FormProvider>(context, listen: false).titular;

    if (data != null) {
      setState(() {
        //todo datos personales
        txtNombres.text = data.nombres;
        form.updateValueTitular("nombres", txtNombres.text);
        txtApellidos.text = data.apellidos;
        form.updateValueTitular("apellidos", txtApellidos.text);
        txtCelular1.text = data.celular1!;
        form.updateValueTitular("celular1", txtCelular1.text);
        txtCelular2.text = data.celular2 ?? "";
        form.updateValueTitular("celular2", txtCelular2.text);
        txtCorreo.text = data.mail ?? "";
        form.updateValueTitular("correo", txtCorreo.text);
        //todo datos nacimiento
        if (data.pais != null && data.pais == "ECUADOR") {
          pais = data.pais;
          funcionPais(pais);
          provinciasVisible = true;
          provincia = data.provincia!;
          funcionProvincia(provincia!);
          ciudadesVisible = true;
          ciudad = data.ciudad!;
        } else {
          txtPais.text = data.pais!;
          provinciasVisible = true;
          txtProvincia.text = data.provincia!;
          ciudadesVisible = true;
          txtCiudad.text = data.ciudad!;
        }
        form.updateValueNacimiento("pais", pais ?? txtPais.text);
        txtProvincia.text = data.provincia!;
        form.updateValueNacimiento("provincia", provincia ?? txtProvincia.text);
        txtCiudad.text = data.ciudad!;
        form.updateValueNacimiento("ciudad", ciudad ?? txtCiudad.text);
        txtFechaNac.text = data.fechaNacimiento ?? "";
        form.updateValueNacimiento("fecha", txtFechaNac.text);
        //todo datos identificacion
        txtCedula.text = data.numeroIdentificacion ?? "";
        form.updateValueIdentificacion("cedula", txtCedula.text);
        txtRuc.text = txtCedula.text.isNotEmpty ? "${txtCedula.text}001" : "";
        form.updateValueIdentificacion("ruc_id", txtRuc.text);
        validarColorIdentificacion();
      });

      if (widget.idRelacionLaboral != null) {
        txtActividad.text = widget.actividadEconomica ?? "";
        form.updateValueActEconomica("actividad", txtActividad.text);

        txtCodigoActividad.text = widget.codigoActividad ?? "";
        form.updateValueActEconomica("codigo_act", txtCodigoActividad.text);

        relacionLaboral = relaciones
            .where((e) => e["id"] == widget.idRelacionLaboral)
            .toList()[0];
        if (widget.idRelacionLaboral == 1) {
          independiente = true;
        } else if (widget.idRelacionLaboral == 2) {
          dependiente = true;
        } else if (widget.idRelacionLaboral == 3) {
          otraActiV = true;
        }
        form.updateValueActEconomica(
            "relacion_laboral", relacionLaboral!["nombre"]);

        sectorNegocio =
            sectores.where((e) => e["id"] == widget.idSector).toList()[0];
        form.updateValueActEconomica("sector", sectorNegocio!["nombre"]);

        txtExpNegocio.text = widget.tiempoFunciones!;
        form.updateValueActEconomica("tiempo_negocio", txtExpNegocio.text);
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
    return Consumer<FormProvider>(builder: (context, form, child) {
      return expansionTile(
        key: widget.gk,
        context,
        title: "Datos personales",
        validateFields: widget.formKey.currentState != null
            ? widget.formKey.currentState!.validate()
            : null,
        func: (val) {
          if (val) {
            widget.updatePixelPosition(widget.gk);
          }
        },
        expController: widget.expController,
        enabled: widget.enableExpansion,
        color: widget.datosPersonalesC,
        children: Form(
            key: widget.formKey,
            child: Column(
              children: [
                //todo NOMBRES
                InputTextFormFields(
                    habilitado: false,
                    onChanged: (val) {
                      validarColorDatosPersonales();
                      form.titular.updateValueTitular("nombres", val);
                    },
                    prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    controlador: txtNombres,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Nombres",
                    placeHolder: ""),
                //todo APELLIDOS
                InputTextFormFields(
                    habilitado: false,
                    onChanged: (val) {
                      validarColorDatosPersonales();
                      form.titular.updateValueTitular("apellidos", val);
                    },
                    prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    controlador: txtApellidos,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Apellidos",
                    placeHolder: ""),
                //todo CELULAR 1
                InputTextFormFields(
                    habilitado: false,
                    onChanged: (val) {
                      validarColorDatosPersonales();
                      form.titular.updateValueTitular("celular1", val);
                    },
                    tipoTeclado: TextInputType.phone,
                    prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    controlador: txtCelular1,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Celular 1",
                    placeHolder: ""),
                //todo CELULAR 2
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    onChanged: (val) {
                      form.titular.updateValueTitular("celular2", val);
                    },
                    tipoTeclado: TextInputType.phone,
                    prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                    controlador: txtCelular2,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Celular 2",
                    placeHolder: ""),
                //todo TELÉFONO CONVENCIONAL
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    onChanged: (val) {
                      form.titular.updateValueTitular("telefono", val);
                    },
                    tipoTeclado: TextInputType.phone,
                    prefixIcon: const Icon(AbiPraxis.telefono, size: 18),
                    controlador: txtTelefono,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Teléfono convencional",
                    placeHolder: ""),
                //todo CORREO ELECTRÓNICO
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    onChanged: (val) {
                      validarColorDatosPersonales();
                      form.titular.updateValueTitular("correo", val);
                    },
                    tipoTeclado: TextInputType.emailAddress,
                    prefixIcon:
                        const Icon(AbiPraxis.correo_electronico_1, size: 18),
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    controlador: txtCorreo,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Correo electrónico",
                    placeHolder: ""),
                //todo EXPANSIONTILE NACIMIENTO
                Form(key: widget.fNkey, child: expansionNacimiento()),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE IDENTIFICACION
                Form(key: widget.fIkey, child: expansionIdentificacion()),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE RESIDENCIA
                Form(key: widget.fRkey, child: expansionResidencia()),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE EDUCACIÓN
                Form(key: widget.fEkey, child: expansionEducacion()),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE ACTIVIDAD ECONOMICA PRINCIPAL
                Form(key: widget.fAEkey, child: expasionActEcon1()),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE ACTIVIDAD ECONOMICA SECUNDARIA
                expansionActEcon2(),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE SITUACIÓN FINANCIERA
                Form(key: widget.fSEkey, child: expansionSitFinanciera()),
                divider(true, color: Colors.grey),
                //todo EXPANSIONTILE ESTADO CIVIL
                Form(key: widget.fECkey, child: expansionEstadoCivil()),
              ],
            )),
      );
    });
  }

  Widget expansionNacimiento() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.nacimiento, size: 18),
          color: widget.datosNacimientoC,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanNac
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Nacimiento",
          func: (_) {
            setState(() => expanNac = !expanNac);
          },
          expController: expdpNacimiento,
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
                                  txtPais.clear();
                                  txtProvincia.clear();
                                  txtCiudad.clear();
                                });
                                setState(() => otroPais = true);
                              } else {
                                setState(() => otroPais = false);
                              }
                              form.titular.updateValueNacimiento("pais", pais!);
                              provinciasVisible = true;
                              ciudadesVisible = true;
                            });
                            funcionPais(pais);
                          }),

                if (otroPais) ...[
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      controlador: txtPais,
                      capitalization: TextCapitalization.characters,
                      tipoTeclado: TextInputType.text,
                      prefixIcon: const Icon(Icons.location_city),
                      onChanged: (val) =>
                          form.titular.updateValueNacimiento("pais", val),
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

                                    form.titular.updateValueNacimiento(
                                        "provincia", provincia);
                                    ciudadesVisible = true;

                                    funcionProvincia(provincia!);
                                  })
                        : InputTextFormFields(
                            habilitado: (widget.edit != null && !widget.edit!)
                                ? false
                                : true,
                            capitalization: TextCapitalization.characters,
                            controlador: txtProvincia,
                            tipoTeclado: TextInputType.text,
                            prefixIcon: const Icon(Icons.location_city),
                            accionCampo: TextInputAction.next,
                            onChanged: (val) => form.titular
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

                                    form.titular.updateValueNacimiento(
                                        "ciudad", ciudad);
                                  })
                        : InputTextFormFields(
                            habilitado: (widget.edit != null && !widget.edit!)
                                ? false
                                : true,
                            capitalization: TextCapitalization.characters,
                            controlador: txtCiudad,
                            onChanged: (val) => form.titular
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
                              validarColorNacimiento();
                              form.titular.updateValueNacimiento("fecha", val);
                            },
                            controlador: txtFechaNac,
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
                                      txtFechaNac.text =
                                          DateFormat("yyyy-MM-dd").format(val);
                                    });
                                    txtEdad.text =
                                        AgeCalculator.age(val).years.toString();

                                    validarColorNacimiento();
                                    form.titular.updateValueNacimiento(
                                        "fecha", txtFechaNac.text);
                                    form.titular.updateValueNacimiento(
                                        "edad", txtEdad.text);
                                  }
                                });
                              },
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
                //todo EDAD
                InputTextFormFields(
                    tipoTeclado: TextInputType.number,
                    controlador: txtEdad,
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
                    value: genero,
                    items: generos
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            if (val != null) {
                              setState(() => genero = val);
                              setState(() => textGenero = val["nombre"]);
                            }
                            validarColorNacimiento();
                            form.titular.updateValueNacimiento(
                                "genero", val!["nombre"]);
                          }),
                //todo ETNIA
                DropdownButtonFormField(
                    validator: (value) => value == null || value.isEmpty
                        ? "Campo obligatorio"
                        : null,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const InputDecoration(label: Text("Etnia")),
                    value: etnia,
                    items: etnias
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() => etnia = val);
                            setState(() => textEtnia = val!["nombre"]);
                            if (val != null && val["nombre"] != "Otro") {
                              setState(() => textEtnia = val["nombre"]);
                            } else {
                              setState(() => enableOtraEtnia = true);
                            }
                            validarColorNacimiento();
                            form.titular
                                .updateValueNacimiento("etnia", val!["nombre"]);
                          }),
                //todo OTRA ETNIA
                if (enableOtraEtnia)
                  InputTextFormFields(
                      controlador: txtOtraEtinia,
                      tipoTeclado: TextInputType.number,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => textEtnia = val);
                        }
                        validarColorNacimiento();
                        form.titular.updateValueNacimiento("otra_etnia", val);
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

  Widget expansionIdentificacion() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
            leading: const Icon(AbiPraxis.identificacion, size: 18),
            color: widget.datosIdentificacionC,
            containerColor: Colors.white,
            expandColorContainer: Colors.white,
            icon: expanIdent
                ? const Icon(Icons.remove_circle_outline_sharp)
                : const Icon(Icons.add_circle_outline_outlined),
            context,
            title: "Identificación", func: (_) {
          setState(() => expanIdent = !expanIdent);
        },
            expController: expdpIdentificacion,
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
                        controlador: txtCedula,
                        onChanged: (val) {
                          validarColorIdentificacion();
                          setState(() {
                            txtRuc.text = "${val}001";
                          });
                          form.titular.updateValueIdentificacion("cedula", val);
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
                        controlador: txtRuc,
                        onChanged: (val) {
                          validarColorIdentificacion();
                          form.titular.updateValueIdentificacion("ruc_id", val);
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
                          validarColorIdentificacion();
                          form.titular
                              .updateValueIdentificacion("pasaporte", val);
                          setState(() {});
                          if (val!.isEmpty) {
                            setState(() {
                              txtFechaEntrada.clear();
                              form.titular.updateValueIdentificacion(
                                  "fecha_entrada", null);

                              txtFechaCadPasaporte.clear();
                              form.titular.updateValueIdentificacion(
                                  "fecha_cad_p", null);

                              txtFechaExpPasaporte.clear();
                              form.titular.updateValueIdentificacion(
                                  "fecha_exp_p", null);

                              estadoMigratorio = null;
                              form.titular.updateValueIdentificacion(
                                  "estado_migratorio", null);
                            });
                          }
                        },
                        controlador: txtPasaporte,
                        validacion: (val) {
                          if (pais != null && pais == "ECUADOR") {
                            return null;
                          } else if (txtPais.text.isNotEmpty &&
                              txtPais.text.toLowerCase() == "ecuador") {
                            return null;
                          } else {
                            return "Campo obligatorio";
                          }
                        },
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Número de pasaporte",
                        placeHolder: ""),
                    //todo CAMPOS DE PASAPORTE
                    if (txtPasaporte.text.isNotEmpty) ...[
                      //todo FECHA EXPEDICIÓN
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: true,
                              child: InputTextFormFields(
                                  validacion: (val) =>
                                      txtPasaporte.text.isNotEmpty &&
                                              val!.isEmpty
                                          ? "Campo obligatorio"
                                          : null,
                                  controlador: txtFechaExpPasaporte,
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
                                            txtFechaExpPasaporte.text =
                                                DateFormat("yyyy-MM-dd")
                                                    .format(val);
                                          });

                                          validarColorIdentificacion();
                                          form.titular
                                              .updateValueIdentificacion(
                                                  "fecha_exp_p",
                                                  txtFechaExpPasaporte.text);
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
                                      txtPasaporte.text.isNotEmpty &&
                                              val!.isEmpty
                                          ? "Campo obligatorio"
                                          : null,
                                  controlador: txtFechaCadPasaporte,
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
                                            txtFechaCadPasaporte.text =
                                                DateFormat("yyyy-MM-dd")
                                                    .format(val);
                                          });

                                          validarColorIdentificacion();
                                          form.titular
                                              .updateValueIdentificacion(
                                                  "fecha_cad_p",
                                                  txtFechaCadPasaporte.text);
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
                                      txtPasaporte.text.isNotEmpty &&
                                              val!.isEmpty
                                          ? "Campo obligatorio"
                                          : null,
                                  controlador: txtFechaEntrada,
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
                                            txtFechaEntrada.text =
                                                DateFormat("yyyy-MM-dd")
                                                    .format(val);
                                          });

                                          validarColorIdentificacion();
                                          form.titular
                                              .updateValueIdentificacion(
                                                  "fecha_entrada",
                                                  txtFechaEntrada.text);
                                        }
                                      });
                                    },
                              icon: const Icon(Icons.calendar_month))
                        ],
                      ),
                      //todo ESTADO MIGRATORIO
                      DropdownButtonFormField(
                          padding: const EdgeInsets.only(left: 10),
                          validator: (val) => txtPasaporte.text.isNotEmpty &&
                                  (val == null || val.isEmpty)
                              ? "Campo obligatorio"
                              : null,
                          decoration: const InputDecoration(
                              label: Text("Estado migratorio")),
                          value: estadoMigratorio,
                          items: estadoM
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e["nombre"])))
                              .toList(),
                          onChanged: (widget.edit != null && !widget.edit!)
                              ? null
                              : (Map<String, dynamic>? val) {
                                  setState(() =>
                                      textEstadoMigratorio = val!["nombre"]);
                                  setState(() => estadoMigratorio = val);
                                  validarColorIdentificacion();
                                  form.titular.updateValueIdentificacion(
                                      "estado_migratorio", val!["nombre"]);
                                })
                    ]
                  ],
                )));
      });

  Widget expansionResidencia() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.recidencia, size: 18),
          color: widget.datosResidenciaC,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanRes
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Residencia",
          func: (_) {
            setState(() => expanRes = !expanRes);
          },
          expController: expdpResidencia,
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
                                  txtPaisRes.clear();
                                  txtProvinciaRes.clear();
                                  txtCiudadRes.clear();
                                });
                                setState(() => otroPaisRes = true);
                              } else {
                                setState(() => otroPaisRes = false);
                              }
                              form.titular
                                  .updateValueResidencia("pais", paisRes!);
                              provinciasResVisible = true;
                              ciudadesResVisible = true;
                              validarColorResidencia();
                            });
                            funcionPaisRes(paisRes);
                          }),

                if (otroPaisRes) ...[
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      controlador: txtPaisRes,
                      capitalization: TextCapitalization.characters,
                      tipoTeclado: TextInputType.text,
                      prefixIcon: const Icon(Icons.location_city),
                      onChanged: (val) {
                        validarColorResidencia();
                        form.titular.updateValueResidencia("pais", val);
                      },
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

                                    form.titular.updateValueResidencia(
                                        "provincia", provinciaRes);
                                    ciudadesResVisible = true;
                                    validarColorResidencia();
                                    funcionProvinciaRes(provinciaRes!);
                                  })
                        : InputTextFormFields(
                            habilitado: (widget.edit != null && !widget.edit!)
                                ? false
                                : true,
                            capitalization: TextCapitalization.characters,
                            controlador: txtProvinciaRes,
                            tipoTeclado: TextInputType.text,
                            prefixIcon: const Icon(Icons.location_city),
                            accionCampo: TextInputAction.next,
                            onChanged: (val) {
                              form.titular
                                  .updateValueResidencia("provincia", val);
                              validarColorResidencia();
                            },
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

                                    form.titular.updateValueResidencia(
                                        "ciudad", ciudadRes);
                                    validarColorResidencia();
                                  })
                        : InputTextFormFields(
                            habilitado: (widget.edit != null && !widget.edit!)
                                ? false
                                : true,
                            capitalization: TextCapitalization.characters,
                            controlador: txtCiudadRes,
                            onChanged: (val) {
                              form.titular.updateValueResidencia("ciudad", val);
                              validarColorResidencia();
                            },
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
                      validarColorResidencia();
                      form.titular.updateValueResidencia("parroquia", val);
                    },
                    controlador: txtParroquiaRes,
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
                      validarColorResidencia();
                      form.titular.updateValueResidencia("barrio", val);
                    },
                    controlador: txtBarrioRes,
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
                    validarColorResidencia();
                    form.titular.updateValueResidencia("direccion", val);
                  },
                  controlador: txtDireccion,
                  validacion: (value) =>
                      value!.isEmpty ? "Campo obligatorio" : null,
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Dirección",
                  placeHolder: "",
                  icon: IconButton(
                      onPressed: (widget.edit != null && !widget.edit!)
                          ? null
                          : () async {
                              /*if (txtDireccion.text.isEmpty) {
                            scaffoldMessenger(context,
                                "Debe ingresar la dirección del domicilio para poder geolocalizar.",
                                icon: const Icon(Icons.error, color: Colors.red));
                            return;
                          }*/
                              //setState(() => loading = true);
                              widget.startLoading();

                              var res = await GeolocatorConfig()
                                  .requestPermission(context);

                              if (res != null) {
                                var loc = await Geolocator.getCurrentPosition();

                                setState(() {
                                  latitudR = loc.latitude.toString();
                                  longitudR = loc.longitude.toString();
                                });

                                form.titular
                                    .updateValueResidencia("latitud", latitudR);
                                form.titular.updateValueResidencia(
                                    "longitud", longitudR);

                                debugPrint("$latitudR, $longitudR");

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

                              //setState(() => loading = false);
                              widget.stopLoading();
                            },
                      icon: latitudR != null && longitudR != null
                          ? const Icon(
                              Icons.location_on,
                              color: Colors.green,
                            )
                          : const Icon(Icons.add_location_alt)),
                ),
                //todo TIPO DE VIVIENDA
                DropdownButtonFormField(
                    padding: const EdgeInsets.only(left: 10),
                    value: tipoVivienda,
                    decoration:
                        const InputDecoration(label: Text("Tipo de vivienda")),
                    items: tiposVivienda
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() => tipoVivienda = val);
                            setState(() => textTipoVivienda = val!["nombre"]);
                            if (val!["id"] == 1 || val["id"] == 2) {
                              setState(() => enableValor = true);
                            } else {
                              setState(() => enableValor = false);
                              setState(() => txtValorV.clear());
                            }
                            validarColorResidencia();
                            form.titular.updateValueResidencia(
                                "tipo_vivienda", val["nombre"]);
                          }),
                //todo VALOR
                if (enableValor)
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      controlador: txtValorV,
                      onChanged: (val) {
                        validarColorResidencia();
                        form.titular.updateValueResidencia("valor", val);
                      },
                      validacion: (value) {
                        if (tipoVivienda!["id"] == 1 ||
                            tipoVivienda!["id"] == 2) {
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
                      validarColorResidencia();
                      form.titular
                          .updateValueResidencia("tiempo_vivienda", val);
                    },
                    tipoTeclado: TextInputType.number,
                    controlador: txtTiempoVivienda,
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Tiempo en vivienda actual (años)",
                    placeHolder: ""),
                //todo SECTOR
                DropdownButtonFormField(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const InputDecoration(label: Text("Sector")),
                    value: sector,
                    items: sectores
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() => textSector = val!["nombre"]);
                            setState(() => sector = val);
                            validarColorResidencia();
                            form.titular.updateValueResidencia(
                                "sector", val!["nombre"]);
                          })
              ],
            ),
          ),
        );
      });

  Widget expansionEducacion() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.educacion, size: 18),
          color: widget.datosEducacionC,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanEduc
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Educación",
          func: (_) {
            setState(() => expanEduc = !expanEduc);
          },
          expController: expdpEducacion,
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
                    value: estudio,
                    items: estudios
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() {
                              estudio = val;
                              textEstudio = val!["nombre"];
                            });
                            validarColorEducacion();
                            form.titular.updateValueEducacion(
                                "estudio", val!["nombre"]);
                          }),
                //todo PROFESIÓN
                DropdownButtonFormField(
                    validator: (value) {
                      if (estudio != null && estudio!["id"] != 1) {
                        value == null || value.isEmpty
                            ? "Campo obligatorio"
                            : null;
                      } else {
                        return null;
                      }
                      return null;
                    },
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const InputDecoration(label: Text("Profesión")),
                    value: profesion,
                    items: profesiones
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() {
                              profesion = val;
                              textProsfesion = val!["nombre"];
                              if (val["id"] == 11) {
                                enableOtraProfesion = true;
                              } else {
                                enableOtraProfesion = false;
                                txtOtraProfesion.clear();
                              }
                            });
                            validarColorEducacion();
                            form.titular.updateValueEducacion(
                                "profesion", val!["nombre"]);
                          }),
                //todo OTRA PROFESIÓN
                if (enableOtraProfesion)
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      onChanged: (val) {
                        validarColorEducacion();
                        form.titular
                            .updateValueEducacion("otra_profesion", val);
                      },
                      controlador: txtOtraProfesion,
                      validacion: (value) {
                        if (enableOtraProfesion &&
                            txtOtraProfesion.text.isEmpty) {
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

  Widget expasionActEcon1() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
            leading: const Icon(AbiPraxis.actividad_economica, size: 18),
            color: widget.actEconoPrinC,
            containerColor: Colors.white,
            expandColorContainer: Colors.white,
            icon: expanActiE
                ? const Icon(Icons.remove_circle_outline_sharp)
                : const Icon(Icons.add_circle_outline_outlined),
            context,
            title: "Act. Económica principal", func: (_) {
          setState(() => expanActiE = !expanActiE);
        },
            expController: expdpActiEcon,
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
                          value: relacionLaboral,
                          items: relaciones
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e["nombre"])))
                              .toList(),
                          onChanged: (widget.edit != null && !widget.edit!)
                              ? null
                              : (Map<String, dynamic>? val) {
                                  setState(() {
                                    relacionLaboral = val;
                                    textRelacionLaboral = val!["nombre"];
                                  });
                                  if (val!["id"] == 1) {
                                    setState(() {
                                      independiente = true;
                                      dependiente = false;
                                      otraActiV = false;
                                    });
                                  } else if (val["id"] == 2) {
                                    setState(() {
                                      independiente = false;
                                      dependiente = true;
                                      otraActiV = false;
                                    });
                                  } else if (val["id"] == 3) {
                                    setState(() {
                                      independiente = false;
                                      dependiente = false;
                                      otraActiV = true;
                                    });
                                  }
                                  form.titular.updateValueActEconomica(
                                      "relacion_laboral", val["nombre"]);

                                  validarColorActEconPrinc();
                                }), //todo ACTIVIDAD ESPECÍFICA
                      if (!otraActiV)
                        InputTextFormFields(
                          habilitado: (widget.edit != null && !widget.edit!)
                              ? false
                              : true,
                          controlador: txtActividad,
                          onChanged: (val) {
                            filtrarActividad(val);
                            validarColorActEconPrinc();
                            form.titular
                                .updateValueActEconomica("actividad", val);
                          },
                          validacion: (val) => independiente && val!.isEmpty
                              ? "Campo obligatorio"
                              : null,
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Actividad específica",
                          placeHolder: "",
                        ),
                      //todo CÓDIGO ACTIVIDAD ESPECÍFICA
                      if (!otraActiV)
                        InputTextFormFields(
                          onChanged: (val) {
                            validarColorActEconPrinc();
                            form.titular
                                .updateValueActEconomica("codigo_act", val);
                          },
                          habilitado: false,
                          controlador: txtCodigoActividad,
                          /*validacion: (val) =>
                        independiente && val!.isEmpty ? "Campo obligatorio" : null,*/
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Código de la actividad",
                          placeHolder: "",
                        ),
                      if (independiente) opcionesIndependiente(),
                      if (dependiente) opcionesDependiente(),
                      if (otraActiV) opcionesOtraActividad(),
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
                                txtCodigoActividad.text =
                                    recomendaciones[index]["cod"];
                                txtActividad.text =
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
  Widget opcionesIndependiente() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo TIPO DE NEGOCIO
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Tipo de negocio")),
                value: tipoNegocio,
                validator: (val) =>
                    independiente && (val == null || val.isEmpty)
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
                          tipoNegocio = val;
                          textNegocio = val!["nombre"];
                        });
                        validarColorActEconPrinc();
                        form.titular.updateValueActEconomica(
                            "tipo_negocio", val!["nombre"]);
                      }),
            //todo EXPERIENCIA DE NEGOCIO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("tiempo_negocio", val);
                },
                controlador: txtExpNegocio,
                validacion: (val) =>
                    independiente && val!.isEmpty ? "Campo obligatorio" : null,
                tipoTeclado: TextInputType.number,
                accionCampo: TextInputAction.next,
                nombreCampo: "Experiencia en el negocio (meses)",
                placeHolder: ""),
            //todo SECTOR NEGOCIO
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration: const InputDecoration(label: Text("Sector")),
                value: sectorNegocio,
                validator: (val) =>
                    independiente && (val == null || val.isEmpty)
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
                          sectorNegocio = val;
                          textSectorNegocio = val!["nombre"];
                        });
                        validarColorActEconPrinc();
                        form.titular
                            .updateValueActEconomica("sector", val!["nombre"]);
                      }),

            //todo CERTIFICADO AMBIENTAL
            ListTile(
              title: const Text("Actividad require certificado ambiental"),
              trailing: Checkbox(
                  value: actividad,
                  onChanged: (widget.edit != null && !widget.edit!)
                      ? null
                      : (val) {
                          setState(() => actividad = !actividad);
                          form.titular
                              .updateValueActEconomica("certificado", "$val");
                        }),
            ),
            divider(true, color: Colors.grey),
            //todo NOMBRE / RAZÓN SOCIAL
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("nombre", val);
                },
                controlador: txtNombreNegocio,
                validacion: (value) =>
                    independiente & value!.isEmpty ? "Campo obligatorio" : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Nombre o Razón Social",
                placeHolder: ""),
            //todo RUC / RISE
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("ruc", val);
                },
                tipoTeclado: TextInputType.number,
                controlador: txtRucNegocio,
                validacion: (value) =>
                    independiente & value!.isEmpty ? "Campo obligatorio" : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "RUC / RISE",
                placeHolder: ""),
            //todo NO. EMPLEADOS
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("num_empleados", val);
                },
                tipoTeclado: TextInputType.number,
                controlador: txtNumEmpleados,
                validacion: (value) =>
                    independiente & value!.isEmpty ? "Campo obligatorio" : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "No. Empleados",
                placeHolder: ""),
            //todo NO. EMPLEADOS A CONTRATAR
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrinc();
                  form.titular
                      .updateValueActEconomica("num_empleados_contratar", val);
                },
                tipoTeclado: TextInputType.number,
                controlador: txtNumEmpleadosContratar,
                validacion: (value) =>
                    independiente & value!.isEmpty ? "Campo obligatorio" : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "No. Empleados a contratar durante el crédito",
                placeHolder: ""),
            //todo TIPO DE LOCAL
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration: const InputDecoration(label: Text("Tipo de local")),
                value: tipoLocal,
                validator: (val) =>
                    independiente && (val == null || val.isEmpty)
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
                          tipoLocal = val;
                          textTipoLocal = val!["nombre"];
                        });
                        validarColorActEconPrinc();
                        form.titular.updateValueActEconomica(
                            "tipo_local", val!["nombre"]);
                      }),
            datosUbicacionNegocio(),
          ],
        );
      });

  //todo ACTIVIDAD ECONOMICA PRINCIPAL - DEPENDIENTE
  Widget opcionesDependiente() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo ORIGEN DE INGRESOS
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Origen de ingresos")),
                value: origenIngreso,
                validator: (value) =>
                    dependiente && (value == null || value.isEmpty)
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
                          origenIngreso = val;
                          textOrigenIngreso = val!["nombre"];
                        });
                        validarColorActEconPrinc();
                        form.titular.updateValueActEconomica(
                            "origen_ingresos", val!["nombre"]);
                      }),
            //todo NOMBRE / RAZÓN SOCIAL
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("nombre", val);
                },
                controlador: txtNombreNegocio,
                validacion: (value) =>
                    dependiente & value!.isEmpty ? "Campo obligatorio" : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Nombre o Razón Social de la empresa",
                placeHolder: ""),
            //todo RUC / RISE
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("ruc", val);
                },
                tipoTeclado: TextInputType.number,
                controlador: txtRucNegocio,
                validacion: (value) =>
                    dependiente & value!.isEmpty ? "Campo obligatorio" : null,
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
                        validacion: (value) => dependiente & value!.isEmpty
                            ? "Campo obligatorio"
                            : null,
                        controlador: txtInicioTrabajo,
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

                                setState(() => txtInicioTrabajo.text = parse);
                                validarColorActEconPrinc();
                                form.titular.updateValueActEconomica(
                                    "inicio_trabajo", txtInicioTrabajo.text);
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
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("tiempo_negocio", val);
                },
                controlador: txtExpNegocio,
                validacion: (val) =>
                    dependiente && val!.isEmpty ? "Campo obligatorio" : null,
                tipoTeclado: TextInputType.number,
                accionCampo: TextInputAction.next,
                nombreCampo: "Tiempo de trabajo (meses)",
                placeHolder: ""),
            //todo CORREO ELECTRÓNICO TRABAJO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("correo", val);
                },
                tipoTeclado: TextInputType.emailAddress,
                controlador: txtCorreoTrabajo,
                accionCampo: TextInputAction.next,
                nombreCampo: "Correo electrónico de trabajo",
                placeHolder: ""),
            //todo TELÉFONO TRABAJO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("telefono", val);
                },
                controlador: txtTelefonoTrabajo,
                tipoTeclado: TextInputType.number,
                accionCampo: TextInputAction.next,
                nombreCampo: "Teléfono de trabajo",
                placeHolder: ""),
            //todo CARGO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("cargo", val);
                },
                controlador: txtCargo,
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
                        validacion: (value) => dependiente & value!.isEmpty
                            ? "Campo obligatorio"
                            : null,
                        controlador: txtInicioTrabajoAnt,
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
                                    () => txtInicioTrabajoAnt.text = parse);
                                validarColorActEconPrinc();
                                form.titular.updateValueActEconomica(
                                    "inicio_trabajo_ant",
                                    txtInicioTrabajoAnt.text);
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
                        validacion: (value) => dependiente & value!.isEmpty
                            ? "Campo obligatorio"
                            : null,
                        controlador: txtSalidaTrabajoAnt,
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
                                    () => txtSalidaTrabajoAnt.text = parse);
                                validarColorActEconPrinc();
                                form.titular.updateValueActEconomica(
                                    "salida_trabajo_ant",
                                    txtSalidaTrabajoAnt.text);
                              }
                            });
                          },
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
            datosUbicacionNegocio(),
          ],
        );
      });

  //todo OTRA ACTIVIDAD ECONÓMICA
  Widget opcionesOtraActividad() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo OTRA ACTIVIDAD ECONÓMICA
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Otra actividad")),
                value: otraActividadEc,
                validator: (value) =>
                    otraActiV && (value == null || value.isEmpty)
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
                          otraActividadEc = val;
                          textOtraActividadEcon = val!["nombre"];
                        });
                        validarColorActEconPrinc();
                        form.titular.updateValueActEconomica(
                            "otra_actividad", val!["nombre"]);
                      }),
            //todo ESPECIFIQUE OTRA ACTIVIDAD
            if (textOtraActividadEcon == "Otros")
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  onChanged: (val) {
                    validarColorActEconPrinc();
                    form.titular.updateValueActEconomica("info_actividad", val);
                  },
                  controlador: txtInfoOtraActividadEcon,
                  validacion: (val) =>
                      otraActiV && val!.isEmpty ? "Campo obligatorio" : null,
                  accionCampo: TextInputAction.done,
                  nombreCampo: "Especifique actividad",
                  placeHolder: "")
          ],
        );
      });

  Widget datosUbicacionNegocio() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo PROVINCIA
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("provincia", val);
                },
                controlador: txtprovinciaNegocio,
                validacion: (value) =>
                    (independiente || dependiente) && value!.isEmpty
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
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("ciudad", val);
                },
                controlador: txtciudadNegocio,
                validacion: (value) =>
                    (independiente || dependiente) && value!.isEmpty
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
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("parroquia", val);
                },
                controlador: txtParroquiaNegocio,
                validacion: (value) =>
                    (independiente || dependiente) && value!.isEmpty
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
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("barrio", val);
                },
                controlador: txtBarrioNegocio,
                validacion: (value) =>
                    (independiente || dependiente) && value!.isEmpty
                        ? "Campo obligatorio"
                        : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Barrio",
                placeHolder: ""),
            //todo DIRECCIÓN
            InputTextFormFields(
              habilitado: (widget.edit != null && !widget.edit!) ? false : true,
              onChanged: (val) {
                validarColorActEconPrinc();
                form.titular.updateValueActEconomica("direccion", val);
              },
              controlador: txtDireccionNegocio,
              validacion: (value) =>
                  (independiente || dependiente) && value!.isEmpty
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
                          //setState(() => loading = true);
                          widget.startLoading();

                          var res = await GeolocatorConfig()
                              .requestPermission(context);

                          if (res != null) {
                            var loc = await Geolocator.getCurrentPosition();

                            setState(() {
                              latitudT = loc.latitude.toString();
                              longitudT = loc.longitude.toString();
                            });

                            form.titular
                                .updateValueActEconomica("latitud", latitudT);
                            form.titular
                                .updateValueActEconomica("longitud", longitudT);

                            await op.actualizarGeolocalizacionPersona(
                                widget.idPersona,
                                2,
                                latitudT!,
                                longitudT!,
                                txtDireccionNegocio.text);

                            debugPrint("$latitudT, $longitudT");

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

                          //setState(() => loading = false);
                          widget.stopLoading();
                        },
                  icon: latitudT != null && longitudT != null
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
                  validarColorActEconPrinc();
                  form.titular.updateValueActEconomica("referencia", val);
                },
                controlador: txtReferenciaNegocio,
                validacion: (value) =>
                    (independiente || dependiente) && value!.isEmpty
                        ? "Campo obligatorio"
                        : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Referencia",
                placeHolder: ""),
          ],
        );
      });

  Widget expansionActEcon2() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.actividad_economica, size: 18),
          color: widget.actEconoSecC,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanActiE2
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Act. Económica secundaria",
          func: (_) {
            setState(() => expanActiE2 = !expanActiE2);
          },
          expController: expdpActiEcon2,
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
                        value: relacionLaboral2,
                        items: relaciones
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e["nombre"])))
                            .toList(),
                        onChanged: (widget.edit != null && !widget.edit!)
                            ? null
                            : (Map<String, dynamic>? val) {
                                setState(() {
                                  relacionLaboral2 = val;
                                  textRelacionLaboral2 = val!["nombre"];
                                });
                                if (val!["id"] == 1) {
                                  setState(() {
                                    independiente2 = true;
                                    dependiente2 = false;
                                    otraActiV2 = false;
                                  });
                                } else if (val["id"] == 2) {
                                  setState(() {
                                    independiente2 = false;
                                    dependiente2 = true;

                                    otraActiV2 = false;
                                  });
                                } else if (val["id"] == 3) {
                                  setState(() {
                                    independiente2 = false;
                                    dependiente2 = false;

                                    otraActiV2 = true;
                                  });
                                }
                                form.titular.updateValueActEconomicaSec(
                                    "relacion_laboral", val["nombre"]);
                              }), //todo ACTIVIDAD ESPECÍFICA
                    if (!otraActiV2)
                      InputTextFormFields(
                        habilitado: (widget.edit != null && !widget.edit!)
                            ? false
                            : true,
                        controlador: txtActividad2,
                        onChanged: (val) {
                          filtrarActividad(val);
                          form.titular
                              .updateValueActEconomicaSec("actividad", val);
                        },
                        /*validacion: (val) =>
                    independiente2 && val!.isEmpty ? "Campo obligatorio" : null,*/
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Actividad específica",
                        placeHolder: "",
                      ),
                    //todo CÓDIGO ACTIVIDAD ESPECÍFICA
                    if (!otraActiV2)
                      InputTextFormFields(
                        habilitado: false,
                        controlador: txtCodigoActividad2,
                        onChanged: (val) => form.titular
                            .updateValueActEconomicaSec("codigo_act", val),
                        /*validacion: (val) =>
                    independiente2 && val!.isEmpty ? "Campo obligatorio" : null,*/
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Código de la actividad",
                        placeHolder: "",
                      ),
                    if (independiente2) opcionesIndependiente2(),
                    if (dependiente2) opcionesDependiente2(),
                    if (otraActiV2) opcionesOtraActividad2(),
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
                              txtCodigoActividad2.text =
                                  recomendaciones[index]["cod"];
                              txtActividad2.text =
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
          ),
        );
      });

  //todo ACTIVIDAD ECONOMICA SECUNDARIA - INDEPENDIENTE
  Widget opcionesIndependiente2() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo TIPO DE NEGOCIO
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Tipo de negocio")),
                value: tipoNegocio2,
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
                          tipoNegocio2 = val;
                          textNegocio2 = val!["nombre"];
                        });

                        form.titular.updateValueActEconomicaSec(
                            "tipo_negocio", val!["nombre"]);
                      }),
            //todo EXPERIENCIA DE NEGOCIO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtExpNegocio2,
                /*validacion: (val) =>
                      independiente && val!.isEmpty ? "Campo obligatorio" : null,*/
                tipoTeclado: TextInputType.number,
                accionCampo: TextInputAction.next,
                onChanged: (val) => form.titular
                    .updateValueActEconomicaSec("tiempo_negocio", val),
                nombreCampo: "Experiencia en el negocio (meses)",
                placeHolder: ""),
            //todo SECTOR NEGOCIO
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration: const InputDecoration(label: Text("Sector")),
                value: sectorNegocio2,
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
                          sectorNegocio2 = val;
                          textSectorNegocio2 = val!["nombre"];
                        });
                        form.titular.updateValueActEconomicaSec(
                            "sector", val!["nombre"]);
                      }),

            //todo CERTIFICADO AMBIENTAL
            ListTile(
              title: const Text("Actividad require certificado ambiental"),
              trailing: Checkbox(
                  value: actividad2,
                  onChanged: (widget.edit != null && !widget.edit!)
                      ? null
                      : (val) {
                          setState(() => actividad2 = !actividad2);
                          form.titular.updateValueActEconomicaSec(
                              "certificado", val.toString());
                        }),
            ),
            divider(true, color: Colors.grey),
            //todo NOMBRE / RAZÓN SOCIAL
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtNombreNegocio2,
                onChanged: (val) =>
                    form.titular.updateValueActEconomicaSec("nombre", val),
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
                controlador: txtRucNegocio2,
                onChanged: (val) =>
                    form.titular.updateValueActEconomicaSec("ruc", val),
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
                controlador: txtNumEmpleados2,
                onChanged: (val) => form.titular
                    .updateValueActEconomicaSec("num_empleados", val),
                /*validacion: (value) =>
                      independiente2 && value!.isEmpty ? "Campo obligatorio" : null,*/
                accionCampo: TextInputAction.next,
                nombreCampo: "No. Empleados",
                placeHolder: ""),
            //todo NO. EMPLEADOS A CONTRATAR
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                tipoTeclado: TextInputType.number,
                controlador: txtNumEmpleadosContratar2,
                onChanged: (val) => form.titular.updateValueActEconomicaSec(
                    "tnum_empleados_contratar", val),
                /*validacion: (value) =>
                      independiente2 && value!.isEmpty ? "Campo obligatorio" : null,*/
                accionCampo: TextInputAction.next,
                nombreCampo: "No. Empleados a contratar durante el crédito",
                placeHolder: ""),
            //todo TIPO DE LOCAL
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration: const InputDecoration(label: Text("Tipo de local")),
                value: tipoLocal2,
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
                          tipoLocal2 = val;
                          textTipoLocal2 = val!["nombre"];
                        });
                        form.titular.updateValueActEconomicaSec(
                            "tipo_local", val!["nombre"]);
                      }),
            datosUbicacionNegocio2(),
          ],
        );
      });

  //todo ACTIVIDAD ECONOMICA PRINCIPAL - DEPENDIENTE
  Widget opcionesDependiente2() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo ORIGEN DE INGRESOS
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Origen de ingresos")),
                value: origenIngreso2,
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
                          origenIngreso2 = val;
                          textOrigenIngreso2 = val!["nombre"];
                        });
                        form.titular.updateValueActEconomicaSec(
                            "origen_ingresos", val!["nombre"]);
                      }),
            //todo NOMBRE / RAZÓN SOCIAL
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtNombreNegocio2,
                onChanged: (val) =>
                    form.titular.updateValueActEconomicaSec("nombre", val),
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
                controlador: txtRucNegocio2,
                onChanged: (val) =>
                    form.titular.updateValueActEconomicaSec("ruc", val),
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
                      controlador: txtInicioTrabajo2,
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

                                setState(() => txtInicioTrabajo2.text = parse);

                                form.titular.updateValueActEconomicaSec(
                                    "inicio_trabajo", txtInicioTrabajo2.text);
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
                controlador: txtExpNegocio2,
                /*validacion: (val) =>
                      dependiente2 && val!.isEmpty ? "Campo obligatorio" : null,*/
                onChanged: (val) => form.titular
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
                    form.titular.updateValueActEconomicaSec("correo", val),
                controlador: txtCorreoTrabajo2,
                accionCampo: TextInputAction.next,
                nombreCampo: "Correo electrónico de trabajo",
                placeHolder: ""),
            //todo TELÉFONO TRABAJO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtTelefonoTrabajo2,
                onChanged: (val) =>
                    form.titular.updateValueActEconomicaSec("telefono", val),
                tipoTeclado: TextInputType.number,
                accionCampo: TextInputAction.next,
                nombreCampo: "Teléfono de trabajo",
                placeHolder: ""),
            //todo CARGO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtCargo2,
                onChanged: (val) =>
                    form.titular.updateValueActEconomicaSec("cargo", val),
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
                      controlador: txtInicioTrabajoAnt2,
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
                                    () => txtInicioTrabajoAnt2.text = parse);
                                form.titular.updateValueActEconomicaSec(
                                    "inicio_trabajo_ant",
                                    txtInicioTrabajoAnt2.text);
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
                      controlador: txtSalidaTrabajoAnt2,
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
                                    () => txtSalidaTrabajoAnt2.text = parse);

                                form.titular.updateValueActEconomicaSec(
                                    "salida_trabajo_ant",
                                    txtSalidaTrabajoAnt2.text);
                              }
                            });
                          },
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
            datosUbicacionNegocio2(),
          ],
        );
      });

  //todo OTRA ACTIVIDAD ECONÓMICA
  Widget opcionesOtraActividad2() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo OTRA ACTIVIDAD ECONÓMICA
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Otra actividad")),
                value: otraActividadEc2,
                validator: (value) =>
                    otraActiV2 && (value == null || value.isEmpty)
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
                          otraActividadEc2 = val;
                          textOtraActividadEcon2 = val!["nombre"];
                        });
                        form.titular.updateValueActEconomicaSec(
                            "otra_actividad", val!["nombre"]);
                        validarColorActEconPrinc();
                      }),
            //todo ESPECIFIQUE OTRA ACTIVIDAD
            if (textOtraActividadEcon2 == "Otros")
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  onChanged: (val) {
                    validarColorActEconPrinc();
                    form.titular
                        .updateValueActEconomicaSec("info_actividad", val);
                  },
                  controlador: txtInfoOtraActividadEcon2,
                  validacion: (val) =>
                      otraActiV2 && val!.isEmpty ? "Campo obligatorio" : null,
                  accionCampo: TextInputAction.done,
                  nombreCampo: "Especifique actividad",
                  placeHolder: "")
          ],
        );
      });

  Widget datosUbicacionNegocio2() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo PROVINCIA
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtprovinciaNegocio2,
                onChanged: (val) =>
                    form.titular.updateValueActEconomicaSec("provincia", val),
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
                controlador: txtciudadNegocio2,
                onChanged: (val) =>
                    form.titular.updateValueActEconomicaSec("ciudad", val),
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
                controlador: txtParroquiaNegocio2,
                onChanged: (val) =>
                    form.titular.updateValueActEconomicaSec("parroquia", val),
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
                controlador: txtBarrioNegocio2,
                onChanged: (val) =>
                    form.titular.updateValueActEconomicaSec("barrio", val),
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
              controlador: txtDireccionNegocio2,
              onChanged: (val) =>
                  form.titular.updateValueActEconomicaSec("direccion", val),
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
                          //setState(() => loading = true);
                          widget.startLoading();

                          var res = await GeolocatorConfig()
                              .requestPermission(context);

                          if (res != null) {
                            var loc = await Geolocator.getCurrentPosition();

                            setState(() {
                              latitudT2 = loc.latitude.toString();
                              longitudT2 = loc.longitude.toString();
                            });

                            form.titular.updateValueActEconomicaSec(
                                "latitud", latitudT2);
                            form.titular.updateValueActEconomicaSec(
                                "longitud", longitudT2);

                            debugPrint("$latitudT2, $longitudT2");

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

                          //setState(() => loading = false);
                          widget.stopLoading();
                        },
                  icon: latitudT2 != null && longitudT2 != null
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
                controlador: txtReferenciaNegocio2,
                onChanged: (val) =>
                    form.titular.updateValueActEconomicaSec("referencia", val),
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

  Widget expansionSitFinanciera() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.estado_situacion_financiera, size: 18),
          color: widget.datosSitEconC,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanSitFinan
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Situación económica",
          func: (_) {
            setState(() => expanSitFinan = !expanSitFinan);
          },
          expController: expdpSitFinan,
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
                    controlador: txtSueldo,
                    onChanged: (val) {
                      var sueldo = double.parse((val!.isNotEmpty ? val : "0"));
                      var venta = double.parse(
                          txtVentas.text.isNotEmpty ? txtVentas.text : "0");
                      var otros = double.parse(txtOtrosIngresos.text.isNotEmpty
                          ? txtOtrosIngresos.text
                          : "0");

                      setState(() => txtTotalIngresos.text =
                          (sueldo + venta + otros).toString());

                      calcularSaldoDisponible();
                      validarColorSitEconom();
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
                    controlador: txtVentas,
                    tipoTeclado: TextInputType.number,
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null,
                    onChanged: (val) {
                      var sueldo = double.parse(
                          (txtSueldo.text.isNotEmpty ? txtSueldo.text : "0"));
                      var venta = double.parse(val!.isNotEmpty ? val : "0");

                      setState(() => txtTotalIngresos.text =
                          (sueldo + venta).toStringAsFixed(2));
                      calcularSaldoDisponible();
                      validarColorSitEconom();
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
                    controlador: txtOtrosIngresos,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      var sueldo = double.parse(
                          (txtSueldo.text.isNotEmpty ? txtSueldo.text : "0"));
                      var venta = double.parse(
                          txtVentas.text.isNotEmpty ? txtVentas.text : "0");
                      var otros = double.parse(val!.isNotEmpty ? val : "0");

                      setState(() => txtTotalIngresos.text =
                          (sueldo + venta + otros).toStringAsFixed(2));
                      calcularSaldoDisponible();
                      validarColorSitEconom();
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
                if (txtOtrosIngresos.text.isNotEmpty)
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      onChanged: (val) {
                        validarColorSitEconom();

                        form.titular
                            .updateValueSitEcon("info_otro_ingreso", val);
                      },
                      controlador: txtInfoOtrosIngresos,
                      validacion: (val) {
                        if (txtOtrosIngresos.text.isNotEmpty && val!.isEmpty) {
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
                    controlador: txtTotalIngresos,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      debugPrint("SE ACTUALIZÓ EL CAMPO");
                    },
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
                    controlador: txtGastosPersonales,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      var gp = double.parse(txtGastosPersonales.text.isNotEmpty
                          ? txtGastosPersonales.text
                          : "0");
                      var go = double.parse(
                          txtGastosOperacionales.text.isNotEmpty
                              ? txtGastosOperacionales.text
                              : "0");

                      var oe = double.parse(txtOtrosGastos.text.isNotEmpty
                          ? txtOtrosGastos.text
                          : "0");

                      setState(() => txtTotalEgresos.text =
                          (gp + go + oe).toStringAsFixed(2));
                      calcularSaldoDisponible();
                      validarColorSitEconom();
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
                    controlador: txtGastosOperacionales,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      var gp = double.parse(txtGastosPersonales.text.isNotEmpty
                          ? txtGastosPersonales.text
                          : "0");
                      var go = double.parse(
                          txtGastosOperacionales.text.isNotEmpty
                              ? txtGastosOperacionales.text
                              : "0");

                      var oe = double.parse(txtOtrosGastos.text.isNotEmpty
                          ? txtOtrosGastos.text
                          : "0");

                      setState(() => txtTotalEgresos.text =
                          (gp + go + oe).toStringAsFixed(2));
                      calcularSaldoDisponible();
                      validarColorSitEconom();
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
                    controlador: txtOtrosGastos,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      var gp = double.parse(txtGastosPersonales.text.isNotEmpty
                          ? txtGastosPersonales.text
                          : "0");
                      var go = double.parse(
                          txtGastosOperacionales.text.isNotEmpty
                              ? txtGastosOperacionales.text
                              : "0");

                      var oe = double.parse(txtOtrosGastos.text.isNotEmpty
                          ? txtOtrosGastos.text
                          : "0");

                      setState(() => txtTotalEgresos.text =
                          (gp + go + oe).toStringAsFixed(2));
                      calcularSaldoDisponible();
                      validarColorSitEconom();
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
                if (txtOtrosGastos.text.isNotEmpty)
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      onChanged: (val) {
                        validarColorSitEconom();
                        form.titular
                            .updateValueSitEcon("info_otro_egreso", val);
                      },
                      controlador: txtInfoOtrosGastos,
                      validacion: (val) {
                        if (txtOtrosGastos.text.isNotEmpty && val!.isEmpty) {
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
                    controlador: txtTotalEgresos,
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
                    controlador: txtSaldoDisponible,
                    habilitado: false,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Saldo disponible (\$)",
                    placeHolder: ""),
                //todo EFECTIVO EN CAJA
                InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtEfectivoCaja,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivos();
                      validarColorSitEconom();
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
                    controlador: txtDineroBancos,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivos();

                      validarColorSitEconom();
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
                    controlador: txtCuentasxCobrar,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivos();

                      validarColorSitEconom();
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
                    controlador: txtInventarios,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivos();
                      validarColorSitEconom();
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
                    controlador: txtPropiedades,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivos();
                      validarColorSitEconom();
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
                    controlador: txtVehiculos,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivos();
                      validarColorSitEconom();
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
                    controlador: txtOtrosPatri,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularActivos();
                      validarColorSitEconom();
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
                if (txtOtrosPatri.text.isNotEmpty)
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      onChanged: (val) {
                        validarColorSitEconom();
                        form.titular
                            .updateValueSitEcon("info_otro_activo", val);
                      },
                      controlador: txtInfoOtrosPatri,
                      validacion: (val) {
                        if (txtOtrosPatri.text.isNotEmpty && val!.isEmpty) {
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
                    controlador: txtTotalActivos,
                    tipoTeclado: TextInputType.number,
                    onChanged: (_) {
                      calcularPatrimonio();
                      validarColorSitEconom();
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
                    controlador: txtPasivoCorto,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularPasivos();
                      calcularPatrimonio();
                      validarColorSitEconom();
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
                    controlador: txtPasivoLargo,
                    tipoTeclado: TextInputType.number,
                    onChanged: (val) {
                      calcularPasivos();
                      calcularPatrimonio();
                      validarColorSitEconom();
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
                    controlador: txtTotalPasivos,
                    tipoTeclado: TextInputType.number,
                    onChanged: (_) {
                      calcularPatrimonio();
                      validarColorSitEconom();
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
                    onChanged: (_) => validarColorSitEconom(),
                    habilitado: false,
                    controlador: txtPatrimonio,
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

  Widget expansionEstadoCivil() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.estado_civil, size: 18),
          color: widget.datosEstadoCivilC,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanEstC
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Estado civil",
          func: (_) {
            setState(() => expanEstC = !expanEstC);
          },
          expController: expdpEstadoCiv,
          enabled: widget.enableExpansion,
          children: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                divider(false),
                //todo ESTADO CIVIL
                DropdownButtonFormField(
                    value: estadoCivil,
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
                              estadoCivil = val;
                              textEstadoCivil = val!["nombre"];
                            });
                            validarColorEstCivil();
                            form.titular.updateValueEstadoCivil(
                                "estado_civil", val!["nombre"]);
                          }),
                //todo NO DEPENDIENTES
                InkWell(
                  onTap: () => viewListDependientes(),
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
                          "Dependientes (${form.titular.getDependientes.length})",
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

  void calcularSaldoDisponible() {
    var titular = Provider.of<FormProvider>(context, listen: false).titular;

    var sueldo = double.parse(txtSueldo.text.isNotEmpty ? txtSueldo.text : "0");
    var ventas = double.parse(txtVentas.text.isNotEmpty ? txtVentas.text : "0");
    var otroI = double.parse(
        txtOtrosIngresos.text.isNotEmpty ? txtOtrosIngresos.text : "0");

    var totalIngresos = (sueldo + ventas + otroI);

    var gp = double.parse(
        txtGastosPersonales.text.isNotEmpty ? txtGastosPersonales.text : "0");
    var go = double.parse(txtGastosOperacionales.text.isNotEmpty
        ? txtGastosOperacionales.text
        : "0");
    var oe = double.parse(
        txtOtrosGastos.text.isNotEmpty ? txtOtrosGastos.text : "0");

    var totalEgresos = (gp + go + oe);

    var saldo = (totalIngresos - totalEgresos).toStringAsFixed(2);

    setState(() => txtSaldoDisponible.text = saldo.isEmpty ? "0.0" : saldo);
    titular.updateValueSitEcon("sueldo", sueldo.toStringAsFixed(2));
    titular.updateValueSitEcon("ventas", ventas.toStringAsFixed(2));
    titular.updateValueSitEcon("otro_ingreso", otroI.toStringAsFixed(2));
    titular.updateValueSitEcon(
        "total_ingreso", totalIngresos.toStringAsFixed(2));
    titular.updateValueSitEcon("gastos_personales", gp.toStringAsFixed(2));
    titular.updateValueSitEcon("gastos_operacionales", go.toStringAsFixed(2));
    titular.updateValueSitEcon("otro_egreso", oe.toStringAsFixed(2));
    titular.updateValueSitEcon("total_egreso", totalEgresos.toStringAsFixed(2));
    titular.updateValueSitEcon("saldo", saldo);
  }

  void calcularActivos() {
    var titular = Provider.of<FormProvider>(context, listen: false).titular;

    var ec = double.parse(
        txtEfectivoCaja.text.isNotEmpty ? txtEfectivoCaja.text : "0");

    var db = double.parse(
        txtDineroBancos.text.isNotEmpty ? txtDineroBancos.text : "0");

    var cc = double.parse(
        txtCuentasxCobrar.text.isNotEmpty ? txtCuentasxCobrar.text : "0");

    var i = double.parse(
        txtInventarios.text.isNotEmpty ? txtInventarios.text : "0");

    var p = double.parse(
        txtPropiedades.text.isNotEmpty ? txtPropiedades.text : "0");

    var v =
        double.parse(txtVehiculos.text.isNotEmpty ? txtVehiculos.text : "0");

    var o =
        double.parse(txtOtrosPatri.text.isNotEmpty ? txtOtrosPatri.text : "0");

    var suma = (ec + db + cc + i + p + v + o).toStringAsFixed(2);

    setState(() => txtTotalActivos.text = suma.isEmpty ? "0.0" : suma);
    titular.updateValueSitEcon("efectivo", ec.toStringAsFixed(2));
    titular.updateValueSitEcon("banco", db.toStringAsFixed(2));
    titular.updateValueSitEcon("cuentas", cc.toStringAsFixed(2));
    titular.updateValueSitEcon("inventarios", i.toStringAsFixed(2));
    titular.updateValueSitEcon("propiedades", p.toStringAsFixed(2));
    titular.updateValueSitEcon("vehiculos", v.toStringAsFixed(2));
    titular.updateValueSitEcon("otro_activo", o.toStringAsFixed(2));
    titular.updateValueSitEcon("total_activo", ec.toStringAsFixed(2));
  }

  void calcularPasivos() {
    var titular = Provider.of<FormProvider>(context, listen: false).titular;

    var pc = double.parse(
        txtPasivoCorto.text.isNotEmpty ? txtPasivoCorto.text : "0");

    var pl = double.parse(
        txtPasivoLargo.text.isNotEmpty ? txtPasivoLargo.text : "0");

    var suma = (pc + pl).toStringAsFixed(2);

    setState(() => txtTotalPasivos.text = suma.isEmpty ? "0.0" : suma);
    titular.updateValueSitEcon("pasivo_corto", pc.toStringAsFixed(2));
    titular.updateValueSitEcon("pasivo_largo", pl.toStringAsFixed(2));
    titular.updateValueSitEcon("total_pasivo", suma);
  }

  void calcularPatrimonio() {
    var titular = Provider.of<FormProvider>(context, listen: false).titular;

    var a = double.parse(
        txtTotalActivos.text.isNotEmpty ? txtTotalActivos.text : "0");

    var p = double.parse(
        txtTotalPasivos.text.isNotEmpty ? txtTotalPasivos.text : "0");

    var res = (a - p).toStringAsFixed(2);

    setState(() => txtPatrimonio.text = res.isEmpty ? "0.0" : res);
    titular.updateValueSitEcon("patrimonio", res);
  }

  void viewListDependientes() => showModalBottomSheet(
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
                              itemCount: form.titular.getDependientes.length,
                              itemBuilder: (itemBuilder, i) {
                                List<PersonaModel> dependientes =
                                    form.titular.getDependientes;
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
                                                  //setState(() => loading = true);
                                                  widget.startLoading();
                                                  // setState(() => dependientes
                                                  //     .remove(dependientes[i]));

                                                  form.titular
                                                      .removeDependiente(i);

                                                  scaffoldMessenger(context,
                                                      "Dependiente eliminado de la lista",
                                                      icon: const Icon(
                                                          Icons.check,
                                                          color: Colors.green));
                                                  //setState(() => loading = false);
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
                                                    "${dependientes[i].nombres!.split(" ")[0]} ${dependientes[i].apellidos!.split(" ")[0]}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ],
                                          ),
                                          trailing: Text(dependientes[i]
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
                                  showModalAgregarDependiente()
                                ],
                        child: const Icon(Icons.add, color: Colors.white),
                      ))
                ],
              ),
            ),
          );
        });
      });

  void showModalAgregarDependiente() async {
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
                  key: _fDkey,
                  child: SingleChildScrollView(
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
                            /*validacion: (val) =>
                                val!.isEmpty ? "Campo obligatorio" : null,*/
                            controlador: txtCedulaDep,
                            tipoTeclado: TextInputType.number,
                            accionCampo: TextInputAction.next,
                            nombreCampo: "Cédula",
                            placeHolder: ""),
                        InputTextFormFields(
                            validacion: (val) =>
                                val!.isEmpty ? "Campo obligatorio" : null,
                            controlador: txtNombreDep,
                            capitalization: TextCapitalization.words,
                            accionCampo: TextInputAction.next,
                            nombreCampo: "Nombres",
                            placeHolder: ""),
                        InputTextFormFields(
                            validacion: (val) =>
                                val!.isEmpty ? "Campo obligatorio" : null,
                            capitalization: TextCapitalization.words,
                            controlador: txtApellidosDep,
                            accionCampo: TextInputAction.next,
                            nombreCampo: "Apellidos",
                            placeHolder: ""),
                        DropdownButtonFormField(
                            validator: (val) => val == null || val.isEmpty
                                ? "Campo obligatorio"
                                : null,
                            decoration: const InputDecoration(
                                label: Text("Parentesco")),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            value: parentescoV,
                            items: parentesco
                                .map((e) => DropdownMenuItem(
                                    value: e, child: Text(e["nombre"])))
                                .toList(),
                            onChanged: (val) {
                              state(() {
                                parentescoV = val;
                                if (parentescoV!["id"] == 10) {
                                  enableOtrosPar = true;
                                } else {
                                  enableOtrosPar = false;
                                }
                              });
                            }),
                        if (enableOtrosPar)
                          InputTextFormFields(
                              controlador: txtInfoOtroParen,
                              validacion: (val) =>
                                  parentescoV != null && val!.isEmpty
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
                                    validacion: (val) => val!.isEmpty
                                        ? "Campo obligatorio"
                                        : null,
                                    controlador: txtFechaNacDep,
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
                                      txtFechaNacDep.text =
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

                              if (!_fDkey.currentState!.validate()) {
                                return;
                              } else {
                                var newDep = PersonaModel(
                                    usuarioCreacion: idUser,
                                    numeroIdentificacion: txtCedulaDep.text,
                                    nombres: txtNombreDep.text,
                                    apellidos: txtApellidosDep.text,
                                    parentesco:
                                        (parentescoV!["id"] ?? 0).toString(),
                                    fechaNacimiento: txtFechaNacDep.text);

                                form.titular.addDependiente(newDep);

                                Navigator.pop(context);

                                scaffoldMessenger(context,
                                    "Dependiente agregado correctamente",
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
              ),
            );
          });
        }).then((_) {
      setState(() {
        txtCedulaDep.clear();
        txtNombreDep.clear();
        txtApellidosDep.clear();
        parentescoV = null;
        txtInfoOtroParen.clear();
        txtFechaNacDep.clear();
        enableOtrosPar = false;
      });
    });
  }

  void validarColorDatosPersonales() {
    var val1 = txtNombres.text.isNotEmpty;
    var val2 = txtApellidos.text.isNotEmpty;
    var val3 = txtCelular1.text.isNotEmpty;
    var val4 = txtCorreo.text.isNotEmpty;

    if (val1 && val2 && val3 && val4) {
      widget.changeColorDatosPersonales(1);
    } else {
      widget.changeColorDatosPersonales(2);
    }

    validarColorNacimiento();
    validarColorIdentificacion();
    validarColorResidencia();
    validarColorEducacion();
    validarColorActEconPrinc();
    validarColorActEconSec();
    validarColorSitEconom();
    validarColorEstCivil();
  }

  void validarColorNacimiento() {
    var val1 = (txtPaisRes.text.isNotEmpty || pais != null);
    var val2 = (txtProvinciaRes.text.isNotEmpty || provincia != null);
    var val3 = (txtCiudadRes.text.isNotEmpty || ciudad != null);
    var val4 = txtFechaNac.text.isNotEmpty;
    var val5 = (genero != null);
    var val6 = (etnia != null);

    if (val1 && val2 && val3 && val4 && val5 && val6) {
      widget.changeColorNac(1);
    } else {
      widget.changeColorNac(2);
    }
  }

  void validarColorIdentificacion() {
    var val1 = txtCedula.text.isNotEmpty;
    var val2 = txtRuc.text.isNotEmpty;
    var val3 = txtPasaporte.text.isNotEmpty;
    var val4 = txtFechaExpPasaporte.text.isNotEmpty;
    var val5 = txtFechaCadPasaporte.text.isNotEmpty;
    var val6 = txtFechaEntrada.text.isNotEmpty;
    var val7 = (estadoMigratorio != null);

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

  void validarColorResidencia() {
    var val1 = (txtPaisRes.text.isNotEmpty || paisRes != null);
    var val2 = (txtProvinciaRes.text.isNotEmpty || provinciaRes != null);
    var val3 = (txtCiudadRes.text.isNotEmpty || ciudadRes != null);
    var val4 = txtParroquiaRes.text.isNotEmpty;
    var val5 = txtBarrioRes.text.isNotEmpty;
    var val6 = txtDireccion.text.isNotEmpty;
    var val7 = (tipoVivienda != null);
    var val8 = txtTiempoVivienda.text.isNotEmpty;
    var val9 = (sector != null);
    var val10 = txtValorV.text.isNotEmpty;

    if (val7 && (tipoVivienda!["id"] == 1 || tipoVivienda!["id"] == 2)) {
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

  void validarColorEducacion() {
    var val1 = (estudio != null);
    var val2 = (profesion != null);
    var val3 = txtOtraProfesion.text.isNotEmpty;

    if (val2 && profesion!["id"] == 11) {
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

  void validarColorActEconPrinc() {
    var val1 = relacionLaboral;
    //todo INDEPENDIENTE
    var val2 = (tipoNegocio != null);
    var val3 = txtExpNegocio.text.isNotEmpty;
    var val4 = (sectorNegocio != null);
    var val5 = txtActividad.text.isNotEmpty;
    //var val6 = txtCodigoActividad.text.isNotEmpty;
    var val7 = txtNombreNegocio.text.isNotEmpty;
    var val8 = txtRucNegocio.text.isNotEmpty;
    var val9 = txtNumEmpleados.text.isNotEmpty;
    var val10 = txtNumEmpleadosContratar.text.isNotEmpty;
    var val11 = (tipoLocal != null);
    var val12 = txtprovinciaNegocio.text.isNotEmpty;
    var val13 = txtciudadNegocio.text.isNotEmpty;
    var val14 = txtParroquiaNegocio.text.isNotEmpty;
    var val15 = txtBarrioNegocio.text.isNotEmpty;
    var val16 = txtDireccionNegocio.text.isNotEmpty;
    var val17 = txtReferenciaNegocio.text.isNotEmpty;
    //todo DEPENDIENTE
    var val18 = (origenIngreso != null);
    //nombre negocio
    //ruc
    var val19 = txtInicioTrabajo.text.isNotEmpty;
    //experiencia negocio
    var val20 = txtCargo.text.isNotEmpty;
    var val21 = txtInicioTrabajoAnt.text.isNotEmpty;
    var val22 = txtSalidaTrabajoAnt.text.isNotEmpty;
    //provincia
    //ciudad
    //parroquia
    //barrio
    //direccion
    //referencia
    //todo OTROS
    var val23 = (otraActividadEc != null);
    var val24 =
        (otraActividadEc != null && otraActividadEc!["nombre"] != "Otros");
    var val25 = txtInfoOtraActividadEcon.text.isNotEmpty;

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
              val10 &&
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

  void validarColorActEconSec() {
    widget.changeColorActSec(1);
  }

  void validarColorSitEconom() {
    var val1 = txtSueldo.text.isNotEmpty;
    var val2 = txtVentas.text.isNotEmpty;
    var val3 = txtOtrosIngresos.text.isNotEmpty;
    var val4 = txtInfoOtrosIngresos.text.isNotEmpty;
    var val5 = txtGastosPersonales.text.isNotEmpty;
    var val6 = txtGastosOperacionales.text.isNotEmpty;
    var val7 = txtOtrosGastos.text.isNotEmpty;
    var val8 = txtInfoOtrosGastos.text.isNotEmpty;
    var val9 = txtEfectivoCaja.text.isNotEmpty;
    var val10 = txtDineroBancos.text.isNotEmpty;
    var val11 = txtCuentasxCobrar.text.isNotEmpty;
    var val12 = txtInventarios.text.isNotEmpty;
    var val13 = txtPropiedades.text.isNotEmpty;
    var val14 = txtVehiculos.text.isNotEmpty;
    var val15 = txtOtrosPatri.text.isNotEmpty;
    var val16 = txtInfoOtrosPatri.text.isNotEmpty;
    var val17 = txtPasivoCorto.text.isNotEmpty;
    var val18 = txtPasivoLargo.text.isNotEmpty;

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

  void validarColorEstCivil() {
    var val1 = (estadoCivil != null);

    if (val1) {
      widget.changeColorEstCiv(1);
    } else {
      widget.changeColorEstCiv(2);
    }
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
    final form = Provider.of<FormProvider>(context, listen: false).titular;

    if (widget.idSolicitud != null) {
      final solicitud = await op.obtenerSolicitud(widget.idSolicitud!);

      if (solicitud != null) {
        widget.startLoading();

        final datosPersonales = jsonDecode(solicitud.datosPersonales);
        final nac = datosPersonales["nacimiento"];
        final iden = datosPersonales["identificacion"];
        final res = datosPersonales["residencia"];
        final educ = datosPersonales["educacion"];
        final actP = datosPersonales["actividad_principal"];
        final actS = datosPersonales["actividad_secundaria"];
        final eco = datosPersonales["economia"];
        final ec = datosPersonales["estado_civil"];

        //todo NACIMIENTO
        //fecha nacimiento
        if (nac["fecha"]?.isNotEmpty ?? false) {
          setState(() => txtFechaNac.text = nac["fecha"]);
          form.updateValueNacimiento("fecha", txtFechaNac.text);
        }

        //edad
        if (nac["edad"]?.isNotEmpty ?? false) {
          setState(() => txtEdad.text = nac["edad"]);
          form.updateValueNacimiento("edad", txtEdad.text);
        }

        //genero
        if (nac["genero"]?.isNotEmpty ?? false) {
          var g = generos.where((e) => nac["genero"] == e["nombre"]).first;

          setState(() => genero = g);
          form.updateValueNacimiento("genero", g["nombre"]);
        }

        //etnia
        if (nac["etnia"]?.isNotEmpty ?? false) {
          var e = etnias.where((e) => nac["etnia"] == e["nombre"]).first;

          setState(() => etnia = e);
          form.updateValueNacimiento("etnia", e["nombre"]);

          //otra etnia
          if (e["nombre"] == "Otro") {
            if (nac["otra_etnia"] != null && nac["otra_etnia"] != "") {
              setState(() => txtOtraEtinia.text = nac["otra_etnia"]);
              form.updateValueNacimiento("otra_etnia", txtOtraEtinia.text);
            }
          }
        }
        validarColorNacimiento();

        //todo IDENTIFICACIÓN obviamos cédula y ruc porque eso se busca por id persona arriba
        //pasaporte
        if (iden["pasaporte"]?.isNotEmpty ?? false) {
          setState(() => txtPasaporte.text = iden["pasaporte"]);
          form.updateValueIdentificacion("pasaporte", txtPasaporte.text);
        }
        //fecha expiracion
        if (iden["fecha_exp_p"]?.isNotEmpty ?? false) {
          setState(() => txtFechaExpPasaporte.text = iden["fecha_exp_p"]);
          form.updateValueIdentificacion(
              "fecha_exp_p", txtFechaExpPasaporte.text);
        }
        //fecha caducidad
        if (iden["fecha_cad_p"]?.isNotEmpty ?? false) {
          setState(() => txtFechaCadPasaporte.text = iden["fecha_cad_p"]);
          form.updateValueIdentificacion(
              "fecha_cad_p", txtFechaCadPasaporte.text);
        }
        //fecha entrada
        if (iden["fecha_entrada"]?.isNotEmpty ?? false) {
          setState(() => txtFechaEntrada.text = iden["fecha_entrada"]);
          form.updateValueIdentificacion("fecha_entrada", txtFechaEntrada.text);
        }
        //estado migratorio
        if (iden["estado_migratorio"]?.isNotEmpty ?? false) {
          var e = estadoM
              .where((e) => iden["estado_migratorio"] == e["nombre"])
              .first;

          setState(() => estadoMigratorio = e);
          form.updateValueIdentificacion("estado_migratorio", e["nombre"]);
        }
        validarColorIdentificacion();

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
            txtPaisRes.text = res["pais"];
            provinciasResVisible = true;
            txtProvinciaRes.text = res["provincia"];
            ciudadesResVisible = true;
            txtCiudadRes.text = res["ciudad"];
          }

          form.updateValueResidencia("pais", paisRes ?? txtPaisRes.text);
          txtProvinciaRes.text = res["provincia"];
          form.updateValueResidencia(
              "provincia", provinciaRes ?? txtProvinciaRes.text);
          txtCiudadRes.text = res["ciudad"];
          form.updateValueResidencia("ciudad", ciudadRes ?? txtCiudadRes.text);
        }

        //parroquia
        if (res["parroquia"]?.isNotEmpty ?? false) {
          setState(() => txtParroquiaRes.text = res["parroquia"]);
          form.updateValueResidencia("parroquia", txtParroquiaRes.text);
        }
        //barrio
        if (res["barrio"]?.isNotEmpty ?? false) {
          setState(() => txtBarrioRes.text = res["barrio"]);
          form.updateValueResidencia("barrio", txtBarrioRes.text);
        }
        //direccion
        if (res["direccion"]?.isNotEmpty ?? false) {
          setState(() => txtDireccion.text = res["direccion"]);
          form.updateValueResidencia("direccion", txtDireccion.text);
        }
        //latitud y longitud
        if (res["latitud"]?.isNotEmpty ?? false) {
          setState(() => latitudR = res["latitud"]);
          setState(() => longitudR = res["longitud"]);
          form.updateValueResidencia("latitud", latitudR);
          form.updateValueResidencia("longitud", longitudR);
        }
        //tipo_vivienda
        if (res["tipo_vivienda"]?.isNotEmpty ?? false) {
          var v = tiposVivienda
              .where((e) => res["tipo_vivienda"] == e["nombre"])
              .first;

          setState(() => tipoVivienda = v);
          form.updateValueResidencia("tipo_vivienda", v["nombre"]);
        }
        //valor
        if (res["valor"]?.isNotEmpty ?? false) {
          setState(() => txtValorV.text = res["valor"]);
          form.updateValueResidencia("valor", txtValorV.text);
        }
        //tiempo vivienda
        if (res["tiempo_vivienda"]?.isNotEmpty ?? false) {
          setState(() => txtTiempoVivienda.text = res["tiempo_vivienda"]);
          form.updateValueResidencia("tiempo_vivienda", txtTiempoVivienda.text);
        }
        //sector
        if (res["sector"]?.isNotEmpty ?? false) {
          var s = sectores.where((e) => res["sector"] == e["nombre"]).first;

          setState(() => sector = s);
          form.updateValueResidencia("sector", s["nombre"]);
        }
        validarColorResidencia();

        //todo EDUCACION
        //estudio
        if (educ["estudio"]?.isNotEmpty ?? false) {
          var e = estudios.where((e) => educ["estudio"] == e["nombre"]).first;
          setState(() => estudio = e);
          form.updateValueEducacion("estudio", e["nombre"]);
        }
        //profesion
        if (educ["profesion"]?.isNotEmpty ?? false) {
          var p =
              profesiones.where((e) => educ["profesion"] == e["nombre"]).first;

          setState(() => profesion = p);
          form.updateValueEducacion("profesion", p["nombre"]);

          if (p["nombre"] == "Otras") {
            if (educ["otra_profesion"] != null &&
                educ["otra_profesion"] != "") {
              setState(() => txtOtraProfesion.text = educ["otra_profesion"]);
              form.updateValueEducacion(
                  "otra_profesion", txtOtraProfesion.text);
            }
          }
        }
        validarColorEducacion();

        //todo ACTIVIDAD ECONOMICA PRINCIPAL
        //relacion laboral
        if (actP["relacion_laboral"]?.isNotEmpty ?? false) {
          var r = relaciones
              .where((e) => actP["relacion_laboral"] == e["nombre"])
              .first;

          setState(() => relacionLaboral = r);
          if (r["id"] == 1) {
            setState(() => independiente = true);
          } else if (r["id"] == 2) {
            setState(() => dependiente = true);
          } else if (r["id"] == 3) {
            setState(() => otraActiV = true);
          }
          form.updateValueActEconomica("relacion_laboral", r["nombre"]);
        }
        //tipo negocio
        if (actP["tipo_negocio"]?.isNotEmpty ?? false) {
          var t =
              negocios.where((e) => actP["tipo_negocio"] == e["nombre"]).first;

          setState(() => tipoNegocio = t);
          form.updateValueActEconomica("tipo_negocio", t["nombre"]);
        }
        //tiempo negocio
        if (actP["tiempo_negocio"]?.isNotEmpty ?? false) {
          setState(() => txtExpNegocio.text = actP["tiempo_negocio"]);
          form.updateValueActEconomica("tiempo_negocio", txtExpNegocio.text);
        }
        //sector
        if (actP["sector"]?.isNotEmpty ?? false) {
          var s = sectores.where((e) => actP["sector"] == e["nombre"]).first;
          setState(() => sectorNegocio = s);
          form.updateValueActEconomica("sector", s["nombre"]);
        }
        //actividad
        if (actP["actividad"]?.isNotEmpty ?? false) {
          setState(() => txtActividad.text = actP["actividad"]);
          form.updateValueActEconomica("actividad", txtActividad.text);
        }
        //codigo actividad
        if (actP["codigo_act"]?.isNotEmpty ?? false) {
          setState(() => txtCodigoActividad.text = actP["codigo_act"]);
          form.updateValueActEconomica("codigo_act", txtCodigoActividad.text);
        }
        //nombre
        if (actP["nombre"]?.isNotEmpty ?? false) {
          setState(() => txtNombreNegocio.text = actP["nombre"]);
          form.updateValueActEconomica("nombre", txtNombreNegocio.text);
        }
        //ruc
        if (actP["ruc"]?.isNotEmpty ?? false) {
          setState(() => txtRucNegocio.text = actP["ruc"]);
          form.updateValueActEconomica("ruc", txtRucNegocio.text);
        }
        //num_empleados
        if (actP["num_empleados"]?.isNotEmpty ?? false) {
          setState(() => txtNumEmpleados.text = actP["num_empleados"]);
          form.updateValueActEconomica("num_empleados", txtNumEmpleados.text);
        }
        //num empleados contratar
        if (actP["num_empleados_contratar"]?.isNotEmpty ?? false) {
          setState(() =>
              txtNumEmpleadosContratar.text = actP["num_empleados_contratar"]);
          form.updateValueActEconomica(
              "num_empleados_contratar", txtNumEmpleadosContratar.text);
        }
        //tipo local
        if (actP["tipo_local"]?.isNotEmpty ?? false) {
          var t =
              tipoLocales.where((e) => actP["tipo_local"] == e["nombre"]).first;

          setState(() => tipoLocal = t);
          form.updateValueActEconomica("tipo_local", t["nombre"]);
        }
        //provincia
        if (actP["provincia"]?.isNotEmpty ?? false) {
          setState(() => txtprovinciaNegocio.text = actP["provincia"]);
          form.updateValueActEconomica("provincia", txtprovinciaNegocio.text);
        }
        //ciudad
        if (actP["ciudad"]?.isNotEmpty ?? false) {
          setState(() => txtciudadNegocio.text = actP["ciudad"]);
          form.updateValueActEconomica("ciudad", txtciudadNegocio.text);
        }
        //parroquia
        if (actP["parroquia"]?.isNotEmpty ?? false) {
          setState(() => txtParroquiaNegocio.text = actP["parroquia"]);
          form.updateValueActEconomica("parroquia", txtParroquiaNegocio.text);
        }
        //barrio
        if (actP["barrio"]?.isNotEmpty ?? false) {
          setState(() => txtBarrioNegocio.text = actP["barrio"]);
          form.updateValueActEconomica("barrio", txtBarrioNegocio.text);
        }
        //direccion
        if (actP["direccion"]?.isNotEmpty ?? false) {
          setState(() => txtDireccionNegocio.text = actP["direccion"]);
          form.updateValueActEconomica("direccion", txtDireccionNegocio.text);
        }
        //latitud
        if (actP["latitud"]?.isNotEmpty ?? false) {
          setState(() => latitudT = actP["latitud"]);
          setState(() => longitudT = actP["longitud"]);
          form.updateValueActEconomica("latitud", latitudT);
          form.updateValueActEconomica("longitud", longitudT);
        }
        //referencia
        if (actP["referencia"]?.isNotEmpty ?? false) {
          setState(() => txtReferenciaNegocio.text = actP["referencia"]);
          form.updateValueActEconomica("referencia", txtReferenciaNegocio.text);
        }
        //origen_ingresos
        if (actP["origen_ingresos"]?.isNotEmpty ?? false) {
          var o = ingresos
              .where((e) => actP["origen_ingresos"] == e["nombre"])
              .first;
          setState(() => origenIngreso = o);
          form.updateValueActEconomica("origen_ingresos", o["nombre"]);
        }
        //inicio trabajo
        if (actP["inicio_trabajo"]?.isNotEmpty ?? false) {
          setState(() => txtInicioTrabajo.text = actP["inicio_trabajo"]);
          form.updateValueActEconomica("inicio_trabajo", txtInicioTrabajo.text);
        }
        //correo
        if (actP["correo"]?.isNotEmpty ?? false) {
          setState(() => txtCorreoTrabajo.text = actP["correo"]);
          form.updateValueActEconomica("correo", txtCorreoTrabajo.text);
        }
        //telefono
        if (actP["telefono"]?.isNotEmpty ?? false) {
          setState(() => txtTelefonoTrabajo.text = actP["telefono"]);
          form.updateValueActEconomica("telefono", txtTelefonoTrabajo.text);
        }
        //cargo
        if (actP["cargo"]?.isNotEmpty ?? false) {
          setState(() => txtCargo.text = actP["cargo"]);
          form.updateValueActEconomica("cargo", txtCargo.text);
        }
        //inicio_trabajo_ant
        if (actP["inicio_trabajo_ant"]?.isNotEmpty ?? false) {
          setState(() => txtInicioTrabajoAnt.text = actP["inicio_trabajo_ant"]);
          form.updateValueActEconomica(
              "inicio_trabajo_ant", txtInicioTrabajoAnt.text);
        }
        //salida_trabajo_ant
        if (actP["salida_trabajo_ant"]?.isNotEmpty ?? false) {
          setState(() => txtSalidaTrabajoAnt.text = actP["salida_trabajo_ant"]);
          form.updateValueActEconomica(
              "salida_trabajo_ant", txtSalidaTrabajoAnt.text);
        }
        //otra_actividad
        if (actP["otra_actividad"]?.isNotEmpty ?? false) {
          var o = otraActvEcon
              .where((e) => actP["otra_actividad"] == e["nombre"])
              .first;

          setState(() => otraActividadEc = o);
          form.updateValueActEconomica("otra_actividad", o["nombre"]);

          if (o["nombre"] == "Otros") {
            if (actP["info_actividad"]?.isNotEmpty ?? false) {
              setState(
                  () => txtInfoOtraActividadEcon.text = actP["info_actividad"]);

              form.updateValueActEconomica(
                  "info_actividad", txtInfoOtraActividadEcon.text);
            }
          }
        }

        validarColorActEconPrinc();
        //todo ACTIVIDAD ECONOMICA SECUNDARIA
        //relacion laboral
        if (actS["relacion_laboral"]?.isNotEmpty ?? false) {
          var r = relaciones
              .where((e) => actS["relacion_laboral"] == e["nombre"])
              .first;

          setState(() => relacionLaboral2 = r);
          if (r["id"] == 1) {
            setState(() => independiente2 = true);
          } else if (r["id"] == 2) {
            setState(() => dependiente2 = true);
          } else if (r["id"] == 3) {
            setState(() => otraActiV2 = true);
          }
          form.updateValueActEconomicaSec("relacion_laboral", r["nombre"]);
        }
        //tipo negocio
        if (actS["tipo_negocio"]?.isNotEmpty ?? false) {
          var t =
              negocios.where((e) => actS["tipo_negocio"] == e["nombre"]).first;

          setState(() => tipoNegocio2 = t);
          form.updateValueActEconomicaSec("tipo_negocio", t["nombre"]);
        }
        //tiempo negocio
        if (actS["tiempo_negocio"]?.isNotEmpty ?? false) {
          setState(() => txtExpNegocio2.text = actS["tiempo_negocio"]);
          form.updateValueActEconomicaSec(
              "tiempo_negocio", txtExpNegocio2.text);
        }
        //sector
        if (actS["sector"]?.isNotEmpty ?? false) {
          var s = sectores.where((e) => actS["sector"] == e["nombre"]).first;
          setState(() => sectorNegocio2 = s);
          form.updateValueActEconomicaSec("sector", s["nombre"]);
        }
        //actividad
        if (actS["actividad"]?.isNotEmpty ?? false) {
          setState(() => txtActividad2.text = actS["actividad"]);
          form.updateValueActEconomicaSec("actividad", txtActividad2.text);
        }
        //codigo actividad
        if (actS["codigo_act"]?.isNotEmpty ?? false) {
          setState(() => txtCodigoActividad2.text = actS["codigo_act"]);
          form.updateValueActEconomicaSec(
              "codigo_act", txtCodigoActividad2.text);
        }
        //nombre
        if (actS["nombre"]?.isNotEmpty ?? false) {
          setState(() => txtNombreNegocio2.text = actS["nombre"]);
          form.updateValueActEconomicaSec("nombre", txtNombreNegocio2.text);
        }
        //ruc
        if (actS["ruc"]?.isNotEmpty ?? false) {
          setState(() => txtRucNegocio2.text = actS["ruc"]);
          form.updateValueActEconomicaSec("ruc", txtRucNegocio2.text);
        }
        //num_empleados
        if (actS["num_empleados"]?.isNotEmpty ?? false) {
          setState(() => txtNumEmpleados2.text = actS["num_empleados"]);
          form.updateValueActEconomicaSec(
              "num_empleados", txtNumEmpleados2.text);
        }
        //num empleados contratar
        if (actS["num_empleados_contratar"]?.isNotEmpty ?? false) {
          setState(() =>
              txtNumEmpleadosContratar2.text = actS["num_empleados_contratar"]);
          form.updateValueActEconomicaSec(
              "num_empleados_contratar", txtNumEmpleadosContratar2.text);
        }
        //tipo local
        if (actS["tipo_local"]?.isNotEmpty ?? false) {
          var t =
              tipoLocales.where((e) => actS["tipo_local"] == e["nombre"]).first;

          setState(() => tipoLocal2 = t);
          form.updateValueActEconomicaSec("tipo_local", t["nombre"]);
        }
        //provincia
        if (actS["provincia"]?.isNotEmpty ?? false) {
          setState(() => txtprovinciaNegocio2.text = actS["provincia"]);
          form.updateValueActEconomicaSec(
              "provincia", txtprovinciaNegocio2.text);
        }
        //ciudad
        if (actS["ciudad"]?.isNotEmpty ?? false) {
          setState(() => txtciudadNegocio2.text = actS["ciudad"]);
          form.updateValueActEconomicaSec("ciudad", txtciudadNegocio2.text);
        }
        //parroquia
        if (actS["parroquia"]?.isNotEmpty ?? false) {
          setState(() => txtParroquiaNegocio2.text = actS["parroquia"]);
          form.updateValueActEconomicaSec(
              "parroquia", txtParroquiaNegocio2.text);
        }
        //barrio
        if (actS["barrio"]?.isNotEmpty ?? false) {
          setState(() => txtBarrioNegocio2.text = actS["barrio"]);
          form.updateValueActEconomicaSec("barrio", txtBarrioNegocio2.text);
        }
        //direccion
        if (actS["direccion"]?.isNotEmpty ?? false) {
          setState(() => txtDireccionNegocio2.text = actS["direccion"]);
          form.updateValueActEconomicaSec(
              "direccion", txtDireccionNegocio2.text);
        }
        //latitud
        if (actS["latitud"]?.isNotEmpty ?? false) {
          setState(() => latitudT2 = actS["latitud"]);
          setState(() => longitudT2 = actS["longitud"]);
          form.updateValueActEconomicaSec("latitud", latitudT2);
          form.updateValueActEconomicaSec("longitud", longitudT2);
        }
        //referencia
        if (actS["referencia"]?.isNotEmpty ?? false) {
          setState(() => txtReferenciaNegocio2.text = actS["referencia"]);
          form.updateValueActEconomicaSec(
              "referencia", txtReferenciaNegocio2.text);
        }
        //origen_ingresos
        if (actS["origen_ingresos"]?.isNotEmpty ?? false) {
          var o = ingresos
              .where((e) => actS["origen_ingresos"] == e["nombre"])
              .first;
          setState(() => origenIngreso2 = o);
          form.updateValueActEconomicaSec("origen_ingresos", o["nombre"]);
        }
        //inicio trabajo
        if (actS["inicio_trabajo"]?.isNotEmpty ?? false) {
          setState(() => txtInicioTrabajo2.text = actS["inicio_trabajo"]);
          form.updateValueActEconomicaSec(
              "inicio_trabajo", txtInicioTrabajo2.text);
        }
        //correo
        if (actS["correo"]?.isNotEmpty ?? false) {
          setState(() => txtCorreoTrabajo2.text = actS["correo"]);
          form.updateValueActEconomicaSec("correo", txtCorreoTrabajo2.text);
        }
        //telefono
        if (actS["telefono"]?.isNotEmpty ?? false) {
          setState(() => txtTelefonoTrabajo2.text = actS["telefono"]);
          form.updateValueActEconomicaSec("telefono", txtTelefonoTrabajo2.text);
        }
        //cargo
        if (actS["cargo"]?.isNotEmpty ?? false) {
          setState(() => txtCargo2.text = actS["cargo"]);
          form.updateValueActEconomicaSec("cargo", txtCargo2.text);
        }
        //inicio_trabajo_ant
        if (actS["inicio_trabajo_ant"]?.isNotEmpty ?? false) {
          setState(
              () => txtInicioTrabajoAnt2.text = actS["inicio_trabajo_ant"]);
          form.updateValueActEconomicaSec(
              "inicio_trabajo_ant", txtInicioTrabajoAnt2.text);
        }
        //salida_trabajo_ant
        if (actS["salida_trabajo_ant"]?.isNotEmpty ?? false) {
          setState(
              () => txtSalidaTrabajoAnt2.text = actS["salida_trabajo_ant"]);
          form.updateValueActEconomicaSec(
              "salida_trabajo_ant", txtSalidaTrabajoAnt2.text);
        }
        //otra_actividad
        if (actS["otra_actividad"]?.isNotEmpty ?? false) {
          var o = otraActvEcon
              .where((e) => actS["otra_actividad"] == e["nombre"])
              .first;

          setState(() => otraActividadEc2 = o);
          form.updateValueActEconomicaSec("otra_actividad", o["nombre"]);

          if (o["nombre"] == "Otros") {
            if (actS["info_actividad"]?.isNotEmpty ?? false) {
              setState(() =>
                  txtInfoOtraActividadEcon2.text = actS["info_actividad"]);

              form.updateValueActEconomicaSec(
                  "info_actividad", txtInfoOtraActividadEcon2.text);
            }
          }
        }

        validarColorActEconSec();

        //todo Situación Económica
        //sueldo
        if (eco["sueldo"]?.isNotEmpty ?? false) {
          setState(() => txtSueldo.text = eco["sueldo"]);
        }
        //ventas
        if (eco["ventas"]?.isNotEmpty ?? false) {
          setState(() => txtVentas.text = eco["ventas"]);
        }
        //otro ingreso
        if (eco["otro_ingreso"]?.isNotEmpty ?? false) {
          setState(() => txtOtrosIngresos.text = eco["otro_ingreso"]);
        }
        //info otro ingreso
        if (eco["info_otro_ingreso"]?.isNotEmpty ?? false) {
          setState(() => txtInfoOtrosIngresos.text = eco["info_otro_ingreso"]);
        }

        //gastos personales
        if (eco["gastos_personales"]?.isNotEmpty ?? false) {
          setState(() => txtGastosPersonales.text = eco["gastos_personales"]);
        }
        //gastos operacionales
        if (eco["gastos_operacionales"]?.isNotEmpty ?? false) {
          setState(
              () => txtGastosOperacionales.text = eco["gastos_operacionales"]);
        }
        //otro egreso
        if (eco["otro_egreso"]?.isNotEmpty ?? false) {
          setState(() => txtOtrosGastos.text = eco["otro_egreso"]);
        }
        //info otro egreso
        if (eco["info_otro_egreso"]?.isNotEmpty ?? false) {
          setState(() => txtInfoOtrosGastos.text = eco["otro_egreso"]);
        }

        //calcular saldo disponible
        /*if ((eco["sueldo"]?.isNotEmpty ?? false) &&
            (eco["gastos_personales"]?.isNotEmpty ?? false)) {*/
        calcularSaldoDisponible();
        //}

        //efecotivo
        if (eco["efectivo"]?.isNotEmpty ?? false) {
          setState(() => txtEfectivoCaja.text = eco["efectivo"]);
        }
        //banco
        if (eco["banco"]?.isNotEmpty ?? false) {
          setState(() => txtDineroBancos.text = eco["banco"]);
        }
        //cuentas
        if (eco["cuentas"]?.isNotEmpty ?? false) {
          setState(() => txtCuentasxCobrar.text = eco["cuentas"]);
        }
        //inventarios
        if (eco["inventarios"]?.isNotEmpty ?? false) {
          setState(() => txtInventarios.text = eco["inventarios"]);
        }
        //propiedades
        if (eco["propiedades"]?.isNotEmpty ?? false) {
          setState(() => txtPropiedades.text = eco["propiedades"]);
        }
        //vehiculos
        if (eco["vehiculos"]?.isNotEmpty ?? false) {
          setState(() => txtVehiculos.text = eco["vehiculos"]);
        }
        //otros activos
        if (eco["otro_activo"]?.isNotEmpty ?? false) {
          setState(() => txtOtrosPatri.text = eco["otro_activo"]);
        }
        //info otro activo
        if (eco["info_otro_activo"]?.isNotEmpty ?? false) {
          setState(() => txtInfoOtrosPatri.text = eco["info_otro_activo"]);
        }
        //calcular activos
        calcularActivos();
        //pasivo corto
        if (eco["pasivo_corto"]?.isNotEmpty ?? false) {
          setState(() => txtPasivoCorto.text = eco["pasivo_corto"]);
        }
        //pasivo largo
        if (eco["pasivo_largo"]?.isNotEmpty ?? false) {
          setState(() => txtPasivoLargo.text = eco["pasivo_largo"]);
        }
        //calcular pasivos
        calcularPasivos();
        //calcular patrimonio
        calcularPatrimonio();
        validarColorSitEconom();

        //todo ESTADO CIVIL
        if (ec["estado_civil"]?.isNotEmpty ?? false) {
          var e = estadosCiviles
              .where((e) => ec["estado_civil"] == e["nombre"])
              .first;

          setState(() => estadoCivil = e);
          form.updateValueEstadoCivil("estado_civil", e["nombre"]);
        }
        //dependientes
        if (ec["dependientes"].isNotEmpty) {
          var personas = ec["dependientes"] as List<PersonaModel>;

          for (var persona in personas) {
            form.addDependiente(persona);
          }
        }
        validarColorEstCivil();
      } else {
        debugPrint("No se encontraron solicitudes...");
      }
    }
  }
}
