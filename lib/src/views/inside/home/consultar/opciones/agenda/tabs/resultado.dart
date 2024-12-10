// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';

class ResultadoAgenda extends StatefulWidget {
  int idAgenda;
  ResultadoAgenda({super.key, required this.idAgenda});

  @override
  State<ResultadoAgenda> createState() => _ResultadoAgendaState();
}

class _ResultadoAgendaState extends State<ResultadoAgenda> {
  final op = Operations();

  List<Map<String, dynamic>> listOptions = [];
  Map<String, dynamic>? optionSelected;
  int estado = 0;

  Future<void> obtenerResultado() async {
    final res = await op.obtenerAgenda(widget.idAgenda);

    if (res != null) {
      setState(() => estado = res.estado);
      //if (estado != 0) {
      if (res.gestion == 1) {
        setState(() {
          listOptions.addAll([
            {"nombre": "Llenó solicitud", "id": 1},
            {"nombre": "Analizará la decisión", "id": 2},
            {"nombre": "No desea", "id": 3},
            {"nombre": "Pendiente documentación", "id": 4},
            {"nombre": "Coordinar otra visita", "id": 5},
            {"nombre": "Otro", "id": 6}
          ]);
        });
      } else if (res.gestion == 2) {
        setState(() {
          listOptions.addAll([
            {"nombre": "Presentó comprobante de pago", "id": 1},
            {"nombre": "Va a pagar", "id": 2},
            {"nombre": "Coordinar otra visita", "id": 3},
          ]);
        });
      } else if (res.gestion == 3) {
        setState(() {
          listOptions.addAll([
            {"nombre": "Pendiente...", "id": 1},
          ]);
        });
      } else if (res.gestion == 4) {
        setState(() {
          listOptions.addAll([
            {"nombre": "Llenó solicitud", "id": 1},
            {"nombre": "Coordinar otra visita", "id": 2},
          ]);
        });
      }

      setState(() => optionSelected = res.resultadoReunion == 0
          ? null
          : listOptions
              .where((e) => e["id"] == res.resultadoReunion)
              .toList()[0]);
      //}
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerResultado();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: listOptions.isEmpty
            ? const Text("Cargando...")
            : DropdownButtonFormField<Map<String, dynamic>>(
                value: optionSelected,
                elevation: 1,
                hint: const Text("Seleccione"),
                decoration: const InputDecoration(
                  labelText: "Resultado de reunión",
                ),
                onChanged: estado != 0
                    ? null
                    : (value) async {
                        final res = await op.actualizarResultado(
                            widget.idAgenda, value!["id"]);

                        if (res == 1) {
                          scaffoldMessenger(
                              context, "Resultado actualizado correctamente",
                              icon:
                                  const Icon(Icons.check, color: Colors.green));
                        } else {
                          scaffoldMessenger(
                              context, "No se pudo acutualizar el resultado",
                              icon: const Icon(Icons.error, color: Colors.red));
                        }
                      },
                items: listOptions
                    .map((e) => DropdownMenuItem<Map<String, dynamic>>(
                        value: e, child: Text(e["nombre"])))
                    .toList(),
              ));
  }
}
//wdsswdsswdss
