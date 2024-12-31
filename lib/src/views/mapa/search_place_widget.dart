import 'package:flutter/material.dart';

import '../../../utils/textFields/input_text_form_fields.dart';
import '../../controller/map_service.dart';
import '../../models/mapas/place_model.dart';

class SearchPlaceWidget extends StatefulWidget {
  String text;
  SearchPlaceWidget({super.key, required this.text});

  @override
  State<SearchPlaceWidget> createState() => _SearchPlaceWidgetState();
}

class _SearchPlaceWidgetState extends State<SearchPlaceWidget> {
  final txtSearch = TextEditingController();
  final wsPlace = WSSearchPlaces();
  List<PlaceInfoModel> lugares = [];
  bool loading = false;
  FocusNode searchNode = FocusNode();

  @override
  void initState() {
    super.initState();
    txtSearch.text = widget.text;
    obtenerLugar(null);
  }

  Future<void> obtenerLugar(String? val) async {
    if (val != null) {
      setState(() => loading = true);
      var res = await wsPlace.obtenerDetallesLugar(val);

      if (res?.isNotEmpty ?? false) {
        lugares = res!;
      }

      setState(() => loading = false);
    } else if (widget.text.isNotEmpty) {
      setState(() => loading = true);
      var res = await wsPlace.obtenerDetallesLugar(widget.text);

      if (res?.isNotEmpty ?? false) {
        lugares = res!;
      }

      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 20,
          backgroundColor: Colors.grey.shade200,
          centerTitle: false,
          title: InputTextFormFields(
              focus: searchNode,
              padding: EdgeInsets.zero,
              icon: IconButton(
                  onPressed: () {
                    setState(() {
                      txtSearch.clear();
                      lugares.clear();
                    });
                    searchNode.requestFocus();
                  },
                  icon: const Icon(Icons.clear, size: 20)),
              onChanged: (val) async {
                if (val?.isNotEmpty ?? false) {
                  await obtenerLugar(val);
                }
              },
              controlador: txtSearch,
              placeHolder: "Ingrese la dirección",
              inputBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
              nombreCampo: "",
              accionCampo: TextInputAction.done),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                  child: loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : lugares.isEmpty
                          ? const Center(
                              child: Text("No se encontraron ubicaciones..."),
                            )
                          : ListView.builder(
                              itemCount: lugares.length,
                              itemBuilder: (_, i) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pop(context, lugares[i]);
                                  },
                                  child: ListTile(
                                    leading: const Icon(Icons.location_on),
                                    title: Text(
                                      lugares[i].name ?? "",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      lugares[i].formattedAddress ?? "",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                );
                              }))
            ],
          ),
        ),
      ),
    );
  }
}
