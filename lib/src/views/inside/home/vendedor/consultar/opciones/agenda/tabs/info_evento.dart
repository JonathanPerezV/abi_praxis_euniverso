// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/agenda/tabs/detalles.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/agenda/tabs/documentos.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/agenda/tabs/resultado.dart';

import '../../../../../../../../../utils/app_bar.dart';

class InfoEvento extends StatefulWidget {
  int idEvento;
  int? index;
  InfoEvento({super.key, required this.idEvento, this.index});

  @override
  State<InfoEvento> createState() => _InfoEventoState();
}

class _InfoEventoState extends State<InfoEvento> with TickerProviderStateMixin {
  late TabController _controller;
  final _sckey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    if (widget.index != null) _controller.index = widget.index!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        // backgroundColor: showContacts ? Colors.grey.shade400 : Colors.white,
        key: _sckey,
        appBar: MyAppBar(key: _sckey).myAppBar(back: true, context: context),
        //drawer: drawerMenu(context),
        body: listaOpciones(),
      ),
    );
  }

  Widget listaOpciones() => Column(
        children: [
          SizedBox(
            height: 40,
            child: TabBar(
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                labelColor: Colors.white,
                indicator: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                indicatorColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                controller: _controller,
                tabs: const [
                  Tab(child: Text("Evento")),
                  Tab(child: Text("Resultado")),
                  Tab(child: Text("Documentos")),
                ]),
          ),
          Expanded(
              child: TabBarView(controller: _controller, children: [
            DetallesEvento(idAgenda: widget.idEvento),
            Align(
                alignment: Alignment.topCenter,
                child: ResultadoAgenda(idAgenda: widget.idEvento)),
            DocumentosEvento(idAgenda: widget.idEvento),
          ]))
        ],
      );
}
