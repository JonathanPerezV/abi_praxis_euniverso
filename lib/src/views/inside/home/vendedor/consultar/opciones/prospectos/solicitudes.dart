// ignore_for_file: use_build_context_synchronously
import 'package:abi_praxis_app/src/models/solicitud/soliciutd_credito_model.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../utils/deviders/divider.dart';
import '../../../../../../../../utils/flushbar.dart';
import '../../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../../../../../../controller/dataBase/operations.dart';
import '../../../../../../../models/autorizacion/autorizacion_model.dart';
import '../../../../../../../models/usuario/persona_model.dart';
import '../../../vender/credito/solicitud/solicitud.dart';

class Solicitudes extends StatefulWidget {
  int idPersona;
  Solicitudes({required this.idPersona, super.key});

  @override
  State<Solicitudes> createState() => _SolicitudesState();
}

class _SolicitudesState extends State<Solicitudes> {
  final op = Operations();

  SolicitudCreditoModel? solicitudModel;
  PersonaModel? persona;

  Future<void> obtenerSolicitudes() async {
    final res = await op.obtenerSolciitudPersonaXestado(widget.idPersona);

    if (res.isNotEmpty) {
      setState(() => solicitudModel = res.last);
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
    obtenerSolicitudes();
  }

  @override
  Widget build(BuildContext context) {
    return options2();
  }

  Widget options2() => Column(
        children: [
          if (solicitudModel != null) ...[
            ListTile(
              leading: const Icon(AbiPraxis.solicitudes_aprovadas),
              title: const Text("Solicitud suscripción EU"),
              subtitle: getStatus(solicitudModel!.estado),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) => onSelect(value, solicitudModel!.estado,
                    solicitudModel!.idSolicitud!),
                itemBuilder: (builder) =>
                    function(builder, solicitudModel!.estado),
              ),
            ),
            divider(true)
          ] else ...[
            const Expanded(
                child: Center(child: Text("No hay solicitudes para mostrar.")))
          ]
        ],
      );

  //estado 1 = pendiente
  //estado 2 = finalizado
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

  //estado 1 = pendiente
  //estado 2 = finalizado
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

  //estado 1 = pendiente
  //estado 2 = finalizado
  void onSelect(dynamic value, int status, int idSolicitud) async {
    switch (status) {
      case 1:
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => SolicitudCredito(
                      idSolicitud: idSolicitud,
                      edit: true,
                    ))).then((_) {
          obtenerSolicitudes();
          setState(() {});
        });
        break;
      case 2:
        if (value == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => SolicitudCredito(
                        idSolicitud: idSolicitud,
                        ver: true,
                      )));
        } else if (value == 2) {}
      default:
    }
  }
}
