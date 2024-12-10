import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/solicitudes_curso/solicitudes_pendientes.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abi_praxis_app/utils/list/solicitudes_ingresadas.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/solicitudes_curso/detalle_solicitud.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/footer.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:abi_praxis_app/utils/textFields/input_text_fields.dart';

class ContenedorSolicitudes extends StatefulWidget {
  const ContenedorSolicitudes({super.key});

  @override
  State<ContenedorSolicitudes> createState() => _ContenedorSolicitudesState();
}

class _ContenedorSolicitudesState extends State<ContenedorSolicitudes>
    with TickerProviderStateMixin {
  final sckey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  String? selectedName;
  Map<String, dynamic> value = options_solicitud[0];
  bool selectAllOptions = false;

  List<Map<String, dynamic>> _searchList = [];
  String searchText = "";

  @override
  void initState() {
    super.initState();
    setState(() => _searchList = solicitudes_ingresadas);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: sckey,
        drawer: DrawerMenu(inicio: false),
        backgroundColor: Colors.white,
        appBar: MyAppBar(key: sckey).myAppBar(context: context),
        body: options(),
      ),
    );
  }

  Widget options() => Column(
        children: [
          header("Solicitudes Ingresadas", AbiPraxis.solucitudes,
              context: context),
          tabBar(),
          Expanded(child: tabBarView())
          /*if (_searchList.isNotEmpty) buscador(),
          if (_searchList.isNotEmpty)
            Align(
                alignment: Alignment.centerRight, child: opcionesSoliciudes()),
          listaSolicitudes(),*/
          //footerBaadal()
        ],
      );

  TabBar tabBar() => TabBar(
          indicator: const BoxDecoration(color: Colors.black),
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: "En proceso"),
            Tab(text: "Ingresadas"),
          ]);

  TabBarView tabBarView() => TabBarView(
      controller: _tabController,
      children: [const SolicitudesPendientes(), Container()]);

  Container opcionesSoliciudes() => Container(
      margin: const EdgeInsets.only(right: 15),
      color: Colors.white,
      width: 130,
      child: DropdownButton<Map<String, dynamic>>(
        dropdownColor: Colors.white,
        hint: const Text("Seleccione"),
        value: value,
        items: options_solicitud
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e["name"]),
                ))
            .toList(),
        onChanged: (value) {
          setState(() => this.value = value!);

          if (value!["value"] == 4) {
            setState(() => _searchList = solicitudes_ingresadas);
          } else {
            setState(() {
              _searchList = solicitudes_ingresadas
                  .where((element) => element["estado"] == value["value"])
                  .toList();
            });
          }
        },
      ));

  List<Map<String, dynamic>> _buildSearchList() {
    //setState(() {
    if (searchText.isEmpty) {
      setState(() => value = options_solicitud[0]);
      return _searchList = solicitudes_ingresadas;
    } else {
      if (value["value"] == 4) {
        _searchList = solicitudes_ingresadas
            .where((element) => element["establecimiento"]
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      } else {
        _searchList = solicitudes_ingresadas
            .where((element) =>
                element["establecimiento"]
                    .toString()
                    .toLowerCase()
                    .contains(searchText.toLowerCase()) &&
                element["value"] == value["value"])
            .toList();
      }

      return _searchList;
    }

    //});
  }
}
