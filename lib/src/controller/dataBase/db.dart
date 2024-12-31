import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider.internal();

  static final DBProvider instance = DBProvider.internal();
  factory DBProvider() => instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  //todo VARIABLES GENERALES
  static const String fechaCreacion = "fecha_creacion";
  static const String horaCreacion = "hora_creacion";
  static const String estado = "estado";
  static const String idPromotor = "id_promotor";
  static const String idPersona = "id_persona";
  static const String idUsuarioCreacion = "usuario_creacion";
  static const String codigoImg = "codigo_imagen";
  static const String descripcion = "descripcion";
  static const String idNube = "id_rds";
  static const String observacion = "observacion";
  static const String fechaUpdate = "fecha_update";
  static const String codDoc = "codigo_documento";
  //todo VARIABLES PERSONA
  static const String nombres = "nombres";
  static const String apellidos = "apellidos";
  static const String celular = "celular1";
  static const String celular2 = "celular2";
  static const String cedula = "numero_identificacion";
  static const String direccion = "direccion";
  static const String direccionTrabajo = "direccion_trabajo";
  static const String referenciaTrabajo = "referencia_trabajo";
  static const String empresa = "empresa_negocio";
  static const String mail = "mail";
  static const String latitud = "latitud";
  static const String latitudTrabajo = "latitud_trabajo";
  static const String longitud = "longitud";
  static const String longitudTrabajo = "longitud_trabajo";
  static const String referencia = "referencia";
  static const String ciudad = "ciudad";
  static const String provincia = "provincia";
  static const String pais = "pais";
  static const String sector = "sector";
  static const String cliente = "cliente";
  static const String fotoRefCasa = "foto_referencia_casa";
  static const String fotoRefTrabajo = "foto_referencia_trabajo";
  static const String fechaNaci = "fecha_nacimiento";
  static const String edad = "edad";
  static const String genero = "genero";
  //todo VARIABLES PROSPECTO
  static const String idProspecto = "id_prospecto";
  //id promotor
  //id persona
  //todo VARIABLES CLIENTE
  static const String idCliente = "id_cliente";
  //el id persona también se usará "id_persona" pero ya se encuentra declarada
  //el estado también se usará "estado" pero ya se encuentra declarada
  static const String mora = "mora";
  static const String calificacion = "calificacion";
  //todo VARIABLES CONTACTO PERSONA
  static const String idContactoPersona = "id_contacto_persona";
  static const String idTitular = "id_titular";
  //static const String id_persona
  static const String tipoContacto = "tipo_contacto";
  static const String ref = "referencia";
  //estado
  //todo VARIABLES TIPO CONTACTO PERSONA
  static const String idTipoContacto = "id_tipo_contacto";
  //estado
  //todo VARIABLES AGENDA
  static const String idAgenda = "id_agenda";
  //idpersona
  //idpromotor
  static const String categoriaProducto = "categoria_producto";
  static const String plan = "plan";
  static const String gestion = "gestion";
  static const String producto = "producto";
  static const String empresaAgenda = "empresa_negocio";
  static const String lugarReunion = "lugar_reunion";
  static const String resultadoReunion = "resultado_reunion";
  static const String allDay = "all_day";
  static const String fechaReunion = "fecha_reunion";
  static const String horaInicio = "hora_inicio";
  static const String horaFin = "hora_fin";
  static const String medioContacto = "medio_contacto";
  static const String latitudA = "latitud";
  static const String latitudLlegada = "latitud_llegada";
  static const String longitudA = "longitud";
  static const String longitudLlegada = "longitud_llegada";
  static const String asistio = "asistio";
  //el estado también se usará "estado" pero ya se encuentra declarada
  static const String fotoReferencia = "foto_referencia";
  //todo VARIABLES CATEGORIAS - AGENDA
  static const String idCategoria = "id_categoria";
  static const String nombreCategoria = "nombre_categoria";
  //todo VARIABLES PRODUCTOS - AGENDA
  static const String idProducto = "id_producto";
  static const String nombreProducto = "nombre_producto";
  //todo VARIABLES CORREOS - AGENDA
  static const String idCorreo = "id_correo_agenda";
  //id agenda
  static const String correo = "mail";
  //estado
  //todo VARIABLES DOCUMENTOS - AGENDA
  static const String idDocumento = "id_documento_agenda";
  static const String nombreDoc = "nombre_documento";
  //
  //
  //todo VARIABLES RELACIÓN LABORAL - AUTORIZACION
  static const String idRelacion = "id_relacion";
  static const String nombreRelacion = "nombre_relacion";
  //todo VARIABLES SECTOR ECONOMICO - AUTORIZACION
  static const String idSector = "id_sector";
  static const String nombreSector = "nombre_sector";
  //todo VARIABLES FUENTE - AUTORIZACION
  static const String idFuente = "id_fuente";
  static const String nombreFuente = "nombre_fuente";
  //todo VARIABLES PLAZO - AUTORIZACION
  static const String idPlazo = "id_plazo";
  static const String nombrePlazo = "nombre_plazo";
  //todo VARIABLES AUTORIZACIÓN CONSULTA
  static const String idAutorizacion = "id_autorizacion";
  //int idPersona - existe
  static const String idCProspecto = "id_conyuge_prospecto";
  static const String idGarante = "id_garante";
  static const String idCGarante = "id_conyuge_garante";
  static const String relacionLaboral = "relacion_laboral";
  static const String actividad = "actividad";
  static const String codActividad = "codigo_actividad";
  static const String sectorEconomico = "sector_economico";
  static const String tiempoFunciones = "tiempo_funciones";
  static const String telefonoTrabajo = "telefono_trabajo";
  static const String fuente = "fuente";
  static const String monto = "monto";
  static const String plazo = "plazo";
  static const String cuota = "cuota";
  //fecha creacion
  //hora creacion
  //usuario creacion
  //estado
  //todo VARIABLES DOCS AUTORIZACIÓN CONSULTA
  static const String idDocAut = "id_documento";
  //id autorizacion
  //id persona
  //codigo documento //P, PC, G, GC
  static const String tipo = "tipo_documento";
  //codigo imagen
  //fecha creacion
  //hora creacion
  //usuario creacion
  //estado
  //todo VARIABLES ESTADO AUTORIZACION
  static const String idEstadoAut = "id_estado_autorizacion";
  //descripcion
  //estado

  //todo VARIABLES SOLICITUD DE CRÉDITO
  static const String idSolicitud = "id_solicitud";
  //id autorización
  //id persona
  //id promotor
  static const String rechazo = "motivo";
  static const String tipoProducto = "id_tipo_producto";
  //monto
  static const String codigoContrato = "codigo_contrato";
  static const String datosPersonales = "datos_personales";
  static const String datosBeneficiario = "datos_beneficiario";
  static const String datosSuscripcion = "datos_suscripcion";
  static const String documentos = "documentos";
  static const String autorizacion = "autorizacion";
  //fecha creacion
  //hora creacion
  //usuario creacion
  static const String codigoPdf = "codigo_pdf";
  //idNube
  //estado

  //todo VARIABLES DOCUMENTOS DE SOLICITUD DE CRÉDITO
  static const String idDocSolicitud = "id_documento_solicitud";
  //id solicitud
  //codigo documento
  static const String tipoDoc = "tipo_documento";
  //observacion
  //fecha creacion
  //hora creacion
  //id persona
  static const String isPdf = "is_pdf";
  //usuario creacion
  //estado

  static initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "abi_praxis.db");
    return await databaseConfig(path);
  }

  static Future<Database> databaseConfig(String path) async {
    return await openDatabase(path, version: 4, onOpen: (db) {},
        onCreate: (db, version) async {
      await db.execute("""
      CREATE TABLE IF NOT EXISTS tbl_persona(
        $idPersona INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $cedula TEXT,
        $nombres TEXT,
        $apellidos TEXT,
        $celular TEXT,
        $celular2 TEXT,
        $direccion TEXT,
        $latitud TEXT,
        $longitud TEXT,
        $direccionTrabajo TEXT,
        $empresa TEXT,
        $mail TEXT,
        $referencia TEXT,
        $referenciaTrabajo TEXT,
        $sector TEXT,
        $latitudTrabajo TEXT,
        $longitudTrabajo TEXT,
        $pais INTEGER,
        $provincia INTEGER,
        $ciudad INTEGER,
        $fotoRefCasa BLOB,
        $fotoRefTrabajo BLOB,
        $fechaCreacion TEXT,
        $horaCreacion TEXT,
        $estado TEXT,
        $fechaNaci TEXT,
        $fechaUpdate TEXT,
        $edad TEXT,
        $genero TEXT,
        $observacion TEXT,
        $idUsuarioCreacion INTEGER,
        $idNube INTEGER
      )""");
      await db.execute("""CREATE TABLE IF NOT EXISTS tbl_contacto_persona(
        $idContactoPersona INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $idTitular INTEGER,
        $idPersona INTEGER,
        $tipoContacto INTEGER,
        $observacion TEXT,
        $estado TEXT,
        $ref INTEGER,
        $idNube INTEGER
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS tbl_prospecto(
        $idProspecto INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $idPersona INTEGER,
        $idPromotor INTEGER,
        $fechaCreacion TEXT,
        $horaCreacion TEXT,
        $idUsuarioCreacion INTEGER,
        $estado INTEGER,
        $idNube INTEGER
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS tbl_cliente(
        $idCliente INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $idPersona INTEGER,
        $idPromotor INTEGER,
        $mora INTEGER, 
        $calificacion INTEGER,   
        $fechaCreacion TEXT,
        $horaCreacion TEXT,
        $idUsuarioCreacion INTEGER,
        $estado INTEGER,
        $idNube INTEGER
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS tbl_agenda(
        $idAgenda INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $idPersona INTEGER,
        $idPromotor INTEGER,
        $categoriaProducto INTEGER,
        $plan INTEGER,
        $gestion INTEGER,
        $lugarReunion TEXT,
        $resultadoReunion INTEGER,
        $fechaReunion TEXT,
        $horaFin TEXT,
        $horaInicio TEXT,
        $producto INTEGER,
        $observacion TEXT,
        $medioContacto INTEGER,
        $latitudA TEXT,
        $longitudA TEXT,
        $asistio TEXT,
        $latitudLlegada TEXT,
        $longitudLlegada TEXT,  
        $estado INTEGER,
        $fotoReferencia BLOB,
        $fechaCreacion TEXT,
        $horaCreacion TEXT,
        $idUsuarioCreacion INTEGER,
        $idNube INTEGER
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS tbl_categoria_producto(
        $idCategoria INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $nombreCategoria TEXT
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS tbl_producto(
        $idProducto INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $idCategoria INTEGER,
        $nombreProducto TEXT
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS tbl_correo_agenda(
        $idCorreo INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $idAgenda INTEGER,
        $estado TEXT,
        $correo TEXT,
        $idUsuarioCreacion INTEGER,
        $idNube INTEGER
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS tbl_documentos_agenda(
        $idDocumento INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $nombreDoc TEXT,
        $codigoImg BLOB,
        $idAgenda INTEGER,
        $idUsuarioCreacion INTEGER,
        $fechaCreacion TEXT,
        $horaCreacion TEXT,
        $estado TEXT,
        $idNube INTEGER
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS tbl_relacion_laboral(
        $idRelacion INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $nombreRelacion TEXT
      )""");
      await db.execute("""CREATE TABLE IF NOT EXISTS tbl_sector_economico(
        $idSector INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $nombreSector TEXT
      )""");
      await db.execute("""CREATE TABLE IF NOT EXISTS tbl_fuente_informacion(
        $idFuente INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $nombreFuente TEXT
      )""");
      await db.execute("""CREATE TABLE IF NOT EXISTS tbl_plazo(
        $idPlazo INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $nombrePlazo TEXT
      )""");
      await db.execute("""CREATE TABLE IF NOT EXISTS tbl_autorizacion(
        $idAutorizacion INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $idPersona INTEGER,
        $idCProspecto INTEGER,
        $idPromotor INTEGER,
        $idGarante INTEGER,
        $idCGarante INTEGER,
        $relacionLaboral INTEGER,
        $actividad TEXT,
        $codActividad TEXT,
        $sectorEconomico TEXT,
        $tiempoFunciones TEXT,
        $telefonoTrabajo TEXT,
        $fuente INTEGER,
        $monto TEXT,
        $plazo INTEGER,
        $cuota TEXT,
        $fechaCreacion TEXT,
        $horaCreacion TEXT,
        $idUsuarioCreacion INTEGER,
        $estado INTEGER,
        $idNube INTEGER
      )""");
      await db
          .execute("""CREATE TABLE IF NOT EXISTS tbl_documentos_autorizacion(
          $idDocAut INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          $idPersona INTEGER,
          $idAutorizacion INTEGER,
          $codDoc TEXT,
          $tipo TEXT,
          $codigoImg BLOB,
          $fechaCreacion TEXT,
          $horaCreacion TEXT,
          $idUsuarioCreacion INTEGER,
          $estado TEXT,
          $idNube INTEGER
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS tbl_estado_autorizacion(
      $idEstadoAut INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $descripcion TEXT,
      $estado TEXT
      )""");
      await db.execute("""CREATE TABLE IF NOT EXISTS tbl_solicitud(
      $idSolicitud INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $idPersona INTEGER,
      $idPromotor INTEGER,
      $rechazo TEXT,
      $tipoProducto INTEGER,
      $codigoContrato TEXT,
      $datosPersonales BLOB,
      $datosBeneficiario BLOB,
      $datosSuscripcion BLOB,
      $autorizacion BLOB,
      $documentos BLOB,
      $fechaCreacion TEXT,
      $horaCreacion TEXT,
      $idUsuarioCreacion INTEGER,
      $codigoPdf BLOB,
      $idNube INTEGER,
      $estado INTEGER
      )""");
      await db.execute("""CREATE TABLE IF NOT EXISTS tbl_documentos_solicitud(
      $idDocSolicitud INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $idSolicitud INTEGER,
      $idPersona INTEGER,
      $codDoc BLOB,
      $tipoDoc INTEGER,
      $observacion TEXT,
      $fechaCreacion TEXT,
      $horaCreacion TEXT,
      $idUsuarioCreacion INTEGER,
      $isPdf INTEGER,
      $estado TEXT
      )""");
    });
  }
}
