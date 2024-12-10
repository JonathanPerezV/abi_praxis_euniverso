import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/prospectos/clientes/al_dia.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/prospectos/clientes/en_mora.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/prospectos/agregar_prospecto.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/prospectos/info_contacto.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../utils/app_bar.dart';
import '../../../../../../../../utils/header.dart';
import '../../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../../../../../../../utils/textFields/input_text_fields.dart';
import '../../../../../lateralMenu/drawer_menu.dart';

class MisClientes extends StatefulWidget {
  const MisClientes({super.key});

  @override
  State<MisClientes> createState() => _MisClientesState();
}

class _MisClientesState extends State<MisClientes>
    with TickerProviderStateMixin {
  final _sckey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>("");
  ValueNotifier<Map<String, dynamic>>? _filter;

  Map<String, dynamic> filterMap = {"tipo": "", "seleccion": ""};

  bool hasPermission = false;

  late TabController controller;

  int selectedValue = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      _searchNotifier.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(builder: (context, form, child) {
      return Scaffold(
          backgroundColor: Colors.white,
          key: _sckey,
          appBar: MyAppBar(key: _sckey).myAppBar(context: context),
          drawer: DrawerMenu(inicio: false),
          body: Column(children: [
            header("Cartera", AbiPraxis.prospectos, context: context),
            tabs(),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InputTextFields(
                      controlador: _searchController,
                      onChanged: (value) {},
                      inputBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      icon: const Icon(Icons.search),
                      placeHolder: "Busqueda por nombre o sector",
                      nombreCampo: "Buscar",
                      accionCampo: TextInputAction.done),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  width: 45,
                  height: 45,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      if (controller.index == 0) {
                        filtroAlDia();
                      } else {
                        filtroEnMora();
                      }
                    },
                    child: const Icon(Icons.filter_list),
                  ),
                )
              ],
            ),
            Expanded(child: tabBarView()),
          ]));
    });
  }

  Widget tabs() {
    return TabBar(
        onTap: (_) => setState(() {
              _searchController.clear();
              _searchNotifier.value = "";
            }),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: const BoxDecoration(color: Colors.black),
        labelColor: Colors.white,
        controller: controller,
        tabs: const [
          Tab(child: Text("Al día", style: TextStyle(fontSize: 17))),
          Tab(
            child: Text("En mora", style: TextStyle(fontSize: 17)),
          )
        ]);
  }

  Widget tabBarView() {
    return TabBarView(controller: controller, children: [
      AlDia(searchNotifier: _searchNotifier),
      EnMora(searchNotifier: _searchNotifier)
    ]);
  }

  void filtroAlDia() {
    //todo FORMATO
    //todo  {
    //todo    "tipo": 1 o 2 => 1 = Renovar, 2 = Por calificacion
    //todo    "seleccion": (Renovar: (1. 1 cuota, 2. Cuota 50%). Calificacion: (1. AAA, 2. AA, 3. A, 4.B, 5.C) )
    //todo  }

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        showDragHandle: true,
        builder: (builder) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15),
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Filtros",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              ListTile(
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 20),
                onTap: () {
                  setState(() => filterMap["tipo"] = 1);
                  Navigator.pop(context);
                  showRenovar();
                },
                title:
                    const Text("Por renovar", style: TextStyle(fontSize: 17)),
              ),
              const SizedBox(height: 10),
              divider(true, color: Colors.grey),
              const SizedBox(height: 10),
              ListTile(
                onTap: () {
                  setState(() => filterMap["tipo"] = 2);
                  Navigator.pop(context);
                  filtroCalificacion();
                },
                title: const Text("Por calificación",
                    style: TextStyle(fontSize: 17)),
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 20),
              ),
              const SizedBox(height: 25),
            ],
          );
        });
  }

  void showRenovar() async {
    await showModalBottomSheet(
        context: context,
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        builder: (builder) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Por renovar",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    onTap: () {
                      state(() => selectedValue = 1);
                    },
                    title: const Text("1 cuota antes del 50%",
                        style: TextStyle(fontSize: 17)),
                    trailing: Radio(
                      groupValue: selectedValue,
                      value: 1,
                      onChanged: (value) {
                        state(() => selectedValue = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  divider(true, color: Colors.grey),
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: () {
                      state(() => selectedValue = 2);
                    },
                    title: const Text("Cuota del 50%",
                        style: TextStyle(fontSize: 17)),
                    trailing: Radio(
                      groupValue: selectedValue,
                      value: 2,
                      onChanged: (value) {
                        state(() => selectedValue = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            );
          });
        }).then((_) {
      setState(() => selectedValue = 0);
    });
  }

  void filtroCalificacion() {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        builder: (builder) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Por calificación",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    onTap: () {
                      state(() => selectedValue = 1);
                    },
                    title: const Text("AAA", style: TextStyle(fontSize: 17)),
                    trailing: Radio(
                      value: 1,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        state(() => selectedValue = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  divider(true, color: Colors.grey),
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: () {
                      state(() => selectedValue = 2);
                    },
                    title: const Text("AA", style: TextStyle(fontSize: 17)),
                    trailing: Radio(
                      value: 2,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        state(() => selectedValue = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  divider(true, color: Colors.grey),
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: () {
                      state(() => selectedValue = 3);
                    },
                    title: const Text("A", style: TextStyle(fontSize: 17)),
                    trailing: Radio(
                      value: 3,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        state(() => selectedValue = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  divider(true, color: Colors.grey),
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: () {
                      state(() => selectedValue = 4);
                    },
                    title: const Text("B", style: TextStyle(fontSize: 17)),
                    trailing: Radio(
                      value: 4,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        state(() => selectedValue = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  divider(true, color: Colors.grey),
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: () {
                      state(() => selectedValue = 5);
                    },
                    title: const Text("C", style: TextStyle(fontSize: 17)),
                    trailing: Radio(
                      value: 5,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        state(() => selectedValue = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            );
          });
        }).then((_) {
      setState(() => selectedValue = 0);
    });
  }

  void filtroEnMora() {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        builder: (builder) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Días en mora",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    onTap: () {
                      state(() => selectedValue = 1);
                    },
                    title: const Text("1 - 29 días",
                        style: TextStyle(fontSize: 17)),
                    trailing: Radio(
                      value: 1,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        state(() => selectedValue = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  divider(true, color: Colors.grey),
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: () {
                      state(() => selectedValue = 2);
                    },
                    title: const Text("30 - 59 días",
                        style: TextStyle(fontSize: 17)),
                    trailing: Radio(
                      value: 2,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        state(() => selectedValue = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  divider(true, color: Colors.grey),
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: () {
                      state(() => selectedValue = 3);
                    },
                    title: const Text("60 - 90 días",
                        style: TextStyle(fontSize: 17)),
                    trailing: Radio(
                      value: 3,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        state(() => selectedValue = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  divider(true, color: Colors.grey),
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: () {
                      state(() => selectedValue = 4);
                    },
                    title: const Text("más de 90 días",
                        style: TextStyle(fontSize: 17)),
                    trailing: Radio(
                      value: 4,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        state(() => selectedValue = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            );
          });
        }).then((_) {
      setState(() => selectedValue = 0);
    });
  }
}
