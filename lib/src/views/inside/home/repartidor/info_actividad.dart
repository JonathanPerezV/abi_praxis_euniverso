import 'package:abi_praxis_app/src/controller/aws/operaciones/ws_agenda.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/calendar_model.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/header_container.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:abi_praxis_app/utils/list/lista_agenda.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_bar.dart';
import '../../../../../utils/header.dart';

class InfoActividad extends StatefulWidget {
  int idAgenda;
  InfoActividad({super.key, required this.idAgenda});

  @override
  State<InfoActividad> createState() => _InfoActividadState();
}

class _InfoActividadState extends State<InfoActividad> {
  final scKey = GlobalKey<ScaffoldState>();
  final wsAg = WSAgenda();
  CalendarModel? ag;

  Future<void> getData() async {
    final data = await wsAg.obtenerAgenda(idAgenda: widget.idAgenda);

    if (data.isNotEmpty) {
      setState(() => ag = data[0]);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scKey,
      appBar: MyAppBar(key: scKey).myAppBar(context: context),
      drawer: DrawerMenu(),
      body: options(),
    );
  }

  Widget options() => Column(
        children: [
          header("Información de actividad", null, context: context),
          Expanded(
            child: Column(
              children: [
                cliente(),
                gestion(),
                direccion(),
                detalles(),
                const SizedBox(height: 30),
                botones()
              ],
            ),
          ),
          //footerBaadal()
        ],
      );

  Widget gestion() => HeaderContainer(
        borderColor: Colors.black,
        margin_container: const EdgeInsets.only(left: 20, right: 20),
        height_container: 50,
        body: Row(
          children: [
            const SizedBox(width: 15),
            const Icon(AbiPraxis.gestion, color: Colors.black),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                ag == null
                    ? "cargando..."
                    : gestiones
                        .where((e) => e["id"] == ag!.gestion)
                        .first["nombre"],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
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
              child: const Text(
                "Gestión a realizar",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              )),
        ),
      );

  Widget cliente() => HeaderContainer(
        borderColor: Colors.black,
        margin_container: const EdgeInsets.only(left: 20, right: 20),
        height_container: 50,
        body: Row(
          children: [
            const SizedBox(width: 15),
            const Icon(Icons.person_outline, color: Colors.black),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                ag == null
                    ? "cargando..."
                    : ("${ag!.nombres ?? ""} ${ag!.apellidos ?? ""}"),
                style: const TextStyle(
                  color: Colors.black,
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
              width: 60,
              color: Colors.white,
              margin: const EdgeInsets.only(left: 35, top: 8),
              child: const Text(
                "Cliente",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              )),
        ),
      );

  Widget direccion() => HeaderContainer(
        borderColor: Colors.black,
        margin_container: const EdgeInsets.only(left: 20, right: 20),
        height_container: 50,
        body: Row(
          children: [
            const SizedBox(width: 15),
            const Icon(Icons.place_outlined, color: Colors.black),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                ag == null ? "cargando..." : ag!.lugarReunion,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
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
              width: 70,
              color: Colors.white,
              margin: const EdgeInsets.only(left: 35, top: 8),
              child: const Text(
                "Dirección",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 17,
                ),
              )),
        ),
      );

  Widget detalles() => HeaderContainer(
        borderColor: Colors.black,
        margin_container: const EdgeInsets.only(left: 20, right: 20),
        height_container: 80,
        body: Row(
          children: [
            const SizedBox(width: 15),
            const Icon(Icons.details_outlined, color: Colors.black),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                ag == null ? "cargando..." : ag!.observacion ?? "Sin detalles",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
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
              width: 70,
              color: Colors.white,
              margin: const EdgeInsets.only(left: 35, top: 8),
              child: const Text(
                "Detalles",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 17,
                ),
              )),
        ),
      );

  Widget botones() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(blurRadius: 3, color: Colors.grey.shade700)
                      ],
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.green),
                  width: 70,
                  height: 70,
                  child: const Icon(Icons.add_location_alt_outlined,
                      color: Colors.white, size: 35),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Geolocalizar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
          Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(blurRadius: 3, color: Colors.grey.shade700)
                      ],
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blue),
                  width: 70,
                  height: 70,
                  child: const Icon(Icons.camera_alt_outlined,
                      color: Colors.white, size: 35),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Tomar foto",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          )
        ],
      );
}
