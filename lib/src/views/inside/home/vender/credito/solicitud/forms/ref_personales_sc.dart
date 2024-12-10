import 'dart:convert';

import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/utils/expansiontile.dart';
import 'package:abi_praxis_app/utils/function_callback.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:abi_praxis_app/utils/list/lista_solicitud.dart';
import 'package:abi_praxis_app/utils/textFields/input_text_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../utils/deviders/divider.dart';
import '../../../../../../../../utils/flushbar.dart';
import '../../../../../../../../utils/geolocator/geolocator.dart';
import '../../../../../../../controller/dataBase/operations.dart';

class ReferenciasPersonales extends StatefulWidget {
  int? idSolicitud;
  bool? edit;
  ExpansionTileController expController;
  Color? datosReferencia1;
  Color? datosReferencia2;
  Color? datosReferencia;
  MoveToTopCallback updatePixelPosition;
  ChangeColorCallback changeColorRef1;
  ChangeColorCallback changeColorRef2;
  ChangeColorCallback changeColorReferencias;
  VoidCallback startLoading;
  VoidCallback stopLoading;
  GlobalKey gk;
  GlobalKey<FormState> keyRef1;
  GlobalKey<FormState> keyRef2;
  bool enableExpansion;
  ReferenciasPersonales(
      {super.key,
      this.idSolicitud,
      this.datosReferencia1,
      this.datosReferencia2,
      this.edit,
      required this.gk,
      required this.changeColorRef1,
      required this.changeColorRef2,
      required this.keyRef1,
      required this.keyRef2,
      required this.enableExpansion,
      required this.changeColorReferencias,
      required this.datosReferencia,
      required this.expController,
      required this.startLoading,
      required this.stopLoading,
      required this.updatePixelPosition});

  @override
  State<ReferenciasPersonales> createState() => _ReferenciasPersonalesState();
}

class _ReferenciasPersonalesState extends State<ReferenciasPersonales> {
  final expRef1 = ExpansionTileController();
  final expRef2 = ExpansionTileController();
  final op = Operations();
  //todo VARIABLES NOMBRES - REF 1
  bool ref1 = false;
  int? idPersona1;
  final txtNombres = TextEditingController();
  final txtApellidos = TextEditingController();
  final txtCelular1 = TextEditingController();
  final txtCelular2 = TextEditingController();
  final txtTelefono = TextEditingController();
  final txtDireccion = TextEditingController();
  String? latitudRef1;
  String? longitudRef1;
  int tipoContacto = 10;
  final txtParentesco = TextEditingController(); //REFERENCIA = 1
  Map<String, dynamic>? relacionLaboral;
  String? textRelacionLaboral;
  final txtActividad = TextEditingController();

  //todo VARIABLES NOMBRES - REF 2
  bool ref2 = false;
  int? idPersona2;
  final txtNombresRef2 = TextEditingController();
  final txtApellidosRef2 = TextEditingController();
  final txtCelular1Ref2 = TextEditingController();
  final txtCelular2Ref2 = TextEditingController();
  final txtTelefonoRef2 = TextEditingController();
  final txtDireccionRef2 = TextEditingController();
  String? latitudRef2;
  String? longitudRef2;
  int tipoContactoRef2 = 10;
  final txtParentescoRef2 = TextEditingController(); //REFERENCIA = 1
  Map<String, dynamic>? relacionLaboralRef2;
  String? textRelacionLaboralRef2;
  final txtActividadRef2 = TextEditingController();

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
        title: "Referencias personales", func: (_) {
      widget.updatePixelPosition(widget.gk);
    },
        expController: widget.expController,
        enabled: widget.enableExpansion,
        color: widget.datosReferencia);
  }

  Widget opcionesReferencias() => Column(
        children: [
          //todo EXPANSIONTILE REFERENCIA 1
          expansionTile(context,
              color: widget.datosReferencia1,
              children: expansionReferencia1(),
              title: "Referencias personales 1", func: (val) {
            setState(() => ref1 = !ref1);
            if (val) {
              widget.updatePixelPosition(widget.gk);
            }
          },
              containerColor: Colors.white,
              expandColorContainer: Colors.white,
              icon: ref1
                  ? const Icon(Icons.remove_circle_outline_sharp)
                  : const Icon(Icons.add_circle_outline_outlined),
              expController: expRef1,
              enabled: widget.enableExpansion),
          divider(true, color: Colors.grey),
          //todo EXPANSIONTILE IDENTIFICACIÓN
          expansionTile(context,
              color: widget.datosReferencia2,
              children: expansionReferencia2(),
              title: "Referencias personales 2", func: (_) {
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

  Widget expansionReferencia1() =>
      Consumer<FormProvider>(builder: (builder, form, child) {
        return Form(
          key: widget.keyRef1,
          child: Column(
            children: [
              //todo NOMBRES
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  validacion: (val) =>
                      val!.isEmpty ? "Campo obligatorio" : null,
                  controlador: txtNombres,
                  onChanged: (val) {
                    validarColorRefPersonal1();
                    form.referencias.updateValueRef1("nombres", val);
                  },
                  prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Nombres",
                  placeHolder: ""),
              //todo APELLIDOS
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  validacion: (val) =>
                      val!.isEmpty ? "Campo obligatorio" : null,
                  controlador: txtApellidos,
                  onChanged: (val) {
                    validarColorRefPersonal1();
                    form.referencias.updateValueRef1("apellidos", val);
                  },
                  prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Apellidos",
                  placeHolder: ""),
              //todo CELULAR 1
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  validacion: (val) =>
                      val!.isEmpty ? "Campo obligatorio" : null,
                  tipoTeclado: TextInputType.number,
                  controlador: txtCelular1,
                  onChanged: (val) {
                    validarColorRefPersonal1();
                    form.referencias.updateValueRef1("celular1", val);
                  },
                  prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Celular 1",
                  placeHolder: ""),
              //todo CELULAR 2
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  tipoTeclado: TextInputType.number,
                  controlador: txtCelular2,
                  onChanged: (val) {
                    validarColorRefPersonal1();
                    form.referencias.updateValueRef1("celular2", val);
                  },
                  prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Celular 2",
                  placeHolder: ""),
              //todo TELEFONO
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  validacion: (val) =>
                      val!.isEmpty ? "Campo obligatorio" : null,
                  tipoTeclado: TextInputType.number,
                  controlador: txtTelefono,
                  onChanged: (val) {
                    validarColorRefPersonal1();
                    form.referencias.updateValueRef1("telefono", val);
                  },
                  prefixIcon: const Icon(AbiPraxis.telefono, size: 18),
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Teléfono convencional",
                  placeHolder: ""),
              //todo DIRECCIÓN
              InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorRefPersonal1();
                  form.referencias.updateValueRef1("direccion", val);
                },
                controlador: txtDireccion,
                validacion: (value) =>
                    value!.isEmpty ? "Campo obligatorio" : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Dirección",
                placeHolder: "",
                prefixIcon: const Icon(Icons.location_city),
                /*  icon: IconButton(
                    onPressed: () async {
                      /*if (txtDireccion.text.isEmpty) {
                              scaffoldMessenger(context,
                                  "Debe ingresar la dirección del domicilio para poder geolocalizar.",
                                  icon: const Icon(Icons.error, color: Colors.red));
                              return;
                            }*/
                      widget.startLoading();

                      var res =
                          await GeolocatorConfig().requestPermission(context);

                      if (res != null) {
                        var loc = await Geolocator.getCurrentPosition();

                        setState(() {
                          latitudRef1 = loc.latitude.toString();
                          longitudRef1 = loc.longitude.toString();
                        });

                        form.referencias
                            .updateValueRef1("latitud", latitudRef1);
                        form.referencias
                            .updateValueRef1("longitud", longitudRef1);
                        validarColorRefPersonal1();

                        debugPrint("$latitudRef1, $longitudRef1");

                        scaffoldMessenger(context,
                            "Se han guardado las coordenadas de su ubicación actual",
                            icon: const Icon(Icons.check, color: Colors.green));
                      } else {
                        scaffoldMessenger(context,
                            "Ocurrió un error, no hemos podido guardar su ubicación actual",
                            icon: const Icon(Icons.error, color: Colors.red));
                      }

                      widget.stopLoading();
                    },
                    icon: latitudRef1 != null && longitudRef1 != null
                        ? const Icon(
                            Icons.location_on,
                            color: Colors.green,
                          )
                        : const Icon(Icons.add_location_alt)), */
              ),
              //todo RELACION CON EL PROSPECTO
              ExpansionTile(
                tilePadding: const EdgeInsets.only(left: 25),
                leading: const Icon(AbiPraxis.relacion_prospecto),
                title: const Text("Relación con el prospecto"),
                children: [
                  divider(true),
                  Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: InputTextFormFields(
                        habilitado: (widget.edit != null && !widget.edit!)
                            ? false
                            : true,
                        onChanged: (val) {
                          validarColorRefPersonal1();
                          form.referencias.updateValueRef1("relacion", val);
                        },
                        validacion: (val) =>
                            val!.isEmpty ? "Campo obligatorio" : null,
                        controlador: txtParentesco,
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Otros",
                        placeHolder: ""),
                  )
                ],
              ),
              divider(false),
              //todo ACTIVIDAD ECONOMICA
              ExpansionTile(
                tilePadding: const EdgeInsets.only(left: 25),
                leading: const Icon(AbiPraxis.actividad_economica),
                title: const Text("Actividad ecónomica principal"),
                children: [
                  divider(true),
                  Container(
                    padding: const EdgeInsets.only(left: 25),
                    child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                            label: Text("Relación laboral")),
                        value: relacionLaboral,
                        items: relaciones
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e["nombre"])))
                            .toList(),
                        onChanged: (widget.edit != null && !widget.edit!)
                            ? null
                            : (Map<String, dynamic>? val) {
                                if (val != null) {
                                  relacionLaboral = val;
                                  form.referencias.updateValueRef1(
                                      "otra_relacion", val["nombre"]);
                                  validarColorRefPersonal1();
                                }
                              }),
                  ),

                  //todo ACTIVIDAD QUE REALIZA
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: InputTextFormFields(
                        habilitado: (widget.edit != null && !widget.edit!)
                            ? false
                            : true,
                        validacion: (val) =>
                            val!.isEmpty ? "Campo obligatorio" : null,
                        onChanged: (val) {
                          validarColorRefPersonal1();
                          form.referencias.updateValueRef1("actividad", val);
                        },
                        controlador: txtActividad,
                        accionCampo: TextInputAction.done,
                        nombreCampo: "Actividad específica",
                        placeHolder: ""),
                  ),
                ],
              )
            ],
          ),
        );
      });

  Widget expansionReferencia2() =>
      Consumer<FormProvider>(builder: (builder, form, child) {
        return Form(
          key: widget.keyRef2,
          child: Column(
            children: [
              //todo NOMBRES
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  validacion: (val) =>
                      val!.isEmpty ? "Campo obligatorio" : null,
                  controlador: txtNombresRef2,
                  onChanged: (val) {
                    validarColorRefPersonal2();
                    form.referencias.updateValueRef2("nombres", val);
                  },
                  prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Nombres",
                  placeHolder: ""),
              //todo APELLIDOS
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  validacion: (val) =>
                      val!.isEmpty ? "Campo obligatorio" : null,
                  controlador: txtApellidosRef2,
                  onChanged: (val) {
                    validarColorRefPersonal2();
                    form.referencias.updateValueRef2("apellidos", val);
                  },
                  prefixIcon: const Icon(AbiPraxis.nombre_apellido, size: 18),
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Apellidos",
                  placeHolder: ""),
              //todo CELULAR 1
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  validacion: (val) =>
                      val!.isEmpty ? "Campo obligatorio" : null,
                  tipoTeclado: TextInputType.number,
                  controlador: txtCelular1Ref2,
                  onChanged: (val) {
                    validarColorRefPersonal2();
                    form.referencias.updateValueRef2("celular1", val);
                  },
                  prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Celular 1",
                  placeHolder: ""),
              //todo CELULAR 2
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  tipoTeclado: TextInputType.number,
                  controlador: txtCelular2Ref2,
                  onChanged: (val) {
                    validarColorRefPersonal2();
                    form.referencias.updateValueRef2("celular2", val);
                  },
                  prefixIcon: const Icon(AbiPraxis.celular, size: 18),
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Celular 2",
                  placeHolder: ""),
              //todo TELEFONO
              InputTextFormFields(
                  habilitado:
                      (widget.edit != null && !widget.edit!) ? false : true,
                  validacion: (val) =>
                      val!.isEmpty ? "Campo obligatorio" : null,
                  tipoTeclado: TextInputType.number,
                  controlador: txtTelefonoRef2,
                  onChanged: (val) {
                    validarColorRefPersonal2();
                    form.referencias.updateValueRef2("telefono", val);
                  },
                  prefixIcon: const Icon(AbiPraxis.telefono, size: 18),
                  accionCampo: TextInputAction.next,
                  nombreCampo: "Teléfono convencional",
                  placeHolder: ""),
              //todo DIRECCIÓN
              InputTextFormFields(
                habilitado:
                    (widget.edit != null && !widget.edit!) ? false : true,
                onChanged: (val) {
                  validarColorRefPersonal2();
                  form.referencias.updateValueRef2("direccion", val);
                },
                controlador: txtDireccionRef2,
                validacion: (value) =>
                    value!.isEmpty ? "Campo obligatorio" : null,
                accionCampo: TextInputAction.next,
                nombreCampo: "Dirección",
                placeHolder: "",
                prefixIcon: const Icon(Icons.location_city),
                /*  icon: IconButton(
                    onPressed: () async {
                      /*if (txtDireccion.text.isEmpty) {
                              scaffoldMessenger(context,
                                  "Debe ingresar la dirección del domicilio para poder geolocalizar.",
                                  icon: const Icon(Icons.error, color: Colors.red));
                              return;
                            }*/
                      widget.startLoading();

                      var res =
                          await GeolocatorConfig().requestPermission(context);

                      if (res != null) {
                        var loc = await Geolocator.getCurrentPosition();

                        setState(() {
                          latitudRef2 = loc.latitude.toString();
                          longitudRef2 = loc.longitude.toString();
                        });

                        form.referencias
                            .updateValueRef2("latitud", latitudRef2);
                        form.referencias
                            .updateValueRef2("longitud", longitudRef2);

                        validarColorRefPersonal2();

                        debugPrint("$latitudRef2, $longitudRef2");

                        scaffoldMessenger(context,
                            "Se han guardado las coordenadas de su ubicación actual",
                            icon: const Icon(Icons.check, color: Colors.green));
                      } else {
                        scaffoldMessenger(context,
                            "Ocurrió un error, no hemos podido guardar su ubicación actual",
                            icon: const Icon(Icons.error, color: Colors.red));
                      }

                      widget.stopLoading();
                    },
                    icon: latitudRef2 != null && longitudRef2 != null
                        ? const Icon(
                            Icons.location_on,
                            color: Colors.green,
                          )
                        : const Icon(Icons.add_location_alt)), */
              ),
              //todo RELACION CON EL PROSPECTO
              ExpansionTile(
                tilePadding: const EdgeInsets.only(left: 25),
                leading: const Icon(AbiPraxis.relacion_prospecto),
                title: const Text("Relación con el prospecto"),
                children: [
                  divider(true),
                  Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: InputTextFormFields(
                        habilitado: (widget.edit != null && !widget.edit!)
                            ? false
                            : true,
                        onChanged: (val) {
                          validarColorRefPersonal2();
                          form.referencias.updateValueRef2("relacion", val);
                        },
                        validacion: (val) =>
                            val!.isEmpty ? "Campo obligatorio" : null,
                        controlador: txtParentescoRef2,
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Otros",
                        placeHolder: ""),
                  )
                ],
              ),
              divider(false),
              //todo ACTIVIDAD ECONOMICA
              ExpansionTile(
                tilePadding: const EdgeInsets.only(left: 25),
                leading: const Icon(AbiPraxis.actividad_economica),
                title: const Text("Actividad ecónomica principal"),
                children: [
                  divider(true),
                  Container(
                    padding: const EdgeInsets.only(left: 25),
                    child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                            label: Text("Relación laboral")),
                        value: relacionLaboralRef2,
                        items: relaciones
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e["nombre"])))
                            .toList(),
                        onChanged: (widget.edit != null && !widget.edit!)
                            ? null
                            : (Map<String, dynamic>? val) {
                                if (val != null) {
                                  relacionLaboralRef2 = val;
                                  validarColorRefPersonal2();
                                  form.referencias.updateValueRef2(
                                      "otra_relacion", val["nombre"]);
                                }
                              }),
                  ),

                  //todo ACTIVIDAD QUE REALIZA
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: InputTextFormFields(
                        habilitado: (widget.edit != null && !widget.edit!)
                            ? false
                            : true,
                        validacion: (val) =>
                            val!.isEmpty ? "Campo obligatorio" : null,
                        onChanged: (val) {
                          validarColorRefPersonal2();
                          form.referencias.updateValueRef2("actividad", val);
                        },
                        controlador: txtActividadRef2,
                        accionCampo: TextInputAction.done,
                        nombreCampo: "Actividad específica",
                        placeHolder: ""),
                  ),
                ],
              )
            ],
          ),
        );
      });

  void validarColorRefPersonal1() {
    var val1 = txtNombres.text.isNotEmpty;
    var val2 = txtApellidos.text.isNotEmpty;
    var val3 = txtCelular1.text.isNotEmpty;
    var val4 = txtDireccion.text.isNotEmpty;
    var val5 = txtParentesco.text.isNotEmpty;
    var val6 = relacionLaboral != null;
    var val7 = txtActividad.text.isNotEmpty;

    if (val1 && val2 && val3 && val4 && val5 && val6 && val7) {
      widget.changeColorRef1(1);
      widget.changeColorReferencias(1);
    } else {
      widget.changeColorRef1(2);
      widget.changeColorReferencias(2);
    }
  }

  void validarColorRefPersonal2() {
    var val1 = txtNombres.text.isNotEmpty;
    var val2 = txtApellidos.text.isNotEmpty;
    var val3 = txtCelular1.text.isNotEmpty;
    var val4 = txtDireccion.text.isNotEmpty;
    var val5 = txtParentesco.text.isNotEmpty;
    var val6 = relacionLaboral != null;
    var val7 = txtActividad.text.isNotEmpty;

    if (val1 && val2 && val3 && val4 && val5 && val6 && val7) {
      widget.changeColorRef2(1);
      widget.changeColorReferencias(1);
    } else {
      widget.changeColorRef2(2);
      widget.changeColorReferencias(2);
    }
  }

  void getData() async {
    final form = Provider.of<FormProvider>(context, listen: false).referencias;

    if (widget.idSolicitud != null) {
      final solicitud = await op.obtenerSolicitud(widget.idSolicitud!);

      if (solicitud != null) {
        final referencias = jsonDecode(solicitud.refPersonales);
        final ref1 = referencias["referencias"]["referencia_1"];
        final ref2 = referencias["referencias"]["referencia_2"];

        //todo REFERENCIA 1
        //id persona
        if (ref1["id_persona"]?.isNotEmpty ?? false) {
          setState(() => idPersona1 = int.parse(ref1["id_persona"]));
          form.updateValueRef1("id_persona", idPersona1.toString());
        }
        //nombres
        if (ref1["nombres"]?.isNotEmpty ?? false) {
          setState(() => txtNombres.text = ref1["nombres"]);
          form.updateValueRef1("nombres", txtNombres.text);
        }
        //apellidos
        if (ref1["apellidos"]?.isNotEmpty ?? false) {
          setState(() => txtApellidos.text = ref1["apellidos"]);
          form.updateValueRef1("apellidos", txtApellidos.text);
        }
        //celular1
        if (ref1["celular1"]?.isNotEmpty ?? false) {
          setState(() => txtCelular1.text = ref1["celular1"]);
          form.updateValueRef1("celular1", txtCelular1.text);
        }
        //celular2
        if (ref1["celular2"]?.isNotEmpty ?? false) {
          setState(() => txtCelular2.text = ref1["celular2"]);
          form.updateValueRef1("celular2", txtCelular2.text);
        }
        //telefono
        if (ref1["telefono"]?.isNotEmpty ?? false) {
          setState(() => txtTelefono.text = ref1["telefono"]);
          form.updateValueRef1("telefono", txtTelefono.text);
        }
        //direccion
        if (ref1["direccion"]?.isNotEmpty ?? false) {
          setState(() => txtDireccion.text = ref1["direccion"]);
          form.updateValueRef1("direccion", txtDireccion.text);
        }
        //relacion
        if (ref1["relacion"]?.isNotEmpty ?? false) {
          setState(() => txtParentesco.text = ref1["relacion"]);
          form.updateValueRef1("relacion", txtParentesco.text);
        }
        //relacion laboral
        if (ref1["otra_relacion"]?.isNotEmpty ?? false) {
          var r = relaciones
              .where((e) => ref1["otra_relacion"] == e["nombre"])
              .first;

          setState(() => relacionLaboral = r);
          form.updateValueRef1("otra_relacion", r["nombre"]);

          //otra actividad
          //if (relacionLaboral!["nombre"] == "Otros") {

          //}
        }
        if (ref1["actividad"]?.isNotEmpty ?? false) {
          setState(() => txtActividad.text = ref1["actividad"]);
          form.updateValueRef1("actividad", txtActividad.text);
        }
        validarColorRefPersonal1();
        //todo REFERENCIA 2
        //id persona
        if (ref2["id_persona"]?.isNotEmpty ?? false) {
          setState(() => idPersona2 = int.parse(ref2["id_persona"]));
          form.updateValueRef2("id_persona", idPersona2.toString());
        }
        //nombres
        if (ref2["nombres"]?.isNotEmpty ?? false) {
          setState(() => txtNombresRef2.text = ref2["nombres"]);
          form.updateValueRef2("nombres", txtNombresRef2.text);
        }
        //apellidos
        if (ref2["apellidos"]?.isNotEmpty ?? false) {
          setState(() => txtApellidosRef2.text = ref2["apellidos"]);
          form.updateValueRef2("apellidos", txtApellidosRef2.text);
        }
        //celular1
        if (ref2["celular1"]?.isNotEmpty ?? false) {
          setState(() => txtCelular1Ref2.text = ref2["celular1"]);
          form.updateValueRef2("celular1", txtCelular1Ref2.text);
        }
        //celular2
        if (ref2["celular2"]?.isNotEmpty ?? false) {
          setState(() => txtCelular2Ref2.text = ref2["celular2"]);
          form.updateValueRef2("celular2", txtCelular2Ref2.text);
        }
        //telefono
        if (ref2["telefono"]?.isNotEmpty ?? false) {
          setState(() => txtTelefonoRef2.text = ref2["telefono"]);
          form.updateValueRef2("telefono", txtTelefonoRef2.text);
        }
        //direccion
        if (ref2["direccion"]?.isNotEmpty ?? false) {
          setState(() => txtDireccionRef2.text = ref2["direccion"]);
          form.updateValueRef2("direccion", txtDireccionRef2.text);
        }
        //relacion
        if (ref2["relacion"]?.isNotEmpty ?? false) {
          setState(() => txtParentescoRef2.text = ref2["relacion"]);
          form.updateValueRef2("relacion", txtParentescoRef2.text);
        }
        //relacion laboral
        if (ref2["otra_relacion"]?.isNotEmpty ?? false) {
          var r = relaciones
              .where((e) => ref2["otra_relacion"] == e["nombre"])
              .first;

          setState(() => relacionLaboralRef2 = r);
          form.updateValueRef2("otra_relacion", r["nombre"]);

          //otra actividad
          //if (relacionLaboralRef2!["nombre"] == "Otros") {

          //}
        }

        if (ref2["actividad"]?.isNotEmpty ?? false) {
          setState(() => txtActividadRef2.text = ref2["actividad"]);
          form.updateValueRef2("actividad", txtActividadRef2.text);
        }
        validarColorRefPersonal2();
      }
    }
  }
}
