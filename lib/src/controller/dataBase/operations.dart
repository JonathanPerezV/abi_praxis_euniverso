import 'package:abi_praxis_app/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis_app/src/models/autorizacion/autorizacion_model.dart';
import 'package:abi_praxis_app/src/models/autorizacion/documento_aut_model.dart';
import 'package:abi_praxis_app/src/models/autorizacion/fuente_model.dart';
import 'package:abi_praxis_app/src/models/autorizacion/plazo_model.dart';
import 'package:abi_praxis_app/src/models/autorizacion/relacion_model.dart';
import 'package:abi_praxis_app/src/models/autorizacion/sector_model.dart';
import 'package:abi_praxis_app/src/models/solicitud/documentos_solicitud_model.dart';
import 'package:abi_praxis_app/src/models/solicitud/soliciutd_credito_model.dart';
import 'package:abi_praxis_app/src/models/usuario/cliente_model.dart';
import 'package:abi_praxis_app/src/models/usuario/contactos/contactos_model.dart';
import 'package:abi_praxis_app/src/models/usuario/prospecto_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:abi_praxis_app/src/controller/dataBase/db.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/calendar_model.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/documentos_model.dart';
import 'package:abi_praxis_app/src/models/calendarEvento/correo_model.dart';
import 'package:abi_praxis_app/src/models/usuario/persona_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final pfrc = UserPreferences();

//todo INICIALIZAR DB
Future<Database> initDatabase() async {
  final db = DBProvider();
  return await db.database;
}

class Operations {
  final String _tblPersona = "tbl_persona";
  final String _tblProspecto = "tbl_prospecto";
  final String _tblCliente = "tbl_cliente";
  final String _tblAgenda = "tbl_agenda";
  final String _tblCats = "tbl_categoria_producto";
  final String _tblProds = "tbl_producto";
  final String _tblCorreo = "tbl_correo_agenda";
  final String _tblDocs = "tbl_documentos_agenda";
  final String _tblRelacion = "tbl_relacion_laboral";
  final String _tblSector = "tbl_sector_economico";
  final String _tblFuente = "tbl_fuente";
  final String _tblPlazo = "tbl_plazo";
  final String _tblAutorizacion = "tbl_autorizacion";
  final String _tblDocAuto = "tbl_documentos_autorizacion";
  final String _tblSolicitud = "tbl_solicitud";
  final String _tblDocSol = "tbl_documentos_solicitud";
  final String _tblContacto = "tbl_contacto_persona";
/* 
  final List<String> _listCats = ["Créditos", "Seguros", "Asitencias"];
  final List<String> _catsCred = [
    "Microcrédito de consumo",
    "Microcrédito productivo"
  ];

  final List<String> _catsSeg = ["Seguro Desgravamen"];
  final List<String> _catsAsis = ["Asistencia Microempresario"]; */

  Future<void> deleteAllDatabase() async {
    final db = await initDatabase();

    List<String> tables = [
      _tblPersona,
      _tblProspecto,
      _tblCliente,
      _tblAgenda,
      _tblCats,
      _tblProds,
      _tblCorreo,
      _tblDocs,
      _tblRelacion,
      _tblSector,
      _tblPlazo,
      _tblAutorizacion,
      _tblDocAuto,
      _tblSolicitud,
      _tblDocSol,
      _tblContacto,
    ];

    await db.transaction((txn) async {
      for (var table in tables) {
        await txn.delete(table);
        await txn.execute("DELETE FROM sqlite_sequence WHERE name = '$table'");
      }
    });

    print('Todas las tablas han sido vaciadas');
  }

  //todo OPERACIONES PERSONA
  Future<int> insertarPersona(PersonaModel persona, {bool? isProsp}) async {
    //todo 0: no insert
    //todo 1: insert
    //todo 00: exist

    final Database db = await initDatabase();

    final idProm = await getIdPromotor();
    int idUser = await pfrc.getIdUser();

    var validate = await obtenerProspectosOclientes(
        phone: persona.celular1, cliente: false);

    if (validate != null) {
      return 100;
    } else {
      var res = await db.insert(_tblPersona, persona.toJson());
      if (res != 0) {
        if (isProsp != null && isProsp) {
          var prospecto = ProspectoModel(
              estado: 0,
              idPersona: res,
              idPromotor: idProm,
              usuarioCreacion: idUser);

          await insertarProspecto(prospecto);
        }

        debugPrint("Persona agregada: ${persona.nombres}");
      }
      return res;
    }
  }

  Future<int> actualizarPersona(int idPersona, PersonaModel persona) async {
    final Database db = await initDatabase();

    var res = await db.update(
        _tblPersona, persona.toJson()..remove("id_persona"),
        where: "id_persona = ?", whereArgs: [idPersona]);

    debugPrint(
        "Datos de la persona: ${res == 1 ? "Acutalizados" : "No actualizados"}");

    return res;
  }

  Future<int> actualizarEstadoPersona(int idPersona, String estado) async {
    final db = await initDatabase();

    var res = await db.rawUpdate("""
    UPDATE $_tblPersona 
      SET estado = ?
        WHERE id_persona = ?""", [estado, idPersona]);

    debugPrint(
        "ESTADO DE PERSONA: ${res != 0 ? "ACTUALIZADO" : "NO ACTUALIZADO"}");

    return res;
  }

  Future<List<PersonaModel>> obtenerPersonas() async {
    final db = await initDatabase();

    var res = await db.rawQuery("SELECT * FROM $_tblPersona");

    return res.isNotEmpty
        ? res.map((e) => PersonaModel.fromJson(e)).toList()
        : [];
  }

  ///
  ///type: 1 => domicilio | 2 => trabajo
  Future<int> actualizarGeolocalizacionPersona(int idPersona, int type,
      String latitud, String longitud, String dir) async {
    String update = "";
    final db = await initDatabase();
    if (type == 1) {
      update = "SET latitud = ?, longitud = ?, direccion = ?";
    } else {
      update =
          "SET latitud_trabajo = ?, longitud_trabajo = ?, direccion_trabajo = ?";
    }

    var res = await db.rawUpdate("""
        UPDATE $_tblPersona
          $update
            WHERE id_persona = ?
        """, [latitud, longitud, dir, idPersona]);

    debugPrint(
        "Geolocalizacion: ${res != 0 ? "Actualizada" : "No actualizada"}");

    return res;
  }

  Future<PersonaModel?> obtenerPersona(int idPersona) async {
    final db = await initDatabase();

    final res = await db.rawQuery(
            "SELECT * FROM $_tblPersona WHERE id_persona = ?", [idPersona])
        as List<Map<String, dynamic>>;

    if (res.isNotEmpty) {
      return PersonaModel.fromJson(res[0]);
    } else {
      return null;
    }
  }

  Future<PersonaModel?> obtenerPersonaXrds(int idPersonaRDS) async {
    final db = await initDatabase();

    final res = await db.rawQuery(
            "SELECT * FROM $_tblPersona WHERE id_rds = ?", [idPersonaRDS])
        as List<Map<String, dynamic>>;

    if (res.isNotEmpty) {
      return PersonaModel.fromJson(res[0]);
    } else {
      return null;
    }
  }

  Future<int> actualizarCedulaPersona(int idPersona, String cedula) async {
    final db = await initDatabase();

    var res = await db.rawUpdate("""UPDATE $_tblPersona 
            SET numero_identificacion = ? 
            WHERE id_persona = $idPersona""", [cedula]);

    return res;
  }

  //todo OPERACIONES PROSPECTOS/CLIENTES

  Future<int> insertarProspecto(ProspectoModel pros) async {
    final Database db = await initDatabase();

    var res = await db.insert(_tblProspecto, pros.toJson());

    debugPrint("PROSPECTO: ${res != 0 ? "Creado" : "No creado"}");

    return res;
  }

  Future<int> insertarCliente(ClienteModel cli) async {
    final db = await initDatabase();

    var res = await db.insert(_tblCliente, cli.toJson());

    debugPrint("CLIENTE: ${res != 0 ? "Creado" : "No creado"}");

    return res;
  }

  Future<ProspectoModel?> obtenerProspecto(int idPersona) async {
    final db = await initDatabase();
    final idPromotor = await pfrc.getIdPromotor();
    final idUser = await pfrc.getIdUser();

    final prospecto = await db.rawQuery(
        """SELECT per.id_persona, pros.id_prospecto, pros.estado, pros.id_rds FROM $_tblPersona AS per
          JOIN $_tblProspecto AS pros ON pros.id_persona = per.id_persona
          WHERE per.id_persona = $idPersona AND pros.estado = 0
        """) as List<Map<String, dynamic>>;

    if (prospecto.isNotEmpty) {
      return ProspectoModel(
          idProspecto: prospecto[0]["id_prospecto"],
          estado: 0,
          idPersona: prospecto[0]["id_persona"],
          idPromotor: idPromotor,
          idNube: prospecto[0]["id_rds"],
          usuarioCreacion: idUser);
    } else {
      return null;
    }
  }

  Future<int> actualizarEstadoProspecto(int estado,
      {required int idProspecto}) async {
    final db = await initDatabase();
    final res = await db.rawUpdate("""UPDATE $_tblProspecto
          SET estado = ?
            WHERE id_rds = ?""", [estado, idProspecto]);

    debugPrint("ESTADO DE PROSPECTO LOCAL ACTUALIZADO: $res - estado: $estado");

    return res;
  }

  Future<int> actualizarEstadoCliente(int estado,
      {required int idCliente}) async {
    final db = await initDatabase();
    final res = await db.rawUpdate("""UPDATE $_tblCliente
          SET estado = ?
            WHERE id_cliente = ?""", [estado, idCliente]);

    debugPrint("ESTADO DE CLIENTE LOCAL ACTUALIZADO: $res - estado: $estado");

    return res;
  }

  Future<ProspectoModel?> obtenerProspectoXrds(int idPersonaRDS) async {
    final db = await initDatabase();
    final idPromotor = await pfrc.getIdPromotor();
    final idUser = await pfrc.getIdUser();

    final prospecto = await db.rawQuery(
        """SELECT per.id_persona, pros.id_prospecto, pros.id_rds, pros.estado FROM $_tblPersona AS per
          JOIN $_tblProspecto AS pros ON pros.id_persona = per.id_persona
          WHERE per.id_rds = $idPersonaRDS AND pros.estado = 0
        """) as List<Map<String, dynamic>>;

    if (prospecto.isNotEmpty) {
      return ProspectoModel(
          idProspecto: prospecto[0]["id_prospecto"],
          estado: 0,
          idPersona: prospecto[0]["id_persona"],
          idPromotor: idPromotor,
          idNube: prospecto[0]["id_rds"],
          usuarioCreacion: idUser);
    } else {
      return null;
    }
  }

  Future<ClienteModel?> obtenerCliente(int idPersona) async {
    final db = await initDatabase();
    final idPromotor = await pfrc.getIdPromotor();
    final idUser = await pfrc.getIdUser();

    final cliente = await db.rawQuery(
        """SELECT per.id_persona, cli.id_cliente, cli.estado FROM $_tblPersona AS per
          JOIN $_tblCliente AS cli ON cli.id_persona = per.id_persona
          WHERE per.id_persona = $idPersona AND cli.estado = 0
        """) as List<Map<String, dynamic>>;

    if (cliente.isNotEmpty) {
      return ClienteModel(
          usuarioCreacion: idUser,
          idCliente: cliente[0]["id_prospecto"],
          estado: 0,
          idPersona: cliente[0]["id_persona"],
          idPromotor: idPromotor);
    } else {
      return null;
    }
  }

  Future<List<PersonaModel>> obtenerProspectos() async {
    final Database db = await initDatabase();

    final list = await db.rawQuery(
            """SELECT per.*, pros.id_prospecto AS id_aux FROM $_tblPersona AS per
          JOIN $_tblProspecto AS pros ON pros.id_persona = per.id_persona
          WHERE per.estado = 'A' AND pros.estado = 0""")
        as List<Map<String, dynamic>>;

    if (list.isNotEmpty) {
      List<PersonaModel> listProspects = [];

      for (var prospec in list) {
        listProspects.add(PersonaModel.fromJson(prospec));
      }

      return listProspects;
    } else {
      return [];
    }
  }

  Future<List<PersonaModel>> obtenerProspectosClientes() async {
    final Database db = await initDatabase();
    List<PersonaModel> listPersonas = [];

    final listPros = await db.rawQuery("""
        SELECT per.*, pros.id_prospecto AS id_aux FROM $_tblPersona AS per
        JOIN $_tblProspecto AS pros ON pros.id_persona = per.id_persona
        WHERE pros.estado = 0 AND (per.estado = 'A' AND pros.estado = 0)
      """) as List<Map<String, dynamic>>;

    final listClie = await db.rawQuery("""
        SELECT per.*, cli.id_cliente AS id_aux FROM $_tblPersona AS per
        JOIN $_tblCliente AS cli ON cli.id_persona = per.id_persona
        WHERE cli.estado = 0 AND (per.estado = 'A' AND cli.estado = 0)
      """);

    if (listPros.isNotEmpty) {
      for (var prospec in listPros) {
        listPersonas.add(PersonaModel.fromJson(prospec));
      }
    }

    if (listClie.isNotEmpty) {
      for (var clie in listClie) {
        listPersonas.add(PersonaModel.fromJson(clie));
      }
    }

    return listPersonas;
  }

  Future<PersonaModel?> obtenerProspectosOclientes(
      {String? phone, int? id, required bool cliente}) async {
    final Database db = await initDatabase();

    if (phone != null && id == null) {
      var res = await db.rawQuery(
              """SELECT per.*, ${cliente ? "aux.id_cliente" : "aux.id_prospecto"}  as id_aux FROM $_tblPersona as per
                  JOIN ${cliente ? _tblCliente : _tblProspecto} as aux ON aux.id_persona = per.id_persona
                 WHERE per.celular1 = '$phone' AND per.estado = 'A'""")
          as List<Map<String, dynamic>>;

      if (res.isNotEmpty) {
        return PersonaModel.fromJson(res[0]);
      }
    } else if (id != null && phone == null) {
      var res = await db.rawQuery(
              """SELECT per.*, ${cliente ? "aux.id_cliente" : "aux.id_prospecto"}  as id_aux FROM $_tblPersona as per
                  JOIN ${cliente ? _tblCliente : _tblProspecto} as aux ON aux.id_persona = per.id_persona 
                  WHERE per.id_persona = $id AND per.estado = 'A'""")
          as List<Map<String, dynamic>>;

      if (res.isNotEmpty) {
        return PersonaModel.fromJson(res[0]);
      }
    }

    return null;
  }

  Future<int> eliminarProspecto(int id) async {
    final Database db = await initDatabase();

    var res = await db.update(_tblProspecto, {"estado": 1},
        where: "id_prospecto = ?", whereArgs: [id]);

    return res;
  }

  Future<int> eliminarCliente(int id) async {
    final Database db = await initDatabase();

    var res =
        await db.delete(_tblCliente, where: "id_cliente = ?", whereArgs: [id]);

    return res;
  }

  //todo OPERACIONES CONTACTO PERSONAS
  Future<int> insertarContactoPersona(ContactosPersonaModel contacto) async {
    final db = await initDatabase();

    final res = await db.insert(_tblContacto, contacto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return res;
  }

  Future<List<ContactosPersonaModel>> obtenerContactoXtitular(
      int idTitular) async {
    final db = await initDatabase();

    final res = await db.rawQuery(
            """SELECT * FROM $_tblContacto WHERE id_titular = ?""", [idTitular])
        as List<Map<String, dynamic>>;

    if (res.isNotEmpty) {
      return res.map((e) => ContactosPersonaModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<ContactosPersonaModel>> obtenerContactosXtitular(
      int idTitular) async {
    final db = await initDatabase();

    final res = await db.rawQuery(
            "SELECT * FROM $_tblContacto WHERE id_titular = $idTitular")
        as List<Map<String, dynamic>>;

    return res.isNotEmpty
        ? res.map((e) => ContactosPersonaModel.fromJson(e)).toList()
        : [];
  }

  Future<ContactosPersonaModel?> obtenerContacto(
      int idTitular, int tipoContacto) async {
    debugPrint("contacto | titular: $idTitular - tipoContacto: $tipoContacto");
    final db = await initDatabase();

    final res = await db.rawQuery(
        "SELECT * FROM $_tblContacto WHERE id_titular = ? AND tipo_contacto = ? AND estado = 'A'",
        [idTitular, tipoContacto]) as List<Map<String, dynamic>>;

    return res.isNotEmpty
        ? res.map((e) => ContactosPersonaModel.fromJson(e)).toList()[0]
        : null;
  }

  /*  //todo OPERACIONES AGENDA
  Future<void> insertarCategoriasYproductos() async {
    final db = await initDatabase();

    final cats = await db.rawQuery("SELECT * FROM $_tblCats")
        as List<Map<String, dynamic>>;

    if (cats.isEmpty) {
      for (var i = 0; i < _listCats.length; i++) {
        debugPrint("nombre cat: ${_listCats[i]}");
        await db.insert(_tblCats, {"nombre_categoria": _listCats[i]});
      }

      for (var i = 0; i < _catsCred.length; i++) {
        debugPrint("nombre product; ${_catsCred[i]}");
        await db.insert(
            _tblProds, {"nombre_producto": _catsCred[i], "id_categoria": 1});
      }

      for (var i = 0; i < _catsSeg.length; i++) {
        debugPrint("nombre product; ${_catsSeg[i]}");
        await db.insert(
            _tblProds, {"nombre_producto": _catsSeg[i], "id_categoria": 2});
      }

      for (var i = 0; i < _catsSeg.length; i++) {
        debugPrint("nombre product; ${_catsAsis[i]}");
        await db.insert(
            _tblProds, {"nombre_producto": _catsAsis[i], "id_categoria": 3});
      }
    } else {
      debugPrint("YA EXISTEN CATEGORÍAS Y PRODUCTOS");
    }
  }

  Future<List<AgendaCatModel>> obtenerCategorias(int id) async {
    final db = await initDatabase();

    List<AgendaCatModel> categorias = [];
    final cats =
        await db.rawQuery("SELECT * FROM $_tblCats where id_persona = $id")
            as List<Map<String, dynamic>>;

    for (var cat in cats) {
      categorias.add(AgendaCatModel.fromJson(cat));
    }

    return categorias;
  }

  Future<List<AgendaProductModel>> obtenerProductos() async {
    final db = await initDatabase();

    List<AgendaProductModel> productos = [];

    final prods = await db.rawQuery("SELECT * FROM $_tblProds")
        as List<Map<String, dynamic>>;

    for (var prod in prods) {
      productos.add(AgendaProductModel.fromJson(prod));
    }

    return productos;
  } */

  Future<int> insertarAgenda(CalendarModel calendar) async {
    final db = await initDatabase();

    final res = await db.insert(_tblAgenda, calendar.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return res;
  }

  Future<int> actualizarAgenda(int idAgenda, CalendarModel agenda) async {
    final db = await initDatabase();

    var res = await db.update(_tblAgenda, agenda.toJson(),
        where: "id_agenda = ?", whereArgs: [idAgenda]);

    return res;
  }

  Future<int> actualizarRDSAgendaYcorreos(int idAgenda, int idRDS) async {
    final db = await initDatabase();

    /*var res = await db.update(_tblAgenda, {"id_rds": idRDS},
        where: "id_agenda = ?", whereArgs: [idRDS]);*/

    final res = await db.rawUpdate("""
      UPDATE $_tblAgenda 
        SET id_rds = ?
          WHERE id_agenda = ?
    """, [idRDS, idAgenda]);

    final cor = await db.rawUpdate("""
      UPDATE $_tblCorreo 
        SET id_rds = ? 
          WHERE id_agenda = ?
      """, [idRDS, idAgenda]);

    debugPrint(
        "ID RDS LOCAL DE LA AGENDA: ${res != 0 ? "ACTUALIZADO" : "NO ACTUALIZADO"}");
    debugPrint(
        "ID RDS LOCAL DEL CORREO: ${cor != 0 ? "ACTUALIZADO" : "NO ACTUALIZADO"}");
    return res;
  }

  Future<int> actualizarDocumentoAgenda(int idDocumento, int idRDS) async {
    final db = await initDatabase();

    final res = await db.rawUpdate("""
      UPDATE $_tblDocs
        SET id_rds = ?
          WHERE id_documento = ?
      """, [idRDS, idDocumento]);

    debugPrint("**********************************************");
    debugPrint("rds documento ${res != 0 ? "Actualizado" : "No actualizado"}");
    debugPrint("**********************************************");

    return res;
  }

  Future<int> actualizarResultado(int idAgenda, int resultado) async {
    final db = await initDatabase();

    final res = await db.rawUpdate(
        'UPDATE $_tblAgenda SET resultado_reunion = ? WHERE id_agenda = ?',
        [resultado, idAgenda]);

    return res;
  }

  Future<List<CalendarModel>> obtenerDatosAgenda(int idAgenda) async {
    final db = await initDatabase();

    List<CalendarModel> eventos = [];

    final res = await db.rawQuery("""
      SELECT( per.nombres || ' ' || per.apellidos) as nombres, per.empresa_negocio, ag.* 
      FROM $_tblAgenda AS ag 
      JOIN $_tblPersona AS per ON ag.id_persona = per.id_persona
      WHERE ag.id_agenda = $idAgenda AND ag.estado = 0
      """) as List<Map<String, dynamic>>;

    for (var evento in res) {
      eventos.add(CalendarModel.fromJson(evento));
    }

    return eventos;
  }

  Future<List<CalendarModel>> obtenerAgendas() async {
    final db = await initDatabase();

    List<CalendarModel> eventos = [];

    final res = await db.rawQuery("""
      SELECT( per.nombres || ' ' || per.apellidos) as nombres, per.empresa_negocio, ag.* 
      FROM $_tblAgenda AS ag 
      JOIN $_tblPersona AS per ON ag.id_persona = per.id_persona
      WHERE ag.estado = 0
      """) as List<Map<String, dynamic>>;

    for (var evento in res) {
      debugPrint("nombres: ${evento["nombres"]}");
      eventos.add(CalendarModel.fromJson(evento));
    }

    return eventos;
  }

  Future<CalendarModel?> obtenerAgenda(int id) async {
    final db = await initDatabase();

    CalendarModel? calendar;

    final res = await db.rawQuery(
            """SELECT( per.nombres || ' ' || per.apellidos) as nombres, per.empresa_negocio, per.mail as correo,ag.* 
      FROM $_tblAgenda AS ag 
      JOIN $_tblPersona AS per ON ag.id_persona = per.id_persona  WHERE ag.id_agenda = $id""")
        as List<Map<String, dynamic>>;

    calendar = CalendarModel.fromJson(res[0]);

    return calendar;
  }

  Future<CalendarModel?> obtenerAgendaXidRDS({required int idRDS}) async {
    final db = await initDatabase();

    CalendarModel? calendar;

    final res = await db.rawQuery(
            """SELECT( per.nombres || ' ' || per.apellidos) as nombres, per.empresa_negocio, per.mail as correo,ag.* 
      FROM $_tblAgenda AS ag 
      JOIN $_tblPersona AS per ON ag.id_persona = per.id_persona  WHERE ag.id_rds = $idRDS""")
        as List<Map<String, dynamic>>;

    if (res.isNotEmpty) {
      calendar = CalendarModel.fromJson(res[0]);
    }

    return calendar;
  }

  Future<List<CalendarModel>> obtenerAgendaYcorreosXpersona(
      int idPersona) async {
    final db = await initDatabase();

    List<CalendarModel> listaCalendario = [];
    CalendarModel? agenda;
    List<CorreoModel> correos = [];
    List<DocsModel> documentos = [];

    final res = await db.rawQuery(
        """SELECT * FROM $_tblAgenda  WHERE id_persona = $idPersona AND estado = 0""");

    if (res.isNotEmpty) {
      debugPrint("*********************************");
      debugPrint("TIENE AGENDAS EN LOCAL");
      debugPrint("*********************************");
      for (var evento in res) {
        agenda = CalendarModel.fromJson(evento);

        final listCorreos = await db.rawQuery(
            """SELECT * FROM $_tblCorreo WHERE id_agenda = ${evento["id_agenda"]}""");

        final listDocs = await db.rawQuery(
            """SELECT * FROM $_tblDocs WHERE id_agenda = ${evento["id_agenda"]}""");

        if (listCorreos.isNotEmpty) {
          for (var correo in listCorreos) {
            correos.add(CorreoModel.fromJson(correo));
          }

          agenda.correos = correos;
        }

        if (listDocs.isNotEmpty) {
          for (var doc in listDocs) {
            documentos.add(DocsModel.fromJson(doc));
          }
          agenda.documentos = documentos;
        }

        listaCalendario.add(agenda);
/* 
      documentos.clear();
      correos.clear();
      agenda = {}; */
      }
    } else {
      debugPrint("*********************************");
      debugPrint("NO TIENE AGENDAS EN LOCAL");
      debugPrint("*********************************");
    }

    return listaCalendario;
  }

  Future<int> insertarDocumentoAgenda(DocsModel doc) async {
    final db = await initDatabase();

    final res = await db.insert(_tblDocs, doc.toJson());

    return res;
  }

  Future<int> eliminarDocumentoAgenda(int idDoc) async {
    final db = await initDatabase();

    final res = await db
        .delete(_tblDocs, where: 'id_documento_agenda = ?', whereArgs: [idDoc]);

    return res;
  }

  Future<List<DocsModel>> obtenerDocumentosAgenda(int idAgenda) async {
    final db = await initDatabase();

    List<DocsModel> docs = [];

    final res =
        await db.rawQuery("SELECT * FROM $_tblDocs WHERE id_agenda = $idAgenda")
            as List<Map<String, dynamic>>;

    for (var doc in res) {
      docs.add(DocsModel.fromJson(doc));
    }

    return docs;
  }

  Future<int> actualizarLlegadaAgenda(int idAgenda) async {
    final db = await initDatabase();
    final position = await Geolocator.getCurrentPosition();
    final date = DateTime.now();

    final res = await db.rawUpdate("""UPDATE $_tblAgenda 
          SET asistio = ?, 
          latitud_llegada = ?, 
          longitud_llegada = ? 
            WHERE id_agenda = ?""",
        ["$date", position.latitude, position.longitude, idAgenda]);

    return res;
  }

  Future<int> actualizarEstadoReunion(int estado, int idAgenda) async {
    final db = await initDatabase();
    final res = await db.rawUpdate("""UPDATE $_tblAgenda
          SET estado = ?
            WHERE id_agenda = ?""", [estado, idAgenda]);

    return res;
  }

  Future<int> actualizarFotoReunion(String foto, int idAgenda) async {
    final db = await initDatabase();
    final res = await db.rawUpdate("""UPDATE $_tblAgenda
          SET foto_referencia = ?
            WHERE id_agenda = ?""", [foto, idAgenda]);

    return res;
  }

  //todo OPERACIONES CORREO
  Future<int> insertCorreos(List<CorreoModel> correos) async {
    final db = await initDatabase();

    var res = 0;

    for (var i = 0; i < correos.length; i++) {
      res = await db.insert(_tblCorreo, correos[i].toJson());

      debugPrint("correo: ${res != 0 ? "Insertado" : "No insertado"}");
    }

    return res;
  }

  Future<int> eliminarCorreo(int idCorreo) async {
    final db = await initDatabase();

    var res = await db.delete(_tblCorreo,
        where: "id_correo_agenda = ?", whereArgs: [idCorreo]);

    return res;
  }

  Future<List<CorreoModel>> obtenerCorreosPorAgenda(int id) async {
    final db = await initDatabase();

    List<CorreoModel> correos = [];

    final res =
        await db.rawQuery("SELECT * FROM $_tblCorreo WHERE id_agenda = $id");

    for (var correo in res) {
      correos.add(CorreoModel.fromJson(correo));
    }

    return correos;
  }

  Future<String> validarCliente(int idPersona) async {
    final Database db = await initDatabase();
    final resC = await db.rawQuery("""
        SELECT * FROM $_tblCliente WHERE id_persona = $idPersona""");

    final resP = await db.rawQuery("""
        SELECT * FROM $_tblProspecto WHERE id_persona = $idPersona""");

    if (resC.isNotEmpty) {
      return "C";
    } else if (resP.isNotEmpty) {
      return "P";
    } else {
      return "";
    }
  }

  Future<List<PersonaModel>> obtenerClientes() async {
    final Database db = await initDatabase();

    final list =
        await db.rawQuery("SELECT * FROM $_tblPersona WHERE cliente = 0")
            as List<Map<String, dynamic>>;

    if (list.isNotEmpty) {
      List<PersonaModel> listProspects = [];

      for (var prospec in list) {
        listProspects.add(PersonaModel.fromJson(prospec));
      }

      return listProspects;
    } else {
      return [];
    }
  }

  Future<List<PersonaModel>> obtenerClientesAlDia() async {
    final Database db = await initDatabase();

    final list = await db.rawQuery("""SELECT * FROM $_tblCliente AS cli
                JOIN $_tblPersona AS per ON per.id_persona = cli.id_persona
             WHERE cli.estado = 0 AND (cli.mora = '' OR (cli.mora = NULL OR cli.mora = '')) AND per.estado = 'A'""")
        as List<Map<String, dynamic>>;

    if (list.isNotEmpty) {
      List<PersonaModel> listProspects = [];

      for (var prospec in list) {
        listProspects.add(PersonaModel.fromJson(prospec));
      }

      return listProspects;
    } else {
      return [];
    }
  }

  Future<List<PersonaModel>> obtenerClientesEnMora() async {
    final Database db = await initDatabase();

    final list = await db.rawQuery("""SELECT * FROM $_tblCliente AS cli
                JOIN $_tblPersona AS per ON per.id_persona = cli.id_persona
             WHERE cli.estado = 0 AND cli.mora != '' AND per.estado = 'A'""")
        as List<Map<String, dynamic>>;

    if (list.isNotEmpty) {
      List<PersonaModel> listProspects = [];

      for (var prospec in list) {
        listProspects.add(PersonaModel.fromJson(prospec));
      }

      return listProspects;
    } else {
      return [];
    }
  }

  Future<void> deleteProspectos() async {
    final db = await initDatabase();

    await db.delete(_tblPersona);
  }

  //todo OPERACIONES AUTORIZACIÓN DE CONSULTA
  Future<int> insertarAutorizacion(AutorizacionModel aut) async {
    final db = await initDatabase();

    return await db.insert(_tblAutorizacion, aut.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> actualizarAutorizacion(AutorizacionModel aut, int idAut) async {
    final db = await initDatabase();

    return await db.update(_tblAutorizacion, aut.toJson(),
        where: "id_autorizacion = ?",
        whereArgs: [idAut],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AutorizacionModel>> obtenerAutorizacionPersonaXestado(
      int idPersona) async {
    final db = await initDatabase();

    final list = await db.rawQuery(
        'SELECT * FROM $_tblAutorizacion WHERE id_persona = ? AND (estado = ? OR estado = ?)',
        [idPersona, 1, 2]);

    if (list.isNotEmpty) {
      var autorizaciones = <AutorizacionModel>[];

      for (var aut in list) {
        autorizaciones.add(AutorizacionModel.fromJson(aut));
      }

      return autorizaciones;
    } else {
      return [];
    }
  }

  Future<List<AutorizacionModel>> obtenerAutorizacionPersonaXestadoFinalizada(
      int idPersona) async {
    final db = await initDatabase();

    final list = await db.rawQuery(
        'SELECT * FROM $_tblAutorizacion WHERE id_persona = ? AND estado = 2',
        [idPersona]);

    if (list.isNotEmpty) {
      var autorizaciones = <AutorizacionModel>[];

      for (var aut in list) {
        autorizaciones.add(AutorizacionModel.fromJson(aut));
      }

      return autorizaciones;
    } else {
      return [];
    }
  }

  Future<AutorizacionModel?> obtenerAutorizacion(int id) async {
    final db = await initDatabase();

    final list = await db.rawQuery(
        """SELECT * FROM $_tblAutorizacion WHERE id_autorizacion = ?""",
        [id]) as List<Map<String, dynamic>>;

    if (list.isNotEmpty) {
      return AutorizacionModel.fromJson(list[0]);
    } else {
      return null;
    }
  }

  //aplica para autorizaciones y solicitudes por persona
  Future<List<Map<String, dynamic>>> obtenerSolicitudesPendientes() async {
    final db = await initDatabase();

    //PARA CUANDO DEBA JUNTAR LA SOLICITUD AGREGAR ESTO LUEGO DE APELLIDOS
    /* COALESCE(
        MAX(CASE WHEN ac.estado = 1 THEN ac.fecha_registro ELSE NULL END)
      ) AS ultima_fecha,*/
    // JOIN $_tblSolicitud sol ON sol.id_autorizacion = ac.id_autorizacion
    final list = await db.rawQuery("""
    SELECT p.id_persona, p.nombres, p.apellidos, ac.fecha_creacion,
      CASE
        WHEN ac.estado = 1 OR ac.estado = 2 THEN 1
        ELSE 2
      END AS estado_general
        FROM $_tblPersona p JOIN $_tblSolicitud ac ON p.id_persona = ac.id_persona
        WHERE p.estado = 'A'
        GROUP BY p.id_persona
        HAVING estado_general = 1""") as List<Map<String, dynamic>>;

    return list.map((e) {
      return {
        "id_persona": e["id_persona"],
        "nombres": e["nombres"],
        "apellidos": e["apellidos"],
        "fecha": e["fecha_creacion"],
        "estado": e["estado_general"]
      };
    }).toList();
  }

  Future<List<SolicitudCreditoModel>> obtenerSolicitudPersonaXestadoFinalizada(
      int idPersona) async {
    final db = await initDatabase();

    final list = await db.rawQuery(
        'SELECT * FROM $_tblSolicitud WHERE id_persona = ? AND estado = 2',
        [idPersona]);

    if (list.isNotEmpty) {
      var solicitudes = <SolicitudCreditoModel>[];

      for (var aut in list) {
        solicitudes.add(SolicitudCreditoModel.fromJson(aut));
      }

      return solicitudes;
    } else {
      return [];
    }
  }

  //todo OPERACIONES DOCUMENTOS DE AUTORIZACIÓN DE CONSULTA
  Future<int> insertarDocumentoAutorizacion(DocumentoAutModel doc) async {
    final db = await initDatabase();

    final res = await db.insert(_tblDocAuto, doc.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    debugPrint("DOCUMENTO AUTORIZACIÓN: $res");

    return res;
  }

  Future<int> actualizarDocumentoAutorizacion(
      int idDoc, DocumentoAutModel doc) async {
    final db = await initDatabase();

    final res = await db.update(_tblDocAuto, doc.toJson(),
        where: "id_documento = ?",
        whereArgs: [idDoc],
        conflictAlgorithm: ConflictAlgorithm.replace);

    debugPrint(
        "Documento autorizacion: ${res == 1 ? "Actualizado" : "No actualizado"}");

    return res;
  }

  Future<List<DocumentoAutModel>> obtenerDocsXaut(int idAut) async {
    final db = await initDatabase();

    final res = await db.rawQuery(
            "SELECT * FROM $_tblDocAuto WHERE id_autorizacion = ?", [idAut])
        as List<Map<String, dynamic>>;

    if (res.isNotEmpty) {
      var lista = <DocumentoAutModel>[];

      for (var doc in res) {
        lista.add(DocumentoAutModel.fromJson(doc));
      }

      return lista;
    } else {
      return [];
    }
  }

  //todo INGRESAR RELACIÓN LABORAL  - AUTORIZACIÓN DE CONSULTA
  Future<void> insertarRelacionLaboral() async {
    final db = await initDatabase();
    List<RelacionModel> lista = [
      RelacionModel(nombreRelacion: "Independiente"),
      RelacionModel(nombreRelacion: "Dependiente"),
      RelacionModel(nombreRelacion: "Otros"),
    ];

    for (var i = 0; i < lista.length; i++) {
      final res = await db.insert(_tblRelacion, lista[i].toJson());
      debugPrint("relación laboral - ${lista[i]}: $res");
    }
  }

  //todo INGRESAR SECTOR ECONÓMICO - AUTORIZACIÓN DE CONSULTA
  Future<void> insertarSectorEconomico() async {
    final db = await initDatabase();
    List<SectorModel> lista = [
      SectorModel(nombreSector: "Comercio"),
      SectorModel(nombreSector: "Servicios"),
      SectorModel(nombreSector: "Producción"),
      SectorModel(nombreSector: "Agropecuario")
    ];

    for (var i = 0; i < lista.length; i++) {
      final res = await db.insert(_tblSector, lista[i].toJson());
      debugPrint("sector económico - ${lista[i]}: $res");
    }
  }

  //todo INGRESAR FUENTES DE INFO - AUTORIZACIÓN DE CONSULTA
  Future<void> insertarFuentes() async {
    final db = await initDatabase();
    List<FuenteModel> lista = [
      FuenteModel(nombreFuente: "Promoción del asesor de crédito"),
      FuenteModel(nombreFuente: "Medios de publicidad"),
      FuenteModel(nombreFuente: "Referido por cliente"),
      FuenteModel(nombreFuente: "Charla informativa"),
      FuenteModel(nombreFuente: "Perifonea"),
      FuenteModel(nombreFuente: "Taller productivo")
    ];

    for (var i = 0; i < lista.length; i++) {
      final res = await db.insert(_tblFuente, lista[i].toJson());
      debugPrint("Fuente - ${lista[i]}: $res");
    }
  }

  //todo INGRESAR PLAZO - AUTORIZACIÓN DE CONSULTA
  Future<void> insertarPlazo() async {
    final db = await initDatabase();
    List<PlazoModel> lista = [
      PlazoModel(nombrePlazo: "6 meses"),
      PlazoModel(nombrePlazo: "12 meses"),
      PlazoModel(nombrePlazo: "15 meses"),
      PlazoModel(nombrePlazo: "18 meses"),
      PlazoModel(nombrePlazo: "24 meses"),
      PlazoModel(nombrePlazo: "36 meses"),
      PlazoModel(nombrePlazo: "48 meses"),
    ];

    for (var i = 0; i < lista.length; i++) {
      final res = await db.insert(_tblPlazo, lista[i].toJson());
      debugPrint("Plazo - ${lista[i]}: $res");
    }
  }

  Future<int> getIdPromotor() async {
    final preferences = await SharedPreferences.getInstance();

    final res = preferences.getInt('idUsuario') ?? 0;

    return res;
  }

  //todo OPERACIONES DE SOLICITUD DE CRÉDITO
  Future<int> insertarSolicitud(SolicitudCreditoModel solicitud) async {
    final db = await initDatabase();

    final res = await db.insert(_tblSolicitud, solicitud.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return res;
  }

  Future<int> actualizarSolicitud(
      SolicitudCreditoModel solicitud, int id) async {
    final db = await initDatabase();

    final res = await db.update(_tblSolicitud, solicitud.toJson(),
        where: "id_solicitud = ?",
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);

    return res;
  }

  Future<SolicitudCreditoModel?> obtenerSolicitud(int id) async {
    final db = await initDatabase();

    SolicitudCreditoModel? solicitud;

    final res = await db.rawQuery(
            """SELECT * FROM $_tblSolicitud WHERE id_solicitud = ?""", [id])
        as List<Map<String, dynamic>>;

    if (res.isNotEmpty) {
      solicitud = SolicitudCreditoModel.fromJson(res[0]);
    }

    return solicitud;
  }

  Future<SolicitudCreditoModel?> obtenerSolicitudXAut(int idAut) async {
    final db = await initDatabase();

    SolicitudCreditoModel? solicitud;

    final res = await db.rawQuery(
        """SELECT * FROM $_tblSolicitud WHERE id_autorizacion = ?""",
        [idAut]) as List<Map<String, dynamic>>;

    if (res.isNotEmpty) {
      solicitud = SolicitudCreditoModel.fromJson(res[0]);
    }

    return solicitud;
  }

  Future<List<SolicitudCreditoModel>> obtenerSolciitudPersonaXestado(
      int idPersona) async {
    final db = await initDatabase();

    final list = await db.rawQuery(
        'SELECT * FROM $_tblSolicitud WHERE id_persona = $idPersona AND estado <> 3');

    if (list.isNotEmpty) {
      var solicitudes = <SolicitudCreditoModel>[];

      for (var aut in list) {
        solicitudes.add(SolicitudCreditoModel.fromJson(aut));
      }

      return solicitudes;
    } else {
      return [];
    }
  }

  //todo DOCUMENTOS SOLICITUD DE CRÉDITO
  Future<int> insertarDocumentoSolicitud(DocumentosSolicitudModel doc) async {
    final db = await initDatabase();

    final res = await db.insert(_tblDocSol, doc.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return res;
  }

  Future<int> actualizarDocumentoSolicitud(
      DocumentosSolicitudModel doc, int idDoc) async {
    final db = await initDatabase();

    final res = await db.update(_tblDocSol, doc.toJson(),
        where: "id_documento_solicitud = ?", whereArgs: [idDoc]);

    return res;
  }

  Future<List<DocumentosSolicitudModel>> obtenerDocumentosXsolicitud(
      int idSol) async {
    List<DocumentosSolicitudModel> solicitudes = [];
    final db = await initDatabase();

    var res = await db.rawQuery(
        """SELECT * FROM $_tblDocSol WHERE id_solicitud = ? AND estado = 'A'""",
        [idSol]) as List<Map<String, dynamic>>;

    solicitudes = res.isNotEmpty
        ? res.map((e) => DocumentosSolicitudModel.fromJson(e)).toList()
        : [];

    return solicitudes;
  }
}
