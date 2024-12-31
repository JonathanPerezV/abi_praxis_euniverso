// ignore_for_file: unrelated_type_equality_checks
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as service;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapaController extends ChangeNotifier {
  String? _latitud;
  String get latitud => _latitud!;

  String? _longitud;
  String get longitud => _longitud!;

  /*GoogleMapController? _mapController;
  GoogleMapController get mapController => _mapController!;*/
  bool _loading = true;
  bool get loading => _loading;

  late bool _gpsEnable;
  bool get gpsEnable => _gpsEnable;

  Position? _initialPosition;
  CameraPosition? get initialCameraPosition => CameraPosition(
      target: LatLng(
        _initialPosition!.latitude,
        _initialPosition!.longitude,
      ),
      zoom: 15.5);

  StreamSubscription? _gpsSubscription, _positionSubscripcion;

  MapaController() {
    init();
  }

  Future<void> init() async {
    if (Platform.isAndroid) {
      _gpsEnable = await Geolocator.isLocationServiceEnabled();
      //_loading = false;

      _gpsSubscription = Geolocator.getServiceStatusStream().listen(
        (status) async {
          _gpsEnable = status == service.ServiceStatus.enabled;
          if (_gpsEnable) {
            _initLocationUpdates();
          }
        },
      );
      _initLocationUpdates();
    } else {
      final status = await Permission.location.status;
      if (Platform.isIOS) {
        if (status.isGranted) {
          _gpsEnable = await Geolocator.isLocationServiceEnabled();
          //_loading = false;

          _gpsSubscription = Geolocator.getServiceStatusStream().listen(
            (status) async {
              _gpsEnable = status == service.ServiceStatus.enabled;
              if (_gpsEnable) {
                _initLocationUpdates();
              }
            },
          );
          _initLocationUpdates();
        } else {
          if (status.isDenied) {
            Permission.location.request();
          }
          if (status.isPermanentlyDenied) {
            openAppSettings();
          }
        }
      }
    }
  }

  Future<void> _initLocationUpdates() async {
    bool initialized = false;
    await _positionSubscripcion?.cancel();
    if (Platform.isAndroid) {
      _positionSubscripcion = Geolocator.getPositionStream().listen(
        ( position) {
          if (!initialized) {
            _setInitialPosition(position);
            initialized = true;
            notifyListeners();
          }
        },
        onError: (e) {
          if (e is LocationServiceDisabledException) {
            _gpsEnable = false;
            notifyListeners();
          }
        },
      );
    } else if (Platform.isIOS) {
      final position = await Geolocator.getCurrentPosition();
      if (!initialized) {
        _setInitialPosition(position);
        initialized = true;
        notifyListeners();
      }
    }
  }

  void _setInitialPosition(Position position) {
    if (_gpsEnable && _initialPosition == null) {
      _initialPosition = position;
      _latitud = position.latitude.toString();
      _longitud = position.longitude.toString();
      _loading = false;
    }
  }

  void updateLocation(
    LatLng? newCoor,
    GoogleMapController? mapController,
  ) async {
    if (mapController != null) {
      final zoom = await mapController.getZoomLevel();
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          newCoor!,
          zoom,
        ),
      );
    }
  }

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();

  @override
  void dispose() {
    _positionSubscripcion?.cancel();
    _gpsSubscription?.cancel();
    super.dispose();
  }
}
