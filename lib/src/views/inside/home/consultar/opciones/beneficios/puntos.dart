import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:flutter/material.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:provider/provider.dart';

class Puntos extends StatefulWidget {
  const Puntos({super.key});

  @override
  State<Puntos> createState() => _PuntosState();
}

class _PuntosState extends State<Puntos> {
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
        children: [header("Puntos", AbiPraxis.puntos, context: context)],
      );
}
