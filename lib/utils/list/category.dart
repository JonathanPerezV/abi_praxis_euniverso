import 'package:flutter/material.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';

List<Map<String, dynamic>> get categoryList => _categoryList;
List<Map<String, dynamic>> get sponsorsList => _sponsorsList;
List<Map<String, dynamic>> get subcategorylist => _subcategorylist;

List<Map<String, dynamic>> _categoryList = [
  {
    "name": "Servicios financieros",
    "icon": const Icon(AbiPraxis.creditos),
    "id": 2
  },
  {"name": "Seguros", "icon": const Icon(AbiPraxis.seguros_1), "id": 3},
  {"name": "Asistencia", "icon": const Icon(AbiPraxis.asistencias), "id": 4},
];

List<Map<String, dynamic>> _subcategorylist = [
  {
    "id_category": 2,
    "id_sub_category": 4,
    "name": "Microcrédito",
    "icon": const Icon(AbiPraxis.microcredito)
  },
  {
    "id_category": 2,
    "id_sub_category": 5,
    "name": "Tarjeta de débito",
    "icon": const Icon(AbiPraxis.tarjeta_debito)
  },
  {
    "id_category": 2,
    "id_sub_category": 6,
    "name": "Tarjeta de crédito",
    "icon": const Icon(AbiPraxis.tarjeta_credito)
  },
  {
    "id_category": 2,
    "id_sub_category": 7,
    "name": "Cuenta corriente",
    "icon": const Icon(AbiPraxis.cuenta_corriente)
  },
  {
    "id_category": 3,
    "id_sub_category": 8,
    "name": "Desgravamen",
    "icon": const Icon(AbiPraxis.desgravamen)
  },
  {
    "id_category": 4,
    "id_sub_category": 9,
    "name": "Microempresario",
    "icon": const Icon(AbiPraxis.asistencias)
  }
];

List<Map<String, dynamic>> _sponsorsList = [
  {
    "id_sub_category": 4,
    "name": "Consumo",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 1,
    "color": Colors.orange,
    "complete": true,
    "progress": 100,
    "icon": const Icon(AbiPraxis.consumo)
  },
  {
    "id_sub_category": 4,
    "name": "Productivo",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 2,
    "color": Colors.pink,
    "complete": true,
    "progress": 100,
    "icon": const Icon(AbiPraxis.productivo)
  },
  {
    "id_sub_category": 5,
    "name": "Tarjeta de débito",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 3,
    "color": Colors.yellow,
    "complete": false,
    "icon": const Icon(AbiPraxis.tarjeta_debito),
    "progress": 0,
  },
  {
    "id_sub_category": 6,
    "name": "Tarjeta de crédito",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 4,
    "color": Colors.brown,
    "complete": true,
    "progress": 100,
    "icon": const Icon(AbiPraxis.tarjeta_credito)
  },
  {
    "id_sub_category": 7,
    "name": "Cuenta corriente",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 5,
    "color": Colors.purple,
    "complete": false,
    "progress": 0,
    "icon": const Icon(AbiPraxis.cuenta_corriente)
  },
  {
    "id_sub_category": 8,
    "name": "Desgravamen",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 6,
    "color": Colors.red,
    "complete": false,
    "progress": 0,
    "icon": const Icon(AbiPraxis.desgravamen)
  },
  {
    "id_sub_category": 9,
    "name": "Microempresario",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 6,
    "color": Colors.red,
    "complete": false,
    "progress": 0,
    "icon": const Icon(AbiPraxis.planes_exequiales)
  }
];
