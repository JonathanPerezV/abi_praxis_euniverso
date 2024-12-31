import 'dart:io';
import 'package:abi_praxis_app/src/controller/aws/operaciones/ws_autorizacion.dart';
import 'package:abi_praxis_app/src/controller/aws/operaciones/ws_contactos.dart';
import 'package:abi_praxis_app/src/controller/aws/operaciones/ws_prospectos.dart';
import 'package:abi_praxis_app/src/controller/aws/operaciones/ws_solicitud.dart';
import 'package:abi_praxis_app/src/controller/dataBase/db.dart';
import 'package:abi_praxis_app/src/controller/provider/loading_provider.dart';
import 'package:abi_praxis_app/src/models/autorizacion/documento_aut_model.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/correo_model.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/documentos_model.dart';
import 'package:abi_praxis_app/utils/alerts/and_alert.dart';
import 'package:abi_praxis_app/utils/alerts/ios_alert.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../models/usuario/persona_model.dart';
import '../dataBase/operations.dart';
import 'operaciones/ws_agenda.dart';
import 'operaciones/ws_clientes.dart';
import 'operaciones/ws_persona.dart';

class Sync {
  final wsPer = WSPersona();
  final wsCont = WSContactos();
  final wsPros = WSProspectos();
  final wsCli = WSClientes();
  final wsAg = WSAgenda();
  final wsAut = WSAutorizacion();
  final wsSol = WSSolicitud();
  final op = Operations();
  final andAlert = AndroidAlert();
  final iosAlert = IosAlert();

  Future<Database> initDB() async {
    final db = DBProvider();

    return await db.database;
  }

  Future<void> sincronizarDatos(context) async {
    final data = Provider.of<LoadingProvider>(context, listen: false);
    final listPersonas = await obtenerPersonas();
    int longitud = 0;

    final hasConexion = await checkInternetConnectivity(context);

    if (!hasConexion) {
      if (Platform.isAndroid) {
        await andAlert.alertSinConexion(context);
      } else {
        await iosAlert.alertSinConexion(context);
      }
      return;
    }

    if (listPersonas.isNotEmpty) {
      //todo habilitar la pantalla activa y evitar que se apague o bloquee mientras se ejecuta la sincronización
      WakelockPlus.enable();

      //todo mostrar loading mientras termina la sincronización
      data.startLoading();
      data.setMaxNumber(listPersonas.length);

      //todo recorrer lista de personas
      for (var persona in listPersonas) {
        debugPrint(
            "👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇");
        data.changeText("${longitud + 1}/${listPersonas.length}");
        longitud += 1;

        if (persona.idRDS != null) {
          //todo EN CASO DE QUE TENGA ID RDS SOLO SE ACTUALIZAN LOS DATOS(PERSONA, PROSPECTO, CLIENTE Y AGENDA, AUTORIZACIÓN Y SOLICITUD SE INGRESAN)
          await funcionesParaActualizarEInsertarDatos(persona);
        } else {
          //todo EN CASO DE QUE NO TENGA ID RDS SE INSERTAR DATOS
          await funcionesParaInsertarNuevosDatos(persona);
        }

        data.setCurrentNumber(longitud);

        await Future.delayed(const Duration(seconds: 5));
      }

      data.limpiarDatos();
    }
    await Future.delayed(const Duration(seconds: 1));
    scaffoldMessenger(
        context, "Todos los datos han sido sincronizados correctamente.",
        icon: const Icon(
          Icons.check,
          color: Colors.green,
        ));

    //todo desactivar pantalla activa cuando termine la sincronización
    WakelockPlus.disable();

    //todo terminar de mostar loading
    data.stopLoading();
  }

  Future<void> funcionesParaInsertarNuevosDatos(PersonaModel persona) async {
    //actualizacion e inserción de persona
    debugPrint("**********************************************");
    debugPrint("**********************************************");
    debugPrint("BUSCAMOS SOLICITUD POR PERSONA");
    debugPrint("**********************************************");
    debugPrint("**********************************************");
    debugPrint("\n");

    int idLocalPersona = persona.idPersona!;

    //todo obtenemos la solicitud para en base a esto poder sincronizar datos
    final solicitud =
        await op.obtenerSolicitudPersonaXestadoFinalizada(idLocalPersona);

    if (solicitud.isNotEmpty) {
      //todo insertamos a la persona de esta solicitud en la base de datos
      final idRDSPersona =
          await wsPer.insertarPersona(persona, idLocal: idLocalPersona);

      //todo obtenemos e insertamos a esta persona como prospecto
      final prospecto = await op.obtenerProspecto(idLocalPersona);

      if (prospecto != null) {
        prospecto.idPersona = idRDSPersona;

        final idProspecto = await wsPros.insertarProspecto(prospecto);

        debugPrint("PROSPECTO INSERTADO EN LA NUBE - ID RDS: $idProspecto");

        //todo obtenemos e insertamos la agenda de esta persona
        final infoAgenda =
            await op.obtenerAgendaYcorreosXpersona(idLocalPersona);

        if (infoAgenda.isNotEmpty) {
          List<CorreoModel> listCorreos = [];
          var listaCalendario = infoAgenda;
          List<DocsModel> listDocumentos = [];

          //todo VALIDAR SI HAY EVENTOS E INGRESAROS, IGUAL LOS CORREOS
          if (listaCalendario.isNotEmpty) {
            debugPrint("\n");
            debugPrint("**********************************************");
            debugPrint("HAY EVENTOS PARA ESTA PERSONA");
            debugPrint("**********************************************");

            for (var ev in listaCalendario) {
              if (ev.correos != null && ev.correos!.isNotEmpty) {
                var correos = ev.correos;

                for (var correo in correos!) {
                  correo.idAgenda = null;
                  listCorreos.add(correo);
                }
              }

              if (ev.documentos != null && ev.documentos!.isNotEmpty) {
                var docs = ev.documentos!;
                for (var doc in docs) {
                  listDocumentos.add(doc);
                }
              }

              //todo insertar agenda y correos, devuelve id de la agenda
              final idAgendaRDS = await wsAg.insertarAgenda(
                  ev, listCorreos, ev.idAgenda!,
                  idPersonaRDS: idRDSPersona);

              //todo INSERTAR DOCUMENTOS Y ACTUALIZAR ID
              if (listDocumentos.isNotEmpty) {
                await wsAg.insertarDocumentosAgenda(
                    listDocumentos, idAgendaRDS);
              }
            }
          }
        } else {
          debugPrint("**********************************************");
          debugPrint(
              "NO HAY REUNIONES AGENDADAS PARA: ${persona.nombres} ${persona.apellidos} CON ID: ${persona.idPersona}");
          debugPrint("**********************************************");
        }

        //todo insertamos la solicitud
        await buscarEinsertarSolicitud(
            idLocalPersona: idLocalPersona, idPersonaRDS: idRDSPersona);
      }
    } else {
      debugPrint("Esta persona no tiene una solicitud en estado finalizada.");
    }
  }

  Future<void> funcionesParaActualizarEInsertarDatos(
      PersonaModel persona) async {
    final idPersonaRDS = persona.idRDS!;
    final idPersonaLocal = persona.idPersona!;

    //todo actualizar personal en la nube con los datos locales
    //primero validamos si esta persona existe en la nube -> si no devuelve datos y existe en la base local, inactivarlo
    final person = await wsPer.obtenerDatosPersona(idPersonaRDS, null);

    if (person != null) {
      //si el estado es "A" continuamos todos los pasos (AGENDA, AUTORIZACIÓN Y SOLICITUD)
      if (person.estado == "A") {
        final updatePerson = await wsPer.actualizarPersona(persona,
            isPromotor: false, idPersona: person.idPersona);

        if (updatePerson == "si") {
          debugPrint("LA PERSONA HA SIDO ACTUALIZADA");
          //si la persona se actualizó continuamos el proceso

          final prospecto =
              await wsPros.obtenerProspecto(idPersonaLocal: idPersonaLocal);

          if (prospecto != null) {
            if (prospecto.estado == 1) {
              //si el estado es 1 se inacstiva al prospecto local
              await op.actualizarEstadoProspecto(1,
                  idProspecto: prospecto.idProspecto!);

              funcionValidarSiEsCliente(idPersonaLocal, idPersonaRDS,
                  comeFromProspect: false, persona: persona);
            } else {
              //continuamos proceso
              funcionValidarSiEsCliente(idPersonaLocal, idPersonaRDS,
                  comeFromProspect: false, persona: persona);
            }
          } else {
            funcionValidarSiEsCliente(idPersonaLocal, idPersonaRDS,
                comeFromProspect: true, persona: persona);
          }
        } else {
          debugPrint("LA PERSONA NO SE PUDO ACTUALIZAR");
        }
      }
      //cancelamos el proceso de las busquedas y únicamente actualizamos el estado de la persona a I
      else {
        final updateEstadoLocal =
            await op.actualizarEstadoPersona(idPersonaLocal, "I");

        if (updateEstadoLocal == 1) {
          debugPrint("**********************************************");
          debugPrint("**********************************************");
          debugPrint(
              "LA PERSONA SE HA INACTIVADO, ID PERSONA RDS: $idPersonaRDS - ID PERSONA LOCAL: $idPersonaLocal");
          debugPrint("**********************************************");
          debugPrint("**********************************************");
        } else {
          debugPrint("**********************************************");
          debugPrint("**********************************************");
          debugPrint("LA PERSONA NO SE HA INACTIVADO");
          debugPrint("**********************************************");
          debugPrint("**********************************************");
        }
      }
    }
  }

  Future<void> funcionValidarSiEsCliente(int idPersonaLocal, int idRDSpersona,
      {required bool comeFromProspect, required PersonaModel persona}) async {
    //en caso de que el prospecto esté inactivo se busca en la base de clientes a ver si existe
    final cliente = await wsCli.obtenerCliente(idPersonaRDS: idRDSpersona);

    //todo si existe un cliente buscar en la base local si este cliente existe para no ingresarlo 2 veces
    if (cliente != null) {
      var clienteLocal = await op.obtenerCliente(idPersonaLocal);

      if (clienteLocal == null) {
        cliente.idNube = cliente
            .idPersona; //actualizo el id rds con el id persona de la nube
        cliente.idPersona =
            idPersonaLocal; //actualizo el id persona de la nube con el id local

        await op.insertarCliente(cliente);
      } else {
        //si el cliente no es nulo validar si el estado es activo, si es activo que siga, caso contrario ahí termina
        if (cliente.estado == 0) {
          debugPrint("CLIENTE ACTIVO");
        } else {
          debugPrint("CLIENTE INACTIVO");
          await op.actualizarEstadoCliente(1,
              idCliente: clienteLocal.idCliente!);

          return;
        }
      }
    }

    //todo comeFromProspecto = true - entonces quiere decir que no existe en prospecto y tampoco en cliente
    if (cliente == null && comeFromProspect) {
      //todo murió proceso porque no se lo encontró ni en prospecto ni en clientes
      return;
    }

    //todo buscamos agendas por persona en la base de datos(nube)
    final agendasRDS =
        await wsAg.obtenerAgenda(idAgenda: null, idPersonaRDS: idRDSpersona);

    if (agendasRDS.isNotEmpty) {
      for (var agendaRDS in agendasRDS) {
        //busco agendas locales por id rds(id agenda de la nube)
        final agendaLocal =
            await op.obtenerAgendaXidRDS(idRDS: agendaRDS.idAgenda!);

        if (agendaLocal != null) {
          //si la agenda local hace match con la agenda de la nube, actualizamos la agenda de la nube
          //actualizamos el id persona de la agenda local con el id persona de la nube
          agendaLocal.idPersona = idRDSpersona;
          await wsAg.actualizarAgenda(agendaLocal, agendaLocal.idNube!);
        } else {
          //si no existe, entonces insertamos la agenda de la nube en la base local
          //instanciamos una agenda para especificar que es local
          var dataAgendaLocal = agendaRDS;
          //reemplazamos el id nube de la agenda local con el id de la agenda de la nube
          dataAgendaLocal.idNube = agendaRDS.idAgenda;
          //reemplazamos el id persona de la agenda extraida de la nube con el id persona local
          dataAgendaLocal.idPersona = idPersonaLocal;

          var insertAg = await op.insertarAgenda(agendaRDS);

          if (insertAg != 0) {
            debugPrint("AGENDA DE LA NUBE INGRESADA EN LA BASE LOCAL");

            //validar si hay documentos para esta agenda e ingresarlos localmente
            if (agendaRDS.documentos != null &&
                agendaRDS.documentos!.isNotEmpty) {
              //recorremos los documentos
              for (var doc in agendaRDS.documentos!) {
                doc.idAgenda = insertAg;
                doc.idNube = doc.idDoc;
                await op.insertarDocumentoAgenda(doc);
              }
            }
          } else {
            debugPrint("AGENDA DE LA NUBE NO SE PUDO INGRESAR");
          }
        }
      }
    }

    //todo buscamos si la persona tiene agendas locales ingresadas
    final agendasLocales =
        await op.obtenerAgendaYcorreosXpersona(idPersonaLocal);

    if (agendasLocales.isNotEmpty) {
      for (var agendaLocal in agendasLocales) {
        if (agendaLocal.idNube == null) {
          //insertar la agenda en la nube y actualizar id rds
          //obtenemos los correos de esta agenda
          var correos = await op.obtenerCorreosPorAgenda(agendaLocal.idAgenda!);
          var documentos =
              await op.obtenerDocumentosAgenda(agendaLocal.idAgenda!);

          final idRDS = await wsAg.insertarAgenda(
              agendaLocal, correos, agendaLocal.idAgenda!,
              idPersonaRDS: idRDSpersona);
          if (documentos.isNotEmpty) {
            await wsAg.insertarDocumentosAgenda(documentos, idRDS);
          }
        }
      }
    }

    //todo BUSCAR SOLICITUDES DE CRÉDITO FINALIZADAS E INGRESARLAS
    await buscarEinsertarSolicitud(
      idLocalPersona: idPersonaLocal,
      idPersonaRDS: idRDSpersona,
    );
  }

  //todo obtener las personas para sincronizar
  Future<List<PersonaModel>> obtenerPersonas() async {
    final db = await initDB();

    List<PersonaModel> personas = [];
    final res =
        await db.rawQuery("SELECT * FROM tbl_persona WHERE estado = 'A'");

    if (res.isNotEmpty) {
      for (var i = 0; i < res.length; i++) {
        personas.add(PersonaModel.fromJson(res[i]));
      }
    }

    return personas;
  }

  Future<int?> buscarEinsertarAutorizacion(PersonaModel persona,
      {required int idRDSPersona}) async {
    //todo BUSCAR AUTORIZACIONES DE CONSULTA FINALIZADAS
    final autorizacion = await op
        .obtenerAutorizacionPersonaXestadoFinalizada(persona.idPersona!);
    List<DocumentoAutModel> documentosAut = [];
    int? idRDSCony;
    int? idRDSGarante;
    int? idRDSConyGarante;
    int? idRDSAutorizacion;

    if (autorizacion.isNotEmpty) {
      debugPrint("**********************************************");
      debugPrint("INGRESAR AUTORIZACIÓN DE CONSULTA");
      debugPrint("**********************************************");
      var aut = autorizacion[0];

      //todo actualizar cedula pesona titular
      final titular = await op.obtenerPersona(persona.idPersona!);

      if (titular != null) {
        await wsPer.actualizarCedula(
            titular.numeroIdentificacion!, idRDSPersona);
      }

      //todo buscar e insertar o actualizar persona CONYUGE
      if (aut.idCProspecto != null) {
        final person = await op.obtenerPersona(aut.idCProspecto!);
        if (person!.idRDS != null) {
          var estado = "A";
          final personRDS = await wsPer.obtenerDatosPersona(person.idRDS, null);

          if (personRDS == null) {
            estado = "I";
          }

          await op.actualizarEstadoPersona(person.idPersona!, estado);
        } else {
          debugPrint("INGRESAR CÓNYUGE(PERSONA) DEL TITULAR");

          var idContacto = await op.obtenerContacto(persona.idPersona!, 1);

          if (idContacto != null) {
            var id = await wsCont.insertarContactoPersona(
                person, idRDSPersona, 1,
                idPersonaLocal: person.idPersona!,
                idContactoLocal: idContacto
                    .idContactoPersona!); /*wsPer.insertarPersona(person, idLocal: person.idPersona!);*/

            idRDSCony = id;
          }
        }
      }

      //todo buscar e insertar o actualizar persona GARANTE
      if (aut.idGarante != null) {
        final person = await op.obtenerPersona(aut.idGarante!);

        if (person!.idRDS != null) {
          var estado = "A";
          final personRDS = await wsPer.obtenerDatosPersona(person.idRDS, null);

          if (personRDS == null) {
            estado = "I";
          }

          await op.actualizarEstadoPersona(person.idPersona!, estado);
        } else {
          debugPrint("INGRESAR GARANTE(PERSONA) DEL TITULAR");

          var idContacto = await op.obtenerContacto(persona.idPersona!, 2);

          if (idContacto != null) {
            var id = await wsCont.insertarContactoPersona(
                person, idRDSPersona, 2,
                idPersonaLocal: person.idPersona!,
                idContactoLocal: idContacto.idContactoPersona!);

            idRDSGarante = id;
          } //await wsPer.insertarPersona(person, idLocal: person.idPersona!);
        }
      }

      //todo buscar e insertar o actualizar persona CONYUGE GARANTE
      if (aut.idCGarante != null) {
        final person = await op.obtenerPersona(aut.idCGarante!);
        if (person!.idRDS != null) {
          var estado = "A";
          final personRDS = await wsPer.obtenerDatosPersona(person.idRDS, null);

          if (personRDS == null) {
            estado = "I";
          }

          await op.actualizarEstadoPersona(person.idPersona!, estado);
        } else {
          debugPrint("INGRESAR CÓNYUGE DEL GARANTE(PERSONA) DEL TITULAR");

          var idContacto = await op.obtenerContacto(persona.idPersona!, 3);

          if (idContacto != null) {
            var id = await wsCont.insertarContactoPersona(
                person, idRDSPersona, 3,
                idPersonaLocal: person.idPersona!,
                idContactoLocal: idContacto
                    .idContactoPersona!); //await wsPer.insertarPersona(person, idLocal: person.idPersona!);
            idRDSConyGarante = id;
          }
        }
      }

      final docsAut = await op.obtenerDocsXaut(aut.idAutorizacion!);

      if (docsAut.isNotEmpty) {
        for (var doc in docsAut) {
          doc.idAut = null;
          switch (doc.codDoc) {
            case "P":
              doc.idPersona = idRDSPersona;
            case "G":
              doc.idPersona = idRDSGarante!;
            case "PC":
              doc.idPersona = idRDSCony!;
            case "GC":
              doc.idPersona = idRDSConyGarante!;
            default:
          }
          documentosAut.add(doc);
        }
      }

      aut.idPersona = idRDSPersona;
      aut.idCProspecto = idRDSCony;
      aut.idGarante = idRDSGarante;
      aut.idCGarante = idRDSConyGarante;
      aut.estado = 3;

      //todo INGRESAR AUTORIZACIÓN
      idRDSAutorizacion = await wsAut.insertarAutorizacion(aut, documentosAut,
          idLocal: aut.idAutorizacion!);

      return idRDSAutorizacion;
    } else {
      debugPrint("**********************************************");
      debugPrint("NO HAY AUTORIZACIÓN FINALIZADA");
      debugPrint("**********************************************");

      return null;
    }
  }

  Future<void> buscarEinsertarSolicitud(
      {required int idLocalPersona, required int idPersonaRDS}) async {
    final solicitud =
        await op.obtenerSolicitudPersonaXestadoFinalizada(idLocalPersona);

    if (solicitud.isNotEmpty) {
      debugPrint("**********************************************");
      debugPrint("INGRESAR SOLICITUD DE SUSCRIPCIÓN");
      debugPrint("**********************************************");

      solicitud[0].idPersona = idPersonaRDS;

      //insertamos la solicitud
      await wsSol.insertarSolicitud(solicitud[0],
          idSolicitudLocal: solicitud[0].idSolicitud!);
    } else {
      debugPrint("**********************************************");
      debugPrint(
          "NO HAY SOLICITUDES O NO SE ENVIÓ LA AUTORIZACIÓN DE CONSULTA");
      debugPrint("**********************************************");
    }
  }

  Future<bool> checkInternetConnectivity(context) async {
    // Primero revisa si el dispositivo está conectado a alguna red
    var load = Provider.of<LoadingProvider>(context, listen: false);

    //todo mostramos loading mientras comprobamos la señal
    load.startLoadingNetwork();
    await Future.delayed(const Duration(seconds: 1));

    var connectivityResult = await Connectivity().checkConnectivity();

    if (!connectivityResult.contains(ConnectivityResult.wifi) &&
        !connectivityResult.contains(ConnectivityResult.mobile)) {
      //todo detenemos el loading
      load.stopLoadingNetwork();
      // No hay conexión a ninguna red
      return false;
    } else {
      // Opcional: verifica la calidad de la conexión mediante una solicitud HTTP
      try {
        final response = await http
            .get(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 5)); // Tiempo de espera ajustable

        if (response.statusCode == 200) {
          //todo detenemos el loading
          load.stopLoadingNetwork();
          return true; // Conexión adecuada
        } else {
          //todo detenemos el loading
          load.stopLoadingNetwork();
          return false; // Problemas de conexión
        }
      } catch (e) {
        //todo detenemos el loading
        load.stopLoadingNetwork();
        return false; // Error en la conexión o en la solicitud
      }
    }
  }
}
