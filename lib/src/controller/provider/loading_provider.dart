import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  bool get loading => _loading;
  bool get loadingNetwork => _loadingNetwork;
  
  bool _loading = false;
  bool _loadingNetwork = false;

  int _maxNumber = 0;
  int get maxNumber => _maxNumber;

  int _currentNumber = 0;
  int get currentNumber => _currentNumber;

  String get text => _text;
  String _text = "";

  //todo LOADING PARA LA SINCRONIZACIÓN DE DATOS
  void startLoading() {
    print('Start loading');
    _loading = true;
    notifyListeners();
  }

  void stopLoading() {
    print('Stop loading');
    _loading = false;
    notifyListeners();
  }

  //todo MOSTRAR INFORMACIÓN DE LAS PETICIONES POR CARGA DE DATOS(SINCRONIZACIÓN)
  void changeText(newText) {
    print('new text: $newText');
    _text = newText;
    notifyListeners();
  }

  void setMaxNumber(int maxNumber) {
    _maxNumber = maxNumber;
    notifyListeners();
  }

  void setCurrentNumber(int current) {
    _currentNumber = current;
    notifyListeners();
  }

  //todo LOADING PARA COMPROBAR CONEXIÓN A INTERNET
  void startLoadingNetwork() {
    _loadingNetwork = true;
    notifyListeners();
  }

  void stopLoadingNetwork() {
    _loadingNetwork = false;
    notifyListeners();
  }

  //todo LIMPIAR TODOS LOS DATOS
  void limpiarDatos() {
    _text = "";
    _maxNumber = 0;
    _currentNumber = 0;
    _loading = false;
    _loadingNetwork = false;
    notifyListeners();
  }
}
