import 'package:flutter/material.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/footer.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:provider/provider.dart';

import '../../../../../../../utils/flushbar.dart';
import '../../../../../../controller/provider/form_state.dart';

class OpcionesBeneficios extends StatefulWidget {
  const OpcionesBeneficios({super.key});

  @override
  State<OpcionesBeneficios> createState() => _OpcionesBeneficiosState();
}

class _OpcionesBeneficiosState extends State<OpcionesBeneficios> {
  final sckey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(builder: (context, form, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        key: sckey,
        appBar: MyAppBar(key: sckey).myAppBar(context: context),
        drawer: DrawerMenu(),
        body: options(),
      );
    });
  }

  Widget options() => Column(
        children: [
          header("Beneficios", AbiPraxis.beneficios, context: context),
          Expanded(child: opciones()),
          footerBaadal()
        ],
      );

  Widget opciones() => Column(
        children: [
          ListTile(
            onTap: () =>
                scaffoldMessenger(context, "Actualmente no tiene beneficios",
                    icon: const Icon(
                      Icons.warning,
                      color: Colors.yellow,
                    )),
            /*Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const MiPlan())),*/
            leading: const Icon(AbiPraxis.plan),
            title: const Text("Mi plan"),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          /*divider(false),
          ListTile(
            onTap: () {},
            leading: const Icon(KmelloIcons.club_beneficios),
            title: const Text("Club de beneficios"),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          divider(false),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const Puntos())),
            leading: const Icon(KmelloIcons.puntos),
            title: const Text("Puntos"),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),*/
          divider(false)
        ],
      );
}
