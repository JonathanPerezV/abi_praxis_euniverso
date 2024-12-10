import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/consultar_opciones.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/sell_page.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:provider/provider.dart';

import '../../../controller/provider/loading_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _sckey = GlobalKey<ScaffoldState>();

  late TabController tabController;
  late MyAppBar appBar;

  @override
  void initState() {
    super.initState();
    Provider.of<LoadingProvider>(context, listen: false);
    appBar = MyAppBar(key: _sckey);
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(builder: (context, form, child) {
      print("Loading state: ${form.loading.loading}");
      return Scaffold(
          backgroundColor: Colors.white,
          key: _sckey,
          drawer: DrawerMenu(),
          //appBar: appBar.myAppBar(),
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  appBar.mySliverAppBar(
                      widgethide: Column(
                    children: [
                      Container(
                        color: const Color.fromRGBO(93, 97, 98, 1),
                        /*margin: EdgeInsets.only(left: 2, right: 2),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(93, 97, 98, 1),   
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(35),
                              bottomRight: Radius.circular(35))),*/
                        width: double.infinity,
                        height: 35,
                        alignment: Alignment.center,
                        child: const Text(
                          "TU SOCIO EN VENTAS",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      getTabBar(),
                    ],
                  ))
                ];
              },
              body: Stack(
                children: [
                  options(),
                  Consumer<LoadingProvider>(
                    builder: (context, loadingProvider, child) {
                      if (loadingProvider.loading) {
                        return loadingWidget(text: loadingProvider.text);
                      }
                      return SizedBox(); // Return an empty SizedBox if not loading
                    },
                  ),
                ],
              )));
    });
  }

  Widget options() => getTabBarView();

  TabBar getTabBar() => TabBar(
          indicator: const BoxDecoration(border: Border()),
          labelColor: Colors.black,
          controller: tabController,
          unselectedLabelColor: Colors.grey.shade400,
          tabs: const [
            Tab(
              child: Column(
                children: [Icon(AbiPraxis.gestionar), Text("Gestionar")],
              ),
            ),
            Tab(
              child: Column(
                children: [Icon(AbiPraxis.vender), Text("Vender")],
              ),
            ),
            Tab(
              child: Column(
                children: [Icon(AbiPraxis.redimir), Text("Redimir")],
              ),
            )
          ]);

  TabBarView getTabBarView() =>
      TabBarView(controller: tabController, children: [
        const ConsultarOpciones(),
        const SellPage(),
        //const RedimirPage()
        Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: const Center(
                child: Text(
              "PRÓXIMAMENTE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ))),
      ]);
}
