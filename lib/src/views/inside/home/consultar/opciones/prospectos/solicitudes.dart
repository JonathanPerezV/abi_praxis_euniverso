// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../../../../../utils/deviders/divider.dart';
import '../../../../../../../utils/flushbar.dart';
import '../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../../../../../controller/dataBase/operations.dart';
import '../../../../../../models/autorizacion/autorizacion_model.dart';
import '../../../../../../models/usuario/persona_model.dart';
import '../../../vender/credito/autorizacion.dart';

class Solicitudes extends StatefulWidget {
  int idPersona;
  Solicitudes({required this.idPersona, super.key});

  @override
  State<Solicitudes> createState() => _SolicitudesState();
}

class _SolicitudesState extends State<Solicitudes> {
  final op = Operations();

  AutorizacionModel? autorizacionModel;
  PersonaModel? persona;

  Future<void> obtenerAutorizaciones() async {
    final res = await op.obtenerAutorizacionPersonaXestado(widget.idPersona);

    if (res.isNotEmpty) {
      setState(() => autorizacionModel = res.last);
    }
  }

  Future<void> obtenerPersona() async {
    final res = await op.obtenerPersona(widget.idPersona);

    if (res != null) {
      setState(() => persona = res);
    } else {
      Navigator.pop(context);
      scaffoldMessenger(context, "No se encontró a esta persona");
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerPersona();
    obtenerAutorizaciones();
  }

  @override
  Widget build(BuildContext context) {
    return options2();
  }

  Widget options2() => Column(
        children: [
          if (autorizacionModel != null) ...[
            ListTile(
              leading: const Icon(AbiPraxis.solicitudes_aprovadas),
              title: const Text("Autorización de consulta"),
              subtitle: getStatus(autorizacionModel!.estado),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) => onSelect(
                    value,
                    autorizacionModel!.estado,
                    autorizacionModel!.idAutorizacion!),
                itemBuilder: (builder) =>
                    function(builder, autorizacionModel!.estado),
              ),
            ),
            divider(true)
          ] else ...[
            const Expanded(
                child: Center(child: Text("No hay solicitudes para mostrar.")))
          ]
        ],
      );

  Widget getStatus(int status) {
    if (status == 1) {
      return Row(
        children: [
          const Text("Pendiente"),
          const SizedBox(width: 5),
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(100)),
          )
        ],
      );
    } else if (status == 2) {
      return Row(
        children: [
          const Text("Finalizado - pendiente de envío"),
          const SizedBox(width: 5),
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                color: Colors.green,
                borderRadius: BorderRadius.circular(100)),
          )
        ],
      );
    } else {
      return const Text("");
    }
  }

  List<PopupMenuEntry<Object?>> function(context, int status) {
    final list = <PopupMenuItem>[];
    switch (status) {
      case 1:
        list.add(const PopupMenuItem(
          value: 1,
          child: Text("Completar"),
        ));
        return list;
      case 2:
        list.add(const PopupMenuItem(
          value: 1,
          child: Text("Ver"),
        ));
        list.add(const PopupMenuItem(
          value: 2,
          child: Text("Sincronizar"),
        ));
        return list;
      default:
        return [];
    }
  }

  void onSelect(dynamic value, int status, int idAut) async {
    switch (status) {
      case 1:
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => AutorizacionConsulta(
                    edit: true, idAutorizacion: idAut))).then((_) {
          obtenerAutorizaciones();
          setState(() {});
        });
        break;
      case 2:
        if (value == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => AutorizacionConsulta(
                      edit: true, idAutorizacion: idAut, ver: true)));
        } else if (value == 2) {}
      default:
    }
  }
}
