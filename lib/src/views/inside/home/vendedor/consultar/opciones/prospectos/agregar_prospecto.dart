// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:abi_praxis_app/src/controller/aws/map_conection.dart';
import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:abi_praxis_app/utils/buttons.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:abi_praxis_app/utils/geolocator/geolocator.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/loading.dart';
import 'package:abi_praxis_app/utils/selectFile/select_file.dart';
import 'package:abi_praxis_app/utils/textFields/input_text_form_fields.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../utils/app_bar.dart';
import '../../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../../../../../../../utils/paisesHabiles/paises.dart';
import '../../../../../../../../utils/paisesHabiles/retornar_resultados.dart';
import '../../../../../../mapa/map_selector.dart';
import '../../../../../lateralMenu/drawer_menu.dart';

class AgregarEditarProspecto extends StatefulWidget {
  bool edit;
  bool isClient;
  int? idPersona;
  bool? fromAut;

  AgregarEditarProspecto(
      {super.key,
      required this.edit,
      required this.isClient,
      this.idPersona,
      this.fromAut}) {
    if (edit && idPersona == null) {
      throw ArgumentError("El prospecto es requerido cuando edit es true");
    }
  }

  @override
  State<AgregarEditarProspecto> createState() => _AgregarEditarProspectoState();
}

class _AgregarEditarProspectoState extends State<AgregarEditarProspecto> {
  final _sckey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  final mapC = MapConection();

  int? idRDS;
  final txtContacto = TextEditingController();
  final txtNombres = TextEditingController();
  final txtApellidos = TextEditingController();
  final txtEmpresa = TextEditingController();
  final txtDireccion = TextEditingController();
  final txtCelular = TextEditingController();
  final txtCelular2 = TextEditingController();
  final txtMail = TextEditingController();
  final txtProvincia = TextEditingController();
  final txtCiudad = TextEditingController();
  final txtReference = TextEditingController();
  final txtReferenceTrabajo = TextEditingController();
  final txtDireccionTrabajo = TextEditingController();

  List<String> listPaises = ['ECUADOR'];
  String? pais;
  int? idPais;
  final txtPais = TextEditingController();

  List<Map<String, dynamic>> listaProvincias = [];
  Map<String, dynamic>? provincia;
  int? idProvincia;
  bool provinciasVisible = false;
  String? hintTextProvincia;

  List<Map<String, dynamic>> listaCiudades = [];
  Map<String, dynamic>? ciudad;
  int? idCiudad;
  bool ciudadesVisible = false;
  String? hintTextCiudad;

  bool otroPais = false;

  //todo BORRAR ESTOS CAMPOS Y CORREGIR ERRORES
  //String francLat = "-2.165758102";
  //String francLong = "-79.87811601";

  String latitud = "";
  String longitud = "";
  String? pathCasa;

  String latitudTrabajo = "";
  String longitudTrabajo = "";
  String? pathTrabajo;

  final op = Operations();

  List<Contact> contactos = [];
  bool showContacts = false;
  List<Contact> _searchList = [];
  bool loading = false;

  bool refCasa = false;
  bool refTra = false;

  bool cliente = false;
  bool prospecto = false;

  final file = SeleccionArchivos();

  void requestPermissionContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final allContacts =
          await FlutterContacts.getContacts(withProperties: true);

      setState(() => contactos = allContacts);
      setState(() => _searchList = allContacts);
    }
  }

  void getData() async {
    setState(() => loading = true);

    var res = await op.obtenerProspectosOclientes(
        id: widget.idPersona, cliente: widget.isClient);

    if (res != null) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        idRDS = res.idRDS;
        txtCelular.text = res.celular1 ?? "";
        txtCelular2.text = res.celular2 ?? "";
        txtDireccion.text = res.direccion ?? "";
        if (res.pais != null) {
          idPais = res.pais!;
          pais = "ECUADOR";
          funcionPais(idPais);
          provincia =
              listaProvincias.where((e) => e["id"] == res.provincia!).first;
          provinciasVisible = true;
          funcionProvincia(provincia!["id"]);
          ciudad = obtenerCiudadesEcuadorDe(provincia!["id"])
              .where((e) => e["id_c"] == res.ciudad)
              .first;
          ciudadesVisible = true;
        } /* else if (res.pais != 1) {
          pais = "OTRO";
          txtPais.text = "";
          txtProvincia.text = "";
          txtCiudad.text = "";
        } */
        txtPais.text = "";
        txtProvincia.text = "";
        txtCiudad.text = "";
        txtDireccionTrabajo.text = res.direccionTrabajo ?? "";
        txtEmpresa.text = res.empresaNegocio ?? "";
        txtMail.text = res.mail ?? "";
        txtNombres.text = res.nombres;
        txtApellidos.text = res.apellidos;
        txtReference.text = res.referencia ?? "";
        txtReferenceTrabajo.text = res.referenciaTrabajo ?? "";
        pathCasa = res.fotoReferenciaCasa;
        if (pathCasa != null) refCasa = true;
        pathTrabajo = res.fotoReferenciaTrabajo;
        if (pathTrabajo != null) refTra = true;
        latitud = res.latitud ?? "";
        longitud = res.longitud ?? "";
        latitudTrabajo = res.latitudTrabajo ?? "";
        longitudTrabajo = res.longitudTrabajo ?? "";
      });
    }
    setState(() => loading = false);
  }

  void prospectOrClient() async {
    if (widget.idPersona != null && widget.edit) {
      final res = await op.validarCliente(widget.idPersona!);

      if (res == "C") {
        setState(() => cliente = true);
        setState(() => prospecto = false);
      } else if (res == "P") {
        setState(() => prospecto = true);
        setState(() => cliente = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissionContacts();
    if (widget.edit) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() => showContacts = false);
      },
      child: Consumer<FormProvider>(builder: (context, form, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          key: _sckey,
          appBar: MyAppBar(key: _sckey).myAppBar(context: context),
          drawer: DrawerMenu(),
          body: Stack(
            children: [
              options(),
              if (loading) loadingWidget(text: "Obteniendo datos...")
            ],
          ),
        );
      }),
    );
  }

  Widget options() {
    return Column(
      children: [
        header(
            widget.edit
                ? cliente
                    ? "Editar cliente"
                    : "Editar prospecto"
                : "Agregar prospecto",
            AbiPraxis.prospectos,
            context: context),
        Expanded(
          child: Stack(
            children: [
              Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      if (contactos.isNotEmpty && !widget.edit)
                        InputTextFormFields(
                            controlador: txtContacto,
                            onChanged: (value) {
                              if (value!.isNotEmpty) {
                                setState(() => showContacts = true);
                                buildSearchList(value);
                              } else {
                                setState(() => _searchList = contactos);
                                setState(() => showContacts = false);
                              }
                            },
                            prefixIcon: const Icon(Icons.search),
                            inputBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            accionCampo: TextInputAction.done,
                            nombreCampo: "Buscar en mis contactos",
                            placeHolder: "Buscar en mis contactos"),
                      if (contactos.isNotEmpty && !widget.edit)
                        const SizedBox(height: 25),
                      if (contactos.isNotEmpty && !widget.edit) divider(true),
                      const SizedBox(height: 25),
                      //todo NOMBRES
                      InputTextFormFields(
                          controlador: txtNombres,
                          validacion: (value) => value != null && value.isEmpty
                              ? "Campo obligatorio*"
                              : null,
                          prefixIcon: const Icon(Icons.person),
                          capitalization: TextCapitalization.words,
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Nombres",
                          placeHolder: "Ej: Jose Alberto"),
                      const SizedBox(height: 20),
                      //todo APELLIDOS
                      InputTextFormFields(
                          controlador: txtApellidos,
                          validacion: (value) => value != null && value.isEmpty
                              ? "Campo obligatorio*"
                              : null,
                          prefixIcon: const Icon(Icons.person),
                          capitalization: TextCapitalization.words,
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Apellidos",
                          placeHolder: "Ej: Zambrano Velez"),
                      const SizedBox(height: 20),
                      //todo NEGOCIO / EMPRESA
                      InputTextFormFields(
                          controlador: txtEmpresa,
                          capitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(Icons.work),
                          validacion: (value) {
                            if (widget.fromAut != null && widget.fromAut!) {
                              if (value!.isEmpty) {
                                return "Campo obligatorio";
                              } else {
                                return null;
                              }
                            } else {
                              return null;
                            }
                          },
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Negocio / Empresa",
                          placeHolder: "Ej: Mi Empresa S.A"),
                      const SizedBox(height: 20),
                      //todo CELULAR
                      InputTextFormFields(
                          controlador: txtCelular,
                          tipoTeclado: TextInputType.number,
                          validacion: (value) => value != null && value.isEmpty
                              ? "Campo obligatorio*"
                              : null,
                          prefixIcon: Platform.isAndroid
                              ? const Icon(Icons.phone_android_sharp)
                              : const Icon(Icons.phone_iphone_sharp),
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          accionCampo: TextInputAction.done,
                          nombreCampo: "Celular",
                          placeHolder: "Ej: 000000000"),
                      const SizedBox(height: 20),
                      //todo CELULAR 2
                      InputTextFormFields(
                          controlador: txtCelular2,
                          tipoTeclado: TextInputType.number,
                          prefixIcon: Platform.isAndroid
                              ? const Icon(Icons.phone_android_sharp)
                              : const Icon(Icons.phone_iphone_sharp),
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          accionCampo: TextInputAction.done,
                          nombreCampo: "Celular 2",
                          placeHolder: "Ej: 000000000"),
                      const SizedBox(height: 20),
                      //todo CORREO ELECTRÓNICO
                      InputTextFormFields(
                          controlador: txtMail,
                          tipoTeclado: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.mail),
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Correo electrónico",
                          placeHolder: "Ej: juan.perez@hotmail.com"),
                      const SizedBox(height: 20),
                      //todo PAIS
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                labelText: "País",
                                prefixIcon: const Icon(Icons.location_city),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0))),
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
                                  value: e.toUpperCase(),
                                  child: Text(e.toUpperCase()));
                            }).toList(),
                            onChanged: (value) async {
                              setState(() {
                                pais = value;
                                idPais = 1;

                                if (provincia != null || ciudad != null) {
                                  provincia = null;
                                  ciudad = null;
                                }
                                if (pais != "ECUADOR") {
                                  setState(() => otroPais = true);
                                } else {
                                  setState(() => otroPais = false);
                                }
                                provinciasVisible = true;
                              });
                              funcionPais(1);
                            }),
                      ),

                      if (otroPais) ...[
                        const SizedBox(height: 20),
                        InputTextFormFields(
                            controlador: txtPais,
                            tipoTeclado: TextInputType.text,
                            prefixIcon: const Icon(Icons.location_city),
                            inputBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0)),
                            accionCampo: TextInputAction.next,
                            validacion: (value) {
                              if (widget.fromAut != null && widget.fromAut!) {
                                if (value!.isEmpty) {
                                  return "Campo obligatorio";
                                } else {
                                  return null;
                                }
                              } else {
                                return null;
                              }
                            },
                            nombreCampo: "País",
                            placeHolder: "Ej: Guatemala")
                      ],

                      if (provinciasVisible) const SizedBox(height: 20),
                      //todo PROVINCIA
                      Visibility(
                        visible: provinciasVisible,
                        child: Container(
                          margin: otroPais
                              ? null
                              : const EdgeInsets.only(left: 10, right: 10),
                          child: AbsorbPointer(
                            absorbing: hintTextProvincia != 'cargando...'
                                ? false
                                : true,
                            child: !otroPais
                                ? DropdownButtonFormField<Map<String, dynamic>>(
                                    decoration: InputDecoration(
                                        labelText: "Provincia",
                                        prefixIcon:
                                            const Icon(Icons.location_city),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0))),
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
                                    hint:
                                        Text(hintTextProvincia ?? 'Seleccione'),
                                    items: listaProvincias.map((e) {
                                      return DropdownMenuItem<
                                          Map<String, dynamic>>(
                                        value: e,
                                        child: Text(
                                            "${e['nombre'].toUpperCase()}"),
                                      );
                                    }).toList(),
                                    onChanged: (value) async {
                                      setState(() {
                                        provincia = value;
                                        idProvincia = value!["id"];
                                        ciudad = null;
                                      });
                                      ciudadesVisible = true;

                                      funcionProvincia(idProvincia!);
                                    })
                                : InputTextFormFields(
                                    controlador: txtProvincia,
                                    tipoTeclado: TextInputType.text,
                                    prefixIcon: const Icon(Icons.location_city),
                                    inputBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    accionCampo: TextInputAction.next,
                                    validacion: (value) {
                                      if (widget.fromAut != null &&
                                          widget.fromAut!) {
                                        if (value!.isEmpty) {
                                          return "Campo obligatorio";
                                        } else {
                                          return null;
                                        }
                                      } else {
                                        return null;
                                      }
                                    },
                                    nombreCampo: "Provincia",
                                    placeHolder: "Ej: Guayas"),
                          ),
                        ),
                      ),
                      if (ciudadesVisible) const SizedBox(height: 20),
                      //todo CIUDAD
                      Visibility(
                        visible: ciudadesVisible,
                        child: Container(
                          margin: otroPais
                              ? null
                              : const EdgeInsets.only(left: 10, right: 10),
                          child: AbsorbPointer(
                            absorbing:
                                hintTextCiudad != 'cargando...' ? false : true,
                            child: !otroPais
                                ? DropdownButtonFormField<Map<String, dynamic>>(
                                    decoration: InputDecoration(
                                        labelText: "Ciudad",
                                        prefixIcon:
                                            const Icon(Icons.location_city),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0))),
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
                                      return DropdownMenuItem<
                                          Map<String, dynamic>>(
                                        value: e,
                                        child: Text(e["nombre"].toUpperCase()),
                                      );
                                    }).toList(),
                                    onChanged: (value) async {
                                      setState(() {
                                        ciudad = value;
                                        idCiudad = ciudad!["id_c"];
                                        txtCiudad.text = ciudad!["nombre"]!;
                                      });
                                    })
                                : InputTextFormFields(
                                    controlador: txtCiudad,
                                    tipoTeclado: TextInputType.text,
                                    prefixIcon: const Icon(Icons.location_city),
                                    inputBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    accionCampo: TextInputAction.next,
                                    validacion: (value) {
                                      if (widget.fromAut != null &&
                                          widget.fromAut!) {
                                        if (value!.isEmpty) {
                                          return "Campo obligatorio";
                                        } else {
                                          return null;
                                        }
                                      } else {
                                        return null;
                                      }
                                    },
                                    nombreCampo: "Ciudad",
                                    placeHolder: "Guayaquil"),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      //todo DIRECCIÓN DOM
                      InputTextFormFields(
                        controlador: txtDireccion,
                        capitalization: TextCapitalization.sentences,
                        prefixIcon: const Icon(Icons.house),
                        validacion: (value) {
                          if (widget.fromAut != null && widget.fromAut!) {
                            if (value!.isEmpty) {
                              return "Campo obligatorio";
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        },
                        inputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Dirección Domicilio",
                        placeHolder: "Ingrese la dirección del cliente",
                        icon: IconButton(
                            onPressed: () async {
                              setState(() => loading = true);

                              var con =
                                  await mapC.checkInternetConnectivity(context);

                              if (!con) {
                                scaffoldMessenger(context,
                                    "No dispone de una conexión estable para poder utilizar el mapa");
                                return;
                              }

                              var map = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const MapSelector()));

                              if (map != null && map.isNotEmpty) {
                                debugPrint("UBICACIÓN GEOLOCALIZADA");
                                setState(() => latitud = map["latitud"]);
                                setState(() => longitud = map["longitud"]);
                                scaffoldMessenger(context,
                                    "Coordenadas guardadas correctamente",
                                    icon: const Icon(Icons.check,
                                        color: Colors.green));
                              } else {
                                debugPrint("NO SE GEOLOCALIZÓ");
                                scaffoldMessenger(
                                    context, "No se obtuvieron las coordenadas",
                                    icon: const Icon(Icons.error,
                                        color: Colors.red));
                              }

                              setState(() => loading = false);
                            },
                            icon: latitud != "" && longitud != ""
                                ? const Icon(
                                    Icons.location_on,
                                    color: Colors.green,
                                  )
                                : const Icon(Icons.add_location_alt)),
                      ),
                      const SizedBox(height: 20),
                      //todo REFERENCIA DOM
                      InputTextFormFields(
                        controlador: txtReference,
                        prefixIcon: const Icon(Icons.house),
                        inputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                        accionCampo: TextInputAction.done,
                        maxLines: 2,
                        nombreCampo: "Referencia domicilio",
                        placeHolder:
                            "Ej: Frente a una farmacia y diagonal a una tienda",
                        icon: IconButton(
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: refCasa ? Colors.green : Colors.black,
                          ),
                          onPressed: () async {
                            final path = await file.selectOrCaptureImage(
                                ImageSource.camera, context);
                            if (path != null) {
                              final bytes = await File(path).readAsBytes();
                              setState(() => refCasa = true);
                              setState(() => pathCasa = base64Encode(bytes));
                              /*flushBarGlobal(
                                  context,
                                  "Foto de referencia del domicilio cargada.",
                                 const Icon(Icons.check, color: Colors.green));*/

                              scaffoldMessenger(context,
                                  "Foto de referencia del domicilio cargada.",
                                  icon: const Icon(Icons.check,
                                      color: Colors.green));
                            } else {
                              /*flushBarGlobal(context, "Se canceló la acción",
                                  const Icon(Icons.error, color: Colors.red));*/

                              scaffoldMessenger(context, "Se canceló la acción",
                                  icon: const Icon(Icons.error,
                                      color: Colors.red));
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      //todo DIRECCIÓN TRAB
                      InputTextFormFields(
                        controlador: txtDireccionTrabajo,
                        capitalization: TextCapitalization.sentences,
                        prefixIcon: const Icon(Icons.work),
                        inputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Dirección Trabajo/Negocio",
                        placeHolder: "Ingrese la dirección del cliente",
                        validacion: (value) {
                          if (widget.fromAut != null && widget.fromAut!) {
                            if (value!.isEmpty) {
                              return "Campo obligatorio";
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        },
                        icon: IconButton(
                            onPressed: () async {
                              setState(() => loading = true);

                              var con =
                                  await mapC.checkInternetConnectivity(context);

                              if (!con) {
                                scaffoldMessenger(context,
                                    "No dispone de una conexión estable para poder utilizar el mapa");
                                return;
                              }

                              var map = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const MapSelector()));

                              if (map != null && map.isNotEmpty) {
                                debugPrint("UBICACIÓN GEOLOCALIZADA");
                                setState(() => latitudTrabajo = map["latitud"]);
                                setState(
                                    () => longitudTrabajo = map["longitud"]);
                                scaffoldMessenger(context,
                                    "Coordenadas guardadas correctamente",
                                    icon: const Icon(Icons.check,
                                        color: Colors.green));
                              } else {
                                debugPrint("NO SE GEOLOCALIZÓ");
                                scaffoldMessenger(
                                    context, "No se obtuvieron las coordenadas",
                                    icon: const Icon(Icons.error,
                                        color: Colors.red));
                              }

                              setState(() => loading = false);
                            },
                            icon: latitudTrabajo != "" && longitudTrabajo != ""
                                ? const Icon(
                                    Icons.location_on,
                                    color: Colors.green,
                                  )
                                : const Icon(Icons.add_location_alt)),
                      ),
                      const SizedBox(height: 20),
                      //todo REFERENCIA TRAB
                      InputTextFormFields(
                        controlador: txtReferenceTrabajo,
                        prefixIcon: const Icon(Icons.work),
                        inputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                        accionCampo: TextInputAction.done,
                        maxLines: 2,
                        nombreCampo: "Referencia trabajo",
                        placeHolder:
                            "Ej: Frente a una farmacia y diagonal a una tienda",
                        icon: IconButton(
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: refTra ? Colors.green : Colors.black,
                          ),
                          onPressed: () async {
                            final path = await file.selectOrCaptureImage(
                                ImageSource.camera, context);
                            if (path != null) {
                              final bytes = await File(path).readAsBytes();
                              setState(() => refTra = true);
                              setState(() => pathTrabajo = base64Encode(bytes));
                              /*flushBarGlobal(
                                  context,
                                  "Foto de referencia del trabajo cargada.",
                                  const Icon(Icons.check, color: Colors.green));*/
                              scaffoldMessenger(context,
                                  "Foto de referencia del trabajo cargada.",
                                  icon: const Icon(Icons.check,
                                      color: Colors.green));
                            } else {
                              /*flushBarGlobal(context, "Se canceló la acción",
                                  const Icon(Icons.error, color: Colors.red));*/
                              scaffoldMessenger(context, "Se canceló la acción",
                                  icon: const Icon(Icons.error,
                                      color: Colors.red));
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (txtNombres.text.isNotEmpty && !widget.edit)
                            nextButton(
                                onPressed: clearText,
                                text: "LIMPIAR",
                                width: 100,
                                background: Colors.red),
                          if (txtNombres.text.isNotEmpty)
                            const SizedBox(width: 15),
                          nextButton(
                              onPressed: validateButton,
                              text: "GUARDAR",
                              width: 100),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              contactsContainer()
            ],
          ),
        ),
      ],
    );
  }

  Widget contactsContainer() {
    return Align(
      alignment: Alignment.center,
      child: AnimatedOpacity(
        opacity: showContacts ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: Visibility(
          visible: showContacts,
          child: GestureDetector(
            onTap: () {
              debugPrint("hola");
            },
            child: Container(
              margin: const EdgeInsets.only(top: 62, left: 10, right: 10),
              width: double.infinity, //250,
              height: 225,
              child: Material(
                borderRadius: BorderRadius.circular(15),
                elevation: 4,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  child: ListView.builder(
                      itemCount: _searchList.length,
                      itemBuilder: (itemBuilder, i) {
                        return InkWell(
                          onTap: () => setState(() {
                            showContacts = false;
                            FocusScope.of(context).unfocus();
                            txtContacto.text = _searchList[i].displayName;
                            txtNombres.text = _searchList[i].displayName;

                            txtCelular.text = (_searchList[i]
                                .phones[0]
                                .number
                                .replaceAll(" ", "-")
                                .replaceAll("+593-", "+593"));

                            if (_searchList[i].phones.length > 1) {
                              txtCelular2.text =
                                  _searchList[i].phones[1].number;
                            }
                            txtMail.text = _searchList[i].emails[0].address;
                            txtEmpresa.text =
                                _searchList[i].organizations[0].company;
                            txtDireccion.text =
                                _searchList[i].addresses[0].address;
                            txtDireccionTrabajo.text =
                                _searchList[i].addresses[1].address;
                            txtCelular.text = _searchList[i].phones[0].number;
                          }),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              height: 45,
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                children: [
                                  Text(
                                    _searchList[i].displayName,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.centerRight,
                                    child:
                                        Text(_searchList[i].phones[0].number),
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
      ),
    );
  }

  void clearText() {
    setState(() {
      FocusScope.of(context).unfocus();
      txtCelular.clear();
      txtCelular2.clear();
      txtContacto.clear();
      txtDireccion.clear();
      txtEmpresa.clear();
      txtNombres.clear();
      txtMail.clear();
      latitud = "";
      longitud = "";
      txtReference.clear();
      txtDireccionTrabajo.clear();
      txtApellidos.clear();
      pais = null;
      provincia = null;
      ciudad = null;
    });
  }

  void validateButton() async {
    final pfrc = UserPreferences();
    int idUser = await pfrc.getIdUser();
    if (_formkey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final persona = PersonaModel(
          usuarioCreacion: idUser,
          direccionTrabajo: txtDireccionTrabajo.text,
          apellidos: txtApellidos.text,
          celular2: txtCelular2.text,
          latitud: latitud, //francLat,
          longitud: longitud, //francLong,
          referencia: txtReference.text,
          idPersona: widget.edit ? widget.idPersona : null,
          mail: txtMail.text,
          celular1: txtCelular.text,
          direccion: txtDireccion.text,
          nombres: txtNombres.text,
          empresaNegocio: txtEmpresa.text,
          latitudTrabajo: latitudTrabajo,
          longitudTrabajo: longitudTrabajo,
          estado: "A",
          fotoReferenciaCasa: pathCasa,
          fotoReferenciaTrabajo: pathTrabajo,
          referenciaTrabajo: txtReferenceTrabajo.text,
          pais: idPais,
          provincia: idProvincia,
          ciudad: idCiudad,
          idRDS: idRDS);

      if (!widget.edit) {
        final res = await op.insertarPersona(persona, isProsp: true);

        if (res == 100) {
          /*flushBarGlobal(context, "Ya existe un prospecto con este número",
              const Icon(Icons.error, color: Colors.red));*/
          scaffoldMessenger(context, "Ya existe un prospecto con este número",
              icon: const Icon(Icons.error, color: Colors.red));
        } else {
          clearText();
          /*flushBarGlobal(context, "Prospecto agregado correctamente",
              const Icon(Icons.check, color: Colors.green));*/
          scaffoldMessenger(context, "Prospecto agregado correctamente",
              icon: const Icon(Icons.check, color: Colors.green));
        }

        debugPrint("resultado: $res");
      } else {
        final res = await op.actualizarPersona(persona.idPersona!, persona);

        if (res == 1) {
          Navigator.pop(context, persona);
          Navigator.pop(context, persona);
          /*flushBarGlobal(context, "Prospecto actualizado correctamente",
              const Icon(Icons.check, color: Colors.green));*/
          scaffoldMessenger(context, "Prospecto actualizado correctamente",
              icon: const Icon(Icons.check, color: Colors.green));
        } else {
          /*flushBarGlobal(context, "No se pudo actualizar el prospecto",
              const Icon(Icons.error, color: Colors.red));*/

          scaffoldMessenger(context, "No se pudo actualizar el prospecto",
              icon: const Icon(Icons.error, color: Colors.red));
        }
      }
    } else {
      return;
    }
  }

  void buildSearchList(text) {
    if (text != "") {
      final list = contactos
          .where((element) => element.displayName
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

  void funcionPais(int? pais) async {
    listaProvincias.clear();
    if (pais == 1) {
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

  void funcionProvincia(int idProvincia) async {
    if (pais == 'ECUADOR') {
      final res = obtenerCiudadesEcuadorDe(idProvincia);
      listaCiudades = res;
    }
  }
}
