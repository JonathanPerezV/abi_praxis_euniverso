// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../utils/deviders/divider.dart';
import '../../../../../../../../utils/expansiontile.dart';
import '../../../../../../../../utils/function_callback.dart';
import '../../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../../../../../../../utils/list/lista_solicitud.dart';
import '../../../../../../../../utils/paisesHabiles/paises.dart';
import '../../../../../../../../utils/paisesHabiles/retornar_resultados.dart';
import '../../../../../../../../utils/textFields/field_formater.dart';
import '../../../../../../../../utils/textFields/input_text_form_fields.dart';
import '../../../../../../../controller/dataBase/operations.dart';

class DatosConyugeCredito extends StatefulWidget {
  bool? edit;
  int? idConyuge;
  int? idSolicitud;
  Color? datosConyugeC;
  Color? datosNacimientoConyuge;
  Color? datosIdentificacionConyuge;
  Color? datosEducacionConyuge;
  Color? datosCivilConyuge;
  Color? actEconoPrinConyuge;
  final GlobalKey gk;
  final GlobalKey<FormState> formKey;
  final GlobalKey<FormState> fNCkey;
  final GlobalKey<FormState> fICkey;
  final GlobalKey<FormState> fECkey;
  final GlobalKey<FormState> fAECkey;
  final GlobalKey<FormState> fECCkey;
  final ExpansionTileController expController;
  bool enableExpansion;
  VoidCallback startLoading;
  VoidCallback stopLoading;
  MoveToTopCallback updatePixelPosition;
  ChangeColorCallback changeColorDatosPersonales;
  ChangeColorCallback changeColorNac;
  ChangeColorCallback changeColorIden;
  ChangeColorCallback changeColorEstCivil;
  ChangeColorCallback changeColorEduc;
  ChangeColorCallback changeColorActPrin;
  DatosConyugeCredito({
    super.key,
    required this.gk,
    this.edit,
    required this.actEconoPrinConyuge,
    required this.changeColorActPrin,
    required this.changeColorDatosPersonales,
    required this.changeColorEduc,
    required this.changeColorEstCivil,
    required this.changeColorIden,
    required this.changeColorNac,
    required this.datosEducacionConyuge,
    required this.datosIdentificacionConyuge,
    required this.datosNacimientoConyuge,
    required this.datosCivilConyuge,
    required this.datosConyugeC,
    required this.enableExpansion,
    required this.expController,
    required this.fAECkey,
    required this.fECkey,
    required this.fICkey,
    required this.fNCkey,
    required this.fECCkey,
    required this.formKey,
    required this.idConyuge,
    required this.startLoading,
    required this.stopLoading,
    required this.updatePixelPosition,
    this.idSolicitud,
  });

  @override
  State<DatosConyugeCredito> createState() => _DatosConyugeCreditoState();
}

class _DatosConyugeCreditoState extends State<DatosConyugeCredito> {
  final op = Operations();
  //todo expansion tile datos personales
  final expdpNacimientoCony = ExpansionTileController();
  bool expanNacCony = false;
  final expdpIdentificacionCony = ExpansionTileController();
  bool expanIdentCony = false;
  final expdpEducacionCony = ExpansionTileController();
  bool expanEducCony = false;
  final expdpActiEconCony = ExpansionTileController();
  bool expanActiECony = false;
  final expdpEstCivilCony = ExpansionTileController();
  bool expanEstCivilCony = false;

  //todo DATOS DEL CÓNYUGE / CONVIVIENTE
  final txtConyNombre = TextEditingController();
  final txtConyApellidos = TextEditingController();
  final txtConyCelular = TextEditingController();
  final txtConyCelular2 = TextEditingController();
  //todo Datos nacimiento
  List<String> listPaises = ['ECUADOR', 'OTRO'];
  String? pais;
  final txtConyPais = TextEditingController();

  List<Map<String, dynamic>> listaProvincias = [];
  String? provincia;
  bool provinciasVisible = false;
  final txtConyProvincia = TextEditingController();
  String? hintTextProvincia;

  List<String> listaCiudades = [];
  String? ciudad;
  bool ciudadesVisible = false;
  final txtConyCiudad = TextEditingController();
  String? hintTextCiudad;

  bool otroPais = false;
  final txtConyFechaNac = TextEditingController();
  final txtConyEdad = TextEditingController();
  Map<String, dynamic>? conyGenero;
  String? textConyGenero;
  //todo Datos Identificación
  final txtConyCedula = TextEditingController();
  final txtConyRuc = TextEditingController();
  final txtConyPasaporte = TextEditingController();
  final txtConyFechaExpPasaporte = TextEditingController();
  final txtConyFechaCadPasaporte = TextEditingController();
  final txtConyFechaEntrada = TextEditingController();
  Map<String, dynamic>? conyEstadoMigra;
  String? textConyEstadoMigra;
  //todo educación
  Map<String, dynamic>? conyEstudio;
  String? textConyEstudio;
  Map<String, dynamic>? conyProfesion;
  String? textConyProfesion;
  bool enableConyOtraProfesion = false;
  final txtConyOtraProfesion = TextEditingController();
  //todo actividad económica principal
  bool independienteCony = false;
  bool dependienteCony = false;
  bool otraActiVCony = false;
  Map<String, dynamic>? conyRelacionLab;
  String? textConyRelacionLab;
  Map<String, dynamic>? conyOrigenIngreso;
  String? textConyOrigenIngre;
  final txtConyTiempoTrabajo = TextEditingController();
  final txtConySueldoIngresoBruto = TextEditingController();
  final txtConyNombreEmpresa = TextEditingController();
  final txtConyRucEmpresa = TextEditingController();
  final txtConyTelEmpresa = TextEditingController();
  final txtConyProvinciaEmpr = TextEditingController();
  final txtConyCantonEmpr = TextEditingController();
  final txtConyParroquiaEmpr = TextEditingController();
  final txtConyBarrioEmpre = TextEditingController();
  final txtConyDireccionEmpr = TextEditingController();
  final txtConyReferenciaEmpr = TextEditingController();
  Map<String, dynamic>? conyOtraActv;
  String? textConyOtraActividad;
  final txtConyInfOtraActv = TextEditingController();
  //todo estado civil
  Map<String, dynamic>? estadoCivil;
  String? textEstadoCivil;
  int? idConyuge;

  void obtenerDatosPersona() async {
    final op = Operations();

    if (widget.idConyuge != null) {
      final data = await op.obtenerPersona(widget.idConyuge ?? idConyuge!);
      final form = Provider.of<FormProvider>(context, listen: false).conyuge;

      if (data != null) {
        setState(() {
          //todo datos personales
          txtConyCedula.text = data.numeroIdentificacion!;
          form.updateValueIdentificacion("cedula", txtConyCedula.text);

          txtConyRuc.text = "${txtConyCedula.text}001";
          form.updateValueIdentificacion("ruc_id", txtConyRuc.text);

          txtConyNombre.text = data.nombres;
          form.updateValueDatos("nombres", txtConyNombre.text);

          txtConyApellidos.text = data.apellidos;
          form.updateValueDatos("apellidos", txtConyApellidos.text);

          txtConyCelular.text = data.celular1 ?? "";
          form.updateValueDatos("celular1", txtConyCelular.text);

          txtConyCelular2.text = data.celular2 ?? "";
          form.updateValueDatos("celular2", txtConyCelular2.text);

          //todo datos nacimiento
          txtConyPais.text = data.pais ?? "";
          form.updateValueNacimiento("pais", txtConyPais.text);

          txtConyProvincia.text = data.provincia ?? "";
          form.updateValueNacimiento("provincia", txtConyProvincia.text);

          txtConyCiudad.text = data.ciudad ?? "";
          form.updateValueNacimiento("ciudad", txtConyCiudad.text);

          txtConyFechaNac.text = data.fechaNacimiento ?? "";
          form.updateValueNacimiento("fecha", txtConyFechaNac.text);

          //todo datos identificacion
          txtConyCedula.text = data.numeroIdentificacion ?? "";
          form.updateValueIdentificacion("cedula", txtConyCedula.text);

          txtConyRuc.text =
              txtConyCedula.text.isNotEmpty ? "${txtConyCedula.text}001" : "";
          form.updateValueIdentificacion("ruc_id", txtConyRuc.text);
        });

        validarColorDatosConyuge();
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
        children: formularioDatosConyuge(),
        title: "Datos del cónyuge / conviviente", func: (val) {
      if (val) {
        widget.updatePixelPosition(widget.gk);
      }
    },
        expController: widget.expController,
        enabled: widget.enableExpansion,
        color: widget.datosConyugeC);
  }

  Widget formularioDatosConyuge() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Form(
            key: widget.formKey,
            child: Column(children: [
              //todo NOMBRES
              InputTextFormFields(
                  habilitado: (widget.edit != null && !widget.edit!)
                      ? false
                      : widget.idConyuge != null
                          ? false
                          : true,
                  onChanged: (val) {
                    validarColorDatosConyuge();
                    form.conyuge.updateValueDatos("nombres", val);
                  },
                  prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                  validacion: (value) => functionValidateDataConyuge(value!),
                  controlador: txtConyNombre,
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Nombres",
                  placeHolder: ""),
              //todo APELLIDOS
              InputTextFormFields(
                  habilitado: (widget.edit != null && !widget.edit!)
                      ? false
                      : widget.idConyuge != null
                          ? false
                          : true,
                  onChanged: (val) {
                    validarColorDatosConyuge();
                    form.conyuge.updateValueDatos("apellidos", val);
                  },
                  prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                  validacion: (value) => functionValidateDataConyuge(value!),
                  controlador: txtConyApellidos,
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Apellidos",
                  placeHolder: ""),
              //todo CELULAR 1
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  onChanged: (val) {
                    validarColorDatosConyuge();
                    form.conyuge.updateValueDatos("celular1", val);
                  },
                  tipoTeclado: TextInputType.phone,
                  prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                  validacion: (value) => functionValidateDataConyuge(value!),
                  controlador: txtConyCelular,
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Celular 1",
                  placeHolder: ""),
              //todo CELULAR 2
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  onChanged: (val) {
                    form.conyuge.updateValueDatos("celular2", val);
                  },
                  tipoTeclado: TextInputType.phone,
                  prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                  controlador: txtConyCelular2,
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Celular 2",
                  placeHolder: ""),
              //todo EXPANSIONTILE NACIMIENTO
              Form(key: widget.fNCkey, child: expansionNacimientoConyuge()),
              divider(true, color: Colors.grey),
              //todo EXPANSIONTILE IDENTIFICACIÓN
              Form(key: widget.fICkey, child: expansionIdentificacionConyuge()),
              divider(true, color: Colors.grey),
              //todo EXPANSIONTILE EDUCACIÓN
              Form(key: widget.fECkey, child: expansionEducacionConyuge()),
              divider(true, color: Colors.grey),
              //todo EXPANSIONTILE ACTIVIDAD ECONOMICA
              Form(key: widget.fAECkey, child: expansionActEconomicaConyuge()),
              divider(true, color: Colors.grey),
              //todo ESTADO CIVIL
              Form(key: widget.fECCkey, child: expansionEstadoCivil()),
            ]));
      });

  Widget expansionNacimientoConyuge() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.nacimiento, size: 18),
          color: widget.datosNacimientoConyuge,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanNacCony
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Nacimiento",
          func: (_) {
            setState(() => expanNacCony = !expanNacCony);
          },
          expController: expdpNacimientoCony,
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
                                  txtConyPais.clear();
                                  txtConyProvincia.clear();
                                  txtConyCiudad.clear();
                                });
                                setState(() => otroPais = true);
                              } else {
                                setState(() => otroPais = false);
                              }
                              form.conyuge.updateValueNacimiento("pais", pais!);
                              provinciasVisible = true;
                              ciudadesVisible = true;
                            });
                            funcionPais(pais);
                          }),

                if (otroPais) ...[
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      controlador: txtConyPais,
                      capitalization: TextCapitalization.characters,
                      tipoTeclado: TextInputType.text,
                      prefixIcon: const Icon(Icons.location_city),
                      onChanged: (val) =>
                          form.conyuge.updateValueNacimiento("pais", val),
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

                                    form.conyuge.updateValueNacimiento(
                                        "provincia", provincia);
                                    ciudadesVisible = true;

                                    funcionProvincia(provincia!);
                                  })
                        : InputTextFormFields(
                            habilitado: (widget.edit != null && !widget.edit!)
                                ? false
                                : true,
                            capitalization: TextCapitalization.characters,
                            controlador: txtConyProvincia,
                            tipoTeclado: TextInputType.text,
                            prefixIcon: const Icon(Icons.location_city),
                            accionCampo: TextInputAction.next,
                            onChanged: (widget.edit != null && !widget.edit!)
                                ? null
                                : (val) => form.conyuge
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

                                    form.conyuge.updateValueNacimiento(
                                        "ciudad", ciudad);
                                  })
                        : InputTextFormFields(
                            habilitado: (widget.edit != null && !widget.edit!)
                                ? false
                                : true,
                            capitalization: TextCapitalization.characters,
                            controlador: txtConyCiudad,
                            onChanged: (val) => form.conyuge
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
                            onChanged: (_) => validarColorNacimientoConyuge(),
                            controlador: txtConyFechaNac,
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
                                      txtConyFechaNac.text =
                                          DateFormat("yyyy-MM-dd").format(val);
                                    });
                                    txtConyEdad.text =
                                        AgeCalculator.age(val).years.toString();

                                    validarColorNacimientoConyuge();
                                    form.conyuge.updateValueNacimiento(
                                        "fecha", txtConyFechaNac.text);
                                    form.conyuge.updateValueNacimiento(
                                        "edad", txtConyEdad.text);
                                  }
                                });
                              },
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
                //todo EDAD
                InputTextFormFields(
                    tipoTeclado: TextInputType.number,
                    controlador: txtConyEdad,
                    validacion: (value) => functionValidateDataConyuge(value!),
                    accionCampo: TextInputAction.next,
                    habilitado: false,
                    nombreCampo: "Edad",
                    placeHolder: ""),
                //todo Género
                DropdownButtonFormField(
                    validator: (value) => functionValidateDataConyuge(value),
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const InputDecoration(label: Text("Género")),
                    value: conyGenero,
                    items: generos
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? value) {
                            if (value != null) {
                              setState(() => conyGenero = value);
                              setState(() => textConyGenero = value["nombre"]);
                            }
                            validarColorNacimientoConyuge();
                            form.conyuge.updateValueNacimiento(
                                "genero", value!["nombre"]);
                          }),
              ],
            ),
          ),
        );
      });

  Widget expansionIdentificacionConyuge() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
            leading: const Icon(AbiPraxis.identificacion, size: 18),
            color: widget.datosIdentificacionConyuge,
            containerColor: Colors.white,
            expandColorContainer: Colors.white,
            icon: expanIdentCony
                ? const Icon(Icons.remove_circle_outline_sharp)
                : const Icon(Icons.add_circle_outline_outlined),
            context,
            title: "Identificación", func: (_) {
          setState(() => expanIdentCony = !expanIdentCony);
        },
            expController: expdpIdentificacionCony,
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
                        controlador: txtConyCedula,
                        onChanged: (val) {
                          validarColorIdentificacionConyuge();
                          form.conyuge.updateValueIdentificacion("cedula", val);
                          setState(() {
                            txtConyRuc.text = "${val}001";
                          });
                          form.conyuge.updateValueIdentificacion(
                              "ruc_id", txtConyRuc.text);
                        },
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Número de cédula",
                        placeHolder: ""),
                    //todo NÚMERO DE RUC
                    InputTextFormFields(
                        habilitado: (widget.edit != null && !widget.edit!)
                            ? false
                            : true,
                        tipoTeclado: TextInputType.number,
                        controlador: txtConyRuc,
                        onChanged: (val) {
                          validarColorIdentificacionConyuge();
                          form.conyuge.updateValueIdentificacion("ruc_id", val);
                        },
                        validacion: (value) =>
                            functionValidateDataConyuge(value!),
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Número de RUC",
                        placeHolder: ""),
                    //todo NÚMERO DE PASAPORTE
                    InputTextFormFields(
                        habilitado: (widget.edit != null && !widget.edit!)
                            ? false
                            : true,
                        onChanged: (vl) {
                          validarColorIdentificacionConyuge();
                          setState(() {});
                          if (vl!.isEmpty) {
                            setState(() {
                              txtConyFechaEntrada.clear();
                              form.conyuge.updateValueIdentificacion(
                                  "fecha_entrada", null);
                              txtConyFechaCadPasaporte.clear();
                              form.conyuge.updateValueIdentificacion(
                                  "fecha_cad_p", null);
                              txtConyFechaExpPasaporte.clear();
                              form.conyuge.updateValueIdentificacion(
                                  "fecha_exp_p", null);
                              conyEstadoMigra = null;
                              form.conyuge.updateValueIdentificacion(
                                  "estado_migratorio", null);
                            });
                          }
                        },
                        controlador: txtConyPasaporte,
                        validacion: (val) {
                          if (pais != null && pais == "ECUADOR") {
                            return null;
                          } else if (txtConyPais.text.isNotEmpty &&
                              txtConyPais.text.toLowerCase() == "ecuador") {
                            return null;
                          } else {
                            return "Campo obligatorio";
                          }
                        },
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Número de pasaporte",
                        placeHolder: ""),
                    //todo CAMPOS DE PASAPORTE
                    if (txtConyPasaporte.text.isNotEmpty) ...[
                      //todo FECHA EXPEDICIÓN
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: true,
                              child: InputTextFormFields(
                                  validacion: (val) =>
                                      txtConyCedula.text.isNotEmpty
                                          ? txtConyPasaporte.text.isNotEmpty &&
                                                  val!.isEmpty
                                              ? "Campo obligatorio"
                                              : null
                                          : null,
                                  controlador: txtConyFechaExpPasaporte,
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
                                            txtConyFechaExpPasaporte.text =
                                                DateFormat("yyyy-MM-dd")
                                                    .format(val);
                                          });

                                          validarColorIdentificacionConyuge();
                                          form.conyuge
                                              .updateValueIdentificacion(
                                                  "fecha_exp_p",
                                                  txtConyFechaExpPasaporte
                                                      .text);
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
                                      txtConyCedula.text.isNotEmpty
                                          ? txtConyPasaporte.text.isNotEmpty &&
                                                  val!.isEmpty
                                              ? "Campo obligatorio"
                                              : null
                                          : null,
                                  controlador: txtConyFechaCadPasaporte,
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
                                            txtConyFechaCadPasaporte.text =
                                                DateFormat("yyyy-MM-dd")
                                                    .format(val);
                                          });

                                          validarColorIdentificacionConyuge();
                                          form.conyuge
                                              .updateValueIdentificacion(
                                                  "fecha_cad_p",
                                                  txtConyFechaCadPasaporte
                                                      .text);
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
                                      txtConyCedula.text.isNotEmpty
                                          ? txtConyPasaporte.text.isNotEmpty &&
                                                  val!.isEmpty
                                              ? "Campo obligatorio"
                                              : null
                                          : null,
                                  controlador: txtConyFechaEntrada,
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
                                            txtConyFechaEntrada.text =
                                                DateFormat("yyyy-MM-dd")
                                                    .format(val);
                                          });

                                          validarColorIdentificacionConyuge();
                                          form.conyuge
                                              .updateValueIdentificacion(
                                                  "fecha_entrada",
                                                  txtConyFechaEntrada.text);
                                        }
                                      });
                                    },
                              icon: const Icon(Icons.calendar_month))
                        ],
                      ),
                      //todo ESTADO MIGRATORIO
                      DropdownButtonFormField(
                          padding: const EdgeInsets.only(left: 10),
                          validator: (val) => txtConyCedula.text.isNotEmpty
                              ? txtConyPasaporte.text.isNotEmpty &&
                                      (val == null || val.isEmpty)
                                  ? "Campo obligatorio"
                                  : null
                              : null,
                          decoration: const InputDecoration(
                              label: Text("Estado migratorio")),
                          value: conyEstadoMigra,
                          items: estadoM
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e["nombre"])))
                              .toList(),
                          onChanged: (widget.edit != null && !widget.edit!)
                              ? null
                              : (Map<String, dynamic>? val) {
                                  setState(() =>
                                      textConyEstadoMigra = val!["nombre"]);
                                  setState(() => conyEstadoMigra = val);
                                  validarColorIdentificacionConyuge();
                                  form.conyuge.updateValueIdentificacion(
                                      "estado_migratorio", val!["nombre"]);
                                })
                    ]
                  ],
                )));
      });

  Widget expansionEducacionConyuge() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.educacion, size: 18),
          color: widget.datosEducacionConyuge,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanEducCony
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Educación",
          func: (_) {
            setState(() => expanEducCony = !expanEducCony);
          },
          expController: expdpEducacionCony,
          enabled: widget.enableExpansion,
          children: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                divider(false),
                //todo NIVEL DE ESTUDIO
                DropdownButtonFormField(
                    validator: (value) => txtConyCedula.text.isNotEmpty
                        ? value == null || value.isEmpty
                            ? "Campo obligatorio"
                            : null
                        : null,
                    padding: const EdgeInsets.only(left: 10),
                    decoration:
                        const InputDecoration(label: Text("Nivel de estudios")),
                    value: conyEstudio,
                    items: estudios
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() {
                              conyEstudio = val;
                              textConyEstudio = val!["nombre"];
                            });
                            validarColorEducacionConyuge();
                            form.conyuge.updateValueEducacion(
                                "estudio", val!["nombre"]);
                          }),
                //todo PROFESIÓN
                DropdownButtonFormField(
                    validator: (value) => txtConyCedula.text.isNotEmpty
                        ? value == null || value.isEmpty
                            ? "Campo obligatorio"
                            : null
                        : null,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const InputDecoration(label: Text("Profesión")),
                    value: conyProfesion,
                    items: profesiones
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (Map<String, dynamic>? val) {
                            setState(() {
                              conyProfesion = val;
                              textConyProfesion = val!["nombre"];
                              if (val["id"] == 11) {
                                enableConyOtraProfesion = true;
                              } else {
                                enableConyOtraProfesion = false;
                                txtConyOtraProfesion.clear();
                              }
                            });
                            validarColorEducacionConyuge();
                            form.conyuge.updateValueEducacion(
                                "profesion", val!["nombre"]);
                          }),
                //todo OTRA PROFESIÓN
                if (enableConyOtraProfesion)
                  InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      onChanged: (val) {
                        validarColorEducacionConyuge();
                        form.conyuge
                            .updateValueEducacion("otra_profesion", val);
                      },
                      controlador: txtConyOtraProfesion,
                      validacion: (value) {
                        if (txtConyCedula.text.isNotEmpty) {
                          if (enableConyOtraProfesion &&
                              txtConyOtraProfesion.text.isEmpty) {
                            return "Campo obligatorio";
                          } else {
                            return null;
                          }
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

  Widget expansionActEconomicaConyuge() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
            leading: const Icon(AbiPraxis.actividad_economica, size: 18),
            color: widget.actEconoPrinConyuge,
            containerColor: Colors.white,
            expandColorContainer: Colors.white,
            icon: expanActiECony
                ? const Icon(Icons.remove_circle_outline_sharp)
                : const Icon(Icons.add_circle_outline_outlined),
            context,
            title: "Act. Económica principal", func: (_) {
          setState(() => expanActiECony = !expanActiECony);
        },
            expController: expdpActiEconCony,
            enabled: widget.enableExpansion,
            children: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
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
                      value: conyRelacionLab,
                      items: relaciones
                          .map((e) => DropdownMenuItem(
                              value: e, child: Text(e["nombre"])))
                          .toList(),
                      onChanged: (widget.edit != null && !widget.edit!)
                          ? null
                          : (Map<String, dynamic>? val) {
                              setState(() {
                                conyRelacionLab = val;
                                textConyRelacionLab = val!["nombre"];
                              });
                              if (val!["id"] == 1) {
                                setState(() {
                                  independienteCony = true;
                                  dependienteCony = false;
                                  otraActiVCony = false;
                                });
                              } else if (val["id"] == 2) {
                                setState(() {
                                  independienteCony = false;
                                  dependienteCony = true;
                                  otraActiVCony = false;
                                });
                              } else if (val["id"] == 3) {
                                setState(() {
                                  independienteCony = false;
                                  dependienteCony = false;
                                  otraActiVCony = true;
                                });
                              }

                              form.conyuge.updateValueActividadEcon(
                                  "relacion_laboral", val["nombre"]);
                            }),
                  if (independienteCony) opcionesActEconomicaConyuge(false),
                  if (dependienteCony) opcionesActEconomicaConyuge(true),
                  if (otraActiVCony) opcionesOtraActividadConyuge(),
                ],
              ),
            ));
      });

  //todo ACTIVIDAD ECONOMICA PRINCIPAL - INDEPENDIENTE CONYUGE
  Widget opcionesActEconomicaConyuge(bool dependiente) =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            if (dependiente) ...[
              //todo ORIGEN DE INGRESOS
              DropdownButtonFormField(
                  padding: const EdgeInsets.only(left: 10),
                  decoration:
                      const InputDecoration(label: Text("Origen de ingresos")),
                  value: conyOrigenIngreso,
                  items: ingresos
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e["nombre"])))
                      .toList(),
                  onChanged: (widget.edit != null && !widget.edit!)
                      ? null
                      : (Map<String, dynamic>? val) {
                          setState(() {
                            conyOrigenIngreso = val;
                            textConyOrigenIngre = val!["nombre"];
                          });
                          form.conyuge.updateValueActividadEcon(
                              "origen_ingresos", val!["nombre"]);
                        }),
            ],
            //todo EXPERIENCIA DE NEGOCIO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) => form.conyuge
                    .updateValueActividadEcon("tiempo_negocio", val),
                controlador: txtConyTiempoTrabajo,
                tipoTeclado: TextInputType.number,
                accionCampo: TextInputAction.next,
                nombreCampo: "Tiempo de trabajo (meses)",
                placeHolder: ""),
            divider(true, color: Colors.grey),
            //todo SUELDO BRUTO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) =>
                    form.conyuge.updateValueActividadEcon("sueldo", val),
                controlador: txtConySueldoIngresoBruto,
                tipoTeclado: TextInputType.number,
                listaFormato: [
                  ThousandsSeparatorInputFormatter(),
                  FilteringTextInputFormatter.deny(",", replacementString: "."),
                ],
                accionCampo: TextInputAction.next,
                nombreCampo: "Sueldo / ingreso bruto (\$)",
                placeHolder: ""),
            divider(true, color: Colors.grey),
            //todo NOMBRE / RAZÓN SOCIAL
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) =>
                    form.conyuge.updateValueActividadEcon("nombre", val),
                controlador: txtConyNombreEmpresa,
                accionCampo: TextInputAction.next,
                nombreCampo: "Nombre o Razón Social",
                placeHolder: ""),
            //todo RUC / RISE
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) =>
                    form.conyuge.updateValueActividadEcon("ruc", val),
                tipoTeclado: TextInputType.number,
                controlador: txtConyRucEmpresa,
                accionCampo: TextInputAction.next,
                nombreCampo: "RUC / RISE",
                placeHolder: ""),

            datosUbicacionNegocioConyuge(),
          ],
        );
      });

  Widget opcionesOtraActividadConyuge() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo OTRA ACTIVIDAD ECONÓMICA
            DropdownButtonFormField(
                padding: const EdgeInsets.only(left: 10),
                decoration:
                    const InputDecoration(label: Text("Otra actividad")),
                value: conyOtraActv,
                items: otraActvEcon
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e["nombre"])))
                    .toList(),
                onChanged: (widget.edit != null && !widget.edit!)
                    ? null
                    : (Map<String, dynamic>? val) {
                        setState(() {
                          conyOtraActv = val;
                          textConyOtraActividad = val!["nombre"];
                        });
                        form.conyuge.updateValueActividadEcon(
                            "otra_actividad", val!["nombre"]);
                      }),
            //todo ESPECIFIQUE OTRA ACTIVIDAD
            if (conyOtraActv != null && conyOtraActv!["id"] == 6)
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  onChanged: (val) => form.conyuge
                      .updateValueActividadEcon("info_actividad", val),
                  controlador: txtConyInfOtraActv,
                  validacion: (val) => otraActiVCony && val!.isEmpty
                      ? "Campo obligatorio"
                      : null,
                  accionCampo: TextInputAction.done,
                  nombreCampo: "Especifique actividad",
                  placeHolder: "")
          ],
        );
      });

  Widget datosUbicacionNegocioConyuge() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return Column(
          children: [
            //todo PROVINCIA
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) =>
                    form.conyuge.updateValueActividadEcon("provincia", val),
                //onChanged: (_) => validarColorActEconPrinc(),
                controlador: txtConyProvinciaEmpr,
                accionCampo: TextInputAction.next,
                nombreCampo: "Provincia",
                placeHolder: ""),
            //todo CIUDAD
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) =>
                    form.conyuge.updateValueActividadEcon("ciudad", val),
                //onChanged: (_) => validarColorActEconPrinc(),
                controlador: txtConyCantonEmpr,
                accionCampo: TextInputAction.next,
                nombreCampo: "Ciudad / Cantón",
                placeHolder: ""),
            //todo PARROQUIA
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) =>
                    form.conyuge.updateValueActividadEcon("parroquia", val),
                //onChanged: (_) => validarColorActEconPrinc(),
                controlador: txtConyParroquiaEmpr,
                accionCampo: TextInputAction.next,
                nombreCampo: "Parroquia",
                placeHolder: ""),
            //todo BARRIO
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) =>
                    form.conyuge.updateValueActividadEcon("barrio", val),
                //onChanged: (_) => validarColorActEconPrinc(),
                controlador: txtConyBarrioEmpre,
                accionCampo: TextInputAction.next,
                nombreCampo: "Barrio",
                placeHolder: ""),
            //todo DIRECCIÓN
            InputTextFormFields(
              habilitado: (widget.edit != null && !widget.edit!) ? false : true,
              onChanged: (val) =>
                  form.conyuge.updateValueActividadEcon("direccion", val),
              //onChanged: (_) => validarColorActEconPrinc(),
              controlador: txtConyDireccionEmpr,
              accionCampo: TextInputAction.next,
              nombreCampo: "Dirección",
              placeHolder: "",
            ),
            //todo REFERENCIA
            InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) =>
                    form.conyuge.updateValueActividadEcon("referencia", val),
                //onChanged: (_) => validarColorActEconPrinc(),
                controlador: txtConyReferenciaEmpr,
                accionCampo: TextInputAction.next,
                nombreCampo: "Referencia",
                placeHolder: ""),
          ],
        );
      });

  Widget expansionEstadoCivil() =>
      Consumer<FormProvider>(builder: (context, form, child) {
        return expansionTile(
          leading: const Icon(AbiPraxis.estado_civil, size: 18),
          color: widget.datosCivilConyuge,
          containerColor: Colors.white,
          expandColorContainer: Colors.white,
          icon: expanEstCivilCony
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_outlined),
          context,
          title: "Estado civil",
          func: (_) {
            setState(() => expanEstCivilCony = !expanEstCivilCony);
          },
          expController: expdpEstCivilCony,
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
                            validarColorEstCivilConyuge();
                            form.conyuge.updateValueEstadoCivil(
                                "estado_civil", val!["nombre"]);
                          }),
              ],
            ),
          ),
        );
      });

  void validarColorDatosConyuge() {
    var val1 = txtConyNombre.text.isNotEmpty;
    var val2 = txtConyApellidos.text.isNotEmpty;
    var val3 = txtConyCelular.text.isNotEmpty;

    if (txtConyCedula.text.isNotEmpty) {
      if (val1 && val2 && val3) {
        widget.changeColorDatosPersonales(1);
      } else {
        widget.changeColorDatosPersonales(2);
      }
    } else {
      widget.changeColorDatosPersonales(1);
    }

    validarColorNacimientoConyuge();
    validarColorIdentificacionConyuge();
    validarColorEducacionConyuge();
    validarColorActEconConyuge();
    validarColorEstCivilConyuge();
  }

  void validarColorNacimientoConyuge() {
    var val1 = (txtConyPais.text.isNotEmpty || pais != null);
    var val2 = (txtConyProvincia.text.isNotEmpty || provincia != null);
    var val3 = (txtConyCiudad.text.isNotEmpty || ciudad != null);
    var val4 = txtConyFechaNac.text.isNotEmpty;
    var val5 = txtConyEdad.text.isNotEmpty;
    var val6 = (conyGenero != null);

    if (txtConyCedula.text.isNotEmpty) {
      if (val1 && val2 && val3 && val4 && val5 && val6) {
        widget.changeColorNac(1);
      } else {
        widget.changeColorNac(2);
      }
    } else {
      widget.changeColorNac(1);
    }
  }

  void validarColorIdentificacionConyuge() {
    var val1 = txtConyCedula.text.isNotEmpty;
    var val2 = txtConyRuc.text.isNotEmpty;
    var val3 = txtConyPasaporte.text.isNotEmpty;
    var val4 = txtConyFechaExpPasaporte.text.isNotEmpty;
    var val5 = txtConyFechaCadPasaporte.text.isNotEmpty;
    var val6 = txtConyFechaEntrada.text.isNotEmpty;
    var val7 = (conyEstadoMigra != null);

    if (val1) {
      if (val3) {
        if (val2 && val4 && val5 && val6 && val7) {
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
    } else {
      widget.changeColorIden(1);
    }
  }

  void validarColorEducacionConyuge() {
    var val1 = (conyEstudio != null);
    var val2 = (conyProfesion != null);
    var val3 = txtConyOtraProfesion.text.isNotEmpty;

    if (txtConyCedula.text.isNotEmpty) {
      if (val2 && conyProfesion!["id"] == 11) {
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
    } else {
      widget.changeColorEduc(1);
    }
  }

  void validarColorEstCivilConyuge() {
    var val1 = (estadoCivil != null);

    if (val1) {
      widget.changeColorEstCivil(1);
    } else {
      widget.changeColorEstCivil(2);
    }
  }

  void validarColorActEconConyuge() {
    widget.changeColorActPrin(1);
  }

  String? functionValidateDataConyuge(dynamic value) =>
      txtConyCedula.text.isNotEmpty && (value == null || value.isEmpty)
          ? "Campo obligatorio"
          : null;

  void funcionProvincia(String provincia) async {
    if (pais == 'ECUADOR') {
      final res = obtenerCiudadesEcuadorDe(provincia);
      listaCiudades = res;
    }
  }

  void funcionPais(String? pais) async {
    listaProvincias.clear();
    if (pais == 'ECUADOR') {
      final provinciasRes = listaProvinciasEcuador['provincias'];
      for (var item in provinciasRes) {
        setState(() {
          listaProvincias.add(item);
        });
      }
      setState(() {
        hintTextProvincia = null;
      });
    }
  }

  void getData() async {
    final form = Provider.of<FormProvider>(context, listen: false).conyuge;

    if (widget.idSolicitud != null) {
      final solicitud = await op.obtenerSolicitud(widget.idSolicitud!);

      if (solicitud != null) {
        final datosConyuge = jsonDecode(solicitud.datosConyuge);
        final nac = datosConyuge["nacimiento"];
        final iden = datosConyuge["identificacion"];
        final educ = datosConyuge["educacion"];
        final act = datosConyuge["actividad_principal"];
        final ec = datosConyuge["estado_civil"];

        //todo NACIMIENTO
        //pais
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
            txtConyPais.text = nac["pais"];
            provinciasVisible = true;
            txtConyProvincia.text = nac["provincia"];
            ciudadesVisible = true;
            txtConyCiudad.text = nac["ciudad"];
          }
          form.updateValueNacimiento("pais", pais ?? txtConyPais.text);
          txtConyProvincia.text = nac["provincia"];
          form.updateValueNacimiento(
              "provincia", provincia ?? txtConyProvincia.text);
          txtConyCiudad.text = nac["ciudad"];
          form.updateValueNacimiento("ciudad", ciudad ?? txtConyCiudad.text);
        }
        //fecha
        if (nac["fecha"]?.isNotEmpty ?? false) {
          setState(() => txtConyFechaNac.text = nac["fecha"]);
          form.updateValueNacimiento("fecha", txtConyFechaNac.text);
        }
        //edad
        if (nac["edad"]?.isNotEmpty ?? false) {
          setState(() => txtConyEdad.text = nac["edad"]);
          form.updateValueNacimiento("edad", txtConyEdad.text);
        }
        //genero
        if (nac["genero"]?.isNotEmpty ?? false) {
          var g = generos.where((e) => nac["genero"] == e["nombre"]).first;

          setState(() => conyGenero = g);
          form.updateValueNacimiento("genero", g["nombre"]);
        }

        validarColorNacimientoConyuge();
        //todo IDENTIFICACIÓN obviamos cédula y ruc porque eso se busca por id persona arriba
        //pasaporte
        if (iden["pasaporte"]?.isNotEmpty ?? false) {
          setState(() => txtConyPasaporte.text = iden["pasaporte"]);
          form.updateValueIdentificacion("pasaporte", txtConyPasaporte.text);
        }
        //fecha expiracion
        if (iden["fecha_exp_p"]?.isNotEmpty ?? false) {
          setState(() => txtConyFechaExpPasaporte.text = iden["fecha_exp_p"]);
          form.updateValueIdentificacion(
              "fecha_exp_p", txtConyFechaExpPasaporte.text);
        }
        //fecha caducidad
        if (iden["fecha_cad_p"]?.isNotEmpty ?? false) {
          setState(() => txtConyFechaCadPasaporte.text = iden["fecha_cad_p"]);
          form.updateValueIdentificacion(
              "fecha_cad_p", txtConyFechaCadPasaporte.text);
        }
        //fecha entrada
        if (iden["fecha_entrada"]?.isNotEmpty ?? false) {
          setState(() => txtConyFechaEntrada.text = iden["fecha_entrada"]);
          form.updateValueIdentificacion(
              "fecha_entrada", txtConyFechaEntrada.text);
        }
        //estado migratorio
        if (iden["estado_migratorio"]?.isNotEmpty ?? false) {
          var e = estadoM
              .where((e) => iden["estado_migratorio"] == e["nombre"])
              .first;

          setState(() => conyEstadoMigra = e);
          form.updateValueIdentificacion("estado_migratorio", e["nombre"]);
        }
        validarColorIdentificacionConyuge();

        //todo EDUCACION
        //estudio
        if (educ["estudio"]?.isNotEmpty ?? false) {
          var e = estudios.where((e) => educ["estudio"] == e["nombre"]).first;
          setState(() => conyEstudio = e);
          form.updateValueEducacion("estudio", e["nombre"]);
        }
        //profesion
        if (educ["profesion"]?.isNotEmpty ?? false) {
          var p =
              profesiones.where((e) => educ["profesion"] == e["nombre"]).first;

          setState(() => conyProfesion = p);
          form.updateValueEducacion("profesion", p["nombre"]);

          if (p["nombre"] == "Otras") {
            if (educ["otra_profesion"] != null &&
                educ["otra_profesion"] != "") {
              setState(
                  () => txtConyOtraProfesion.text = educ["otra_profesion"]);
              form.updateValueEducacion(
                  "otra_profesion", txtConyOtraProfesion.text);
            }
          }
        }
        validarColorEducacionConyuge();

        //todo ACTIVIDAD ECONOMICA PRINCIPAL
        //relacion laboral
        if (act["relacion_laboral"]?.isNotEmpty ?? false) {
          var r = relaciones
              .where((e) => act["relacion_laboral"] == e["nombre"])
              .first;

          setState(() => conyRelacionLab = r);
          form.updateValueActividadEcon("relacion_laboral", r["nombre"]);
        }

        //tiempo negocio
        if (act["tiempo_negocio"]?.isNotEmpty ?? false) {
          setState(() => txtConyTiempoTrabajo.text = act["tiempo_negocio"]);
          form.updateValueActividadEcon(
              "tiempo_negocio", txtConyTiempoTrabajo.text);
        }

        //sueldo
        if (act["sueldo"]?.isNotEmpty ?? false) {
          setState(() => txtConySueldoIngresoBruto.text = act["sueldo"]);
          form.updateValueActividadEcon(
              "sueldo", txtConySueldoIngresoBruto.text);
        }

        //nombre
        if (act["nombre"]?.isNotEmpty ?? false) {
          setState(() => txtConyNombreEmpresa.text = act["nombre"]);
          form.updateValueActividadEcon("nombre", txtConyNombreEmpresa.text);
        }
        //ruc
        if (act["ruc"]?.isNotEmpty ?? false) {
          setState(() => txtConyRucEmpresa.text = act["ruc"]);
          form.updateValueActividadEcon("ruc", txtConyRucEmpresa.text);
        }

        //provincia
        if (act["provincia"]?.isNotEmpty ?? false) {
          setState(() => txtConyProvinciaEmpr.text = act["provincia"]);
          form.updateValueActividadEcon("provincia", txtConyProvinciaEmpr.text);
        }
        //ciudad
        if (act["ciudad"]?.isNotEmpty ?? false) {
          setState(() => txtConyCantonEmpr.text = act["ciudad"]);
          form.updateValueActividadEcon("ciudad", txtConyCantonEmpr.text);
        }
        //parroquia
        if (act["parroquia"]?.isNotEmpty ?? false) {
          setState(() => txtConyParroquiaEmpr.text = act["parroquia"]);
          form.updateValueActividadEcon("parroquia", txtConyParroquiaEmpr.text);
        }
        //barrio
        if (act["barrio"]?.isNotEmpty ?? false) {
          setState(() => txtConyBarrioEmpre.text = act["barrio"]);
          form.updateValueActividadEcon("barrio", txtConyBarrioEmpre.text);
        }
        //direccion
        if (act["direccion"]?.isNotEmpty ?? false) {
          setState(() => txtConyDireccionEmpr.text = act["direccion"]);
          form.updateValueActividadEcon("direccion", txtConyDireccionEmpr.text);
        }

        //referencia
        if (act["referencia"]?.isNotEmpty ?? false) {
          setState(() => txtConyReferenciaEmpr.text = act["referencia"]);
          form.updateValueActividadEcon(
              "referencia", txtConyReferenciaEmpr.text);
        }
        //origen_ingresos
        if (act["origen_ingresos"]?.isNotEmpty ?? false) {
          var o = ingresos
              .where((e) => act["origen_ingresos"] == e["nombre"])
              .first;
          setState(() => conyOrigenIngreso = o);
          form.updateValueActividadEcon("origen_ingresos", o["nombre"]);
        }

        //otra_actividad
        if (act["otra_actividad"]?.isNotEmpty ?? false) {
          var o = otraActvEcon
              .where((e) => act["otra_actividad"] == e["nombre"])
              .first;

          setState(() => conyOtraActv = o);
          form.updateValueActividadEcon("otra_actividad", o["nombre"]);

          if (o["nombre"] == "Otros") {
            if (act["info_actividad"]?.isNotEmpty ?? false) {
              setState(() => txtConyInfOtraActv.text = act["info_actividad"]);

              form.updateValueActividadEcon(
                  "info_actividad", txtConyInfOtraActv.text);
            }
          }
        }

        validarColorActEconConyuge();

        //todo estado civil
        if (ec["estado_civil"]?.isNotEmpty ?? false) {
          var e = estadosCiviles
              .where((e) => ec["estado_civil"] == e["nombre"])
              .first;

          setState(() => estadoCivil = e);
          form.updateValueEstadoCivil("estado_civil", e["nombre"]);
        }

        validarColorEstCivilConyuge();
      }
    }
  }
}
