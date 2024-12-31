import 'package:abi_praxis_app/src/views/inside/home/vendedor/consultar/opciones/solicitudes_curso/contenedor.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/vender/credito/solicitud/solicitud.dart';
import 'package:abi_praxis_app/utils/textFields/input_text_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';
import 'package:abi_praxis_app/main.dart';
import 'package:abi_praxis_app/src/views/register/login.dart';
import 'package:abi_praxis_app/utils/buttons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/controller/aws/sync.dart';
import '../../src/models/usuario/persona_model.dart';
import '../../src/views/inside/home/vendedor/consultar/opciones/prospectos/agregar_prospecto.dart';

class IosAlert {
  void acceptTermCondsIos(context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            content: const Text(
                "Es necesario que acepte Términos y Condiciones y Autorización de Datos Personales para continuar."),
            actions: [
              Container(
                child: nextButton(
                    onPressed: () => Navigator.pop(context), text: "Entendido"),
              ),
            ],
          );
        });
  }

  void accountExists(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text('Usuario existente'),
            content: const Text(
                'Este número celular ya se encuentra almacenado en nuestra base de datos.'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  nextButton(
                      onPressed: () => Navigator.pop(context),
                      text: "Regresar",
                      width: 100,
                      fontSize: 15),
                  nextButton(
                      onPressed: () => Navigator.pushNamed(context, "login"),
                      text: "Iniciar sesión",
                      width: 110,
                      fontSize: 15),
                ],
              )
            ],
          );
        });
  }

  void incorrectPin(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) {
          return CupertinoAlertDialog(
            //title: const Text('Usuario existente'),
            content: const Text(
              'Código incorrecto.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              nextButton(
                  onPressed: () => Navigator.pop(context),
                  text: "Volver a intentar",
                  //width: 120,
                  fontSize: 15),
            ],
          );
        });
  }

  void errorLogin(context, String title, String error) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(
              error,
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              nextButton(
                  onPressed: () => Navigator.pop(context),
                  text: "Regresar",
                  width: 120,
                  fontSize: 15),
            ],
          );
        });
  }

  void alertaPermisoCamaraManual(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text('Permiso denegado'),
            content: const Text(
                'El permiso a la cámara y galeria ha sido denegado, activelo manualmente.'),
            actions: [
              Center(
                  child: TextButton(
                child: const Text('Configuración'),
                onPressed: () {
                  openAppSettings().whenComplete(() => Navigator.pop(context));
                },
              ))
            ],
          );
        });
  }

  void alertaPermisoArchivosManual(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text('Permiso denegado'),
            content: const Text(
                'El permiso a los archivos ha sido denegado, activelo manualmente.'),
            actions: [
              Center(
                  child: TextButton(
                child: const Text('Configuración'),
                onPressed: () {
                  openAppSettings().whenComplete(() => Navigator.pop(context));
                },
              ))
            ],
          );
        });
  }

  void cerrarSesion(context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Desea cerrar su sesión?.'),
            actions: [
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Cerrar sesión'),
                onPressed: () async {
                  final pfrc = await SharedPreferences.getInstance();

                  await op.deleteAllDatabase();

                  await pfrc.remove("login");
                  await pfrc.remove("idPromotor");
                  FlutterBackgroundService().invoke("stopService");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const LoginPage()));
                },
              ),
            ],
          );
        });
  }

  void alertCapcitacion(context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            content: const Text('Debe capacitarse para empezar a vender.'),
            actions: [
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Iniciar'),
                onPressed: () async {},
              ),
            ],
          );
        });
  }

  void alertaAgregarEvento(context, DateTime date, Function()? onpressed) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Agregar evento"),
            content: Text(
                "Agregara un evento a la siguiente fecha:  ${DateFormat.MMMMEEEEd("es").format(date)}."),
            actions: [
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                onPressed: onpressed,
                child: const Text('Continuar'),
              ),
            ],
          );
        });
  }

  void agendaAgregada(BuildContext context, Function() onPressed) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Evento creado"),
            content: const Text(
                "Evento creado. ¿Desea agregar documentos al evento?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              TextButton(onPressed: onPressed, child: const Text("Si")),
            ],
          );
        });
  }

  void alertSync(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Sincronización"),
            content: const Text(
                "Para sincronizar su dispositivo, es necesario contar con acceso a internet; de lo contrario, podría perder información. ¿Está seguro de que desea continuar?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("NO"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final sync = Sync();

                  await sync
                      .sincronizarDatos(context)
                      .then((_) => Navigator.pop(context));
                },
                child: const Text("SI"),
              )
            ],
          );
        });
  }

  void tipoTramiteCredito(BuildContext context, {required int idProducto}) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            content: const Text("¿Qué tipo de trámite va a realizar?"),
            actions: [
              Column(
                children: [
                  nextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => SolicitudCredito(
                                    idTipoProducto: idProducto)));
                      },
                      text: "Vinculación",
                      fontSize: 12,
                      width: 120,
                      background: Colors.black),
                  nextButton(
                      onPressed: () {},
                      text: "Actualización",
                      fontSize: 12,
                      width: 120,
                      background: Colors.black),
                ],
              )
            ],
          );
        });
  }

  Future<PersonaModel?> actualizarDatos(
      BuildContext context, int idPersona) async {
    return showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Actualizar datos"),
            content: const Text(
                "Para continuar es necesario que actualice los datos del prospecto."),
            actions: [
              TextButton(
                  onPressed: () async {
                    PersonaModel? persona = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AgregarEditarProspecto(
                                fromAut: true,
                                idPersona: idPersona,
                                edit: true,
                                isClient: false)));
                  },
                  child: const Text("Actualizar"))
            ],
          );
        });
  }

  void alertAutorizacionExiste(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Autorización"),
            content: const Text(
                "Ya se ha generado una autorización de consulta con este prospecto."),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  nextButton(
                      onPressed: () => Navigator.pop(context),
                      text: "Regresar",
                      fontSize: 12,
                      width: 100,
                      background: Colors.black),
                  nextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    const ContenedorSolicitudes()));
                      },
                      text: "Ver",
                      fontSize: 12,
                      width: 100,
                      background: Colors.black),
                ],
              )
            ],
          );
        });
  }

  Future<void> alertSinConexion(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Sincronización"),
            content: const Text(
                "No fue posible establecer una conexión exitosa. Por favor, asegúrese de estar conectado a internet o intente nuevamente más tarde."),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ),
            ],
          );
        });
  }

  Future<String> alertCodigoContrato(BuildContext context,
      {String? num}) async {
    final txtCodigo = TextEditingController();
    final fkey = GlobalKey<FormState>();

    if (num != null) {
      txtCodigo.text = num;
    }

    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Código de contrato"),
            content: Column(children: [
              const Text(
                  "Ingrese el código del contrato físico que se encuentra en la parte superior izquierda."),
              const SizedBox(height: 10),
              Form(
                  key: fkey,
                  child: InputTextFields(
                      tipoTeclado: TextInputType.number,
                      controlador: txtCodigo,
                      placeHolder: "202020",
                      nombreCampo: "CÓDIGO DE CONTRATO",
                      accionCampo: TextInputAction.done)
                  /*Pinput(
                    length: 6,
                    controller: txtCodigo,
                    validator: (val) =>
                        val!.isEmpty ? "Campo obligatorio *" : null,
                    animationCurve: Curves.bounceInOut,
                  )*/
                  )
            ]),
            actions: [
              Center(
                child: nextButton(
                    onPressed: () => fkey.currentState!.validate()
                        ? Navigator.pop(context, txtCodigo.text)
                        : null,
                    text: "Continuar"),
              )
            ],
          );
        });
    return txtCodigo.text;
  }
}
