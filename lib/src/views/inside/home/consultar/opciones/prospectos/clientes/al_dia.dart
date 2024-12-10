import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../../../../utils/flushbar.dart';
import '../../../../../../../controller/dataBase/operations.dart';
import '../../../../../../../models/usuario/persona_model.dart';
import '../info_contacto.dart';

class AlDia extends StatefulWidget {
  //todo FORMATO
  //todo  {
  //todo    "tipo": 1 o 2 => 1 = Renovar, 2 = Por calificacion
  //todo    "seleccion": (Renovar: (1. 1 cuota, 2. Cuota 50%). Calificacion: (1. AAA, 2. AA, 3. A, 4.B, 5.C) )
  //todo  }
  final ValueNotifier<String> searchNotifier;
  ValueNotifier<Map<String, dynamic>>? filtro;
  AlDia({super.key, required this.searchNotifier, this.filtro});

  @override
  State<AlDia> createState() => _AlDiaState();
}

class _AlDiaState extends State<AlDia> {
  final op = Operations();
  List<PersonaModel> contacts = [];
  List<PersonaModel> cacheContacts = [];
  bool showSector = false;
  List<Contact> phoneContacts = [];

  Future<void> getData() async {
    var data = await op.obtenerClientesAlDia();

    setState(() => contacts = data);
    setState(() => cacheContacts = contacts);
  }

  @override
  void initState() {
    super.initState();
    if (widget.filtro != null) {}
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return cacheContacts.isEmpty
        ? const Center(
            child: Text("No tiene clientes."),
          )
        : ValueListenableBuilder(
            valueListenable: widget.searchNotifier,
            builder: (context, searchQuery, _) {
              buildSearchList(widget.searchNotifier.value);
              return ListView.builder(
                  itemCount: cacheContacts.length,
                  itemBuilder: (context, index) {
                    String initial = "";
                    if (cacheContacts[index].nombres != "") {
                      initial = cacheContacts[index].nombres!.split("")[0];
                      return Slidable(
                        key: UniqueKey(),
                        startActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          SlidableAction(
                            onPressed: (_) async {
                              List<Contact>? contact = phoneContacts
                                  .where((c) =>
                                      c.phones.isNotEmpty &&
                                      c.phones[0].number.toString() ==
                                          cacheContacts[index]
                                              .celular1
                                              .toString())
                                  .toList();

                              if (contact.isNotEmpty) {
                                await FlutterContacts.updateContact(Contact(
                                    id: contact[0].id,
                                    displayName: cacheContacts[index].nombres,
                                    name: Name(
                                        first: cacheContacts[index].nombres),
                                    phones: [
                                      Phone(
                                          cacheContacts[index].celular1 ?? ""),
                                      Phone(
                                          cacheContacts[index].celular2 ?? ""),
                                    ],
                                    addresses: [
                                      Address(
                                          cacheContacts[index].direccion ?? "")
                                    ],
                                    organizations: [
                                      Organization(
                                          company: cacheContacts[index]
                                                  .empresaNegocio ??
                                              "")
                                    ],
                                    emails: [
                                      Email(cacheContacts[index].mail ?? "")
                                    ]));

                                scaffoldMessenger(context,
                                    "Se actualizó un contacto existente en su dispositivo",
                                    icon: const Icon(Icons.check,
                                        color: Colors.green));
                              } else {
                                await FlutterContacts.insertContact(Contact(
                                    name: Name(
                                        first: cacheContacts[index].nombres),
                                    displayName: cacheContacts[index].nombres,
                                    phones: [
                                      Phone(
                                          cacheContacts[index].celular1 ?? ""),
                                      Phone(
                                          cacheContacts[index].celular2 ?? ""),
                                    ],
                                    addresses: [
                                      Address(
                                          cacheContacts[index].direccion ?? "")
                                    ],
                                    organizations: [
                                      Organization(
                                          company: cacheContacts[index]
                                                  .empresaNegocio ??
                                              "")
                                    ],
                                    emails: [
                                      Email(contacts[index].mail ?? "")
                                    ]));
                                scaffoldMessenger(context,
                                    "Se guardo un contacto nuevo en su dispositivo",
                                    icon: const Icon(Icons.check,
                                        color: Colors.green));
                              }
                            },
                            icon: Icons.save_alt_rounded,
                            backgroundColor: Colors.blue,
                          ),
                          // SlidableAction(
                          //   backgroundColor: Colors.red,
                          //   onPressed: (_) async {
                          //     await op
                          //         .eliminarProspecto(
                          //             contacts[index].idProspecto!)
                          //         .then((value) {
                          //       debugPrint("eliminado?: $value");
                          //       if (value == 1) {
                          //         scaffoldMessenger(
                          //             context,
                          //             "Prospecto eliminado correctamente",
                          //             const Icon(Icons.check,
                          //                 color: Colors.green));
                          //       } else {
                          //         scaffoldMessenger(
                          //             context,
                          //             "No se eliminó el prospecto, inténtelo más tarde",
                          //             const Icon(Icons.error,
                          //                 color: Colors.red));
                          //       }
                          //       getData();
                          //     });
                          //   },
                          //   icon: Icons.delete,
                          //   foregroundColor: Colors.white,
                          // )
                        ]),
                        child: InkWell(
                          onTap: () async => await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => InfoContacto(
                                        prospecto: cacheContacts[index],
                                        isClient: true,
                                      ))).then((_) => getData()),
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
                                      borderRadius: BorderRadius.circular(100)),
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
                                          margin:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                            getNamePros(
                                                cacheContacts[index].nombres,
                                                cacheContacts[index].apellidos),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        if (showSector)
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 15),
                                            width: double.infinity,
                                            child: Text(
                                              cacheContacts[index].sector ?? "",
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                          )
                                      ],
                                    )),
                                /*Container(
                                            height: 10,
                                            width: 0.5,
                                            color: Colors.black),
                                        Expanded(
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
                  });
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

  List<PersonaModel> buildSearchList(String value) {
    List<PersonaModel> newList = [];

    if (value.isNotEmpty) {
      showSector = true;
      var filter = contacts
          .where((e) =>
              (e.nombres.toLowerCase().contains(value.toLowerCase())) ||
              (e.apellidos.toLowerCase().contains(value.toLowerCase())) ||
              (e.sector!.toLowerCase().contains(value.toLowerCase())))
          .toList();

      newList = filter;
      cacheContacts = newList;
    } else {
      showSector = false;
      cacheContacts = contacts;
      newList = contacts;
    }

    return newList;
  }
}
