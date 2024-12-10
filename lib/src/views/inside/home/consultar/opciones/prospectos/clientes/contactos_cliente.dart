import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/models/usuario/contactos/contactos_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../../utils/flushbar.dart';
import '../../../../../../../../utils/header_container.dart';

class ContactosCliente extends StatefulWidget {
  int idTitular;
  ContactosCliente({super.key, required this.idTitular});

  @override
  State<ContactosCliente> createState() => _ContactosClienteState();
}

class _ContactosClienteState extends State<ContactosCliente> {
  final op = Operations();
  List<ContactosPersonaModel> contactos = [];
  String? celularGarante;
  String? celular2Garante;
  String? direccionGarante;
  String? celularConyuge;
  String? celular2Conyuge;

  Color grey = Colors.grey;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var res = await op.obtenerContactoXtitular(widget.idTitular);

    //tipo contacto: 1- Conyuge | 2- Garante | 3- Conyuge Garante
    if (res.isNotEmpty) {
      setState(() => contactos = res);
      for (var contacto in res) {
        var per = await op.obtenerPersona(contacto.idPersona);
        if (per != null) {
          if (contacto.tipoContacto == 1) {
            setState(() {
              celularConyuge = per.celular1;
              celular2Conyuge = per.celular2;
            });
          } else if (contacto.tipoContacto == 2) {
            setState(() {
              celularGarante = per.celular1;
              celular2Garante = per.celular2;
              direccionGarante = per.direccion;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return contactos.isEmpty
        ? const Center(
            child: Text("No tiene contactos registrados."),
          )
        : Column(
            children: [
              HeaderContainer(
                borderColor: Colors.grey.shade400,
                margin_container: const EdgeInsets.only(left: 20, right: 20),
                height_container: 65,
                body: Row(
                  children: [
                    const SizedBox(width: 15),
                    Icon(Icons.phone_iphone_outlined, color: grey),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        celularConyuge ?? "Celular no asignado",
                        style: TextStyle(
                          color: grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: celularConyuge != null
                            ? () async => await llamar(celularConyuge)
                            : null,
                        icon: const Icon(Icons.phone)),
                    const SizedBox(width: 10)
                  ],
                ),
                has_header: false,
                has_title: true,
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      alignment: Alignment.center,
                      width: 140,
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 35, top: 8),
                      child: Text(
                        "Celular Cónyuge",
                        style: TextStyle(
                          color: grey,
                          fontSize: 17,
                        ),
                      )),
                ),
              ),
              HeaderContainer(
                borderColor: Colors.grey.shade400,
                margin_container: const EdgeInsets.only(left: 20, right: 20),
                height_container: 65,
                body: Row(
                  children: [
                    const SizedBox(width: 15),
                    Icon(Icons.phone_iphone_outlined, color: grey),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        celular2Conyuge ?? "Celular no asignado",
                        style: TextStyle(
                          color: grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: celular2Conyuge != null
                            ? () async => await llamar(celular2Conyuge)
                            : null,
                        icon: const Icon(Icons.phone)),
                    const SizedBox(width: 10)
                  ],
                ),
                has_header: false,
                has_title: true,
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      alignment: Alignment.center,
                      width: 150,
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 35, top: 8),
                      child: Text(
                        "Celular Cónyuge 2",
                        style: TextStyle(
                          color: grey,
                          fontSize: 17,
                        ),
                      )),
                ),
              ),
              HeaderContainer(
                borderColor: Colors.grey.shade400,
                margin_container: const EdgeInsets.only(left: 20, right: 20),
                height_container: 65,
                body: Row(
                  children: [
                    const SizedBox(width: 15),
                    Icon(Icons.phone_iphone_outlined, color: grey),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        celularGarante ?? "Celular no asignado",
                        style: TextStyle(
                          color: grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: celularGarante != null
                            ? () async => await llamar(celularGarante)
                            : null,
                        icon: const Icon(Icons.phone)),
                    const SizedBox(width: 10)
                  ],
                ),
                has_header: false,
                has_title: true,
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      alignment: Alignment.center,
                      width: 140,
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 35, top: 8),
                      child: Text(
                        "Celular Garante",
                        style: TextStyle(
                          color: grey,
                          fontSize: 17,
                        ),
                      )),
                ),
              ),
              HeaderContainer(
                borderColor: Colors.grey.shade400,
                margin_container: const EdgeInsets.only(left: 20, right: 20),
                height_container: 65,
                body: Row(
                  children: [
                    const SizedBox(width: 15),
                    Icon(Icons.phone_iphone_outlined, color: grey),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        celular2Garante ?? "Celular no asignado",
                        style: TextStyle(
                          color: grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: celular2Garante != null
                            ? () async => await llamar(celular2Garante)
                            : null,
                        icon: const Icon(Icons.phone)),
                    const SizedBox(width: 10)
                  ],
                ),
                has_header: false,
                has_title: true,
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      alignment: Alignment.center,
                      width: 140,
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 35, top: 8),
                      child: Text(
                        "Celular Garante 2",
                        style: TextStyle(
                          color: grey,
                          fontSize: 17,
                        ),
                      )),
                ),
              ),
              HeaderContainer(
                borderColor: Colors.grey.shade400,
                margin_container: const EdgeInsets.only(left: 20, right: 20),
                height_container: 65,
                body: Row(
                  children: [
                    const SizedBox(width: 15),
                    Icon(Icons.location_city, color: grey),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        direccionGarante ?? "Dirección no asignada",
                        style: TextStyle(
                          color: grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                has_header: false,
                has_title: true,
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      alignment: Alignment.center,
                      width: 140,
                      color: Colors.white,
                      margin: const EdgeInsets.only(left: 35, top: 8),
                      child: Text(
                        "Dirección Garante",
                        style: TextStyle(
                          color: grey,
                          fontSize: 17,
                        ),
                      )),
                ),
              ),
            ],
          );
  }

  Future<void> llamar(String? celular) async {
    if (celular != null) {
      final phone = "tel:$celular";

      if (await canLaunchUrl(Uri.parse(phone))) {
        await launchUrl(Uri.parse(phone));
      } else {
        scaffoldMessenger(context, "No se pudo llamar al prospecto",
            icon: const Icon(Icons.error, color: Colors.red));
      }
    } else {
      scaffoldMessenger(context, "No hay un celular asignado",
          icon: const Icon(Icons.error, color: Colors.red));
    }
  }
}
