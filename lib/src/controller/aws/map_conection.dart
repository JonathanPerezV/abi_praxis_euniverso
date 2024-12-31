import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MapConection {
  Future<bool> checkInternetConnectivity(context) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (!connectivityResult.contains(ConnectivityResult.wifi) &&
        !connectivityResult.contains(ConnectivityResult.mobile)) {
      return false;
    } else {
      // Opcional: verifica la calidad de la conexión mediante una solicitud HTTP
      try {
        final response = await http
            .get(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 5)); // Tiempo de espera ajustable

        if (response.statusCode == 200) {
          //todo detenemos el loading
          return true; // Conexión adecuada
        } else {
          //todo detenemos el loading
          return false; // Problemas de conexión
        }
      } catch (e) {
        //todo detenemos el loading
        return false; // Error en la conexión o en la solicitud
      }
    }
  }
}
