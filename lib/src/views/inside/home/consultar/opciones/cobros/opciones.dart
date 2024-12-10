import 'package:flutter/material.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/cobros/solAprobada/solicitudes_aprobadas.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/footer.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:provider/provider.dart';

import '../../../../../../controller/provider/form_state.dart';

class OpcionesCobros extends StatefulWidget {
  const OpcionesCobros({super.key});

  @override
  State<OpcionesCobros> createState() => _OpcionesCobrosState();
}

class _OpcionesCobrosState extends State<OpcionesCobros> {
  final sckey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(builder: (context, form, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        key: sckey,
        appBar: MyAppBar(key: sckey).myAppBar(context: context),
        drawer: DrawerMenu(),
        body: Column(
          children: [Expanded(child: options()), footerBaadal()],
        ),
      );
    });
  }

  Widget options() => Column(
        children: [
          header("Mis cobros", AbiPraxis.cobros, context: context),
          const SizedBox(height: 10),
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => const SolicitudesAprobadas())),
            title: const Text("Solicitudes Aprobadas"),
            leading: const Icon(AbiPraxis.solucitudes),
            trailing: const Icon(Icons.navigate_next_sharp),
          ),
          divider(false),
          const SizedBox(height: 10),
          const ListTile(
            title: Text("Preliquidaciones"),
            leading: Icon(AbiPraxis.solucitudes),
            trailing: Icon(Icons.navigate_next_sharp),
          ),
          divider(false),
          const SizedBox(height: 10),
          const ListTile(
            title: Text("Pagos"),
            leading: Icon(AbiPraxis.solucitudes),
            trailing: Icon(Icons.navigate_next_sharp),
          ),
          divider(false),
        ],
      );
}
