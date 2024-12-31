import 'package:abi_praxis_app/src/controller/aws/operaciones/ws_agenda.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/calendar_model.dart';
import 'package:abi_praxis_app/src/views/inside/home/repartidor/info_actividad.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:abi_praxis_app/utils/list/lista_agenda.dart';
import 'package:abi_praxis_app/utils/loading.dart';
import 'package:flutter/material.dart';

class HomeRepartidor extends StatefulWidget {
  const HomeRepartidor({super.key});

  @override
  State<HomeRepartidor> createState() => _HomeRepartidorState();
}

class _HomeRepartidorState extends State<HomeRepartidor> {
  final key = GlobalKey<ScaffoldState>();
  late MyAppBar appBar;
  List<CalendarModel> agendas = [];
  final wsAg = WSAgenda();
  bool loading = false;
  bool firstCharge = false;

  @override
  void initState() {
    super.initState();
    appBar = MyAppBar(key: key);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: key,
      drawer: DrawerMenu(),
      appBar: appBar.myAppBar(context: context, back: false),
      body: loading
          ? Center(
              child: loadingWidget(text: "Consultando actividades..."),
            )
          : agendas.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async => await getData(),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.black,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8.0),
                        width: double.infinity,
                        child: Text(
                          "Actividades a realizar".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: ListView.builder(
                            itemCount: agendas.length,
                            itemBuilder: (_, i) {
                              var date =
                                  DateTime.parse(agendas[i].fechaReunion);
                              return InkWell(
                                onTap: () => Navigator.push(
                                    (_),
                                    MaterialPageRoute(
                                        builder: (builder) => InfoActividad(
                                            idAgenda: agendas[i].idAgenda!))),
                                child: Card(
                                  margin: const EdgeInsets.all(5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0)),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 50,
                                        color: const Color.fromRGBO(
                                            82, 123, 189, 1),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              width: double.infinity,
                                              child: Text(
                                                "${agendas[i].nombres ?? ""} ${agendas[i].apellidos ?? ""}",
                                                //style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  Text(
                                                      gestiones
                                                          .where((e) =>
                                                              e["id"] ==
                                                              agendas[i]
                                                                  .gestion!)
                                                          .first["nombre"],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  const SizedBox(width: 5),
                                                  Container(
                                                      width: 3,
                                                      height: 15,
                                                      color: Colors.grey),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                      "${date.day}/${date.month}")
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      /*IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: () {},
                                )*/
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text("Actividades pendientes..."),
                ),
    );
  }

  Future<void> getData() async {
    final sckey = GlobalKey<ScaffoldMessengerState>();

    if (!firstCharge) {
      setState(() => loading = true);
    }

    if (firstCharge) {
      scaffoldMessenger(
          // ignore: use_build_context_synchronously
          context,
          "Consultando actividades",
          seconds: 2,
          key: sckey,
          trailing: const SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 1.5)));
    }

    final data = await wsAg.obtenerAgendas();

    if (data.isNotEmpty) {
      if (!firstCharge) {
        setState(() => loading = false);
        setState(() => firstCharge = true);
      }
      setState(() => agendas = data);
    }
  }
}
