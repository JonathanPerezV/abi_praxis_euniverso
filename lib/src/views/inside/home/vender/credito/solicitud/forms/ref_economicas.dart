import 'dart:convert';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/function_callback.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:abi_praxis_app/utils/textFields/input_text_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../utils/expansiontile.dart';
import '../../../../../../../../utils/list/lista_bancos.dart';

class ReferenciasEconomicas extends StatefulWidget {
  bool? edit;
  int? idSolicitud;
  bool enableExpansion;
  Color? datosReferencia;
  ExpansionTileController expController;
  Color? datoBancarioC;
  Color? datoProveedorC;
  MoveToTopCallback updatePixelPosition;
  GlobalKey gk;
  ReferenciasEconomicas(
      {super.key,
      this.edit,
      this.idSolicitud,
      required this.gk,
      required this.expController,
      this.datoBancarioC,
      this.datoProveedorC,
      this.datosReferencia,
      required this.enableExpansion,
      required this.updatePixelPosition});

  @override
  State<ReferenciasEconomicas> createState() => _ReferenciasEconomicasState();
}

class _ReferenciasEconomicasState extends State<ReferenciasEconomicas> {
  bool ref1 = false;
  bool ref2 = false;
  final op = Operations();
  final expRef1 = ExpansionTileController();
  final expRef2 = ExpansionTileController();
  //todo variables bancaria
  List<String> instituciones = [];
  final txtInstitucion = TextEditingController();
  bool corriente = false;
  bool ahorro = false;
  bool pdf = false;
  bool tc = false;

  //todo variables proveedor
  final txtNombre = TextEditingController();
  final txtNombreContacto = TextEditingController();
  final txtCelular = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return expansionTile(context,
        key: widget.gk,
        children: opcionesReferencias(),
        title: "Referencias económicas", func: (val) {
      if (val) {
        widget.updatePixelPosition(widget.gk);
      }
    },
        expController: widget.expController,
        enabled: widget.enableExpansion,
        color: widget.datosReferencia);
  }

  Widget opcionesReferencias() {
    return Column(
      children: [
        //todo EXPANSIONTILE BANCARIA
        expansionTile(context,
            leading: const Icon(AbiPraxis.bancaria),
            children: expansionReferencia1(),
            title: "Bancaria", func: (_) {
          setState(() => ref1 = !ref1);
        },
            containerColor: Colors.white,
            expandColorContainer: Colors.white,
            icon: ref1
                ? const Icon(Icons.remove_circle_outline_sharp)
                : const Icon(Icons.add_circle_outline_outlined),
            expController: expRef1,
            enabled: widget.enableExpansion),
        divider(true, color: Colors.grey),
        //todo EXPANSIONTILE PROVEEDOR
        expansionTile(context,
            leading: const Icon(AbiPraxis.proveedor),
            children: expansionReferencia2(),
            title: "Proveedor", func: (_) {
          setState(() => ref2 = !ref2);
        },
            containerColor: Colors.white,
            expandColorContainer: Colors.white,
            icon: ref2
                ? const Icon(Icons.remove_circle_outline_sharp)
                : const Icon(Icons.add_circle_outline_outlined),
            expController: expRef2,
            enabled: widget.enableExpansion)
      ],
    );
  }

  Widget expansionReferencia1() {
    return Consumer<FormProvider>(builder: (builder, form, child) {
      return Stack(
        children: [
          Column(
            children: [
              divider(false),
              Container(
                margin: const EdgeInsets.only(left: 45, right: 15),
                child: InputTextFormFields(
                    habilitado:
                        (widget.edit != null && !widget.edit!) ? false : true,
                    controlador: txtInstitucion,
                    validacion: (value) =>
                        value!.isEmpty ? "Campo obligatorio*" : null,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Institución",
                    onChanged: (value) {
                      filtrarActividad(value);
                    },
                    placeHolder: ""),
              ),
              Container(
                margin: const EdgeInsets.only(left: 55, right: 15),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Cuenta corriente"),
                  trailing: Checkbox(
                    value: corriente,
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (val) {
                            setState(() {
                              corriente = !corriente;
                            });
                            form.refEconomicas.updateValueDatosBancarios(
                                "corriente", val.toString());
                          },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 55, right: 15),
                child: divider(false),
              ),
              Container(
                margin: const EdgeInsets.only(left: 55, right: 15),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Cuenta de ahorros"),
                  trailing: Checkbox(
                    value: ahorro,
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (val) {
                            setState(() {
                              ahorro = !ahorro;
                            });
                            form.refEconomicas.updateValueDatosBancarios(
                                "ahorros", val.toString());
                          },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 55, right: 15),
                child: divider(false),
              ),
              Container(
                margin: const EdgeInsets.only(left: 55, right: 15),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Cuenta dfp"),
                  trailing: Checkbox(
                    value: pdf,
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (val) {
                            setState(() {
                              pdf = !pdf;
                            });
                            form.refEconomicas.updateValueDatosBancarios(
                                "pdf", val.toString());
                          },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 55, right: 15),
                child: divider(false),
              ),
              Container(
                margin: const EdgeInsets.only(left: 55, right: 15),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("TC"),
                  trailing: Checkbox(
                    value: tc,
                    onChanged: (widget.edit != null && !widget.edit!)
                        ? null
                        : (val) {
                            setState(() {
                              tc = !tc;
                            });
                            form.refEconomicas.updateValueDatosBancarios(
                                "tc", val.toString());
                          },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 55, right: 15),
                child: divider(false),
              ),
            ],
          ),
          if (instituciones.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 55),
              height: 400,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              child: Material(
                borderRadius: BorderRadius.circular(25),
                elevation: 2,
                child: ListView.separated(
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                  itemCount: instituciones.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        txtInstitucion.text = instituciones[index];
                        instituciones.clear();
                        form.refEconomicas.updateValueDatosBancarios(
                            "institucion", txtInstitucion.text);
                      }),
                      child: Column(
                        children: [
                          SizedBox(
                              width: double.infinity,
                              child: Text(
                                (instituciones[index]),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
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
    });
  }

  Widget expansionReferencia2() {
    return Consumer<FormProvider>(builder: (builder, form, child) {
      return Container(
          margin: const EdgeInsets.only(left: 55, right: 15),
          child: Column(
            children: [
              divider(false),
              InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtNombre,
                onChanged: (val) {
                  form.refEconomicas.updateValueProveedor("institucion", val);
                },
                accionCampo: TextInputAction.next,
                nombreCampo: "Nombre de la institución",
                placeHolder: "",
              ),
              InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtNombreContacto,
                onChanged: (val) {
                  form.refEconomicas.updateValueProveedor("contacto", val);
                },
                accionCampo: TextInputAction.next,
                nombreCampo: "Nombre persona de contacto",
                placeHolder: "",
              ),
              InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                controlador: txtCelular,
                onChanged: (val) {
                  form.refEconomicas.updateValueProveedor("celular  ", val);
                },
                accionCampo: TextInputAction.next,
                nombreCampo: "Celular / teléfono",
                placeHolder: "",
              ),
            ],
          ));
    });
  }

  void filtrarActividad(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        instituciones.clear();
      });

      return;
    }

    final list = (bancos
        .where((e) => e.toLowerCase().contains(value.toLowerCase()))
        .toList());

    setState(() {
      instituciones = list;
    });
  }

  void getData() async {
    final form =
        Provider.of<FormProvider>(context, listen: false).refEconomicas;

    if (widget.idSolicitud != null) {
      final solicitud = await op.obtenerSolicitud(widget.idSolicitud!);

      if (solicitud != null) {
        final referencias = jsonDecode(solicitud.refEconomicas);
        final datos = referencias["datos_bancarios"];
        final prov = referencias["proveedor"];

        //todo DATOS BANCARIOS
        //institucion
        if (datos["institucion"]?.isNotEmpty ?? false) {
          setState(() => txtInstitucion.text = datos["institucion"]);
          form.updateValueDatosBancarios("institucion", txtInstitucion.text);
        }
        //cta corriente
        if (datos["corriente"]?.isNotEmpty ?? false) {
          setState(() => corriente = bool.parse(datos["corriente"]));
          form.updateValueDatosBancarios("corriente", corriente.toString());
        }
        //cta ahorros
        if (datos["ahorros"]?.isNotEmpty ?? false) {
          setState(() => ahorro = bool.parse(datos["ahorros"]));
          form.updateValueDatosBancarios("ahorros", ahorro.toString());
        }
        //cta pdf
        if (datos["pdf"]?.isNotEmpty ?? false) {
          setState(() => pdf = bool.parse(datos["pdf"]));
          form.updateValueDatosBancarios("pdf", pdf.toString());
        }
        //tc
        if (datos["tc"]?.isNotEmpty ?? false) {
          setState(() => tc = bool.parse(datos["tc"]));
          form.updateValueDatosBancarios("tc", tc.toString());
        }

        //todo PROVEEDOR
        if (prov["institucion"]?.isNotEmpty ?? false) {
          setState(() => txtNombre.text = prov["institucion"]);
          form.updateValueProveedor("institucion", txtNombre.text);
        }
        //contacto
        if (prov["contacto"]?.isNotEmpty ?? false) {
          setState(() => txtNombreContacto.text = prov["contacto"]);
          form.updateValueProveedor("contacto", txtNombreContacto.text);
        }
        //celular
        if (prov["celular"]?.isNotEmpty ?? false) {
          setState(() => txtCelular.text = prov["celular"]);
          form.updateValueProveedor("celular", txtCelular.text);
        }
      }
    }
  }
}
