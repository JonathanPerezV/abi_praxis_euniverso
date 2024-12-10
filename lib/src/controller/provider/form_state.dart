import 'package:abi_praxis_app/src/controller/provider/autorizacion_notifier.dart';
import 'package:abi_praxis_app/src/controller/provider/conyuge_notifier.dart';
import 'package:abi_praxis_app/src/controller/provider/documentos_notifier.dart';
import 'package:abi_praxis_app/src/controller/provider/garante_notifier.dart';
import 'package:abi_praxis_app/src/controller/provider/referencias_economicas_notifier.dart';
import 'package:abi_praxis_app/src/controller/provider/referencias_notifier.dart';
import 'package:abi_praxis_app/src/controller/provider/solicitud_producto_notifier.dart';
import 'package:abi_praxis_app/src/controller/provider/titular_notifier.dart';
import 'package:flutter/material.dart';

import 'loading_provider.dart';

class FormProvider extends ChangeNotifier {
  TitularNotifier titular = TitularNotifier();
  ConyugeNotifier conyuge = ConyugeNotifier();
  GaranteNotifier garante = GaranteNotifier();
  ReferenciasNotifier referencias = ReferenciasNotifier();
  ReferenciasEconomicasNotifier refEconomicas = ReferenciasEconomicasNotifier();
  SolicitudProductoNotifier solicitud = SolicitudProductoNotifier();
  DocumentosNotifier documentos = DocumentosNotifier();
  AutorizacionNotifier autorizacion = AutorizacionNotifier();
  LoadingProvider loading = LoadingProvider();

  void limpiarDatos() {
    titular.limpiarDatos();
    conyuge.limpiarDatos();
    garante.limpiarDatos();
    referencias.limpiarDatos();
    refEconomicas.limpiarDatos();
    solicitud.limpiarDatos();
    documentos.limpiarDatos();
    autorizacion.limpiarDatos();
    notifyListeners();
  }
}
