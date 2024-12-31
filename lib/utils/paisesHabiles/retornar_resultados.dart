import 'package:abi_praxis_app/utils/paisesHabiles/paises.dart';

List<Map<String, dynamic>> obtenerCiudadesEcuadorDe(int? idProvincia) {
  List<Map<String, dynamic>> lista = [];
  switch (idProvincia) {
    case 3:
      lista = listaCiudadesAzuay;
      break;
    case 5:
      lista = listaCiudadesBolivar;
      break;
    case 6:
      lista = listaCiudadesCanar;
      break;
    case 7:
      lista = listaCiudadesCarchi;
      break;
    case 9:
      lista = listaCiudadesChimborazo;
      break;
    case 8:
      lista = listaCiudadesCotopaxi;
      break;
    case 10:
      lista = listaCiudadesElOro;
      break;
    case 11:
      lista = listaCiudadesEsmeraldas;
      break;
    case 20:
      lista = listaCiudadesGalapagos;
      break;
    case 1:
      lista = listaCiudadesGuayas;
      break;
    case 12:
      lista = listaCiudadesImbabura;
      break;
    case 13:
      lista = listaCiudadesLoja;
      break;
    case 14:
      lista = listaCiudadesLosRios;
      break;
    case 4:
      lista = listaCiudadesManabi;
      break;
    case 15:
      lista = listaCiudadesMoronaSant;
      break;
    case 16:
      lista = listaCiudadesNapo;
      break;
    case 21:
      lista = listaCiudadesSucumbios;
      break;
    case 17:
      lista = listaCiudadesPastaza;
      break;
    case 2:
      lista = listaCiudadesPichincha;
      break;
    case 24:
      lista = listaCiudadesSantaElena;
      break;
    case 23:
      lista = listaCiudadesSantoDomin;
      break;
    case 22:
      lista = listaCiudadesFrancOrellana;
      break;
    case 18:
      lista = listaCiudadesTungurahua;
      break;
    case 19:
      lista = listaZamoraChinchipe;
      break;
    default:
  }
  return lista;
}
