import 'dart:io';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/productos/show_pdf.dart';
import 'package:flutter/material.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/alerts/and_alert.dart';
import 'package:abi_praxis_app/utils/alerts/ios_alert.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/cut/diagonal_cuts.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/footer.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:abi_praxis_app/utils/list/category.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../utils/header.dart';

class Products extends StatefulWidget {
  int idSubCategory;
  String subCatName;
  Products({super.key, required this.idSubCategory, required this.subCatName});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final sckey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> listSponsors = [];
  final andAlert = AndroidAlert();
  final iosAlert = IosAlert();

  @override
  void initState() {
    super.initState();
    searchSubCategory();
  }

  void searchSubCategory() {
    final data = sponsorsList
        .where((element) => element["id_sub_category"] == widget.idSubCategory)
        .toList();

    setState(() => listSponsors = data);
  }

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
          header("Productos", AbiPraxis.productos,
              context: context, back: true),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios)),
                /*const Icon(
                  Icons.folder_outlined,
                  size: 35,
                ),*/
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: Text(
                      widget.subCatName,
                      //textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
          divider(true),
          Align(
            alignment: Alignment.centerRight,
            child: ClipPath(
              clipper: DiagonalClipper(),
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                width: 245,
                height: 35,
                alignment: Alignment.center,
                color: const Color.fromRGBO(93, 97, 98, 1),
                child: const Text(
                  "Elegir Subcategoría",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: listSponsors.length,
                itemBuilder: (builder, i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => ShowPdf(
                                  idSubCategory: widget.idSubCategory,
                                  subCatName: widget.subCatName)));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: listSponsors[i]["icon"],
                                        width: 50,
                                      ),
                                      // Expanded(
                                      //     flex: 1,
                                      //     child: Align(
                                      //         alignment: Alignment.centerLeft,
                                      //         child: Container(
                                      //           decoration: BoxDecoration(
                                      //               color: listSponsors[i]
                                      //                   ["color"],
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       100)),
                                      //           width: 40,
                                      //           height: 40,
                                      //           child: const Center(
                                      //               child: Text(
                                      //             "S",
                                      //             style: TextStyle(
                                      //                 color: Colors.white,
                                      //                 fontWeight:
                                      //                     FontWeight.bold),
                                      //           )),
                                      //         ))),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            listSponsors[i]["name"],
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => ShowPdf(
                                                idSubCategory:
                                                    widget.idSubCategory,
                                                subCatName:
                                                    widget.subCatName))),
                                    icon: const Icon(Icons.arrow_forward_ios))
                                /*Row(
                                  children: [
                                    if (listSponsors[i]["complete"])
                                      const Icon(Icons.verified,
                                          color: Colors.blue)
                                    else
                                      const Icon(Icons.pending,
                                          color: Colors.yellow),
                                    const Icon(Icons.navigate_next)
                                  ],
                                )*/
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          divider(true)
                        ],
                      ),
                    ),
                  );
                }),
          ),
          footerBaadal(),
          const SizedBox(height: 10),
        ],
      );
}
