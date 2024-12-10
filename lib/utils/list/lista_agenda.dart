import '../../src/models/calendarEvento/categorias_agenda_model.dart';

List<Map<String, dynamic>> get medios => _medios;
List<Map<String, dynamic>> get gestiones => _gestiones;
List<AgendaCatModel> get categorias => _categorias;
List<AgendaProductModel> get productos => _productos;
List<Map<String, dynamic>> get subProductos => _subProductos;

List<Map<String, dynamic>> _medios = [
  {"nombre": "Visita", "id": 1},
  {"nombre": "Llamada", "id": 2},
  {"nombre": "Videoconferencia", "id": 3},
];

List<Map<String, dynamic>> _gestiones = [
  {"nombre": "Venta", "id": 1},
  {"nombre": "Cobranza", "id": 2},
  {"nombre": "Recolectar documentación", "id": 3},
  {"nombre": "Renovación", "id": 4},
];

List<AgendaCatModel> _categorias = [
  AgendaCatModel(nombreCategoria: "CREDITO", idCategoria: 1),
  AgendaCatModel(nombreCategoria: "SEGURO", idCategoria: 2),
  AgendaCatModel(nombreCategoria: "ASISTENCIA", idCategoria: 3),
  AgendaCatModel(nombreCategoria: "SUSCRIPCIONES", idCategoria: 4),
];

List<AgendaProductModel> _productos = [
  AgendaProductModel(
      idCategoria: 1, nombreProducto: "CRÉDITO CONSUMO", idProducto: 1),
  AgendaProductModel(
      idCategoria: 1, nombreProducto: "MICROCRÉDITO PRODUCTIVO", idProducto: 2),
  AgendaProductModel(
      idCategoria: 2, nombreProducto: "SEGURO DESGRAVAMEN", idProducto: 3),
  AgendaProductModel(
      idCategoria: 3,
      nombreProducto: "ASISTENCIA MICROEMPRESARIO",
      idProducto: 4),
  AgendaProductModel(idCategoria: 4, nombreProducto: "PAPEL", idProducto: 5),
  AgendaProductModel(idCategoria: 4, nombreProducto: "DIGITAL", idProducto: 6),
];

List<Map<String, dynamic>> _subProductos = [
  //todo PAPEL
  {"nombre": "Anual Domingo", "id_prod": 5, "idsub_prod": 1},
  {"nombre": "Anual Empresarial", "id_prod": 5, "idsub_prod": 2},
  {"nombre": "Anual Entretenimiento Oro", "id_prod": 5, "idsub_prod": 3},
  {"nombre": "Anual Entretenimiento Plata", "id_prod": 5, "idsub_prod": 4},
  {"nombre": "Mensual Domingo", "id_prod": 5, "idsub_prod": 5},
  {"nombre": "Mensual Empresarial", "id_prod": 5, "idsub_prod": 6},
  {"nombre": "Mensual Entretenimiento Oro", "id_prod": 5, "idsub_prod": 7},
  {"nombre": "Mensual Entretenimiento Plata", "id_prod": 5, "idsub_prod": 8},
  //todo DIGITAL
  {"nombre": "Anual Digital EU COM", "id_prod": 6, "idsub_prod": 9},
  {"nombre": "Anual Digital Oferta EU COM", "id_prod": 6, "idsub_prod": 10},
  {
    "nombre": "Anual Digital Promocional EU COM",
    "id_prod": 6,
    "idsub_prod": 11
  },
  {"nombre": "Mensual Digital", "id_prod": 6, "idsub_prod": 12},
  {"nombre": "Mensual Digital EU COM", "id_prod": 6, "idsub_prod": 13}
];
