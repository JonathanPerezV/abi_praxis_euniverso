import 'package:flutter/material.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/agenda/agenda.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/beneficios/opciones_beneficios.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/productos/product_list.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/prospectos/clientes/mis_clientes.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/prospectos/prospectos/mis_prospectos.dart';

import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/solicitudes_curso/contenedor.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/ventas_comisiones/informacion.dart';
import 'package:abi_praxis_app/src/views/inside/school/what_sell/view_category.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:abi_praxis_app/utils/textFields/input_text_fields.dart';

class ConsultarOpciones extends StatefulWidget {
  const ConsultarOpciones({super.key});

  @override
  State<ConsultarOpciones> createState() => _ConsultarOpcionesState();
}

class _ConsultarOpcionesState extends State<ConsultarOpciones> {
  List optionsList = [
    {
      "name": "Prospectos",
      "icon": AbiPraxis.prospectos,
      "route": const MisProspectos(),
    },
    {
      "name": "Cartera",
      "icon": AbiPraxis.cartera,
      "route": const MisClientes()
    },
    {
      "name": "Agenda",
      "icon": AbiPraxis.agenda,
      "route": const Agenda() //const Calendario(),
    },
    {
      "name": "Solicitudes",
      "icon": AbiPraxis.solucitudes,
      "route": const ContenedorSolicitudes()
    },
    {
      "name": "Productos",
      "icon": AbiPraxis.productos,
      "route": const CategoryProductList()
    },
    {
      "name": "Academia",
      "icon": AbiPraxis.academia_1,
      "route": ViewCategory(
        inside: true,
      )
    },
    {
      "name": "Ventas y Comisiones",
      "icon": AbiPraxis.venta_comisiones,
      "route": const InformacionComisiones()
    },

    /*{
      "name": "Mis cobros",
      "icon": KmelloIcons.cobros,
      "route": const OpcionesCobros()
    },*/

    {
      "name": "Beneficios",
      "icon": AbiPraxis.beneficios_1,
      "route": const OpcionesBeneficios()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          const SizedBox(height: 10),
          buscador(),
          Expanded(
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: optionsList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    optionsList[index]["route"])),
                        leading: Icon(optionsList[index]["icon"]),
                        title: Text(
                          optionsList[index]["name"],
                          style: const TextStyle(fontSize: 19),
                        ),
                        trailing: const Icon(Icons.navigate_next),
                      ),
                      divider(false, color: Colors.grey)
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget buscador() => Container(
        child: InputTextFields(
            icon: const Icon(Icons.search),
            padding: const EdgeInsets.only(left: 15),
            inputBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            placeHolder: "Buscar en cartera de la institución",
            style: const TextStyle(fontSize: 15),
            nombreCampo: "Buscador",
            accionCampo: TextInputAction.done),
      );
}
