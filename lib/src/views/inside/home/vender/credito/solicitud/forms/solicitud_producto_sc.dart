import 'dart:convert';

import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/utils/expansiontile.dart';
import 'package:abi_praxis_app/utils/function_callback.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:abi_praxis_app/utils/list/lista_autorizacion_consulta.dart';
import 'package:abi_praxis_app/utils/list/lista_solicitud.dart';
import 'package:abi_praxis_app/utils/textFields/field_formater.dart';
import 'package:abi_praxis_app/utils/textFields/input_text_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SolicitudProducto extends StatefulWidget {
  bool? edit;
  int? idSolicitud;
  GlobalKey<FormState> formKey;
  MoveToTopCallback updatePixelPosition;
  GlobalKey gk;
  ChangeColorCallback changeColorSolicitud;
  Color? dataColorSolicitud;
  bool enableExpansion;
  String? monto;
  int? fuente;
  int? plazo;
  String? cuota;
  VoidCallback stopLoading;
  ExpansionTileController expController;
  SolicitudProducto(
      {super.key,
      this.edit,
      this.idSolicitud,
      required this.stopLoading,
      required this.changeColorSolicitud,
      this.dataColorSolicitud,
      required this.gk,
      required this.enableExpansion,
      required this.expController,
      required this.formKey,
      required this.updatePixelPosition,
      this.monto,
      this.cuota,
      this.fuente,
      this.plazo});

  @override
  State<SolicitudProducto> createState() => _SolicitudProductoState();
}

class _SolicitudProductoState extends State<SolicitudProducto> {
  final op = Operations();
  final txtMonto = TextEditingController();
  Map<String, dynamic>? destino;
  String? textDestino;
  final txtOtroDestino = TextEditingController();
  final txtFechaPago = TextEditingController();
  Map<String, dynamic>? plazo;
  String? textPlazo;
  Map<String, dynamic>? frecuencia;
  String? textFrecuencia;

  @override
  void initState() {
    super.initState();
    if (widget.fuente != null) {
      final form = Provider.of<FormProvider>(context, listen: false).solicitud;

      if (widget.plazo != null) {
        if (widget.plazo.toString().length > 1) {
          plazo = listaPlazo
              .where((e) => e["nombre"] == "${widget.plazo}meses")
              .toList()[0];
        } else {
          plazo = listaPlazo.where((e) => e["id"] == widget.plazo).toList()[0];
        }
      }
      form.updateValueSolicitud("plazo", plazo!["nombre"]);
      txtMonto.text = widget.monto ?? "";
      form.updateValueSolicitud("monto", txtMonto.text);
    }
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return expansionTile(
      context,
      key: widget.gk,
      children: formularioProducto(),
      title: "Solicitud de producto",
      func: (val) {
        if (val) {
          widget.updatePixelPosition(widget.gk);
        }
      },
      expController: widget.expController,
      enabled: widget.enableExpansion,
      color: widget.dataColorSolicitud,
    );
  }

  Widget formularioProducto() =>
      Consumer<FormProvider>(builder: (builder, form, child) {
        return Form(
          key: widget.formKey,
          child: Column(
            children: [
              //todo MONTO SOLICITADO
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  controlador: txtMonto,
                  tipoTeclado:
                      const TextInputType.numberWithOptions(decimal: false),
                  prefixIcon: const Icon(AbiPraxis.monto_solicitado),
                  listaFormato: [
                    ThousandsSeparatorInputFormatter(),
                    FilteringTextInputFormatter.deny(",",
                        replacementString: "."),
                  ],
                  validacion: (val) =>
                      val!.isEmpty ? "Campo obligatorio" : null,
                  onChanged: (val) {
                    validarColorSolicitudProducto();
                    form.solicitud
                        .updateValueSolicitud("monto", val.toString());
                  },
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Monto",
                  placeHolder: ""),
              //todo DESTINOS
              DropdownButtonFormField(
                  validator: (val) =>
                      val == null || val.isEmpty ? "Campo obligatorio" : null,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(AbiPraxis.destino_credito),
                    label: Text("Destino de crédito"),
                  ),
                  items: destinos
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e["nombre"])))
                      .toList(),
                  onChanged: (widget.edit != null && !widget.edit!)
                      ? null
                      : (Map<String, dynamic>? val) {
                          setState(() {
                            destino = val;
                          });
                          validarColorSolicitudProducto();
                          form.solicitud
                              .updateValueSolicitud("destino", val!["nombre"]);
                        }),
              //todo ESPECIFICAR OTRO DESTINO
              if (destino != null && destino!["id"] == 7)
                Container(
                  margin: const EdgeInsets.only(left: 50),
                  child: InputTextFormFields(
                      habilitado:
                          (widget.edit != null && !widget.edit!) ? false : true,
                      onChanged: (_) {
                        validarColorSolicitudProducto();
                      },
                      validacion: (val) =>
                          destino!["id"] == 7 ? "Campo obligatorio" : null,
                      accionCampo: TextInputAction.next,
                      nombreCampo: "Especifique otro destino",
                      placeHolder: ""),
                ),
              //todo DÍA A CANCELAR CUOTA
              Row(
                children: [
                  Expanded(
                    child: AbsorbPointer(
                      absorbing: true,
                      child: InputTextFormFields(
                          prefixIcon: const Icon(AbiPraxis.dia_cancelar_cuota),
                          validacion: (val) =>
                              val!.isEmpty ? "Campo obligatorio" : null,
                          controlador: txtFechaPago,
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Fecha cuota a pagar",
                          placeHolder: ""),
                    ),
                  ),
                  IconButton(
                      onPressed: (widget.edit != null && !widget.edit!)
                          ? null
                          : () async {
                              await showDatePicker(
                                      context: context,
                                      firstDate:
                                          DateTime(DateTime.now().year - 5),
                                      lastDate:
                                          DateTime(DateTime.now().year + 15))
                                  .then((val) {
                                if (val != null) {
                                  setState(() {
                                    txtFechaPago.text =
                                        DateFormat("yyyy-MM-dd").format(val);
                                  });

                                  validarColorSolicitudProducto();
                                  form.solicitud.updateValueSolicitud(
                                      "pago_cuota", txtFechaPago.text);
                                }
                              });
                            },
                      icon: const Icon(Icons.calendar_month))
                ],
              ),
              //todo PLAZO
              DropdownButtonFormField(
                  value: plazo,
                  validator: (val) =>
                      val == null || val.isEmpty ? "Campo obligatorio" : null,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: const InputDecoration(
                    label: Text("Plazo"),
                    prefixIcon: Icon(AbiPraxis.plazo),
                  ),
                  items: listaPlazo
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e["nombre"])))
                      .toList(),
                  onChanged: (widget.edit != null && !widget.edit!)
                      ? null
                      : (Map<String, dynamic>? val) {
                          setState(() => plazo = val);
                          validarColorSolicitudProducto();
                          form.solicitud
                              .updateValueSolicitud("plazo", val!["nombre"]);
                        }),
              //todo FRECUENCIA DE PAGO
              DropdownButtonFormField(
                  value: frecuencia,
                  validator: (val) =>
                      val == null || val.isEmpty ? "Campo obligatorio" : null,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: const InputDecoration(
                    label: Text("Frecuencia de pago"),
                    prefixIcon: Icon(AbiPraxis.frecuencia_pago),
                  ),
                  items: frecuencias
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e["nombre"])))
                      .toList(),
                  onChanged: (widget.edit != null && !widget.edit!)
                      ? null
                      : (Map<String, dynamic>? val) {
                          setState(() => frecuencia = val);
                          validarColorSolicitudProducto();
                          form.solicitud.updateValueSolicitud(
                              "frecuencia", val!["nombre"]);
                        }),
            ],
          ),
        );
      });

  void validarColorSolicitudProducto() {
    var val1 = txtMonto.text.isNotEmpty;
    var val2 = (destino != null);
    var val3 = txtFechaPago.text.isNotEmpty;
    var val4 = (plazo != null);
    var val5 = (frecuencia != null);

    if (val1 && val2 && val3 && val4 && val5) {
      widget.changeColorSolicitud(1);
    } else {
      widget.changeColorSolicitud(2);
    }
  }

  void getData() async {
    final form = Provider.of<FormProvider>(context, listen: false).solicitud;

    if (widget.idSolicitud != null) {
      final solicitud = await op.obtenerSolicitud(widget.idSolicitud!);

      if (solicitud != null) {
        final sol = jsonDecode(solicitud.solicitudProd);
        final data = sol["solicitud"];

        //monto
        if (data["monto"]?.isNotEmpty ?? false) {
          setState(() => txtMonto.text = data["monto"]);
          form.updateValueSolicitud("monto", txtMonto.text);
        }
        //destino
        if (data["destino"]?.isNotEmpty ?? false) {
          var d = destinos.where((e) => data["destino"] == e["nombre"]).first;
          setState(() => destino = d);
          form.updateValueSolicitud("destino", d["nombre"]);

          if (d["nombre"] == "Otros") {
            if (data["otro_destino"]) {
              setState(() => txtOtroDestino.text = data["otro_destino"]);
              form.updateValueSolicitud("otro_destino", txtOtroDestino.text);
            }
          }
        }
        //pago cuota
        if (data["pago_cuota"]?.isNotEmpty ?? false) {
          setState(() => txtFechaPago.text = data["pago_cuota"]);
          form.updateValueSolicitud("pago_cuota", txtFechaPago.text);
        }
        //plazo
        if (data["plazo"]?.isNotEmpty ?? false) {
          var p = listaPlazo.where((e) => data["plazo"] == e["nombre"]).first;

          setState(() => plazo = p);
          form.updateValueSolicitud("plazo", p["nombre"]);
        }
        //frecuencia
        if (data["frecuencia"]?.isNotEmpty ?? false) {
          var f =
              frecuencias.where((e) => data["frecuencia"] == e["nombre"]).first;

          setState(() => frecuencia = f);
          form.updateValueSolicitud("frecuencia", f["nombre"]);
        }

        validarColorSolicitudProducto();
        widget.stopLoading();
      }
    }
  }
}
