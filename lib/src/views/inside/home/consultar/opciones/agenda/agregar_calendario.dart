// ignore_for_file: must_be_immutable, missing_required_param, use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:abi_praxis_app/src/controller/aws/operaciones/ws_agenda.dart';
import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:abi_praxis_app/main.dart';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/calendar_model.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/categorias_agenda_model.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/correo_model.dart';
import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/agenda/tabs/info_evento.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/prospectos/agregar_prospecto.dart';
import 'package:abi_praxis_app/utils/alerts/and_alert.dart';
import 'package:abi_praxis_app/utils/alerts/ios_alert.dart';
import 'package:abi_praxis_app/utils/buttons.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:abi_praxis_app/utils/loading.dart';
import 'package:mobkit_calendar/mobkit_calendar.dart';
import 'package:provider/provider.dart';
import '../../../../../../../utils/geolocator/geolocator.dart';
import '../../../../../../../utils/list/lista_agenda.dart';
import '../../../../../../../utils/responsive.dart';
import '../../../../../../models/calendarEvento/event.dart' as evn;
import 'package:flutter/material.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:abi_praxis_app/utils/textFields/input_text_form_fields.dart';
import 'package:abi_praxis_app/utils/util_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_search/textfield_search.dart';

class EventEditingPage extends StatefulWidget {
  evn.Event? event;
  List<MobkitCalendarAppointmentModel>? eventList;
  DateTime? startDate;
  EventEditingPage({Key? key, this.event, this.startDate, this.eventList})
      : super(key: key);

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final key = GlobalKey<ScaffoldState>();
  GlobalKey personKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  bool enableTextField = false;
  late Timer _timer;
  final wsAg = WSAgenda();

  //final webServiceEventos = WebServiceEventos();

  DateTime? fromDate;
  late ValueNotifier<DateTime?> toDate;

  final iosAlert = IosAlert();
  final andAlert = AndroidAlert();

  int? idUser;
  int? idPromotor;
  int? idPersona;

  List<String> listMails = [];

  final txtPersonController = TextEditingController();
  final txtEmpresaController = TextEditingController();
  final txtGestionController = TextEditingController();
  final controllerTitulo = TextEditingController();
  final controllerDescription = TextEditingController();
  final txtUbicacion = TextEditingController();
  final txtMail = TextEditingController();
  final txtAditionalMail = TextEditingController();
  final _controller = CustomPopupMenuController();
  final txtObservacion = TextEditingController();

  List<PersonaModel> contactos = [];

  bool showContacts = false;
  bool allDay = false;

  List<PersonaModel> _searchList = [];

  AgendaCatModel? categorySelected;
  int idCategory = 0;

  AgendaProductModel? productSelected;
  int idProduct = 0;

  Map<String, dynamic>? subProdSelected;
  int idSubProduct = 0;

  int minMax = 30;
  int hourMax = 0;

  bool enable = false;
  String? latitud;
  String? longitud;

  String celular = "";

  Map<String, dynamic>? medioSelected;
  int idMedio = 0;

  /*List<Map<String, dynamic>> resultado = [
    {"nombre": "Llenó solicitud", "id": 1},
    {"nombre": "Analizará la decisión", "id": 2},
    {"nombre": "No desea", "id": 3},
    {"nombre": "Coordinar otra visita", "id": 4}
  ];
  Map<String, dynamic>? resultadoSelected;
  int idResultado = 0;*/

  List<Map<String, dynamic>> optionsAddress = [];
  Map<String, dynamic>? addressSelected;

  Map<String, dynamic>? gestionSelected;
  int idGestion = 0;

  Future<void> validateProspecto() async {
    final db = Operations();

    final res = await db.obtenerProspectosClientes();

    if (res.isNotEmpty) {
      setState(() => enable = true);
    } else {
      setState(() => enable = false);
    }
  }

  void obtenerProspectosClientes() async {
    final allContacts = await op.obtenerProspectosClientes();

    setState(() => contactos = allContacts);
    setState(() => _searchList = allContacts);
  }

  @override
  void initState() {
    super.initState();
    setState(() => loading = true);
    obtenerIdUser();
    obtenerProspectosClientes();
    validateProspecto();
    if (widget.startDate != null) {
      final startDate = widget.startDate;
      setState(() {
        fromDate = DateTime.now().minute <= 30
            ? DateTime(startDate!.year, startDate.month, startDate.day,
                DateTime.now().hour, 30)
            : DateTime(startDate!.year, startDate.month, startDate.day,
                DateTime.now().add(const Duration(hours: 1)).hour, 00);

        toDate = ValueNotifier(fromDate!.add(Duration(minutes: minMax)));
      });
    } else {
      var date = DateTime.now();
      if (date.minute <= 30) {
        setState(() => fromDate =
            DateTime(date.year, date.month, date.day, date.hour, 30));
      } else {
        setState(() => fromDate = DateTime(date.year, date.month, date.day,
            date.add(const Duration(hours: 1)).hour, 00));
      }

      toDate = ValueNotifier(fromDate!.add(Duration(minutes: minMax)));
    }
    setState(() => loading = false);
  }

  Future<void> obtenerIdUser() async {
    final pfrc = UserPreferences();
    var data = await pfrc.getIdUser();
    var data2 = await pfrc.getIdPromotor();
    setState(() {
      idUser = data;
      idPromotor = data2;
    });
  }

  @override
  void dispose() {
    controllerTitulo.dispose();
    toDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => showContacts = false);
        FocusScope.of(context).unfocus();
      },
      child: Consumer<FormProvider>(builder: (context, form, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          key: key,
          appBar: MyAppBar(key: key).myAppBar(context: context),
          drawer: DrawerMenu(),
          body: listaOpciones(),
        );
      }),
    );
  }

  Widget listaOpciones() {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      header("Agregar Evento", AbiPraxis.evento, context: context),
      Expanded(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [form()],
              ),
            ),
            if (loading) loadingWidget(),
          ],
        ),
      ),
    ]);
  }

  Widget form() => SizedBox(
        width: double.infinity,
        // margin: EdgeInsets.only(left: 10, right: 10),
        child: Form(
            key: formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          if (!enable) {
                            scaffoldMessenger(context,
                                "No ha registrado prospectos, por favor diríjase a la sección de prospectos y registre uno",
                                icon: const Icon(Icons.warning,
                                    color: Colors.yellow),
                                seconds: 4,
                                trailing: IconButton(
                                    onPressed: () async => await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    AgregarEditarProspecto(
                                                        isClient: false,
                                                        edit: false)))
                                        .then((_) => validateProspecto()),
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Colors.white,
                                    )));
                          }
                        },
                        child: SizedBox(
                          height: 60,
                          key: personKey,
                          child: InputTextFormFields(
                            validacion: (value) =>
                                value!.isEmpty ? "Campo Obligatorio*" : null,
                            habilitado: enable,
                            controlador: txtPersonController,
                            capitalization: TextCapitalization.words,
                            accionCampo: TextInputAction.next,
                            onChanged: (value) {
                              if (value!.isNotEmpty) {
                                setState(() => showContacts = true);
                                buildSearchList(value);
                              } else {
                                setState(() => _searchList = contactos);
                                setState(() => showContacts = false);
                              }
                            },
                            nombreCampo: "Persona",
                            placeHolder: "Nombre del contacto",
                            prefixIcon:
                                const Icon(AbiPraxis.persona_empresa, size: 20),
                            icon: txtPersonController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () => setState(() {
                                          showContacts = false;
                                          txtPersonController.clear();
                                          FocusScope.of(context).unfocus();
                                        }),
                                    icon: const Icon(Icons.clear))
                                : null,
                          ),
                        ),
                      ),
                      InputTextFormFields(
                        controlador: txtEmpresaController,
                        capitalization: TextCapitalization.sentences,
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Negocio / Empresa",
                        prefixIcon:
                            const Icon(AbiPraxis.persona_empresa, size: 20),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButtonFormField<AgendaCatModel>(
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Seleccione una categoría",
                                prefixIcon: Icon(AbiPraxis.prodcuto_categoria),
                                label: Text("Categoría del Producto")),
                            isExpanded: true,
                            value: categorySelected,
                            items: categorias
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.nombreCategoria),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                productSelected = null;
                                categorySelected = value;
                                idCategory = value!.idCategoria!;
                              });
                            }),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButtonFormField<AgendaProductModel>(
                            iconDisabledColor: Colors.grey,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Seleccione un producto",
                                prefixIcon: Icon(AbiPraxis.prodcuto_categoria),
                                label: Text("Producto")),
                            isExpanded: true,
                            value: productSelected,
                            items: categorySelected != null
                                ? productos
                                    .where((element) =>
                                        element.idCategoria ==
                                        categorySelected!.idCategoria)
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.nombreProducto),
                                        ))
                                    .toList()
                                : [],
                            onChanged: (value) {
                              setState(() {
                                productSelected = value;
                                idProduct = value!.idProducto!;
                                subProdSelected = null;
                              });
                            }),
                      ),
                      const SizedBox(height: 15),
                      if (productSelected != null &&
                          productSelected!.idCategoria == 4) ...[
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButtonFormField<Map<String, dynamic>>(
                              iconDisabledColor: Colors.grey,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText: "Seleccione el plan",
                                  prefixIcon:
                                      Icon(AbiPraxis.prodcuto_categoria),
                                  label: Text("Plan")),
                              isExpanded: true,
                              value: subProdSelected,
                              items: productSelected != null
                                  ? subProductos
                                      .where((element) =>
                                          element["id_prod"] ==
                                          productSelected!.idProducto)
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e["nombre"]),
                                          ))
                                      .toList()
                                  : [],
                              onChanged: (value) {
                                setState(() {
                                  subProdSelected = value!;
                                  idSubProduct = value["idsub_prod"]!;
                                });
                              }),
                        ),
                        const SizedBox(height: 15),
                      ],
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButtonFormField<Map<String, dynamic>>(
                            iconDisabledColor: Colors.grey,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Seleccione un medio",
                                prefixIcon: Icon(AbiPraxis.medio_contacto),
                                label: Text("Medio de contacto")),
                            isExpanded: true,
                            value: medioSelected,
                            items: medios
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e["nombre"]),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                medioSelected = value;
                                idMedio = value!["id"];
                              });
                            }),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButtonFormField<Map<String, dynamic>>(
                            iconDisabledColor: Colors.grey,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Seleccione la gestion",
                                prefixIcon: Icon(AbiPraxis.gestion),
                                label: Text("Gestión")),
                            isExpanded: true,
                            value: gestionSelected,
                            items: gestiones
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e["nombre"]),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                gestionSelected = value;
                                idGestion = value!["id"];
                              });
                            }),
                      ),
                      const SizedBox(height: 15),
                      showDate(),
                      const SizedBox(height: 15),
                      
                      if (optionsAddress.isNotEmpty)
                        Row(
                        children: [
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: DropdownButtonFormField<
                                        Map<String, dynamic>>(
                                    value: addressSelected,
                                    decoration: const InputDecoration(
                                        label: Text("Ubicación"),
                                        prefixIcon:
                                            Icon(Icons.location_on_outlined),
                                        hintText: "Ubicación"),
                                    items: optionsAddress.map((e) {
                                      return DropdownMenuItem<
                                              Map<String, dynamic>>(
                                          value: e,
                                          child: Row(
                                            children: [
                                              Icon(e["icon"]),
                                              const SizedBox(width: 10),
                                              Text(e["name"] != ""
                                                  ? e["name"]
                                                  : e["address"]),
                                            ],
                                          ));
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() => addressSelected = value);
                                      if (addressSelected!["name"] != "Otro") {
                                        setState(() {
                                          enableTextField = false;
                                          txtUbicacion.text =
                                              addressSelected!["address"];
                                          latitud = addressSelected!["latitud"];
                                          longitud =
                                              addressSelected!["longitud"];
                                        });
                                      } else {
                                        setState(() {
                                          enableTextField = true;
                                          txtUbicacion.clear();
                                          latitud = "";
                                          longitud = "";
                                        });
                                      }
                                    }),
                              ),
                            ),

                          /*Expanded(
                            child: InputTextFormFields(
                                controlador: txtUbicacion,
                                prefixIcon: const Icon(Icons.place),
                                accionCampo: TextInputAction.next,
                                nombreCampo: "Ubicación",
                                placeHolder:
                                    "Ingrese la ubicación de la reunión"),
                          ),*/
                          if (latitud != "" && !enableTextField)
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: latitud != "" && longitud != ""
                                  ? GestureDetector(
                                      onTap: () async {
                                        setState(() => loading = true);

                                        var res = await GeolocatorConfig()
                                            .requestPermission(context);

                                        if (res != null) {
                                          var loc = await Geolocator
                                              .getCurrentPosition();

                                          setState(() {
                                            latitud = loc.latitude.toString();
                                            longitud = loc.longitude.toString();
                                          });

                                          debugPrint("$latitud, $longitud");

                                          scaffoldMessenger(context,
                                              "Se han guardado las coordenadas de tu ubicación actual.",
                                              icon: const Icon(Icons.check,
                                                  color: Colors.green));
                                        } else {
                                          scaffoldMessenger(context,
                                              "Ocurrió un error, no hemos podido guardar tu ubicación actual",
                                              icon: const Icon(Icons.error,
                                                  color: Colors.red));
                                        }

                                        setState(() => loading = false);
                                      },
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.green,
                                      ),
                                    )
                                  : const Icon(Icons.add_location_alt),
                            ),
                        ],
                      ),
                      if (enableTextField || optionsAddress.isEmpty)
                        Column(
                          children: [
                            const SizedBox(height: 25),
                            Row(
                              children: [
                                Expanded(
                                  child: InputTextFormFields(
                                      controlador: txtUbicacion,
                                      prefixIcon: const Icon(
                                          Icons.location_on_outlined),
                                      accionCampo: TextInputAction.next,
                                      nombreCampo: "Ubicación",
                                      placeHolder:
                                          "Ingrese la ubicación de la reunión"),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        setState(() => loading = true);

                                        var res = await GeolocatorConfig()
                                            .requestPermission(context);

                                        if (res != null) {
                                          var loc = await Geolocator
                                              .getCurrentPosition();

                                          setState(() {
                                            latitud = loc.latitude.toString();
                                            longitud = loc.longitude.toString();
                                          });

                                          debugPrint("$latitud, $longitud");

                                          scaffoldMessenger(context,
                                              "Se han guardado las coordenadas de tu ubicación actual.",
                                              icon: const Icon(Icons.check,
                                                  color: Colors.green));
                                        } else {
                                          scaffoldMessenger(context,
                                              "Ocurrió un error, no hemos podido guardar tu ubicación actual",
                                              icon: const Icon(Icons.error,
                                                  color: Colors.red));
                                        }

                                        setState(() => loading = false);
                                      },
                                      child: Icon(
                                        latitud != "" && longitud != ""
                                            ? Icons.location_on
                                            : Icons.add_location_alt,
                                        color: latitud != "" && longitud != ""
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      /* const SizedBox(height: 35),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          width: double.infinity,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: const Text(
                            "+ Subir documento",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),*/
                      const SizedBox(height: 25),
                      InputTextFormFields(
                          controlador: txtMail,
                          prefixIcon: const Icon(Icons.mail),
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Correo prospecto para notificar",
                          placeHolder: "Ingrese el correo del prospecto"),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () => showModalMails(),
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 13),
                                  child: Icon(
                                    Icons.mail,
                                    color: Colors.grey.shade800,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text(
                                "Correos adicionales para notificar (${listMails.length})",
                                style: const TextStyle(fontSize: 15),
                              ))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      InputTextFormFields(
                          prefixIcon: const Icon(
                            AbiPraxis.observaciones,
                            size: 20,
                          ),
                          maxLines: 3,
                          controlador: txtObservacion,
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Observaciones",
                          placeHolder:
                              "Ingrese las observaciones correspondientes"),
                      /*const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButtonFormField<Map<String, dynamic>>(
                            iconDisabledColor: Colors.grey,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Seleccione el resultado",
                                prefixIcon: Icon(KmelloIcons.resultado_reunion),
                                label: Text("Resultado de la reunión")),
                            isExpanded: true,
                            value: resultadoSelected,
                            items: resultado
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e["nombre"]),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                resultadoSelected = value;
                                idMedio = value!["id"];
                              });
                            }),
                      ),*/
                      const SizedBox(height: 25),
                      nextButton(
                          onPressed: () => validateButton(),
                          text: "Guardar evento",
                          width: 150),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
                Align(
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
                          margin: const EdgeInsets.only(
                              top: 62, left: 10, right: 10),
                          width: double.infinity, //250,
                          //height: 225,
                          child: Material(
                            borderRadius: BorderRadius.circular(15),
                            elevation: 4,
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: _searchList.length,
                                  itemBuilder: (itemBuilder, i) {
                                    return InkWell(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          idPersona = _searchList[i].idPersona;
                                          txtPersonController.text =
                                              getNamePros(
                                                  _searchList[i].nombres!,
                                                  _searchList[i].apellidos!);
                                          txtEmpresaController.text =
                                              _searchList[i].empresaNegocio ??
                                                  "";
                                          showContacts = false;
                                          celular =
                                              _searchList[i].celular1 ?? "";

                                          setState(() {
                                            optionsAddress.add({
                                              "icon": Icons.house,
                                              "name": "Domicilio",
                                              "address":
                                                  _searchList[i].direccion
                                            });
                                          });
                                          if (_searchList[i].latitud != "") {
                                            var dom = optionsAddress
                                                .where((e) => e
                                                    .containsValue("Domicilio"))
                                                .toList();

                                            setState(() => dom[0].addAll({
                                                  "latitud":
                                                      _searchList[i].latitud,
                                                  "longitud":
                                                      _searchList[i].longitud
                                                }));

                                            debugPrint("mapa: ${dom[0]}");
                                          } else {
                                            setState(() {
                                              optionsAddress.removeWhere((e) =>
                                                  e.containsValue("Domicilio"));
                                            });
                                          }

                                          txtMail.text =
                                              _searchList[i].mail ?? "";

                                          setState(() {
                                            optionsAddress.add({
                                              "icon": Icons.work,
                                              "name": "Trabajo",
                                              "address": _searchList[i]
                                                  .direccionTrabajo
                                            });
                                          });

                                          if (_searchList[i].latitudTrabajo !=
                                              "") {
                                            var dom = optionsAddress
                                                .where((e) =>
                                                    e.containsValue("Trabajo"))
                                                .toList();

                                            setState(() => dom[0].addAll({
                                                  "latitud": _searchList[i]
                                                      .latitudTrabajo,
                                                  "longitud": _searchList[i]
                                                      .longitudTrabajo
                                                }));

                                            debugPrint("mapa: ${dom[0]}");
                                          } else {
                                            setState(() {
                                              optionsAddress.removeWhere((e) =>
                                                  e.containsValue("Trabajo"));
                                            });
                                          }

                                          if ((_searchList[i].latitud != null &&
                                                  _searchList[i]
                                                      .latitud!
                                                      .isNotEmpty) ||
                                              (_searchList[i].latitudTrabajo !=
                                                      null &&
                                                  _searchList[i]
                                                      .latitudTrabajo!
                                                      .isNotEmpty)) {
                                            optionsAddress.add({
                                              "icon": Icons.location_city,
                                              "name": "Otro"
                                            });
                                          }
                                        });
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        color: Colors.white,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: /*_searchList[i].cliente == 1
                                                  ? Colors.green.shade100
                                                  : */
                                                Colors.white,
                                          ),
                                          height: 45,
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Row(
                                            children: [
                                              Text(
                                                getNamePros(
                                                        _searchList[i].nombres,
                                                        _searchList[i]
                                                            .apellidos)
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                  child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                    _searchList[i].celular1 ??
                                                        ""),
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
                ),
              ],
            )),
      );

  Widget showDate() {
    return Container(
      margin: const EdgeInsets.only(left: 23, right: 10),
      child: Column(
        children: [
          Row(
            children: [
              const Row(
                children: [
                  Icon(
                    AbiPraxis.fecha,
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Fecha",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
              Expanded(
                child: /*!allDay
                      ? */
                    Container(),
                /*: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Todo el día",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              height: 30,
                              child: FittedBox(
                                child: Switch(
                                    value: allDay,
                                    onChanged: (value) {
                                      setState(() => allDay = value);
                                      fromDate = null;
                                      toDate.value = null;
                                    }),
                              ),
                            )
                          ],
                        )*/
              ),
              allDay
                  ? InkWell(
                      onTap: () => setState(() => allDay = !allDay),
                      child: const Icon(Icons.arrow_drop_down))
                  : AbsorbPointer(
                      absorbing: allDay,
                      child: CustomPopupMenu(
                        menuBuilder: () {
                          return Card(
                            child: Container(
                              width: 100,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () => setState(() {
                                      minMax = 15;
                                      hourMax = 0;
                                      _controller.hideMenu();
                                      //configurationTime();
                                      _updateEndTime(Duration(minutes: minMax));
                                    }),
                                    child: Container(
                                      height: 45,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "15 min",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  divider(false, color: Colors.grey),
                                  InkWell(
                                    onTap: () => setState(() {
                                      minMax = 30;
                                      hourMax = 0;
                                      _controller.hideMenu();
                                      //configurationTime();\
                                      _updateEndTime(Duration(minutes: minMax));
                                    }),
                                    child: Container(
                                      height: 45,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "30 min",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  divider(false, color: Colors.grey),
                                  InkWell(
                                    onTap: () => setState(() {
                                      minMax = 0;
                                      hourMax = 1;
                                      _controller.hideMenu();
                                      //configurationTime();
                                      _updateEndTime(
                                          const Duration(minutes: 60));
                                    }),
                                    child: Container(
                                      height: 45,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "1h",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        pressType: PressType.singleClick,
                        verticalMargin: -10,
                        controller: _controller,
                        child: Icon(
                          Icons.timelapse,
                          color: allDay ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 10),
          allDay
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Row(children: [
                          Expanded(child: Container()),
                          /*Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Todo el día",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  const SizedBox(width: 3),
                                  SizedBox(
                                    height: 25,
                                    child: FittedBox(
                                      child: Switch(
                                          value: allDay,
                                          onChanged: (value) {
                                            setState(() => allDay = value);
                                            fromDate = null;
                                            toDate.value = null;
                                          }),
                                    ),
                                  )
                                ],
                              )),*/
                          const Expanded(
                              flex: 1,
                              child: Center(
                                  child: Text(
                                "Hora inicio",
                                style: TextStyle(fontSize: 17),
                              )))
                        ])),
                    Container(
                      width: 1,
                      height: 10,
                      color: Colors.black,
                    ),
                    const Expanded(
                        child: Center(
                            child: Text(
                      "Hora fin",
                      style: TextStyle(fontSize: 17),
                    )))
                  ],
                ),
          allDay
              ? Container()
              : Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                          width: double.infinity,
                          height: 120,
                          child: CupertinoTheme(
                            data: const CupertinoThemeData(
                                textTheme: CupertinoTextThemeData(
                                    dateTimePickerTextStyle: TextStyle(
                                        fontSize: 14, color: Colors.black))),
                            child: CupertinoDatePicker(
                              initialDateTime: fromDate,
                              mode: CupertinoDatePickerMode.dateAndTime,
                              use24hFormat: true,
                              showDayOfWeek: false,
                              onDateTimeChanged: (DateTime? newDate) {
                                //final newList = widget.eventList;
                                if (newDate != null) {
                                  //configurationTime();
                                  setState(() => fromDate = newDate);
                                  setState(() => _updateEndTime(Duration(
                                      minutes: minMax,
                                      hours: hourMax != 0 ? hourMax : 0)));
                                  // final timeDay = newList!
                                  //     .where((element) =>
                                  //         element.appointmentStartDate.hour ==
                                  //             newDate.hour &&
                                  //         element.appointmentStartDate.minute ==
                                  //             newDate.minute &&
                                  //         element.appointmentStartDate.day ==
                                  //             newDate.day)
                                  //     .toList();

                                  // if (timeDay.isNotEmpty) {
                                  //   scaffoldMessenger(
                                  //       context,
                                  //       "Esta hora ya ha sido registrada en otra reunión",
                                  //       const Icon(Icons.error,
                                  //           color: Colors.red));
                                  // }
                                } else {}
                              },
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 120,
                      child: const VerticalDivider(
                        width: 1,
                        color: Colors.black,
                        thickness: 0.5,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: 120,
                        child: CupertinoTheme(
                          data: const CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                  dateTimePickerTextStyle: TextStyle(
                                      fontSize: 14, color: Colors.black))),
                          child: ValueListenableBuilder(
                            valueListenable: toDate,
                            builder: (context, endTime, child) {
                              return CupertinoDatePicker(
                                  key: UniqueKey(),
                                  use24hFormat: true,
                                  showDayOfWeek: false,
                                  initialDateTime: endTime,
                                  mode: CupertinoDatePickerMode.time,
                                  onDateTimeChanged: (date) {
                                    print("fecha: ${date.minute}");
                                    setState(() {
                                      toDate.value = DateTime(
                                        fromDate!.year,
                                        fromDate!.month,
                                        fromDate!.day,
                                        date.hour,
                                        date.minute,
                                      );
                                    });
                                  });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  void _updateEndTime(Duration duration) {
    setState(() {
      toDate.value = fromDate!.add(duration);
    });
  }

  void validateButton() async {
    if (!formKey.currentState!.validate()) {
      scaffoldMessenger(context, "Complete los campos para continuar",
          icon: const Icon(Icons.error, color: Colors.red));
      return;
    } else {
      final agenda = CalendarModel(
          usuarioCreacion: idUser!,
          idPersona: idPersona!,
          fotoReferencia: "",
          estado: 0,
          categoriaProducto:
              categorySelected != null ? categorySelected!.idCategoria : 0,
          gestion: gestionSelected != null ? gestionSelected!["id"] : "",
          idPromotor: idPromotor!,
          lugarReunion: txtUbicacion.text,
          medioContacto: medioSelected != null ? medioSelected!["id"] : "",
          producto: productSelected != null ? productSelected!.idProducto : 0,
          resultadoReunion: 0,
          fechaReunion: fromDate.toString(),
          horaFin:
              toDate != null ? DateFormat("HH:mm").format(toDate.value!) : "",
          horaInicio:
              fromDate != null ? DateFormat("HH:mm").format(fromDate!) : "",
          observacion: txtObservacion.text,
          plan: subProdSelected != null ? subProdSelected!["idsub_prod"] : 0,
          latitud: latitud,
          longitud: longitud);

      final listaMails = <CorreoModel>[];

      final res = await op.insertarAgenda(agenda);

      for (var mail in listMails) {
        listaMails.add(
            CorreoModel(usuarioCreacion: idUser!, correo: mail, idAgenda: res));
      }

      final correos = await op.insertCorreos(listaMails);

      debugPrint("correo #: $correos");

      setState(() => loading = true);

      if (res != 0) {
        /*scaffoldMessenger(context, "Evento creado correctamente",
            const Icon(Icons.check, color: Colors.green));*/
        Platform.isAndroid
            ? andAlert.agendaAgregada(context, () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            InfoEvento(idEvento: res, index: 2)));
              })
            : iosAlert.agendaAgregada(context, () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            InfoEvento(idEvento: res, index: 2)));
              });
      } else {
        scaffoldMessenger(context, "No se pudo crear el evento",
            icon: const Icon(Icons.error, color: Colors.red));
      }
      setState(() => loading = false);
    }
  }

  void configurationTime() {
    if (fromDate != null) {
      DateTime newDate = fromDate!
          .add(Duration(minutes: minMax, hours: minMax == 0 ? hourMax : 0));

      debugPrint("NEW TIME: ${newDate.hour}:${newDate.minute}");

      setState(() => toDate.value = newDate);
      setState(() {});
    }
  }

  void showModalMails() async {
    final rsp = Responsive.of(context);
    showModalBottomSheet(
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (builder) {
          return Stack(
            children: [
              SizedBox(
                height: rsp.hp(60),
                width: double.infinity,
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Correos Adicionales",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      divider(true, color: Colors.grey),
                      Expanded(
                        child: ListView.builder(
                            itemCount: listMails.length,
                            itemBuilder: (context, i) {
                              return Slidable(
                                  key: UniqueKey(),
                                  direction: Axis.horizontal,
                                  startActionPane: ActionPane(
                                      extentRatio: 0.35,
                                      motion: const DrawerMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (_) {
                                            Navigator.pop(context);
                                            setState(() => loading = true);
                                            setState(() =>
                                                listMails.remove(listMails[i]));

                                            scaffoldMessenger(context,
                                                "Correo eliminado de la lista",
                                                icon: const Icon(Icons.check,
                                                    color: Colors.green));
                                            setState(() => loading = false);
                                          },
                                          flex: 1,
                                          autoClose: true,
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.red,
                                          icon: Icons.delete,
                                        ),
                                      ]),
                                  child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                alignment: Alignment.centerLeft,
                                                child: Text(listMails[i])),
                                          ],
                                        ),
                                      )));
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                right: 15,
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  backgroundColor: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                    ingresarCorreo();
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              )
            ],
          );
        });
  }

  void ingresarCorreo() {
    showDialog(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, state) {
            return AlertDialog(
              title: const Text("Agregar correo"),
              content: InputTextFormFields(
                controlador: txtAditionalMail,
                nombreCampo: "Correo adicional",
                placeHolder: "Ingrese un correo electrónico",
                tipoTeclado: TextInputType.emailAddress,
              ),
              actions: [
                loading
                    ? const Center(child: Text("Agregando..."))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25))),
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.black)),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25))),
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.black)),
                              onPressed: () async {
                                Navigator.pop(context);
                                state(() => loading = true);
                                state(() {
                                  listMails.add(txtAditionalMail.text);
                                });

                                scaffoldMessenger(
                                    context, "Correo agregado correctamente",
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ));
                                state(() => loading = false);
                              },
                              child: const Text("Agregar",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white))),
                        ],
                      )
              ],
            );
          });
        }).then((value) {
      setState(() => txtAditionalMail.clear());
    });
  }

  String getNamePros(String name, String lastName) {
    final listN = name.split(" ");
    final listA = lastName.split(" ");
    String apellidos = "";

    if (listA.length > 2) {
      apellidos = "${listA[0]} ${listA[1]}";
    } else {
      apellidos = listA[0];
    }

    return "${listN[0]} $apellidos";
  }

  void buildSearchList(text) {
    if (text != "") {
      final list = contactos
          .where((element) => element.nombres!
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
}
