import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/models/autorizacion/autorizacion_model.dart';
import 'package:abi_praxis_app/src/models/solicitud/soliciutd_credito_model.dart';
import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abi_praxis_app/utils/list/solicitudes_ingresadas.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/footer.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';

import '../../../vender/credito/solicitud/solicitud.dart';

class DetalleSolicitud extends StatefulWidget {
  int idPersona;
  DetalleSolicitud({super.key, required this.idPersona});

  @override
  State<DetalleSolicitud> createState() => _DetalleSolicitudState();
}

class _DetalleSolicitudState extends State<DetalleSolicitud> {
  final scKey = GlobalKey<ScaffoldState>();
  final op = Operations();

  AutorizacionModel? autorizacionModel;
  SolicitudCreditoModel? solicitudModel;
  PersonaModel? persona;

  @override
  void initState() {
    super.initState();
    obtenerPersona();
    obtenerSolicitudes();
  }

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
          header("En proceso", null, context: context),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                card(),
                const SizedBox(height: 25),
                options2(),
                const SizedBox(height: 25),
              ],
            ),
          ),
          //footerBaadal()
        ],
      );

  Widget card() => Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: double.infinity,
        //width: 350,
        height: 150,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  blurRadius: 0.3, offset: Offset(2, 2), color: Colors.grey)
            ],
            color: const Color.fromRGBO(238, 238, 238, 1),
            borderRadius: BorderRadius.circular(25)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                persona == null
                    ? ""
                    : "${persona!.nombres} ${persona!.apellidos}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(autorizacionModel != null
                  ? DateFormat.yMMMMEEEEd("es")
                      .format(DateTime.parse(autorizacionModel!.fechaCreacion!))
                  : ""),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Suscripción"),
                Container(width: 0.5, height: 40, color: Colors.black),
                const Text(
                  "En proceso",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      );

  Widget options2() => Column(
        children: [
          if (solicitudModel != null) ...[
            ListTile(
              leading: const Icon(AbiPraxis.solicitudes_aprovadas),
              title: const Text("Solicitud suscripción EU"),
              subtitle: getStatus(solicitudModel!.estado),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) => onSelect(
                  value,
                  solicitudModel!.estado,
                  solicitudModel!.idSolicitud!,
                ),
                itemBuilder: (builder) =>
                    function(builder, solicitudModel!.estado),
              ),
            ),
            divider(true)
          ], /* else ...[
            const Text("Solicitud enviada")
          ],*/
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
