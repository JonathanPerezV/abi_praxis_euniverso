List<Map<String, dynamic>> get generos => _generos;
List<Map<String, dynamic>> get etnias => _etnias;
List<Map<String, dynamic>> get estadoM => _estadoM;
List<Map<String, dynamic>> get tiposVivienda => _tipoVivi;
List<Map<String, dynamic>> get sectores => _sectores;
List<Map<String, dynamic>> get estudios => _estudios;
List<Map<String, dynamic>> get profesiones => _profesiones;
List<Map<String, dynamic>> get relaciones => _relaciones;
List<Map<String, dynamic>> get negocios => _negocios;
List<Map<String, dynamic>> get tipoLocales => _tipoLocal;
List<Map<String, dynamic>> get ingresos => _ingresos;
List<Map<String, dynamic>> get estadosCiviles => _estadoCivil;
List<Map<String, dynamic>> get otraActvEcon => _otraActvEconomia;
List<Map<String, dynamic>> get parentesco => _parentesco;
List<Map<String, dynamic>> get destinos => _destinos;
List<Map<String, dynamic>> get frecuencias => _frecuencia;

List<Map<String, dynamic>> _generos = [
  {"nombre": "Masculino", "id": 1},
  {"nombre": "Femenino", "id": 2},
  {"nombre": "Otro", "id": 3}
];

List<Map<String, dynamic>> _etnias = [
  {"nombre": "Afroamericano", "id": 1},
  {"nombre": "Blanco", "id": 2},
  {"nombre": "Indígena", "id": 3},
  {"nombre": "Mestizo", "id": 4},
  {"nombre": "Montubio", "id": 5},
  {"nombre": "Otro", "id": 6}
];

List<Map<String, dynamic>> _estadoM = [
  {"nombre": "Ciudadano", "id": 1},
  {"nombre": "Residente", "id": 2},
  {"nombre": "Asilado/Refugiado", "id": 3},
  {"nombre": "Entrada migratoria condicional", "id": 4},
  {"nombre": "Protección temporanea", "id": 5}
];

List<Map<String, dynamic>> _tipoVivi = [
  {"nombre": "Propiedad Hipotecada", "id": 1},
  {"nombre": "Propiedad no hipotecada", "id": 2},
  {"nombre": "Arrendada", "id": 3},
  {"nombre": "Prestada", "id": 4},
  {"nombre": "Vive con familiares", "id": 5}
];

List<Map<String, dynamic>> _sectores = [
  {"nombre": "Urbano", "id": 1},
  {"nombre": "Rural", "id": 2}
];

List<Map<String, dynamic>> _estudios = [
  {"nombre": "Sin estudios", "id": 1},
  {"nombre": "Primaria", "id": 2},
  {"nombre": "Secundaria", "id": 3},
  {"nombre": "Formación intermedia", "id": 4},
  {"nombre": "Universitaria", "id": 5},
  {"nombre": "Postgrado", "id": 6}
];

List<Map<String, dynamic>> _profesiones = [
  {"nombre": "Sin título académico", "id": 1},
  {"nombre": "Ciencias Administrativas y Económicas", "id": 2},
  {"nombre": "Ingeniería y Ciencias exactas", "id": 3},
  {"nombre": "Arquitectos y afines", "id": 4},
  {"nombre": "Profesional de la salud", "id": 5},
  {"nombre": "Fuerza pública", "id": 6},
  {"nombre": "Ciencias sociales", "id": 7},
  {"nombre": "Ciencias de la educación", "id": 8},
  {"nombre": "Derecho", "id": 9},
  {"nombre": "Periodistas", "id": 10},
  {"nombre": "Otras", "id": 11}
];

List<Map<String, dynamic>> _relaciones = [
  {"nombre": "Independiente", "id": 1},
  {"nombre": "Dependiente", "id": 2},
  {"nombre": "Otros", "id": 3},
];

//todo INDEPENDIENTE
List<Map<String, dynamic>> _negocios = [
  {"nombre": "Fijo", "id": 1},
  {"nombre": "Ambulatorio", "id": 2}
];

List<Map<String, dynamic>> _tipoLocal = [
  {"nombre": "Propio", "id": 1},
  {"nombre": "Arrendado", "id": 2},
  {"nombre": "Familiares", "id": 3},
  {"nombre": "Herencia", "id": 4},
  {"nombre": "Prestado", "id": 5}
];

//todo DEPENDIENTE
List<Map<String, dynamic>> _ingresos = [
  {"nombre": "Empleado público", "id": 1},
  {"nombre": "Empleado privado", "id": 2},
];

List<Map<String, dynamic>> _estadoCivil = [
  {"nombre": "Soltero", "id": 1},
  {"nombre": "Casado", "id": 2},
  {"nombre": "Unión de hecho", "id": 3},
  {"nombre": "Divorciado", "id": 4},
  {"nombre": "Viudo", "id": 5}
];

//todo OTROS
List<Map<String, dynamic>> _otraActvEconomia = [
  {"nombre": "Jubilado / Pensionista", "id": 1},
  {"nombre": "Estudiante", "id": 2},
  {"nombre": "Rentista", "id": 3},
  {"nombre": "Ama de casa", "id": 4},
  {"nombre": "Remesas del esterior", "id": 5},
  {"nombre": "Otros", "id": 6},
];

List<Map<String, dynamic>> _parentesco = [
  {"nombre": "Padre", "id": 4},
  {"nombre": "Madre", "id": 5},
  {"nombre": "Tío/a", "id": 6},
  {"nombre": "Abuelo/a", "id": 7},
  {"nombre": "Hijo/a", "id": 8},
  {"nombre": "Hermano/a", "id": 9},
  {"nombre": "Otros", "id": 10},
];

List<Map<String, dynamic>> _destinos = [
  {"nombre": "Capital de trabajo(CT)", "id": 1},
  {"nombre": "No productivo(OT)", "id": 2},
  {"nombre": "Activo fijo intangible", "id": 3},
  {"nombre": "Activo fijo tangible", "id": 4},
  {"nombre": "Restructuración pasivos", "id": 5},
  {"nombre": "Pago de obligaciones", "id": 6},
  {"nombre": "Otros", "id": 7}
];

List<Map<String, dynamic>> _listaPlazo = [
  {"nombre": "6meses", "id": 1},
  {"nombre": "12meses", "id": 2},
  {"nombre": "15meses", "id": 3},
  {"nombre": "18meses", "id": 4},
  {"nombre": "24meses", "id": 5},
  {"nombre": "36meses", "id": 6},
  {"nombre": "48meses", "id": 7},
];

List<Map<String, dynamic>> _frecuencia = [
  {"nombre": "Mensual", "id": 1},
  {"nombre": "Trimestral", "id": 2},
  {"nombre": "Semestral", "id": 3}
];
