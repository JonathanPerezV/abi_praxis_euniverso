import 'package:abi_praxis_app/src/models/solicitud/documentos_solicitud_model.dart';
import 'package:flutter/material.dart';

class DocumentosNotifier extends ChangeNotifier {

  List<DocumentosSolicitudModel> get  documentos => _documentos;

  final List<DocumentosSolicitudModel> _documentos = [];

  void addDocument(DocumentosSolicitudModel doc) {
    _documentos.add(doc);
    notifyListeners();
  }

  void removeDocuments(
      {required int idPersona, required bool isPdf, required int tipo}) {
    _documentos.removeWhere((e) =>
        e.idPersona == idPersona &&
        e.isPdf == (isPdf ? 1 : 0) &&
        e.tipoDocumento == tipo);
    notifyListeners();
  }

  void validateExists(
      {required int idPersona,
      required int tipo,
      DocumentosSolicitudModel? doc}) {
    var hasDocs = _documentos
        .where((e) => e.idPersona == idPersona && e.tipoDocumento == tipo)
        .toList();

    if (hasDocs.isNotEmpty) {
      _documentos[0] = doc!;
      notifyListeners();
    } else {
      addDocument(doc!);
    }
  }

  void limpiarDatos() {
    _documentos.clear();
    notifyListeners();
  }
}
