// ignore_for_file: unnecessary_null_comparison
import 'dart:ui';
import 'package:abi_praxis_app/src/controller/preferences/app_preferences.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/loading.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../utils/app_bar.dart';
import '../../controller/map_service.dart';
import '../../controller/provider/map/map_controller.dart';
import '../../models/mapas/detalle_place_model.dart';
import '../../models/mapas/place_model.dart';
import 'search_place_widget.dart';

class MapSelector extends StatefulWidget {
  const MapSelector({Key? key}) : super(key: key);

  @override
  _MapSelectorState createState() => _MapSelectorState();
}

class _MapSelectorState extends State<MapSelector> {
  late MyAppBar appBar;
  bool isExpanded = false;
  final appPfrc = AppPreferences();

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TutorialCoachMark tutorialCoachMark;
  GlobalKey buscadorKey = GlobalKey();
  GlobalKey currentPosKey = GlobalKey();
  GlobalKey buttonKey = GlobalKey();
  GlobalKey marcadorKey = GlobalKey();

  TextEditingController txtController = TextEditingController();
  TextEditingController txtNombreController = TextEditingController();
  GeocodingPlatform? obtenerDireccion;
  LatLng? newCoor;
  final wsPlaces = WSSearchPlaces();
  int? idUser;
  String dire = '';
  String? address;
  String? misCoordenadas;
  String? latitud;
  String? direccionEscrita;
  String? longitud;
  bool direcciones = false;
  bool placeMap = true;
  bool buscador = false;
  bool loading = false;
  bool chargedMap = false;
  GoogleMapController? controllerMap;

  @override
  void initState() {
    super.initState();
    //todo NAVEGAR SI SE PRESENTA UNA NOTIFICACIÓN
    appBar = MyAppBar(key: key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: appBar.myAppBar(context: context),
      drawer: DrawerMenu(),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 45,
                color: Colors.black,
                width: double.infinity,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setBool('inicio', false);
                        Navigator.pop(context);
                      },
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Agregar nueva dirección',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: cuerpo()),
            ],
          ),
          if (!chargedMap)
            Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color.fromRGBO(0, 0, 0, 120),
                child: Center(child: loadingWidget(text: "Cargando mapa..."))),
          if (loading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromRGBO(0, 0, 0, 120),
              child: Center(child: loadingWidget()),
            )
        ],
      ),
    );
  }

  Widget cuerpo() {
    return Selector<MapaController, bool>(
      selector: (_, controller) => controller.loading,
      builder: (context, loading, loadingWidget) {
        if (loading) {
          return loadingWidget!;
        }
        return Consumer<MapaController>(
          builder: (_, mapaControlador, enableGpsWidget) {
            if (!mapaControlador.gpsEnable) enableGpsWidget!;
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: GoogleMap(
                          mapType: MapType.normal,
                          myLocationButtonEnabled: false,
                          onCameraMove: (CameraPosition position) async {
                            setState(() {
                              latitud = position.target.latitude.toString();
                              longitud = position.target.longitude.toString();
                            });
                          },
                          onCameraIdle: () async {
                            if (!buscador) {
                              await buscarDireccion(double.parse(latitud!),
                                  double.parse(longitud!));
                              setState(() {
                                txtController.text = direccionEscrita!;
                              });
                            }
                          },
                          onMapCreated: (controller) async {
                            print("mapa creado");

                            final tutorial = await appPfrc.getTutorialMap();
                            setState(() => chargedMap = true);

                            if (!tutorial) {
                              crearTutorial();
                              Future.delayed(Duration.zero, showTutorial);
                            }

                            controllerMap = controller;
                            await buscarDireccion(
                                double.parse(mapaControlador.latitud),
                                double.parse(mapaControlador.longitud));
                            setState(() {
                              latitud = mapaControlador.latitud;
                              longitud = mapaControlador.longitud;
                              txtController.text = direccionEscrita!;
                            });
                          },
                          initialCameraPosition:
                              mapaControlador.initialCameraPosition!),
                    ),
                  ],
                ),
                cuadroDeBusqueda(),
                Align(
                  alignment: Alignment.center,
                  child: Visibility(
                    //: mostrarImagenFlotante,
                    child: Container(
                      key: marcadorKey,
                      margin: const EdgeInsets.only(bottom: 20),
                      width: 60,
                      height: 60,
                      child: Image.asset(
                        'assets/marcador/abipraxis.png',
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: botonGuardar(),
                ),
              ],
            );
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Para utilizar la opción del mapa, debe activar el gps.',
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    final controller = context.read<MapaController>();
                    controller.turnOnGPS();
                  },
                  child: const Text('Activar GPS'),
                ),
              ],
            ),
          ),
        );
      },
      child: Center(child: loadingWidget()),
    );
  }

  Widget botonUbicacionActual() {
    return InkWell(
        onTap: () async {
          Position position = await Geolocator.getCurrentPosition();
          controllerMap!.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(
                position.latitude,
                position.longitude,
              ),
              16,
            ),
          );
        },
        child: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(top: 15, right: 10),
          decoration: BoxDecoration(
            boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 0.5)],
            border: Border.all(color: Colors.grey.shade200),
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(
            Icons.my_location,
          ),
        ));
  }

  Widget botonGuardar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 220,
        height: 100,
        margin: const EdgeInsets.only(top: 6, left: 10),
        child: Center(
          // ignore: deprecated_member_use
          child: TextButton(
            key: buttonKey,
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
              Colors.black,
            )),
            child: const Text(
              'CONTINUAR',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              Map<String, dynamic> map = {};

              if (latitud != null && longitud != null) {
                map.addAll({"latitud": latitud, "longitud": longitud});
              }
              Navigator.pop(context, map);
            },
          ),
        ),
      ),
    );
  }

  Widget cuadroDeBusqueda() {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Row(
        children: [
          InkWell(
            key: buscadorKey,
            onTap: () => setState(() {
              isExpanded =
                  !isExpanded; // Cambia el estado para expandir/contraer
            }),
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(top: 15, left: 10, bottom: 10),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(color: Colors.black, blurRadius: 0.5)
                ],
                border: Border.all(color: Colors.grey.shade200),
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.search,
              ),
            ),
          ),
          if (!isExpanded) Expanded(child: Container()),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isExpanded ? 250.0 : 0.0,
            height: 45,
            curve: Curves.easeInOut,
            child: InkWell(
              onTap: () async {
                /* setState(() {
                      placeMap = false;
                      buscador = true;
                    });*/
                String? startText;
                if (txtController.text.isNotEmpty) {
                  setState(() {
                    startText = txtController.text;
                  });
                } else {
                  setState(() {
                    startText = "Ingrese la ubicación";
                  });
                }

                PlaceInfoModel place = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => SearchPlaceWidget(
                              text: txtController.text,
                            )));

                if (place != null) {
                  setState(() {
                    txtController.text =
                        place.name ?? place.formattedAddress ?? "";
                    setState(() => placeMap = true);
                  });

                  final plist = GoogleMapsPlaces(
                    apiKey: dotenv.env['api_places'],
                    apiHeaders: await const GoogleApiHeaders().getHeaders(),
                  );

                  String placeId = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeId);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final long = geometry.location.lng;
                  var newlatlng = LatLng(lat, long);

                  controllerMap
                      ?.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                    target: newlatlng,
                    zoom: 18,
                  )))
                      .then((value) async {
                    await Future.delayed(const Duration(milliseconds: 2000))
                        .then((value) => setState(() => buscador = false));
                  });
                } else {
                  setState(() => placeMap = true);
                }
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: TextFormField(
                  //key: buscadorKey,
                  enabled: false,
                  style: const TextStyle(color: Colors.black),
                  controller: txtController,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    enabled: true,
                    hintText: 'Ingrese una direccion',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Container(
              key: currentPosKey,
              margin: const EdgeInsets.only(bottom: 10),
              child: botonUbicacionActual()),
        ],
      ),
    );
  }

  Future<void> buscarDireccion(double latitud, double longitud) async {
    FocusScope.of(context).unfocus();

    var res =
        await wsPlaces.obtenerDireccionXCoordenada(LatLng(latitud, longitud));

    if (res != null) {
      var direccion = construirDireccion(res);

      setState(() => direccionEscrita = direccion);
    } else {
      setState(() => direccionEscrita = "");
    }
  }

  String construirDireccion(DetallesPlaceModel detalles) {
    const prioridad = [
      'route', // Calle principal
      'street_number', // Numeración
      'sublocality', // Calle secundaria
      'locality',
      //'administrative_area_level_1',
      'country',
      'postal_code'
    ];

    // Almacena las partes de la dirección en orden
    List<String> direccion = [];

    // Itera sobre la prioridad para construir la dirección
    for (String tipo in prioridad) {
      var componente = detalles.addressComponents.firstWhere(
        (c) => c.types!.contains(tipo),
        //orElse: () => null,
      );
      if (componente != null) {
        direccion.add(componente.longName!);
      }
    }

    // Forma la dirección final separando los componentes con comas
    String direccionFormada = direccion.join(', ');

    // Validar si la dirección tiene contenido
    return direccionFormada.isNotEmpty
        ? direccionFormada
        : 'Dirección desconocida';
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void crearTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: const Color.fromRGBO(0, 0, 0, 60),
      textSkip: "OMITIR",
      paddingFocus: 1,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      onFinish: () {
        debugPrint("finish");
        skipButtonFunction();
      },
      onClickTarget: (t) => debugPrint("onClickTarget: $t"),
      onClickTargetWithTapPosition: (target, tapDetails) {
        debugPrint("target: $target");
        debugPrint(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) => debugPrint('onClickOverlay: $target'),
      onSkip: () {
        skipButtonFunction();

        return true;
      },
    );
  }

  void skipButtonFunction() async {
    await appPfrc.saveTutorialMap(true);
  }

  List<TargetFocus> _createTargets() => [
        TargetFocus(
          identify: "buscadorKey",
          paddingFocus: 0.0,
          keyTarget: buscadorKey,
          alignSkip: Alignment.topRight,
          enableOverlayTab: true,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Habilitar buscador",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Ingrese la dirección que desea buscar.",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ))
          ],
        ),
        TargetFocus(
          identify: "currentPosKey",
          keyTarget: currentPosKey,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
                align: ContentAlign.left,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Posición Actual",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Regresar a su ubicación actual.",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ))
          ],
        ),
        TargetFocus(
          identify: "marcadorKey",
          keyTarget: marcadorKey,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Container(
                  height: 200,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Marcador",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Mueva el marcador para una ubicación más exacta.",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
        TargetFocus(
          identify: "buttonKey",
          keyTarget: buttonKey,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Container(
                  height: 200,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Botón continuar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Si está conforme con la ubicación del marcador, haga clic en “CONTINUAR” para guardar.",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
      ];
}
