// ignore_for_file: prefer_null_aware_operators, unused_local_variable, use_build_context_synchronously
import 'dart:convert';

import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/src/views/mapa/map_selector.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:abi_praxis_app/utils/function_callback.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../utils/textFields/input_text_form_fields.dart';
import '../../../../../../../../../utils/expansiontile.dart';
import '../../../../../../../../controller/aws/map_conection.dart';

class DatosBeneficiario extends StatefulWidget {
  bool? edit;
  bool? ver;
  int? idSolicitud;
  Color? datosPersonalesC;
  GlobalKey gk;
  final GlobalKey<FormState> formKey;
  final ExpansionTileController expController;
  bool enableExpansion;
  VoidCallback startLoading;
  VoidCallback stopLoading;
  MoveToTopCallback updatePixelPosition;
  ChangeColorCallback changeColorDatosBeneficiario;
  DatosBeneficiario({
    super.key,
    this.edit,
    this.ver,
    this.idSolicitud,
    required this.gk,
    required this.formKey,
    required this.enableExpansion,
    required this.startLoading,
    required this.stopLoading,
    required this.expController,
    required this.changeColorDatosBeneficiario,
    required this.updatePixelPosition,
    this.datosPersonalesC,
  });

  @override
  State<DatosBeneficiario> createState() => _DatosBeneficiarioState();
}

class _DatosBeneficiarioState extends State<DatosBeneficiario> {
  final op = Operations();
  List<Map<String, dynamic>> recomendaciones = [];
  bool titular = false;
  final mapC = MapConection();

  List<Map<String, dynamic>> tiposDocumentos = [
    {"tipo": "CI", "id": 1},
    {"tipo": "RUC", "id": 2}
  ];
  Map<String, dynamic>? tipoIdentificacion;
  int? idTipoDocumento;
  LatLng? coordenadasEntrega;

  //todo expansion tile datos personales
  final expdpNacimiento = ExpansionTileController();
  bool expanNac = false;
  //todo VARIABLES DE DATOS PERSONALES
  final txtNombres = TextEditingController();
  final txtApellidos = TextEditingController();
  final txtCelular1 = TextEditingController();
  final txtCelular2 = TextEditingController();
  final txtNumeroIdentificacion = TextEditingController();
  final txtDireccionEntrega = TextEditingController();

  @override
  void initState() {
    super.initState();
    //obtenerDatosPersona();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(builder: (context, form, child) {
      return expansionTile(
        key: widget.gk,
        context,
        title: "Datos del beneficiario",
        /*validateFields: widget.formKey.currentState != null
            ? widget.formKey.currentState!.validate()
            : null,*/
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
                //todo SWITHC PARA USAR DATOS DEL TITULAR COMO BENEFICIARIO
                if (widget.idSolicitud == null)
                  ListTile(
                    title: const Text(
                        "¿Usar datos del titular como datos del beneficiario?"),
                    trailing: Switch(
                        value: titular,
                        onChanged: (val) {
                          setState(() => titular = val);
                          if (val) {
                            setState(() {
                              txtNombres.text =
                                  form.titular.getValueTitular("nombres") ?? "";
                              form.beneficiario.updateValueBeneficiario(
                                  "nombres", txtNombres.text);

                              txtApellidos.text =
                                  form.titular.getValueTitular("apellidos") ??
                                      "";
                              form.beneficiario.updateValueBeneficiario(
                                  "apellidos", txtApellidos.text);

                              txtCelular1.text =
                                  form.titular.getValueTitular("celular1") ??
                                      "";
                              form.beneficiario.updateValueBeneficiario(
                                  "celular1", txtCelular1.text);

                              txtCelular2.text =
                                  form.titular.getValueTitular("celular2") ??
                                      "";
                              form.beneficiario.updateValueBeneficiario(
                                  "celular2", txtCelular2.text);
                            });
                            validarColorDatosBeneficiario();
                          } else {
                            setState(() {
                              txtNombres.clear();
                              form.beneficiario
                                  .updateValueBeneficiario("nombres", null);

                              txtApellidos.clear();
                              form.beneficiario
                                  .updateValueBeneficiario("apellidos", null);

                              txtCelular1.clear();
                              form.beneficiario
                                  .updateValueBeneficiario("celular1", null);

                              txtCelular2.clear();
                              form.beneficiario
                                  .updateValueBeneficiario("celular2", null);
                            });
                            validarColorDatosBeneficiario();
                          }
                        }),
                  ),
                divider(true),
                //todo NOMBRES
                InputTextFormFields(
                    habilitado:
                        widget.ver != null && widget.ver! ? false : true,
                    onChanged: (val) {
                      validarColorDatosBeneficiario();
                      form.beneficiario.updateValueBeneficiario("nombres", val);
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
                    habilitado:
                        widget.ver != null && widget.ver! ? false : true,
                    onChanged: (val) {
                      validarColorDatosBeneficiario();
                      form.beneficiario
                          .updateValueBeneficiario("apellidos", val);
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
                    habilitado:
                        widget.ver != null && widget.ver! ? false : true,
                    onChanged: (val) {
                      validarColorDatosBeneficiario();
                      form.beneficiario
                          .updateValueBeneficiario("celular1", val);
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
                        widget.ver != null && widget.ver! ? false : true,
                    onChanged: (val) {
                      validarColorDatosBeneficiario();
                      form.beneficiario
                          .updateValueBeneficiario("celular2", val);
                    },
                    tipoTeclado: TextInputType.phone,
                    prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                    controlador: txtCelular2,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Celular 2",
                    placeHolder: ""),
                //todo TIPO DE DOCUMENTO

                DropdownButtonFormField<Map<String, dynamic>>(
                    validator: (value) =>
                        value == null ? "Campo obligatorio" : null,
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    decoration: const InputDecoration(
                      label: Text("Tipo de documento"),
                      prefixIcon: Icon(AbiPraxis.cedula, size: 18),
                    ),
                    value: tipoIdentificacion,
                    items: tiposDocumentos
                        .map((e) => DropdownMenuItem<Map<String, dynamic>>(
                            value: e, child: Text(e["tipo"])))
                        .toList(),
                    onChanged: widget.ver != null && widget.ver!
                        ? null
                        : (val) {
                            if (val != null) {
                              setState(() {
                                tipoIdentificacion = val;
                                idTipoDocumento = val["id"];
                              });

                              form.beneficiario.updateValueBeneficiario(
                                  "tipo_identificacion",
                                  idTipoDocumento!.toString());
                            }
                          }),
                //todo NUMERO DE IDENTIFICACIÓN
                if (tipoIdentificacion != null)
                  InputTextFormFields(
                      habilitado:
                          widget.ver != null && widget.ver! ? false : true,
                      onChanged: (val) {
                        validarColorDatosBeneficiario();
                        form.beneficiario.updateValueBeneficiario(
                            "numero_identificacion", val);
                      },
                      tipoTeclado: TextInputType.phone,
                      prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                      validacion: (value) =>
                          value!.isEmpty ? "Campo obligatorio" : null,
                      controlador: txtNumeroIdentificacion,
                      accionCampo: TextInputAction.next,
                      nombreCampo: "Número de identificación",
                      placeHolder: ""),
                //todo DIRECCIÓN ENTREGA
                InputTextFormFields(
                    habilitado:
                        widget.ver != null && widget.ver! ? false : true,
                    controlador: txtDireccionEntrega,
                    maxLines: 4,
                    onChanged: (val) {
                      validarColorDatosBeneficiario();
                      form.beneficiario
                          .updateValueBeneficiario("direccion_entrega", val);
                    },
                    prefixIcon: const Icon(Icons.location_city_outlined),
                    icon: IconButton(
                        onPressed: () async {
                          widget.startLoading();

                          var con =
                              await mapC.checkInternetConnectivity(context);

                          widget.stopLoading();

                          if (!con) {
                            scaffoldMessenger(context,
                                "No dispone de una conexión estable para poder utilizar el mapa");
                            return;
                          }

                          var map = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const MapSelector()));

                          if (map != null && map.isNotEmpty) {
                            debugPrint("UBICACIÓN GEOLOCALIZADA");
                            setState(() => coordenadasEntrega = LatLng(
                                double.parse(map["latitud"]),
                                double.parse(map["longitud"])));
                            scaffoldMessenger(
                                context, "Coordenadas guardadas correctamente",
                                icon: const Icon(Icons.check,
                                    color: Colors.green));

                            form.beneficiario.updateValueBeneficiario("latitud",
                                coordenadasEntrega!.latitude.toString());
                            form.beneficiario.updateValueBeneficiario(
                                "longitud",
                                coordenadasEntrega!.longitude.toString());
                          } else {
                            debugPrint("NO SE GEOLOCALIZÓ");
                            scaffoldMessenger(
                                context, "No se obtuvieron las coordenadas",
                                icon:
                                    const Icon(Icons.error, color: Colors.red));
                          }
                        },
                        icon: Icon(
                          Icons.location_on_sharp,
                          color: coordenadasEntrega != null
                              ? Colors.green
                              : Colors.grey,
                        )),
                    accionCampo: TextInputAction.done,
                    nombreCampo: "Dirección y referencia",
                    placeHolder: "Ingrese la dirección y una referencia"),
              ],
            )),
      );
    });
  }

  void validarColorDatosBeneficiario() {
    var val1 = txtNombres.text.isNotEmpty;
    var val2 = txtApellidos.text.isNotEmpty;
    var val3 = txtCelular1.text.isNotEmpty;
    var val4 = tipoIdentificacion != null;
    var val5 = txtNumeroIdentificacion.text.isNotEmpty;
    var val6 = txtDireccionEntrega.text.isNotEmpty;

    if (val1 && val2 && val3 && val4 && val5 && val6) {
      widget.changeColorDatosBeneficiario(1);
    } else {
      widget.changeColorDatosBeneficiario(2);
    }
  }

  //todo SI EL ID DE LA SOLICITUD NO ESTÁ NULA OBTENGO DATOS
  void getData() async {
    final form = Provider.of<FormProvider>(context, listen: false).beneficiario;

    if (widget.idSolicitud != null) {
      final solicitud = await op.obtenerSolicitud(widget.idSolicitud!);

      if (solicitud != null) {
        final datos = jsonDecode(solicitud.datosBeneficiario);
        final per = datos["beneficiario"];

        setState(() {
          txtApellidos.text = per["apellidos"];
          form.updateValueBeneficiario("apellidos", txtApellidos.text);
          txtCelular1.text = per["celular1"];
          form.updateValueBeneficiario("celular1", txtCelular1.text);
          txtCelular2.text = per["celular2"];
          form.updateValueBeneficiario("celular2", txtCelular2.text);
          txtDireccionEntrega.text = per["direccion_entrega"] ?? "";
          form.updateValueBeneficiario(
              "direccion_entrega",
              txtDireccionEntrega.text.isNotEmpty
                  ? txtDireccionEntrega.text
                  : null);

          coordenadasEntrega = per["latitud"] != null && per["longitud"] != null
              ? LatLng(per["latitud"], per["longitud"])
              : null;
          form.updateValueBeneficiario(
              "latitud",
              coordenadasEntrega != null
                  ? coordenadasEntrega!.latitude.toString()
                  : null);
          form.updateValueBeneficiario(
              "longitud",
              coordenadasEntrega != null
                  ? coordenadasEntrega!.longitude.toString()
                  : null);

          txtNombres.text = per["nombres"];
          form.updateValueBeneficiario("nombres", txtNombres.text);
          if (per["tipo_identificacion"] != null) {
            var tipo = tiposDocumentos
                .where((e) => e["id"] == int.parse(per["tipo_identificacion"]))
                .first;

            tipoIdentificacion = tipo;
            form.updateValueBeneficiario(
                "tipo_identificacion", tipo["id"].toString());
            txtNumeroIdentificacion.text = per["numero_identificacion"] ?? "";
            form.updateValueBeneficiario(
                "numero_identificacion", txtNumeroIdentificacion.text);
          }
        });

        validarColorDatosBeneficiario();
      }
    }
  }
}
