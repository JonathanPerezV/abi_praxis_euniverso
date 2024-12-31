import 'dart:convert';

import 'package:abi_praxis_app/utils/expansiontile.dart';
import 'package:abi_praxis_app/utils/function_callback.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:abi_praxis_app/utils/list/lista_solicitud.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../utils/textFields/input_text_form_fields.dart';
import '../../../../../../../../controller/dataBase/operations.dart';
import '../../../../../../../../controller/provider/form_state.dart';

class PlanesSuscripcion extends StatefulWidget {
  bool? edit;
  bool? ver;
  int? idSolicitud;
  Color? suscripcionesC;
  GlobalKey gk;
  final GlobalKey<FormState> formKey;
  final ExpansionTileController expController;
  bool enableExpansion;
  VoidCallback startLoading;
  VoidCallback stopLoading;
  MoveToTopCallback updatePixelPosition;
  ChangeColorCallback changeColorSuscripciones;
  PlanesSuscripcion({
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
    required this.changeColorSuscripciones,
    required this.updatePixelPosition,
    this.suscripcionesC,
  });

  @override
  State<PlanesSuscripcion> createState() => _PlanesSuscripcionState();
}

class _PlanesSuscripcionState extends State<PlanesSuscripcion> {
  final txtInfoAdicional = TextEditingController();
  final op = Operations();
  List<Map<String, dynamic>> planes = [
    {"nombre": "Premium (lunes a domingo)", "id": 1},
    {"nombre": "Familiar (jueves a lunes)", "id": 2},
    {"nombre": "Empresarial (luneas a viernes)", "id": 3},
    {"nombre": "Vital (viernes a lunes)", "id": 4},
    {"nombre": "Entretenimiento (viernes a domingo)", "id": 5},
    {"nombre": "Ejecutivo (sábado a lunes)", "id": 6},
    {"nombre": "Fin de semana (sábado y domingo)", "id": 7}
  ];
  Map<String, dynamic>? planSelected;
  int? idPlan;

  List<Map<String, dynamic>> pagos = [
    {"nombre": "Efectivo", "id": 1},
    {"nombre": "Tarjeta de Débito", "id": 2},
    {"nombre": "Tarjeta de Crédito", "id": 3},
  ];
  Map<String, dynamic>? pagoSelected;
  int? idPago;

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(builder: (context, form, child) {
      return expansionTile(
        key: widget.gk,
        context,
        title: "Plan de suscripciones",
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
        color: widget.suscripcionesC,
        children: Form(
            key: widget.formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                //todo TIPO DE PLAN
                DropdownButtonFormField<Map<String, dynamic>>(
                    validator: (val) =>
                        val == null ? "Campo obligatorio *" : null,
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    decoration: const InputDecoration(
                      label: Text("Tipo de plan"),
                      prefixIcon: Icon(AbiPraxis.plan, size: 18),
                    ),
                    value: planSelected,
                    items: planes
                        .map((e) => DropdownMenuItem<Map<String, dynamic>>(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: widget.ver != null && widget.ver!
                        ? null
                        : (val) {
                            if (val != null) {
                              setState(() {
                                planSelected = val;
                                idPlan = val["id"];
                              });

                              form.suscripciones.updateValueSuscripcion(
                                  "plan", val["nombre"]);
                              form.suscripciones.updateValueSuscripcion(
                                  "id_plan", idPlan.toString());

                              validarColorSuscripcion();
                            }
                          }),
                const SizedBox(height: 10),
                //todo MÉTODO DE PAGO
                DropdownButtonFormField<Map<String, dynamic>>(
                    validator: (val) =>
                        val == null ? "Campo obligatorio *" : null,
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    decoration: const InputDecoration(
                      label: Text("Forma de Pago"),
                      prefixIcon: Icon(AbiPraxis.pagos, size: 18),
                    ),
                    value: pagoSelected,
                    items: pagos
                        .map((e) => DropdownMenuItem<Map<String, dynamic>>(
                            value: e, child: Text(e["nombre"])))
                        .toList(),
                    onChanged: widget.ver != null && widget.ver!
                        ? null
                        : (val) {
                            if (val != null) {
                              setState(() {
                                pagoSelected = val;
                                idPago = val["id"];
                              });

                              form.suscripciones.updateValueSuscripcion(
                                  "pago", val["nombre"]);
                              form.suscripciones.updateValueSuscripcion(
                                  "id_pago", idPago.toString());

                              validarColorSuscripcion();
                            }
                          }),
                const SizedBox(height: 10),
                //todo INFORMACIÓN ADICIONAL
                InputTextFormFields(
                    habilitado:
                        widget.ver != null && widget.ver! ? false : true,
                    maxLines: 4,
                    onChanged: (val) {
                      validarColorSuscripcion();
                      form.suscripciones.updateValueSuscripcion(
                          "informacion_adicional", txtInfoAdicional.text);
                    },
                    prefixIcon: const Icon(Icons.info_outline, size: 18),
                    /* validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null, */
                    controlador: txtInfoAdicional,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Información adicional (opcional)",
                    placeHolder:
                        "Ingrese información adicional sobre la forma de pago o del plan."),
              ],
            )),
      );
    });
  }

  void validarColorSuscripcion() {
    var val1 = planSelected != null;
    var val2 = pagoSelected != null;

    if (val1 && val2) {
      widget.changeColorSuscripciones(1);
    } else {
      widget.changeColorSuscripciones(2);
    }
  }

  //todo SI EL ID DE LA SOLICITUD NO ESTÁ NULA OBTENGO DATOS
  void getData() async {
    final form =
        Provider.of<FormProvider>(context, listen: false).suscripciones;

    if (widget.idSolicitud != null) {
      final solicitud = await op.obtenerSolicitud(widget.idSolicitud!);

      if (solicitud != null) {
        widget.stopLoading();
        final data = jsonDecode(solicitud.datosSuscripcion);
        final sus = data["plan_suscripciones"];

        if (sus["id_plan"] != null) {
          setState(() {
            planSelected =
                planes.where((e) => e["id"] == int.parse(sus["id_plan"])).first;
            idPlan = int.parse(sus["id_plan"]);
            form.updateValueSuscripcion("id_plan", idPlan.toString());
            form.updateValueSuscripcion("plan", planSelected!["nombre"]);
          });
        }

        if (sus["id_pago"] != null) {
          setState(() {
            pagoSelected =
                pagos.where((e) => e["id"] == int.parse(sus["id_pago"])).first;
            idPago = int.parse(sus["id_pago"]);
            form.updateValueSuscripcion("id_pago", idPago.toString());
            form.updateValueSuscripcion("pago", pagoSelected!["nombre"]);
          });
        }
        setState(
            () => txtInfoAdicional.text = sus["informacion_adicional"] ?? "");
        form.updateValueSuscripcion("informacion_adicional",
            txtInfoAdicional.text.isNotEmpty ? txtInfoAdicional.text : null);

        validarColorSuscripcion();
      }
    }
  }
}
