import 'package:abi_praxis_app/src/controller/provider/autorizacion_notifier.dart';
import 'package:abi_praxis_app/src/controller/provider/beneficiario_notifier.dart';
import 'package:abi_praxis_app/src/controller/provider/documentos_notifier.dart';
import 'package:abi_praxis_app/src/controller/provider/suscripciones_notifier.dart';
import 'package:abi_praxis_app/src/controller/provider/titular_notifier.dart';
import 'package:flutter/material.dart';

import 'loading_provider.dart';

class FormProvider extends ChangeNotifier {
  TitularNotifier titular = TitularNotifier();
  BeneficiarioNotifier beneficiario = BeneficiarioNotifier();
  DocumentosNotifier documentos = DocumentosNotifier();
  SuscripcionesNotifier suscripciones = SuscripcionesNotifier();
  AutorizacionNotifier autorizacion = AutorizacionNotifier();
  LoadingProvider loading = LoadingProvider();

  void limpiarDatos() {
    titular.limpiarDatos();
    documentos.limpiarDatos();
    autorizacion.limpiarDatos();
    suscripciones.limpiarDatos();
    notifyListeners();
  }
}
