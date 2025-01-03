import 'dart:convert';
import 'dart:io';
import 'package:abi_praxis_app/src/controller/provider/loading_provider.dart';
import 'package:abi_praxis_app/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/home_page.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/mi_perfil/datos_personales.dart';
import 'package:abi_praxis_app/utils/alerts/and_alert.dart';
import 'package:abi_praxis_app/utils/alerts/ios_alert.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:provider/provider.dart';
import '../../../../utils/deviders/divider.dart';

class DrawerMenu extends StatefulWidget {
  bool? inicio;
  DrawerMenu({this.inicio, super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool enableSync = false;

  @override
  void initState() {
    super.initState();

    validateTipoUsuario();
  }

  Future<void> validateTipoUsuario() async {
    final user = UserPreferences();

    final tipoUsuario = await user.getTipoUsuario();

    if (tipoUsuario == 3) {
      setState(() => enableSync = false);
    } else {
      setState(() => enableSync = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(builder: (context, form, child) {
      return Stack(
        children: [
          Drawer(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            backgroundColor: Colors.white,
            elevation: 50,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      //const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        height: 110,
                        color: Colors.black,
                        padding: const EdgeInsets.only(left: 55, right: 55),
                        child: Image.asset(
                          "assets/abi_praxis_logo_white.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      header(context),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(children: [
                            if (widget.inicio != null && !widget.inicio!)
                              divider(false),
                            if (widget.inicio != null && !widget.inicio!)
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              const HomePage()));
                                },
                                leading: const Icon(
                                  Icons.home,
                                  color: Colors.black,
                                ),
                                title: const Text(
                                  "Inicio",
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            divider(false),
                            miPerfil(context),
                            divider(false),
                            /*vendedor(context),
                                  divider(false),*/
                            terminosCondiciones(context),
                            divider(false),
                            ListTile(
                              onTap: () => showModal(context),
                              leading: const Icon(
                                Icons.settings,
                                color: Colors.black,
                              ),
                              title: const Text(
                                "Configuración",
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            divider(false),
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (enableSync)
                      Expanded(
                        child: Container(
                          height: Platform.isIOS ? 60 : 50,
                          decoration: const BoxDecoration(
                            /*borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100),
                                bottomLeft: Radius.circular(100)),*/
                            color: Colors.green,
                          ),
                          child: IconButton(
                              tooltip: "Sincronizar datos",
                              onPressed: () => Platform.isAndroid
                                  ? AndroidAlert().alertSync(context)
                                  : IosAlert().alertSync(context),
                              icon: const Icon(Icons.cloud_sync_outlined,
                                  size: 35, color: Colors.white)),
                        ),
                      ),
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        onTap: () => Platform.isAndroid
                            ? AndroidAlert().cerrarSesion(context)
                            : IosAlert().cerrarSesion(context),
                        child: Container(
                            height: Platform.isIOS ? 60 : 50,
                            color: Colors.black,
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'CERRAR SESIÓN',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 15),
                                    child: const Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              //),
                              /*),
                                                            ],*/
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (form.loading)
            //loadingWidget(text: form.text)
            loadingWithBarProgress()
          else if (form.loadingNetwork)
            loadingWidget(text: "Comprobando conexión...")
          else
            const SizedBox.shrink(),
        ],
      );
    });
  }

  Widget header(context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10),
        height: 165,
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 100,
              width: 100,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(166, 8, 50, 1),
                    Color.fromRGBO(239, 68, 113, 1),
                    Color.fromRGBO(241, 95, 32, 1),
                    Color.fromRGBO(195, 35, 77, 1),
                  ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                  borderRadius: BorderRadius.circular(100)),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: FutureBuilder<String>(
                    future: UserPreferences().getPathPhoto(),
                    builder: (builder, snapshot) {
                      return snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data != ""
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.memory(
                                /*"${dotenv.env["ws_dominio"]! + snapshot.data!}?timestamp=${DateTime.now().millisecondsSinceEpoch}",
                                key: UniqueKey(),
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                      child:
                                          LoadingAnimationWidget.discreteCircle(
                                              color: Colors.black, size: 30));
                                },*/
                                base64Decode(snapshot.data!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 80,
                            );
                    },
                  )),
            ),
            const SizedBox(height: 10),
            FutureBuilder<String>(
                future: UserPreferences().getFullName(),
                builder: (builder, snapshot) {
                  return Text(
                    snapshot.data ?? "< Sin datos >",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  );
                }),
            const SizedBox(height: 3)
          ],
        ),
      );

  Widget miPerfil(context) => Column(children: [
        //todo MI BILLETERA
        ExpansionTile(
          title: const Text(
            "Mi perfil",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          leading: const Icon(Icons.person),
          children: [
            dividerMenuLateral(),
            ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const DatosPersonales())),
              /*leading: const Icon(
                KmelloIcons.mi_perfil,
                color: Colors.black,
              ),*/
              trailing: const Icon(
                Icons.navigate_next_sharp,
                color: Colors.black,
              ),
              title: Container(
                padding: const EdgeInsets.only(left: 40),
                child: const Text(
                  "Datos personales",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            /* dividerMenuLateral(),
            ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) =>
                          const /*TestStackOverflow()*/ DatosCuentaBanco())),
              trailing: const Icon(
                Icons.navigate_next_sharp,
                color: Colors.black,
              ),
              title: Container(
                padding: const EdgeInsets.only(left: 40),
                child: const Text(
                  "Datos de cuenta bancaria",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),*/
          ],
        )
      ]);

  Widget terminosCondiciones(context) => Column(
        children: [
          //todo INFORMACIÓN CONTÁCTENOS
          ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            leading: const Icon(
              AbiPraxis.mis_clientes,
              color: Colors.black,
            ),
            title: const Text(
              "Términos y condiciones",
              style: TextStyle(
                fontSize: 19,
                color: Colors.black,
              ),
            ),
          ),
        ],
      );

  void showModal(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        showDragHandle: false,
        context: context,
        builder: (builder) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                const ListTile(
                    leading: Icon(Icons.settings, color: Colors.black),
                    title: Text(
                      "Configuración",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    )),
                divider(false),
                const SizedBox(height: 15),
                const ListTile(
                    leading: Icon(AbiPraxis.contrasena, color: Colors.black),
                    title: Text(
                      "Actualizar contraseña",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    )),
                const ListTile(
                  leading: Icon(Icons.delete, color: Colors.black),
                  title: Text(
                    "Eliminar cuenta",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.red),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          );
        });
  }
}
