import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/solicitudes_curso/detalle_solicitud.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../../../../../../utils/textFields/input_text_fields.dart';

class SolicitudesPendientes extends StatefulWidget {
  const SolicitudesPendientes({super.key});

  @override
  State<SolicitudesPendientes> createState() => _SolicitudesPendientesState();
}

class _SolicitudesPendientesState extends State<SolicitudesPendientes> {
  final _searchController = TextEditingController();
  final op = Operations();

  //nombres, apellidos, estado general, id_persona
  List<Map<String, dynamic>> listaSolicitudesdb = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final data = await op.obtenerSolicitudesPendientes();

    if (data.isNotEmpty) {
      setState(() => listaSolicitudesdb = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [buscador(), listaSolicitudes()],
    );
  }

  Container buscador() => Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(15)),
        width: double.infinity,
        height: 50,
        child: InputTextFields(
          onChanged: (value) {
            /*setState(() => searchText = value);
            _buildSearchList();*/
          },
          controlador: _searchController,
          //align: TextAlign.center,
          padding: const EdgeInsets.only(right: 40),
          icon: const Icon(Icons.search),
          accionCampo: TextInputAction.done,
          placeHolder: "Buscar solicitudes pendientes",
          //align: TextAlign.center,
          inputBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      );

  Expanded listaSolicitudes() => Expanded(
      child: listaSolicitudesdb.isEmpty
          ? const Center(
              child: Text("No tiene solicitudes en proceso"),
            )
          : ListView.builder(
              itemCount: listaSolicitudesdb.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => DetalleSolicitud(
                              idPersona: listaSolicitudesdb[index]
                                  ["id_persona"]))),
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(left: 20, top: 10),
                          child: Text(listaSolicitudesdb[index]["fecha"] != null
                              ? DateFormat.yMMMMEEEEd("es").format(
                                  DateTime.parse(
                                      listaSolicitudesdb[index]["fecha"]))
                              : "FECHA")),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      listaSolicitudesdb[index]["nombres"] +
                                          " " +
                                          listaSolicitudesdb[index]
                                              ["apellidos"],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: const Text("Crédito"),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => DetalleSolicitud(
                                            idPersona: listaSolicitudesdb[index]
                                                ["id_persona"]))),
                                icon: const Icon(Icons.arrow_forward_ios_outlined))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }));
}
