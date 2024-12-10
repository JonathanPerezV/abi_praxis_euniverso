// ignore_for_file: prefer_null_aware_operators
import 'dart:convert';

import 'package:abi_praxis_app/main.dart';
import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis_app/src/controller/provider/form_state.dart';
import 'package:abi_praxis_app/src/models/solicitud/soliciutd_credito_model.dart';
import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/credito/solicitud/forms/autorizacion_sc.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/credito/solicitud/forms/datos_conyuge_sc.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/credito/solicitud/forms/datos_garante_sc.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/credito/solicitud/forms/datos_personales_sc.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/credito/solicitud/forms/documentos_sc.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/credito/solicitud/forms/ref_economicas.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/credito/solicitud/forms/ref_personales_sc.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/credito/solicitud/forms/solicitud_producto_sc.dart';
import 'package:abi_praxis_app/src/views/inside/home/vender/credito/solicitud/view_pdf.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/cut/diagonal_cuts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../utils/buttons.dart';
import '../../../../../../../utils/flushbar.dart';
import '../../../../../../../utils/header.dart';
import '../../../../../../../utils/icons/abi_praxis_icons.dart';
import '../../../../../../../utils/loading.dart';

class SolicitudCredito extends StatefulWidget {
  int? idSolicitud;
  int? idTipoProducto;
  int? idAutorizacion;
  int idPersona;
  int? idPersonaConyuge;
  int? idPersonaGarante;
  int? idConyugeGarante;
  String? monto;
  String? actividadEcon;
  String? codActividad;
  int? idRleacionLaboral;
  int? idSector;
  String? tiempoFuncionamiento;
  int? idFuente;
  int? idPlazo;
  String? cuota;
  bool? edit;
  SolicitudCredito(
      {this.idTipoProducto,
      this.idAutorizacion,
      required this.idPersona,
      this.idConyugeGarante,
      this.idSolicitud,
      this.edit,
      this.idPersonaConyuge,
      this.idPersonaGarante,
      this.monto,
      this.actividadEcon,
      this.codActividad,
      this.idRleacionLaboral,
      this.idSector,
      this.tiempoFuncionamiento,
      this.cuota,
      this.idFuente,
      this.idPlazo,
      super.key});

  @override
  State<SolicitudCredito> createState() => _SolicitudCreditoState();
}

class _SolicitudCreditoState extends State<SolicitudCredito> {
  final _scrollController = ScrollController();
  int? idAutorizacion;
  late DraggableScrollableController _scrollableController;
  bool enableVisibility = false;
  String titulo = "";
  String path = "";

  //todo GLOBAL KEYS
  final gk1 = GlobalKey();
  final gk2 = GlobalKey();
  final gk3 = GlobalKey();
  final gk4 = GlobalKey();
  final gk5 = GlobalKey();
  final gk6 = GlobalKey();
  final gk7 = GlobalKey();
  final gk8 = GlobalKey();

  final _scKey = GlobalKey<ScaffoldState>();
  //todo TITULAR
  final _fDPkey = GlobalKey<FormState>();
  final _fNkey = GlobalKey<FormState>();
  final _fIkey = GlobalKey<FormState>();
  final _fRkey = GlobalKey<FormState>();
  final _fEkey = GlobalKey<FormState>();
  final _fAEPkey = GlobalKey<FormState>();
  final _fSkey = GlobalKey<FormState>();
  final _fECkey = GlobalKey<FormState>();
  //todo TITULAR/CONYUGE
  final _fDCkey = GlobalKey<FormState>();
  final _fNCkey = GlobalKey<FormState>();
  final _fICkey = GlobalKey<FormState>();
  final _fECCkey = GlobalKey<FormState>();
  final _fECCCkey = GlobalKey<FormState>();
  final _fAECkey = GlobalKey<FormState>();
  //todo GARANTE
  final _fDPGkey = GlobalKey<FormState>();
  final _fNGkey = GlobalKey<FormState>();
  final _fIGkey = GlobalKey<FormState>();
  final _fRGkey = GlobalKey<FormState>();
  final _fEGkey = GlobalKey<FormState>();
  final _fAEPGkey = GlobalKey<FormState>();
  final _fSGkey = GlobalKey<FormState>();
  final _fECGkey = GlobalKey<FormState>();
  //todo REFERENCIAS
  final _fRef1 = GlobalKey<FormState>();
  final _fRef2 = GlobalKey<FormState>();
  //todo SOLICITUD PRODUCTO
  final _fSProducto = GlobalKey<FormState>();

  bool loading = false;
  //todo EXPANSION TILE VARIABLES
  bool enabledExpansion = true;
  //todo VALIDACION COLORES DATOS PERSONALES
  Color? datosPersonalesC;
  Color? datosNacimientoC;
  Color? datosIdentificacionC;
  Color? datosResidenciaC;
  Color? datosEducacionC;
  Color? actEconoPrinC;
  Color? actEconoSecC;
  Color? datosSitEconC;
  Color? datosEstadoCivilC;
  //todo VALIDACION COLORES
  Color? datosGaranteC;
  Color? datosConyugeC;
  Color? refPersonalesC;
  Color? refEconomicasC;
  Color? solicitudProdC;
  Color? documentosC;
  Color? autorizacionC;

  final _exp1 = ExpansionTileController();
  final _exp2 = ExpansionTileController();
  final _exp3 = ExpansionTileController();
  final _exp4 = ExpansionTileController();
  final _exp5 = ExpansionTileController();
  final _exp6 = ExpansionTileController();
  final _exp7 = ExpansionTileController();
  final _exp8 = ExpansionTileController();

  //todo VALIDACION COLORES DATOS PERSONALES - CONYUGE
  Color? datosPersonalesConyuge;
  Color? datosNacimientoConyuge;
  Color? datosIdentificacionConyuge;
  Color? datosEducacionConyuge;
  Color? actEconoPrinConyuge;
  Color? datosCivilConyuge;

  //todo VALIDACION COLORES DATOS PERSONALES - GARANTE
  Color? datosNacimientoCG;
  Color? datosIdentificacionCG;
  Color? datosResidenciaCG;
  Color? datosEducacionCG;
  Color? actEconoPrinCG;
  Color? actEconoSecCG;
  Color? datosSitEconCG;
  Color? datosEstadoCivilCG;
  Color? datosGaranteCG;
  Color? datosConyugeCG;
  Color? refPersonalesCG;
  Color? refEconomicasCG;
  Color? solicitudProdCG;
  Color? documentosCG;
  Color? autorizacionCG;

  //todo VALIDACIÓN COLORES  DATOS - REFERENCIAS
  Color? datosReferencia1;
  Color? datosReferencia2;

  //todo VALIDACIÓN COLORES DATOS - REFERENCIAS ECONÓMICAS
  Color? datoBancarioC;
  Color? datoProveedorC;

  //todo VALICACIÓN COLORES DATOS - SOLICITUD PRODUCTO
  Color? datoColorSolicitud;

  void startLoading() {
    setState(() {
      loading = true;
    });
  }

  void stopLoading() {
    setState(() {
      loading = false;
    });
  }

  void verFirma(String? titulo, String? path) {
    if (titulo != null && path != null) {
      setState(() {
        enableVisibility = true;
        this.titulo = titulo;
        this.path = path;
      });
    } else {
      setState(() {
        enableVisibility = false;
        this.titulo = "";
        this.path = "";
      });
    }
  }

  //todo FUNCIONES PARA CAMBIAR DE COLOR DE LOS DATOS PERSONALES DEL TITULAR
  void changeColorDatosPersonales(int type) {
    if (type == 1) {
      setState(() => datosPersonalesC = Colors.green);
    } else {
      setState(() => datosPersonalesC = Colors.yellow);
    }
  }

  void changeColorNac(int type) {
    if (type == 1) {
      setState(() => datosNacimientoC = Colors.green);
      setState(() => datosPersonalesC = Colors.green);
    } else {
      setState(() => datosNacimientoC = Colors.yellow);
      setState(() => datosPersonalesC = Colors.yellow);
    }
  }

  void changeColorIdent(int type) {
    if (type == 1) {
      setState(() => datosIdentificacionC = Colors.green);
      setState(() => datosPersonalesC = Colors.green);
    } else {
      setState(() => datosIdentificacionC = Colors.yellow);
      setState(() => datosPersonalesC = Colors.yellow);
    }
  }

  void changeColorRes(int type) {
    if (type == 1) {
      setState(() => datosResidenciaC = Colors.green);
      setState(() => datosPersonalesC = Colors.green);
    } else {
      setState(() => datosResidenciaC = Colors.yellow);
      setState(() => datosPersonalesC = Colors.yellow);
    }
  }

  void changeColorEduc(int type) {
    if (type == 1) {
      setState(() => datosEducacionC = Colors.green);
      setState(() => datosPersonalesC = Colors.green);
    } else {
      setState(() => datosEducacionC = Colors.yellow);
      setState(() => datosPersonalesC = Colors.yellow);
    }
  }

  void changeColorActPrin(int type) {
    if (type == 1) {
      setState(() => actEconoPrinC = Colors.green);
      setState(() => datosPersonalesC = Colors.green);
    } else {
      setState(() => actEconoPrinC = Colors.yellow);
      setState(() => datosPersonalesC = Colors.yellow);
    }
  }

  void changeColorActSec(int type) {
    setState(() => actEconoSecC = Colors.green);
    setState(() => datosPersonalesC = Colors.green);
  }

  void changeColorSitEco(int type) {
    if (type == 1) {
      setState(() {
        datosSitEconC = Colors.green;
        datosPersonalesC = Colors.green;
      });
    } else {
      setState(() {
        datosSitEconC = Colors.yellow;
        datosPersonalesC = Colors.yellow;
      });
    }
  }

  void changeColorEstCiv(int type) {
    if (type == 1) {
      setState(() {
        datosEstadoCivilC = Colors.green;
        datosPersonalesC = Colors.green;
      });
    } else {
      setState(() {
        datosEstadoCivilC = Colors.yellow;
        datosPersonalesC = Colors.yellow;
      });
    }
  }

  //todo FUNCIONES PARA CAMBIAR DE COLOR DE LOS DATOS DEL CONYUGE
  void changeColorDatosPersonalesConyuge(int type) {
    if (type == 1) {
      setState(() {
        datosConyugeC = Colors.green;
      });
    } else {
      setState(() {
        datosConyugeC = Colors.yellow;
      });
    }
  }

  void changeColorNacConyuge(int type) {
    if (type == 1) {
      setState(() {
        datosNacimientoConyuge = Colors.green;
        datosConyugeC = Colors.green;
      });
    } else {
      setState(() {
        datosNacimientoConyuge = Colors.yellow;
        datosConyugeC = Colors.yellow;
      });
    }
  }

  void changeColorIdenConyuge(int type) {
    if (type == 1) {
      setState(() => datosIdentificacionConyuge = Colors.green);
      setState(() => datosConyugeC = Colors.green);
    } else {
      setState(() => datosIdentificacionConyuge = Colors.yellow);
      setState(() => datosConyugeC = Colors.yellow);
    }
  }

  void changeColorEducConyuge(int type) {
    if (type == 1) {
      setState(() => datosEducacionConyuge = Colors.green);
      setState(() => datosConyugeC = Colors.green);
    } else {
      setState(() => datosEducacionConyuge = Colors.yellow);
      setState(() => datosConyugeC = Colors.yellow);
    }
  }

  void changeColorEstCivConyuge(int type) {
    if (type == 1) {
      setState(() => datosCivilConyuge = Colors.green);
      setState(() => datosConyugeC = Colors.green);
    } else {
      setState(() => datosCivilConyuge = Colors.yellow);
      setState(() => datosConyugeC = Colors.yellow);
    }
  }

  void changeColorActPrinConyuge(int type) {
    setState(() => actEconoPrinConyuge = Colors.green);
    setState(() => datosConyugeC = Colors.green);
  }

  //todo FUNCIONES PARA CAMBIAR DE COLOR DE LOS DATOS PERSONALES DEL GARANTE
  void changeColorDatosPersonalesGarante(int type) {
    if (type == 1) {
      setState(() => datosGaranteC = Colors.green);
    } else {
      setState(() => datosGaranteC = Colors.yellow);
    }
  }

  void changeColorNacGarante(int type) {
    if (type == 1) {
      setState(() => datosNacimientoCG = Colors.green);
      setState(() => datosGaranteC = Colors.green);
    } else {
      setState(() => datosNacimientoCG = Colors.yellow);
      setState(() => datosGaranteC = Colors.yellow);
    }
  }

  void changeColorIdentGarante(int type) {
    if (type == 1) {
      setState(() => datosIdentificacionCG = Colors.green);
      setState(() => datosGaranteC = Colors.green);
    } else {
      setState(() => datosIdentificacionCG = Colors.yellow);
      setState(() => datosGaranteC = Colors.yellow);
    }
  }

  void changeColorResGarante(int type) {
    if (type == 1) {
      setState(() => datosResidenciaCG = Colors.green);
      setState(() => datosGaranteC = Colors.green);
    } else {
      setState(() => datosResidenciaCG = Colors.yellow);
      setState(() => datosGaranteC = Colors.yellow);
    }
  }

  void changeColorEducGarante(int type) {
    if (type == 1) {
      setState(() => datosEducacionCG = Colors.green);
      setState(() => datosGaranteC = Colors.green);
    } else {
      setState(() => datosEducacionCG = Colors.yellow);
      setState(() => datosGaranteC = Colors.yellow);
    }
  }

  void changeColorActPrinGarante(int type) {
    if (type == 1) {
      setState(() => actEconoPrinCG = Colors.green);
      setState(() => datosGaranteC = Colors.green);
    } else {
      setState(() => actEconoPrinCG = Colors.yellow);
      setState(() => datosGaranteC = Colors.yellow);
    }
  }

  void changeColorActSecGarante(int type) {
    setState(() => actEconoSecCG = Colors.green);
    setState(() => datosGaranteC = Colors.green);
  }

  void changeColorSitEcoGarante(int type) {
    if (type == 1) {
      setState(() {
        datosSitEconCG = Colors.green;
        datosGaranteC = Colors.green;
      });
    } else {
      setState(() {
        datosSitEconCG = Colors.yellow;
        datosGaranteC = Colors.yellow;
      });
    }
  }

  void changeColorEstCivGarante(int type) {
    if (type == 1) {
      setState(() {
        datosEstadoCivilCG = Colors.green;
        datosGaranteC = Colors.green;
      });
    } else {
      setState(() {
        datosEstadoCivilCG = Colors.yellow;
        datosGaranteC = Colors.yellow;
      });
    }
  }

  //todo FUNCIONES PARA CAMBIAR DE COLOR DE REFERENCIAS
  void changeColorReferencia1(int type) {
    if (type == 1) {
      setState(() {
        datosReferencia1 = Colors.green;
        refPersonalesC = Colors.green;
      });
    } else {
      setState(() {
        datosReferencia1 = Colors.yellow;
        refPersonalesC = Colors.yellow;
      });
    }
  }

  void changeColorReferencia2(int type) {
    if (type == 1) {
      setState(() {
        datosReferencia2 = Colors.green;
        refPersonalesC = Colors.green;
      });
    } else {
      setState(() {
        datosReferencia2 = Colors.yellow;
        refPersonalesC = Colors.yellow;
      });
    }
  }

  void changeColorReferencias(int type) {
    if (type == 1) {
      setState(() {
        refPersonalesC = Colors.green;
      });
    } else {
      setState(() {
        refPersonalesC = Colors.yellow;
      });
    }
  }

  //todo FUNCIONES PARA CAMBIAR DE COLOR DE REFERENCIAS ECONÓMICAS

  //todo FUNCIONES PARA CAMBIAR DE COLOR DE SOLICITUD DE PRODUCTO
  void changeColorSolicitud(int type) {
    if (type == 1) {
      setState(() => datoColorSolicitud = Colors.green);
    } else {
      setState(() => datoColorSolicitud = Colors.yellow);
    }
  }

  //todo FUNCION PARA CAMBIAR DE COLOR DE DOCUMENTOS
  void changeColorDocumento(int type) {
    setState(() => documentosC = Colors.green);
  }

  void changeColorAutorizacion(int type) {
    setState(() => autorizacionC = Colors.green);
  }

  void updatePixelPosition(GlobalKey key) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        final position = box.localToGlobal(Offset.zero,
            ancestor: context.findRenderObject());
        _scrollController.animateTo(
          _scrollController.offset +
              position.dy -
              AppBar().preferredSize.height -
              125, // Ajusta con la posición actual del scroll
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void getData() async {
    if (widget.idSolicitud != null) {
      final sol = await op.obtenerSolicitud(widget.idSolicitud!);

      if (sol != null) {
        setState(() => idAutorizacion = sol.idAutorizacion);
        changeColorDocumento(2);
        changeColorAutorizacion(2);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    _scrollableController = DraggableScrollableController();
    var form = Provider.of<FormProvider>(context, listen: false);
    Future.delayed(const Duration(milliseconds: 500))
        .then((_) => form.limpiarDatos());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var form = Provider.of<FormProvider>(context, listen: false);
        form.limpiarDatos();
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Consumer<FormProvider>(builder: (context, form, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            key: _scKey,
            drawer: DrawerMenu(inicio: false),
            appBar: MyAppBar(key: _scKey).myAppBar(context: context),
            body: Stack(
              children: [
                options(),
                if (loading) loadingWidget(text: "Obteniendo datos...")
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget options() {
    return Column(
      children: [
        header("Productivo", AbiPraxis.productivo, context: context),
        Align(
          alignment: Alignment.centerRight,
          child: ClipPath(
            clipper: DiagonalClipper(),
            child: Container(
              //margin: const EdgeInsets.only(right: 15),
              width: 245,
              height: 35,
              alignment: Alignment.center,
              color: const Color.fromRGBO(93, 97, 98, 1),
              child: const Text(
                "Solicitud de crédito",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        listExpansions(),
      ],
    );
  }

  Widget listExpansions() => Expanded(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  //todo DATOS PERSONALES
                  DatosPersonalesCredito(
                    edit: widget.edit,
                    idSolicitud: widget.idSolicitud,
                    gk: gk1,
                    changeColorDatosPersonales: changeColorDatosPersonales,
                    changeColorNac: changeColorNac,
                    changeColorIden: changeColorIdent,
                    changeColorRes: changeColorRes,
                    changeColorEduc: changeColorEduc,
                    changeColorActPrin: changeColorActPrin,
                    changeColorActSec: changeColorActSec,
                    changeColorSitEco: changeColorSitEco,
                    changeColorEstCiv: changeColorEstCiv,
                    formKey: _fDPkey,
                    enableExpansion: enabledExpansion,
                    fAEkey: _fAEPkey,
                    fECkey: _fECkey,
                    fEkey: _fEkey,
                    fIkey: _fIkey,
                    fNkey: _fNkey,
                    fRkey: _fRkey,
                    fSEkey: _fSkey,
                    expController: _exp1,
                    idPersona: widget.idPersona,
                    startLoading: startLoading,
                    stopLoading: stopLoading,
                    actEconoPrinC: actEconoPrinC,
                    actEconoSecC: actEconoSecC,
                    datosEducacionC: datosEducacionC,
                    datosEstadoCivilC: datosEstadoCivilC,
                    datosIdentificacionC: datosIdentificacionC,
                    datosNacimientoC: datosNacimientoC,
                    datosPersonalesC: datosPersonalesC,
                    datosResidenciaC: datosResidenciaC,
                    datosSitEconC: datosSitEconC,
                    updatePixelPosition: updatePixelPosition,
                    actividadEconomica: widget.actividadEcon,
                    codigoActividad: widget.codActividad,
                    idRelacionLaboral: widget.idRleacionLaboral,
                    idSector: widget.idSector,
                    tiempoFunciones: widget.tiempoFuncionamiento,
                  ),
                  //todo DATOS DEL CONYUGE/CONVIVIENET
                  DatosConyugeCredito(
                    edit: widget.edit,
                    idSolicitud: widget.idSolicitud,
                    gk: gk2,
                    changeColorActPrin: changeColorActPrinConyuge,
                    changeColorDatosPersonales:
                        changeColorDatosPersonalesConyuge,
                    changeColorEduc: changeColorEducConyuge,
                    changeColorIden: changeColorIdenConyuge,
                    changeColorNac: changeColorNacConyuge,
                    changeColorEstCivil: changeColorEstCivConyuge,
                    actEconoPrinConyuge: actEconoPrinConyuge,
                    datosEducacionConyuge: datosEducacionConyuge,
                    datosIdentificacionConyuge: datosIdentificacionConyuge,
                    datosNacimientoConyuge: datosNacimientoConyuge,
                    datosCivilConyuge: datosCivilConyuge,
                    datosConyugeC: datosConyugeC,
                    enableExpansion: enabledExpansion,
                    expController: _exp2,
                    fAECkey: _fAECkey,
                    fECkey: _fECCkey,
                    fICkey: _fICkey,
                    fNCkey: _fNCkey,
                    fECCkey: _fECCCkey,
                    formKey: _fDCkey,
                    idConyuge: widget.idPersonaConyuge ?? 0,
                    startLoading: startLoading,
                    stopLoading: stopLoading,
                    updatePixelPosition: updatePixelPosition,
                  ),
                  //todo DATOS GARANTE
                  DatosGaranteCredito(
                    edit: widget.edit,
                    idSolicitud: widget.idSolicitud,
                    gk: gk3,
                    formKey: _fDPGkey,
                    updatePixelPosition: updatePixelPosition,
                    enableExpansion: enabledExpansion,
                    fAEGkey: _fAEPGkey,
                    fECGkey: _fECGkey,
                    fEGkey: _fEGkey,
                    fIGkey: _fIGkey,
                    fNGkey: _fNGkey,
                    fRGkey: _fRGkey,
                    fSEGkey: _fSGkey,
                    idGarante: widget.idPersonaGarante ?? 0,
                    startLoading: startLoading,
                    stopLoading: stopLoading,
                    expController: _exp3,
                    changeColorActPrin: changeColorActPrinGarante,
                    changeColorActSec: changeColorActSecGarante,
                    changeColorDatosPersonales:
                        changeColorDatosPersonalesGarante,
                    changeColorEduc: changeColorEducGarante,
                    changeColorEstCiv: changeColorEstCivGarante,
                    changeColorIden: changeColorIdentGarante,
                    changeColorNac: changeColorNacGarante,
                    changeColorRes: changeColorResGarante,
                    changeColorSitEco: changeColorSitEcoGarante,
                    actEconoPrinC: actEconoPrinCG,
                    actEconoSecC: actEconoSecCG,
                    datosEducacionC: datosEducacionCG,
                    datosEstadoCivilC: datosEstadoCivilCG,
                    datosIdentificacionC: datosIdentificacionCG,
                    datosNacimientoC: datosNacimientoCG,
                    datosPersonalesG: datosGaranteC,
                    datosResidenciaC: datosResidenciaCG,
                    datosSitEconC: datosSitEconCG,
                  ),
                  //todo REEFERENCIAS PERSONALES
                  ReferenciasPersonales(
                    edit: widget.edit,
                    idSolicitud: widget.idSolicitud,
                    gk: gk4,
                    updatePixelPosition: updatePixelPosition,
                    datosReferencia1: datosReferencia1,
                    datosReferencia2: datosReferencia2,
                    changeColorRef1: changeColorReferencia1,
                    changeColorRef2: changeColorReferencia2,
                    keyRef1: _fRef1,
                    keyRef2: _fRef2,
                    enableExpansion: enabledExpansion,
                    changeColorReferencias: changeColorReferencias,
                    datosReferencia: refPersonalesC,
                    expController: _exp4,
                    startLoading: startLoading,
                    stopLoading: stopLoading,
                  ),
                  //todo REEFERENCIAS ECONÓMICAS
                  ReferenciasEconomicas(
                    edit: widget.edit,
                    idSolicitud: widget.idSolicitud,
                    gk: gk5,
                    updatePixelPosition: updatePixelPosition,
                    expController: _exp5,
                    datosReferencia: refEconomicasC,
                    enableExpansion: enabledExpansion,
                    datoBancarioC: datoBancarioC,
                    datoProveedorC: datoProveedorC,
                  ),
                  //todo SOLICITUD DE PRODUCTO
                  SolicitudProducto(
                    edit: widget.edit,
                    stopLoading: stopLoading,
                    idSolicitud: widget.idSolicitud,
                    gk: gk6,
                    updatePixelPosition: updatePixelPosition,
                    dataColorSolicitud: datoColorSolicitud,
                    changeColorSolicitud: changeColorSolicitud,
                    enableExpansion: enabledExpansion,
                    expController: _exp6,
                    formKey: _fSProducto,
                    monto: widget.monto,
                    cuota: widget.cuota,
                    plazo: widget.idPlazo,
                    fuente: widget.idFuente,
                  ),
                  //todo DOCUMENTOS
                  DocumentosSC(
                    edit: widget.edit,
                    idSolicitud: widget.idSolicitud,
                    gk: gk7,
                    updatePixelPosition: updatePixelPosition,
                    datoDocumentoC: documentosC,
                    changeColorDocumentosC: changeColorDocumento,
                    enableExpansion: enabledExpansion,
                    expController: _exp7,
                    idPersona: widget.idPersona,
                    idGarante: widget.idPersonaGarante,
                    idConyuge: widget.idPersonaConyuge,
                    idConyGarante: widget.idPersonaGarante,
                  ),
                  //todo AUTORIZACIÓN
                  AutorizacionSc(
                      firmaCallback: verFirma,
                      edit: widget.edit,
                      idSolicitud: widget.idSolicitud,
                      gk: gk8,
                      changeColorAutorizacionC: changeColorAutorizacion,
                      enableExpansion: enabledExpansion,
                      updatePixelPosition: updatePixelPosition,
                      datoAutorizacionC: autorizacionC,
                      expController: _exp8),
                  //todo BUTTONS
                  const SizedBox(height: 15),
                  buttons(),
                ],
              ),
            ),
            mostrarFirma(),
          ],
        ),
      );

  Widget buttons() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.idSolicitud == null)
                nextButton(
                    onPressed: () => guardarSolicitudPendiente(),
                    text: /*widget.edit ? "Regresar" :*/ "Pendiente",
                    width: 110,
                    background: const Color.fromRGBO(38, 72, 162, 1)),
              nextButton(
                  onPressed: () => validarFormulario(),
                  text: "Finalizar",
                  width: 110),
            ],
          ),
          nextButton(
              onPressed: () {
                final form = Provider.of<FormProvider>(context, listen: false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => ViewPDF(
                            solicitud: SolicitudCreditoModel(
                                usuarioCreacion: 0,
                                idAutorizacion:
                                    widget.idAutorizacion ?? idAutorizacion!,
                                idPersona: widget.idPersona,
                                idPromotor: 0,
                                idTipoProducto: widget.idTipoProducto ?? 1,
                                monto: widget.monto?.replaceAll(".", ""),
                                datosPersonales: form.titular.toJson(),
                                datosConyuge: form.conyuge.toJson(),
                                datosGarante: form.garante.toJson(),
                                refPersonales: form.referencias.toJson(),
                                refEconomicas: form.refEconomicas.toJson(),
                                documentos:
                                    jsonEncode(form.documentos.documentos),
                                solicitudProd: form.solicitud.toJson(),
                                autorizacion: form.autorizacion.toJson(),
                                estado: 2))));
              },
              text: "Generar PDF")
        ],
      );

  void validarFormulario() async {
    final pfrc = UserPreferences();
    final idPromotor = await pfrc.getIdPromotor();
    final idUser = await pfrc.getIdUser();
    final form = Provider.of<FormProvider>(context, listen: false);

    //todo VALIDAR DATOS PERSONALES DEL TITULAR
    if (!validarDatosTitular()) return;
    //todo VALIDAR OPCIONES DE LOS DATOS DEL CÓNYUGE
    if (!validarDatosConyuge()) return;
    //todo VALDIAR DATOS DEL GARANTE
    if (!validarDatosGarante()) return;
    //todo VALIDAR DATOS REFERENCIAS PERSONALES
    if (!validarDatosReferenciasPersonales()) return;
    //todo VALIDAR DATOS REFERENCIAS ECONÓMICAS
    setState(() => refEconomicasC = Colors.green);
    //todo VALIDAR DATOS SOLICITUD DE PRODUCTO
    if (!validarDatosSolicitudProducto()) return;
    //todo VALIDAR DOCUMENTOS SUBIDOS
    setState(() => documentosC = Colors.yellow);
    //todo VALIDAR AUTORIZACIONES
    setState(() => autorizacionC = Colors.yellow);

    var ref = form.referencias;

    var newRef1 = PersonaModel(
        usuarioCreacion: idUser,
        apellidos: ref.getValueRef1("apellidos") ?? "",
        nombres: ref.getValueRef1("nombres") ?? "",
        celular1: ref.getValueRef1("celular1"),
        celular2: ref.getValueRef1("celular2"),
        direccion: ref.getValueRef1("direccion"),
        estado: "A");

    var newRef2 = PersonaModel(
        usuarioCreacion: idUser,
        apellidos: ref.getValueRef2("apellidos") ?? "",
        nombres: ref.getValueRef2("nombres") ?? "",
        celular1: ref.getValueRef2("celular1"),
        celular2: ref.getValueRef2("celular2"),
        direccion: ref.getValueRef1("direccion"),
        estado: "A");

    //todo insertamos a la referencia 1 y la creamos como prospecto
    var id = form.referencias.getValueRef1("id_persona");
    if ((id?.isNotEmpty ?? false) && id != "null") {
      await op.actualizarPersona(int.parse(id!), newRef1);
    } else {
      final insertRef1 = await op.insertarPersona(newRef1, isProsp: true);
      ref.updateValueRef1("id_persona", insertRef1.toString());
    }

    //todo insertamos a la referencia 2 y la creamos como prospecto
    var id2 = form.referencias.getValueRef2("id_persona");
    if ((id2?.isNotEmpty ?? false) && id2 != "null") {
      await op.actualizarPersona(int.parse(id2!), newRef2);
    } else {
      final insertRef2 = await op.insertarPersona(newRef2, isProsp: true);
      ref.updateValueRef2("id_persona", insertRef2.toString());
    }

    final solicitud = SolicitudCreditoModel(
        usuarioCreacion: idUser,
        idAutorizacion: widget.idAutorizacion ?? idAutorizacion!,
        idPersona: widget.idPersona,
        idPromotor: idPromotor,
        idTipoProducto: widget.idTipoProducto ?? 1,
        monto: widget.monto?.replaceAll(".", ""),
        datosPersonales: form.titular.toJson(),
        datosConyuge: form.conyuge.toJson(),
        datosGarante: form.garante.toJson(),
        refPersonales: form.referencias.toJson(),
        refEconomicas: form.refEconomicas.toJson(),
        documentos: jsonEncode(form.documentos.documentos),
        solicitudProd: form.solicitud.toJson(),
        autorizacion: form.autorizacion.toJson(),
        estado: 2);

    setState(() => loading = true);
    var res = 0;

    if (widget.edit == null || widget.idSolicitud == null) {
      res = await op.insertarSolicitud(solicitud);
    } else {
      res = await op.actualizarSolicitud(solicitud, widget.idSolicitud!);
    }

    var listDocuments = form.documentos.documentos;

    if (listDocuments.isNotEmpty) {
      for (var doc in listDocuments) {
        //actualizo id de la solicitud al id ingresado
        if (doc.idDocumento != null) {
          var update =
              await op.actualizarDocumentoSolicitud(doc, doc.idDocumento!);
          debugPrint(
              "documento de la solicitud: ${update == 1 ? "ACTUALIZADO" : "NO ACTUALIZADO"}");
        } else {
          doc.idSolicitud = res;
          var insertDoc = await op.insertarDocumentoSolicitud(doc);

          debugPrint(
              "documento de la solicitud: ${insertDoc != 0 ? "AGREGADO" : "NO AGREGADO"}");
        }
      }
    }

    setState(() => loading = false);

    if (res != 0) {
      scaffoldMessenger(context, "Solicitud guardada correctamente",
          icon: const Icon(Icons.check, color: Colors.green));
    } else {
      scaffoldMessenger(
          context, "No se generó la solicitud, inténtelo de nuevo más tarde",
          icon: const Icon(Icons.error, color: Colors.red));
    }
  }

  bool validarDatosTitular() {
    bool ok = false;
    //todo validamos el estado del formulario de datos personasles, si está lleno avanza, caso contrario regresa error campos obligatorios
    if (!_fDPkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos del titular");
      _exp1.expand();
      cerrarTabs(1);
      setState(() => datosPersonalesC = Colors.red);

      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(nacimiento), si está lleno avanza, caso contrario regresa error campos obligatorios
    if (_fDPkey.currentState!.validate() && !_fNkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos de nacimiento");
      _exp1.expand();
      cerrarTabs(1);
      setState(() => datosNacimientoC = Colors.red);
      setState(() => datosPersonalesC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(identificacion), si está lleno avanza, caso contrario regresa error campos obligatorios
    if (_fDPkey.currentState!.validate() && !_fIkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos de identificación");
      _exp1.expand();
      cerrarTabs(1);
      setState(() => datosIdentificacionC = Colors.red);
      setState(() => datosPersonalesC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(residencia), si está lleno avanza, caso contrario regresa error campos obligatorios
    if (_fDPkey.currentState!.validate() && !_fRkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos de residencia");
      _exp1.expand();
      cerrarTabs(1);
      setState(() => datosResidenciaC = Colors.red);
      setState(() => datosPersonalesC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(educación), si está lleno avanza, caso contrario regresa error campos obligatorios
    if (_fDPkey.currentState!.validate() && !_fEkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos de educación");
      _exp1.expand();
      cerrarTabs(1);
      setState(() => datosEducacionC = Colors.red);
      setState(() => datosPersonalesC = Colors.yellow);

      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(act princ), si está lleno avanza, caso contrario regresa error campos obligatorios
    if (_fDPkey.currentState!.validate() &&
        !_fAEPkey.currentState!.validate()) {
      scaffoldMessenger(
          context, "Faltan datos de la actividad económica principal");
      _exp1.expand();
      cerrarTabs(1);
      setState(() => actEconoPrinC = Colors.red);
      setState(() => datosPersonalesC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(sit econ), si está lleno avanza, caso contrario regresa error campos obligatorios
    if (_fDPkey.currentState!.validate() && !_fSkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos de la situación económica");
      _exp1.expand();
      cerrarTabs(1);
      setState(() => datosSitEconC = Colors.red);
      setState(() => datosPersonalesC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(est civil), si está lleno avanza, caso contrario regresa error campos obligatorios
    if (_fDPkey.currentState!.validate() && !_fECkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos de estado civil");
      _exp1.expand();
      cerrarTabs(1);

      setState(() => datosEstadoCivilC = Colors.red);
      setState(() => datosPersonalesC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }

    return ok;
  }

  bool validarDatosConyuge() {
    bool ok = false;
    var conyugeNotifier = Provider.of<FormProvider>(context, listen: false);

    String conyCedula =
        conyugeNotifier.conyuge.getValueIdentificacion("cedula") ?? "";

    if (conyCedula == "") {
      setState(() => datosConyugeC = Colors.green);
      setState(() => ok = true);
      return ok;
    }
    //todo DATOS PERSONALES DE CONYUGE VALIDACIÓN
    if (conyCedula.isNotEmpty && !_fDCkey.currentState!.validate()) {
      scaffoldMessenger(
          context, "Falta completar los datos del cónyuge del titular");
      _exp2.expand();
      cerrarTabs(2);

      setState(() {
        datosConyugeC = Colors.red;
      });
      return false;
    } else {
      setState(() => ok = true);
    }

    //todo DATOS NACIMIENTO DEL CONYUGE VALIDACIÓN
    if ((conyCedula.isNotEmpty && conyCedula != "null") &&
        (_fDCkey.currentState!.validate() &&
            !_fNCkey.currentState!.validate())) {
      scaffoldMessenger(
          context, "Falta completar los datos nacimiento del cónyuge");
      _exp2.expand();
      cerrarTabs(2);

      setState(() {
        datosNacimientoConyuge = Colors.red;
        datosConyugeC = Colors.yellow;
      });

      return false;
    } else {
      setState(() => ok = true);
    }

    //todo DATOS DE IDENTIFICACIÓN DEL CÓNYUGE VALIDACIÓN
    if ((conyCedula.isNotEmpty && conyCedula != "null") &&
        (_fDCkey.currentState!.validate() &&
            !_fICkey.currentState!.validate())) {
      scaffoldMessenger(
          context, "Falta completar los datos identificación del cónyuge");
      _exp2.expand();
      cerrarTabs(2);

      setState(() {
        datosIdentificacionConyuge = Colors.red;
        datosConyugeC = Colors.yellow;
      });
      return false;
    } else {
      setState(() => ok = true);
    }

    //todo DATOS DE EDUCACIÓN DEL CÓNYUGE VALIDACIÓN
    if ((conyCedula.isNotEmpty && conyCedula != "null") &&
        (_fDCkey.currentState!.validate() &&
            !_fECCkey.currentState!.validate())) {
      scaffoldMessenger(
          context, "Falta completar los datos de educación del cónyuge");
      _exp2.expand();
      cerrarTabs(2);

      setState(() {
        datosEducacionConyuge = Colors.red;
        datosConyugeC = Colors.yellow;
      });
      return false;
    } else {
      setState(() => ok = true);
    }

    //todo DATOS DE ESTADO CIVIL DEL CÓNYUGE VALIDACIÓN
    if ((conyCedula.isNotEmpty && conyCedula != "null") &&
        (_fDCkey.currentState!.validate() &&
            !_fECCCkey.currentState!.validate())) {
      scaffoldMessenger(
          context, "Falta completar los datos de estado civil del cónyuge");
      _exp2.expand();
      cerrarTabs(2);

      setState(() {
        datosCivilConyuge = Colors.red;
        datosConyugeC = Colors.yellow;
      });
      return false;
    } else {
      setState(() => ok = true);
    }

    return ok;
  }

  bool validarDatosGarante() {
    bool ok = false;
    //todo validamos el estado del formulario de datos personasles, si está lleno avanza, caso contrario regresa error campos obligatorios - GARANTE
    if (!_fDPGkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos del garante");
      _exp3.expand();
      cerrarTabs(3);
      setState(() => datosGaranteC = Colors.red);
      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(nacimiento), si está lleno avanza, caso contrario regresa error campos obligatorios - GARANTE
    if (_fDPGkey.currentState!.validate() &&
        !_fNGkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos de nacimiento del garante");
      _exp3.expand();
      cerrarTabs(3);
      setState(() => datosNacimientoCG = Colors.red);
      setState(() => datosGaranteC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(identificacion), si está lleno avanza, caso contrario regresa error campos obligatorios - GARANTE
    if (_fDPGkey.currentState!.validate() &&
        !_fIGkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos de identificación del garante");
      _exp3.expand();
      cerrarTabs(3);
      setState(() => datosIdentificacionCG = Colors.red);
      setState(() => datosGaranteC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(residencia), si está lleno avanza, caso contrario regresa error campos obligatorios - GARANTE
    if (_fDPGkey.currentState!.validate() &&
        !_fRGkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos de residencia del garante");
      _exp3.expand();
      cerrarTabs(3);
      setState(() => datosResidenciaCG = Colors.red);
      setState(() => datosGaranteC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(educación), si está lleno avanza, caso contrario regresa error campos obligatorios - GARANTE
    if (_fDPGkey.currentState!.validate() &&
        !_fEGkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos de educación del garante");
      _exp3.expand();
      cerrarTabs(3);
      setState(() => datosEducacionCG = Colors.red);
      setState(() => datosGaranteC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(act princ), si está lleno avanza, caso contrario regresa error campos obligatorios - GARANTE
    if (_fDPGkey.currentState!.validate() &&
        !_fAEPGkey.currentState!.validate()) {
      scaffoldMessenger(context,
          "Faltan datos de la actividad económica principal del garante");
      _exp3.expand();
      cerrarTabs(3);
      setState(() => actEconoPrinCG = Colors.red);
      setState(() => datosGaranteC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(sit econ), si está lleno avanza, caso contrario regresa error campos obligatorios - GARANTE
    if (_fDPGkey.currentState!.validate() &&
        !_fSGkey.currentState!.validate()) {
      scaffoldMessenger(
          context, "Faltan datos de la situación económica del garante");
      _exp3.expand();
      cerrarTabs(3);
      setState(() => datosSitEconCG = Colors.red);
      setState(() => datosGaranteC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }
    //todo validamos el estado del formulario de datos personasles(est civil), si está lleno avanza, caso contrario regresa error campos obligatorios - GARANTE
    if (_fDPGkey.currentState!.validate() &&
        !_fECGkey.currentState!.validate()) {
      scaffoldMessenger(context, "Faltan datos de estado civil del garante");
      _exp3.expand();
      cerrarTabs(3);

      setState(() => datosEstadoCivilCG = Colors.red);
      setState(() => datosGaranteC = Colors.yellow);
      return false;
    } else {
      setState(() => ok = true);
    }

    return ok;
  }

  bool validarDatosReferenciasPersonales() {
    bool ok = false;
    if (!_fRef1.currentState!.validate()) {
      scaffoldMessenger(
          context, "Falta completar los datos de la referencia personal 1");
      _exp4.expand();
      cerrarTabs(4);

      setState(() {
        refPersonalesC = Colors.yellow;
        datosReferencia1 = Colors.red;
      });
      return false;
    } else {
      setState(() => ok = true);
    }

    if (!_fRef2.currentState!.validate()) {
      scaffoldMessenger(
          context, "Falta completar los datos de la referencia personal 2");
      _exp4.expand();
      cerrarTabs(4);

      setState(() {
        refPersonalesC = Colors.yellow;
        datosReferencia2 = Colors.red;
      });
      return false;
    } else {
      setState(() => ok = true);
    }

    return ok;
  }

  bool validarDatosSolicitudProducto() {
    bool ok = false;
    if (!_fSProducto.currentState!.validate()) {
      scaffoldMessenger(
          context, "Falta completar los datos de la solicitud ded producto");
      _exp6.expand();
      cerrarTabs(6);

      setState(() {
        solicitudProdC = Colors.red;
      });
      return false;
    } else {
      setState(() => ok = true);
    }

    return ok;
  }

  void guardarSolicitudPendiente() async {
    final pfrc = UserPreferences();
    final idPromotor = await pfrc.getIdPromotor();
    final idUser = await pfrc.getIdUser();
    final form = Provider.of<FormProvider>(context, listen: false);

    final solicitud = SolicitudCreditoModel(
        usuarioCreacion: idUser,
        idAutorizacion: widget.idAutorizacion!,
        idPersona: widget.idPersona!,
        idPromotor: idPromotor,
        idTipoProducto: widget.idTipoProducto!,
        datosPersonales: form.titular.toJson(),
        datosConyuge: form.conyuge.toJson(),
        datosGarante: form.garante.toJson(),
        refPersonales: form.referencias.toJson(),
        refEconomicas: form.refEconomicas.toJson(),
        solicitudProd: form.solicitud.toJson(),
        documentos: jsonEncode(form.documentos.documentos),
        autorizacion: form.autorizacion.toJson(),
        estado: 1);

    setState(() => loading = true);

    var res = await op.insertarSolicitud(solicitud);

    setState(() => loading = false);

    if (res != 0) {
      scaffoldMessenger(context, "Solicitud guardada con estado pendiente",
          icon: const Icon(Icons.check, color: Colors.green));
    } else {
      scaffoldMessenger(
          context, "No se generó la solicitud, inténtelo de nuevo más tarde",
          icon: const Icon(Icons.error, color: Colors.red));
    }
  }

  void cerrarTabs(int index) {
    switch (index) {
      case 1:
        setState(() {
          _exp2.collapse();
          _exp3.collapse();
          _exp4.collapse();
          _exp5.collapse();
          _exp6.collapse();
          _exp7.collapse();
          _exp8.collapse();
        });
      case 2:
        setState(() {
          _exp1.collapse();
          _exp3.collapse();
          _exp4.collapse();
          _exp5.collapse();
          _exp6.collapse();
          _exp7.collapse();
          _exp8.collapse();
        });
      case 3:
        setState(() {
          _exp1.collapse();
          _exp2.collapse();
          _exp4.collapse();
          _exp5.collapse();
          _exp6.collapse();
          _exp7.collapse();
          _exp8.collapse();
        });
      case 4:
        setState(() {
          _exp1.collapse();
          _exp2.collapse();
          _exp3.collapse();
          _exp5.collapse();
          _exp6.collapse();
          _exp7.collapse();
          _exp8.collapse();
        });
      case 5:
        setState(() {
          _exp1.collapse();
          _exp2.collapse();
          _exp3.collapse();
          _exp4.collapse();
          _exp6.collapse();
          _exp7.collapse();
          _exp8.collapse();
        });
      case 6:
        setState(() {
          _exp1.collapse();
          _exp2.collapse();
          _exp3.collapse();
          _exp4.collapse();
          _exp5.collapse();
          _exp7.collapse();
          _exp8.collapse();
        });
      case 7:
        setState(() {
          _exp1.collapse();
          _exp2.collapse();
          _exp3.collapse();
          _exp4.collapse();
          _exp5.collapse();
          _exp6.collapse();
          _exp8.collapse();
        });
      case 8:
        setState(() {
          _exp1.collapse();
          _exp2.collapse();
          _exp3.collapse();
          _exp4.collapse();
          _exp5.collapse();
          _exp6.collapse();
          _exp7.collapse();
        });
    }
  }

  //todo FUNCIÓN PARA MOSTRAR FIRMA
  Widget mostrarFirma() {
    return Visibility(
      visible: enableVisibility,
      child: DraggableScrollableSheet(
          shouldCloseOnMinExtent: true,
          controller: _scrollableController,
          maxChildSize: 0.4,
          minChildSize: 0.15,
          initialChildSize: 0.20,
          builder: (builder, scroll) {
            return Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 15,
                        color: Colors.black,
                        blurStyle: BlurStyle.outer)
                  ]),
              child: SingleChildScrollView(
                controller: scroll,
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: 40,
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () {
                            setState(() => enableVisibility = false);
                          },
                          icon: const Icon(Icons.close, color: Colors.black)),
                    ),
                    Text(
                      titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    if (path.isNotEmpty) Image.memory(base64Decode(path))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
