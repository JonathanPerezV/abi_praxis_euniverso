import 'package:abi_praxis_app/utils/paisesHabiles/paises.dart';

List<String> obtenerCiudadesEcuadorDe(String? nombre) {
  List<String> lista = [];
  switch (nombre) {
    case 'AZUAY':
      lista = listaCiudadesAzuay;
      break;
    case 'BOLIVAR':
      lista = listaCiudadesBolivar;
      break;
    case 'CAÑAR':
      lista = listaCiudadesCanar;
      break;
    case 'CARCHI':
      lista = listaCiudadesCarchi;
      break;
    case 'CHIMBORAZO':
      lista = listaCiudadesChimborazo;
      break;
    case 'COTOPAXI':
      lista = listaCiudadesCotopaxi;
      break;
    case 'EL ORO':
      lista = listaCiudadesElOro;
      break;
    case 'ESMERALDAS':
      lista = listaCiudadesEsmeraldas;
      break;
    case 'GALÁPAGOS':
      lista = listaCiudadesGalapagos;
      break;
    case 'GUAYAS':
      lista = listaCiudadesGuayas;
      break;
    case 'IMBABURA':
      lista = listaCiudadesImbabura;
      break;
    case 'LOJA':
      lista = listaCiudadesLoja;
      break;
    case 'LOS RÍOS':
      lista = listaCiudadesLosRios;
      break;
    case 'MANABÍ':
      lista = listaCiudadesManabi;
      break;
    case 'MORONA SANTIAGO':
      lista = listaCiudadesMoronaSant;
      break;
    case 'NAPO':
      lista = listaCiudadesNapo;
      break;
    case 'SUCUMBÍOS':
      lista = listaCiudadesSucumbios;
      break;
    case 'PASTAZA':
      lista = listaCiudadesPastaza;
      break;
    case 'PICHINCHA':
      lista = listaCiudadesPichincha;
      break;
    case 'SANTA ELENA':
      lista = listaCiudadesSantaElena;
      break;
    case 'SANTO DOMINGO':
      lista = listaCiudadesSantoDomin;
      break;
    case 'FRANCISCO DE ORELLANA':
      lista = listaCiudadesFrancOrellana;
      break;
    case 'TUNGURAHUA':
      lista = listaCiudadesTungurahua;
      break;
    case 'ZAMORA CHINCHIPE':
      lista = listaZamoraChinchipe;
      break;
    default:
  }
  return lista;
}
