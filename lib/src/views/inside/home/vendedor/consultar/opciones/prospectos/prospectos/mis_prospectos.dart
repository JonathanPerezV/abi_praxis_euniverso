import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/prospectos/agregar_prospecto.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/prospectos/info_contacto.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/textFields/input_text_fields.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../utils/app_bar.dart';
import '../../../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../../../../../lateralMenu/drawer_menu.dart';

class MisProspectos extends StatefulWidget {
  const MisProspectos({super.key});

  @override
  State<MisProspectos> createState() => _MisProspectosState();
}

class _MisProspectosState extends State<MisProspectos> {
  final op = Operations();
  final _searchController = TextEditingController();

  List<PersonaModel> contacts = [];
  List<PersonaModel> cacheContacts = [];

  List<Contact> phoneContacts = [];
  bool hasPermission = false;
  bool showSector = false;

  final _sckey = GlobalKey<ScaffoldState>();

  Future<void> getData() async {
    var data = await op.obtenerProspectos();

    setState(() => contacts = data);
    setState(() => cacheContacts = contacts);
  }

  Future<void> permissionContacts() async {
    var res = await FlutterContacts.requestPermission();

    setState(() => hasPermission = res);

    if (res) {
      final allContacts =
          await FlutterContacts.getContacts(withProperties: true);

      setState(() {
        phoneContacts = allContacts;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    permissionContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(builder: (context, form, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        key: _sckey,
        appBar: MyAppBar(key: _sckey).myAppBar(context: context),
        drawer: DrawerMenu(inicio: false),
        body: Column(
          children: [
            header("Prospectos", AbiPraxis.prospectos, context: context),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    child: options(),
                  ),
                  /*Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 15, bottom: 15),
                      child: FloatingActionButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        onPressed: () async => await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => AgregarEditarProspecto(
                                      edit: false,
                                      isClient: false,
                                    ))).then((_) async => getData()),
                        backgroundColor: Colors.black,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget options() => Column(
        children: [
          const SizedBox(height: 10),
          InputTextFields(
              controlador: _searchController,
              onChanged: (value) {
                setState(() => buildSearchList(value));
              },
              inputBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              icon: const Icon(Icons.search),
              placeHolder: "Busqueda por nombre o sector",
              nombreCampo: "Buscar",
              accionCampo: TextInputAction.done),
          Expanded(
              child: cacheContacts.isEmpty
                  ? const Center(
                      child: Text("No tiene prospectos."),
                    )
                  : ListView.builder(
                      itemCount: cacheContacts.length,
                      itemBuilder: (context, index) {
                        String initial = "";
                        if (cacheContacts[index].nombres != "") {
                          initial = cacheContacts[index].nombres.split("")[0];
                          return Slidable(
                            key: UniqueKey(),
                            startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  /*if (hasPermission)
                                    SlidableAction(
                                      onPressed: (_) async {
                                        List<Contact>? contact = phoneContacts
                                            .where((c) =>
                                                c.phones.isNotEmpty &&
                                                c.phones[0].number.toString() ==
                                                    cacheContacts[index]
                                                        .celular
                                                        .toString())
                                            .toList();

                                        if (contact.isNotEmpty) {
                                          await FlutterContacts.updateContact(
                                              Contact(
                                                  id: contact[0].id,
                                                  displayName:
                                                      cacheContacts[index]
                                                          .nombres,
                                                  name: Name(
                                                      first:
                                                          cacheContacts[index]
                                                              .nombres),
                                                  phones: [
                                                Phone(cacheContacts[index]
                                                    .celular),
                                                Phone(cacheContacts[index]
                                                    .celular2),
                                              ],
                                                  addresses: [
                                                Address(cacheContacts[index]
                                                    .direccion)
                                              ],
                                                  organizations: [
                                                Organization(
                                                    company:
                                                        cacheContacts[index]
                                                            .empresa)
                                              ],
                                                  emails: [
                                                Email(cacheContacts[index].mail)
                                              ]));

                                          scaffoldMessenger(
                                              context,
                                              "Se actualizó un contacto existente en su dispositivo",
                                              const Icon(Icons.check,
                                                  color: Colors.green));
                                        } else {
                                          await FlutterContacts.insertContact(
                                              Contact(
                                                  name: Name(
                                                      first:
                                                          cacheContacts[index]
                                                              .nombres),
                                                  displayName:
                                                      cacheContacts[index]
                                                          .nombres,
                                                  phones: [
                                                Phone(cacheContacts[index]
                                                    .celular),
                                                Phone(cacheContacts[index]
                                                    .celular2),
                                              ],
                                                  addresses: [
                                                Address(cacheContacts[index]
                                                    .direccion)
                                              ],
                                                  organizations: [
                                                Organization(
                                                    company:
                                                        cacheContacts[index]
                                                            .empresa)
                                              ],
                                                  emails: [
                                                Email(cacheContacts[index].mail)
                                              ]));
                                          scaffoldMessenger(
                                              context,
                                              "Se guardo un contacto nuevo en su dispositivo",
                                              const Icon(Icons.check,
                                                  color: Colors.green));
                                        }
                                      },
                                      icon: Icons.save_alt_rounded,
                                      backgroundColor: Colors.blue,
                                    ),*/
                                  SlidableAction(
                                    backgroundColor: Colors.red,
                                    onPressed: (_) async {
                                      await op
                                          .eliminarProspecto(
                                              cacheContacts[index].idAux!)
                                          .then((value) {
                                        debugPrint("eliminado?: $value");
                                        if (value == 1) {
                                          scaffoldMessenger(context,
                                              "Prospecto eliminado correctamente",
                                              icon: const Icon(Icons.check,
                                                  color: Colors.green));
                                        } else {
                                          scaffoldMessenger(context,
                                              "No se eliminó el prospecto, inténtelo más tarde",
                                              icon: const Icon(Icons.error,
                                                  color: Colors.red));
                                        }
                                        getData();
                                      });
                                    },
                                    icon: Icons.delete,
                                    foregroundColor: Colors.white,
                                  )
                                ]),
                            child: InkWell(
                              onTap: () async => await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => InfoContacto(
                                              prospecto: cacheContacts[index])))
                                  .then((_) => getData()),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20, right: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade800,
                                                blurRadius: 1.1,
                                                offset: const Offset(0, 0),
                                                spreadRadius: 0.5)
                                          ],
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Text(
                                        initial,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(
                                                  left: 15),
                                              child: Text(
                                                //"${contacts[index].nombres.split(" ")[0]} ${contacts[index].nombres.split(" ")[2]}",
                                                // "${cacheContacts[index].nombres.split(" ")[0]} ${cacheContacts[index].nombres.split(" ")[2] ?? ""}",
                                                getNamePros(
                                                    cacheContacts[index]
                                                        .nombres
                                                        .toUpperCase(),
                                                    cacheContacts[index]
                                                        .apellidos
                                                        .toUpperCase()),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            if (showSector)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 15),
                                                width: double.infinity,
                                                child: Text(
                                                  cacheContacts[index].sector ??
                                                      "",
                                                  style: const TextStyle(
                                                      fontSize: 11),
                                                ),
                                              )
                                          ],
                                        )),
                                    /*Container(
                                        height: 10,
                                        width: 0.5,
                                        color: Colors.black),*/
                                    /*Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          (contacts[index].sector ?? "")
                                              .toLowerCase(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),*/
                                    const Icon(Icons.navigate_next_outlined)
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }))
        ],
      );

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

  List<PersonaModel> buildSearchList(String value) {
    List<PersonaModel> newList = [];

    if (value.isNotEmpty) {
      setState(() => showSector = true);
      var filter = contacts
          .where((e) =>
                  //(e.sector!.toLowerCase().contains(value.toLowerCase())) ||
                  (e.nombres.toLowerCase().contains(value.toLowerCase())) ||
                  (e.apellidos.toLowerCase().contains(value
                      .toLowerCase())) /*||
              (e.sector!.toLowerCase().contains(value.toLowerCase()))*/
              )
          .toList();

      setState(() => newList = filter);
      setState(() => cacheContacts = newList);
    } else {
      setState(() => showSector = false);
      setState(() => cacheContacts = contacts);
      setState(() => newList = contacts);
    }

    return newList;
  }
}
