// ignore_for_file: prefer_null_aware_operators, unused_local_variable, use_build_context_synchronously, must_be_immutable
import 'dart:convert';

import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/utils/function_callback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../utils/expansiontile.dart';
import '../../../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../../../../../../../../utils/textFields/input_text_form_fields.dart';

class DatosPersonalesCredito extends StatefulWidget {
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
  ChangeColorCallback changeColorDatosPersonales;
  DatosPersonalesCredito({
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
    required this.changeColorDatosPersonales,
    required this.updatePixelPosition,
    this.datosPersonalesC,
  });

  @override
  State<DatosPersonalesCredito> createState() => _DatosPersonalesCreditoState();
}

class _DatosPersonalesCreditoState extends State<DatosPersonalesCredito> {
  final op = Operations();
  List<Map<String, dynamic>> recomendaciones = [];

  //todo expansion tile datos personales
  final expdpNacimiento = ExpansionTileController();
  bool expanNac = false;
  //todo VARIABLES DE DATOS PERSONALES
  final txtNombres = TextEditingController();
  final txtApellidos = TextEditingController();
  final txtCelular1 = TextEditingController();
  final txtCelular2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    //obtenerDatosPersona();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(builder: (context, form, child) {
      return expansionTile(
        key: widget.gk,
        context,
        title: "Datos del titular",
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
                //todo NOMBRES
                InputTextFormFields(
                    habilitado:
                        widget.ver != null && widget.ver! ? false : true,
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
                    habilitado:
                        widget.ver != null && widget.ver! ? false : true,
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
                    habilitado:
                        widget.ver != null && widget.ver! ? false : true,
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
                        widget.ver != null && widget.ver! ? false : true,
                    onChanged: (val) {
                      validarColorDatosPersonales();
                      form.titular.updateValueTitular("celular2", val);
                    },
                    tipoTeclado: TextInputType.phone,
                    prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                    /* validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio" : null, */
                    controlador: txtCelular2,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Celular 2",
                    placeHolder: ""),
              ],
            )),
      );
    });
  }

  void validarColorDatosPersonales() {
    var val1 = txtNombres.text.isNotEmpty;
    var val2 = txtApellidos.text.isNotEmpty;
    var val3 = txtCelular1.text.isNotEmpty;

    if (val1 && val2 && val3) {
      widget.changeColorDatosPersonales(1);
    } else {
      widget.changeColorDatosPersonales(2);
    }
  }

  //todo SI EL ID DE LA SOLICITUD NO ESTÁ NULA OBTENGO DATOS
  void getData() async {
    final form = Provider.of<FormProvider>(context, listen: false).titular;

    if (widget.idSolicitud != null) {
      final solicitud = await op.obtenerSolicitud(widget.idSolicitud!);

      if (solicitud != null) {
        widget.startLoading();

        final data = jsonDecode(solicitud.datosPersonales);
        final per = data["datos"];
        setState(() {
          txtNombres.text = per["nombres"];
          form.updateValueTitular("nombres", txtNombres.text);

          txtApellidos.text = per["apellidos"];
          form.updateValueTitular("apellidos", txtApellidos.text);

          txtCelular1.text = per["celular1"];
          form.updateValueTitular("celular1", txtCelular1.text);

          txtCelular2.text = per["celular2"] ?? "";
          form.updateValueTitular("celular2",
              txtCelular2.text.isNotEmpty ? txtCelular2.text : null);
        });

        validarColorDatosPersonales();
      }
    }
  }
}
