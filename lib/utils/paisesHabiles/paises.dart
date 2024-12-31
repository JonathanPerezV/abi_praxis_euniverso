Map<String, dynamic> listaPaises = {
  'paises': [
    {'id': 1, 'nombre': 'Ecuador'},
  ]..sort((a, b) => a["nombre"]
      .toString()
      .toLowerCase()
      .compareTo(b["nombre"].toString().toLowerCase()))
};

//todo--------------------------------------------------------------------------
//todo------------------------------ECUADOR-------------------------------------
//todo--------------------------------------------------------------------------
Map<String, dynamic> listaProvinciasEcuador = {
  'provincias': [
    {'id': 1, 'nombre': 'GUAYAS'},
    {'id': 2, 'nombre': 'PICHINCHA'},
    {'id': 3, 'nombre': 'AZUAY'},
    {'id': 4, 'nombre': 'MANABI'},
    {'id': 5, 'nombre': 'BOLIVAR'},
    {'id': 6, 'nombre': 'CAÑAR'},
    {'id': 7, 'nombre': 'CARCHI'},
    {'id': 8, 'nombre': 'COTOPAXI'},
    {'id': 9, 'nombre': 'CHIMBORAZO'},
    {'id': 10, 'nombre': 'EL ORO'},
    {'id': 11, 'nombre': 'ESMERALDAS'},
    {'id': 12, 'nombre': 'IMBABURA'},
    {'id': 13, 'nombre': 'LOJA'},
    {'id': 14, 'nombre': 'LOS RIOS'},
    {'id': 15, 'nombre': 'MORONA SANTIAGO'},
    {'id': 16, 'nombre': 'NAPO'},
    {'id': 17, 'nombre': 'PASTAZA'},
    {'id': 18, 'nombre': 'TUNGURAHUA'},
    {'id': 19, 'nombre': 'ZAMORA CHINCHIPE'},
    {'id': 20, 'nombre': 'GALAPAGOS'},
    {'id': 21, 'nombre': 'SUCUMBIOS'},
    {'id': 22, 'nombre': 'ORELLANA'},
    {'id': 23, 'nombre': 'SANTO DOMINGO DE LOS TSACHILAS'},
    {'id': 24, 'nombre': 'SANTA ELENA'},
  ]..sort((a, b) => a["nombre"]
      .toString()
      .toLowerCase()
      .compareTo(b["nombre"].toString().toLowerCase()))
};

List<Map<String, dynamic>> listaCiudadesAzuay = [
  {"nombre": "CUENCA", "id_c": 34, "id_p": 3},
  {"nombre": "GIRÓN", "id_c": 35, "id_p": 3},
  {"nombre": "GUALACEO", "id_c": 36, "id_p": 3},
  {"nombre": "NABÓN", "id_c": 37, "id_p": 3},
  {"nombre": "PAUTE", "id_c": 38, "id_p": 3},
  {"nombre": "PUCARA", "id_c": 39, "id_p": 3},
  {"nombre": "SAN FERNANDO", "id_c": 40, "id_p": 3},
  {"nombre": "SANTA ISABEL", "id_c": 41, "id_p": 3},
  {"nombre": "SIGSIG", "id_c": 42, "id_p": 3},
  {"nombre": "OÑA", "id_c": 43, "id_p": 3},
  {"nombre": "CHORDELEG", "id_c": 44, "id_p": 3},
  {"nombre": "EL PAN", "id_c": 45, "id_p": 3},
  {"nombre": "SEVILLA DE ORO", "id_c": 46, "id_p": 3},
  {"nombre": "GUACHAPALA", "id_c": 47, "id_p": 3},
  {"nombre": "CAMILO PONCE ENRÍQUEZ", "id_c": 48, "id_p": 3},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesBolivar = [
  {"nombre": "GUARANDA", "id_c": 71, "id_p": 5},
  {"nombre": "CHILLANES", "id_c": 72, "id_p": 5},
  {"nombre": "CHIMBO", "id_c": 73, "id_p": 5},
  {"nombre": "ECHENDÍA", "id_c": 74, "id_p": 5},
  {"nombre": "SAN MIGUEL", "id_c": 75, "id_p": 5},
  {"nombre": "CALUMA", "id_c": 76, "id_p": 5},
  {"nombre": "LAS NAVES", "id_c": 77, "id_p": 5},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesCanar = [
  {"nombre": "AZOGUES", "id_c": 78, "id_p": 6},
  {"nombre": "BIBLIÁN", "id_c": 79, "id_p": 6},
  {"nombre": "CAÑAR", "id_c": 80, "id_p": 6},
  {"nombre": "LA TRONCAL", "id_c": 81, "id_p": 6},
  {"nombre": "EL TAMBO", "id_c": 82, "id_p": 6},
  {"nombre": "DÉLEG", "id_c": 83, "id_p": 6},
  {"nombre": "SUSCAL", "id_c": 84, "id_p": 6},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesCarchi = [
  {"nombre": "TULCÁN", "id_c": 85, "id_p": 7},
  {"nombre": "BOLÍVAR", "id_c": 86, "id_p": 7},
  {"nombre": "ESPEJO", "id_c": 87, "id_p": 7},
  {"nombre": "MIRA", "id_c": 88, "id_p": 7},
  {"nombre": "MONTÚFAR", "id_c": 89, "id_p": 7},
  {"nombre": "SAN PEDRO DE HUACA", "id_c": 90, "id_p": 7},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesChimborazo = [
  {"nombre": "RIOBAMBA", "id_c": 98, "id_p": 9},
  {"nombre": "ALAUSI", "id_c": 99, "id_p": 9},
  {"nombre": "COLTA", "id_c": 100, "id_p": 9},
  {"nombre": "CHAMBO", "id_c": 101, "id_p": 9},
  {"nombre": "CHUNCHI", "id_c": 102, "id_p": 9},
  {"nombre": "GUAMOTE", "id_c": 103, "id_p": 9},
  {"nombre": "GUANO", "id_c": 104, "id_p": 9},
  {"nombre": "PALLATANGA", "id_c": 105, "id_p": 9},
  {"nombre": "PENIPE", "id_c": 106, "id_p": 9},
  {"nombre": "CUMANDÁ", "id_c": 107, "id_p": 9},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesCotopaxi = [
  {"nombre": "LATACUNGA", "id_c": 91, "id_p": 8},
  {"nombre": "LA MANÁ", "id_c": 92, "id_p": 8},
  {"nombre": "PANGUA", "id_c": 93, "id_p": 8},
  {"nombre": "PUJILI", "id_c": 94, "id_p": 8},
  {"nombre": "SALCEDO", "id_c": 95, "id_p": 8},
  {"nombre": "SAQUISILÍ", "id_c": 96, "id_p": 8},
  {"nombre": "SIGCHOS", "id_c": 97, "id_p": 8},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesElOro = [
  {"nombre": "MACHALA", "id_c": 108, "id_p": 10},
  {"nombre": "ARENILLAS", "id_c": 109, "id_p": 10},
  {"nombre": "ATAHUALPA", "id_c": 110, "id_p": 10},
  {"nombre": "BALSAS", "id_c": 111, "id_p": 10},
  {"nombre": "CHILLA", "id_c": 112, "id_p": 10},
  {"nombre": "EL GUABO", "id_c": 113, "id_p": 10},
  {"nombre": "HUAQUILLAS", "id_c": 114, "id_p": 10},
  {"nombre": "MARCABELÍ", "id_c": 115, "id_p": 10},
  {"nombre": "PASAJE", "id_c": 116, "id_p": 10},
  {"nombre": "PIÑAS", "id_c": 117, "id_p": 10},
  {"nombre": "PORTOVIEJO", "id_c": 118, "id_p": 10},
  {"nombre": "SANTA ROSA", "id_c": 119, "id_p": 10},
  {"nombre": "ZARUMA", "id_c": 120, "id_p": 10},
  {"nombre": "LAS LAJAS", "id_c": 121, "id_p": 10},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesEsmeraldas = [
  {"nombre": "ESMERALDAS", "id_c": 122, "id_p": 11},
  {"nombre": "ELOY ALFARO", "id_c": 123, "id_p": 11},
  {"nombre": "MUISNE", "id_c": 124, "id_p": 11},
  {"nombre": "QUININDÉ", "id_c": 125, "id_p": 11},
  {"nombre": "SAN LORENZO", "id_c": 126, "id_p": 11},
  {"nombre": "ATACAMES", "id_c": 127, "id_p": 11},
  {"nombre": "RIOVERDE", "id_c": 128, "id_p": 11},
  {"nombre": "LA CONCORDIA", "id_c": 129, "id_p": 11},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesGalapagos = [
  {"nombre": "SAN CRISTÓBAL", "id_c": 204, "id_p": 20},
  {"nombre": "ISABELA", "id_c": 205, "id_p": 20},
  {"nombre": "SANTA CRUZ", "id_c": 206, "id_p": 20}
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesGuayas = [
  {"nombre": "GUAYAQUIL", "id_c": 1, "id_p": 1},
  {"nombre": "ALFREDO BAQUERIZO MORENO (JUJÁN)", "id_c": 2, "id_p": 1},
  {"nombre": "BALAO", "id_c": 3, "id_p": 1},
  {"nombre": "BALZAR", "id_c": 4, "id_p": 1},
  {"nombre": "COLIMES", "id_c": 5, "id_p": 1},
  {"nombre": "DAULE", "id_c": 6, "id_p": 1},
  {"nombre": "DURÁN", "id_c": 7, "id_p": 1},
  {"nombre": "EL EMPALME", "id_c": 8, "id_p": 1},
  {"nombre": "EL TRIUNFO", "id_c": 9, "id_p": 1},
  {"nombre": "MILAGRO", "id_c": 10, "id_p": 1},
  {"nombre": "NARANJAL", "id_c": 11, "id_p": 1},
  {"nombre": "NARANJUTO", "id_c": 12, "id_p": 1},
  {"nombre": "PALESTINA", "id_c": 13, "id_p": 1},
  {"nombre": "PEDRO CARBO", "id_c": 14, "id_p": 1},
  {"nombre": "SAMBORONDÓN", "id_c": 15, "id_p": 1},
  {"nombre": "SANTA LUCÍA", "id_c": 16, "id_p": 1},
  {"nombre": "SALITRE (URBINA JADO)", "id_c": 17, "id_p": 1},
  {"nombre": "SAN JACINTO DE YAGUACHI", "id_c": 18, "id_p": 1},
  {"nombre": "PLAYAS", "id_c": 19, "id_p": 1},
  {"nombre": "SIMÓN BOLIVAR", "id_c": 20, "id_p": 1},
  {"nombre": "CORONEL MARCELINO MARIDUEÑA", "id_c": 21, "id_p": 1},
  {"nombre": "LOMAS DE SARGENTILLO", "id_c": 22, "id_p": 1},
  {"nombre": "NOBOL", "id_c": 23, "id_p": 1},
  {"nombre": "GENERAL ANTONIO ELIZALDE", "id_c": 24, "id_p": 1},
  {"nombre": "ISIDRO AYORA", "id_c": 25, "id_p": 1},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesImbabura = [
  {"nombre": "IBARRA", "id_c": 130, "id_p": 12},
  {"nombre": "ANTONIO ANTE", "id_c": 131, "id_p": 12},
  {"nombre": "COTACACHI", "id_c": 132, "id_p": 12},
  {"nombre": "OTAVALO", "id_c": 133, "id_p": 12},
  {"nombre": "PIMAMPIRO", "id_c": 134, "id_p": 12},
  {"nombre": "SAN MIGUEL DE URCUQUÍ", "id_c": 135, "id_p": 12},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesLoja = [
  {"nombre": "LOJA", "id_c": 136, "id_p": 13},
  {"nombre": "CALVAS", "id_c": 137, "id_p": 13},
  {"nombre": "CATAMAYO", "id_c": 138, "id_p": 13},
  {"nombre": "CELICA", "id_c": 139, "id_p": 13},
  {"nombre": "CHAGUARPAMBA", "id_c": 140, "id_p": 13},
  {"nombre": "ESPÍNDOLA", "id_c": 141, "id_p": 13},
  {"nombre": "GONZANAMÁ", "id_c": 142, "id_p": 13},
  {"nombre": "MACARÁ", "id_c": 143, "id_p": 13},
  {"nombre": "PALTAS", "id_c": 144, "id_p": 13},
  {"nombre": "PUYANGO", "id_c": 145, "id_p": 13},
  {"nombre": "SARAGURO", "id_c": 146, "id_p": 13},
  {"nombre": "SOZORANGA", "id_c": 147, "id_p": 13},
  {"nombre": "ZAPOTILLO", "id_c": 148, "id_p": 13},
  {"nombre": "PINDAL", "id_c": 149, "id_p": 13},
  {"nombre": "QUILANGA", "id_c": 150, "id_p": 13},
  {"nombre": "OLMEDO", "id_c": 151, "id_p": 13},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesLosRios = [
  {"nombre": "BABAHOYO", "id_c": 152, "id_p": 14},
  {"nombre": "BABA", "id_c": 153, "id_p": 14},
  {"nombre": "MONTALVO", "id_c": 154, "id_p": 14},
  {"nombre": "PUEBLOVIEJO", "id_c": 155, "id_p": 14},
  {"nombre": "QUEVEDO", "id_c": 156, "id_p": 14},
  {"nombre": "URDANETA", "id_c": 157, "id_p": 14},
  {"nombre": "VENTANAS", "id_c": 158, "id_p": 14},
  {"nombre": "VÍNCES", "id_c": 159, "id_p": 14},
  {"nombre": "PALENQUE", "id_c": 160, "id_p": 14},
  {"nombre": "BUENA FÉ", "id_c": 161, "id_p": 14},
  {"nombre": "VALENCIA", "id_c": 162, "id_p": 14},
  {"nombre": "MOCACHE", "id_c": 163, "id_p": 14},
  {"nombre": "QUINSALOMA", "id_c": 164, "id_p": 14},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesManabi = [
  {"nombre": "PORTOVIEJO", "id_c": 49, "id_p": 4},
  {"nombre": "BOLÍVAR", "id_c": 50, "id_p": 4},
  {"nombre": "CHONE", "id_c": 51, "id_p": 4},
  {"nombre": "EL CARMEN", "id_c": 52, "id_p": 4},
  {"nombre": "FLAVIO ALFARO", "id_c": 53, "id_p": 4},
  {"nombre": "JIPIJAPA", "id_c": 54, "id_p": 4},
  {"nombre": "JUNÍN", "id_c": 55, "id_p": 4},
  {"nombre": "MANTA", "id_c": 56, "id_p": 4},
  {"nombre": "MONTECRISTI", "id_c": 57, "id_p": 4},
  {"nombre": "PAJÁN", "id_c": 58, "id_p": 4},
  {"nombre": "PICHINCHA", "id_c": 59, "id_p": 4},
  {"nombre": "ROCAFUERTE", "id_c": 60, "id_p": 4},
  {"nombre": "SANTA ANA", "id_c": 61, "id_p": 4},
  {"nombre": "SUCRE", "id_c": 62, "id_p": 4},
  {"nombre": "TOSAGUA", "id_c": 63, "id_p": 4},
  {"nombre": "24 DE MAYO", "id_c": 64, "id_p": 4},
  {"nombre": "PEDERNALES", "id_c": 65, "id_p": 4},
  {"nombre": "OLMEDO", "id_c": 66, "id_p": 4},
  {"nombre": "PUERTO LÓPEZ", "id_c": 67, "id_p": 4},
  {"nombre": "JAMA", "id_c": 68, "id_p": 4},
  {"nombre": "JARAMIJÓ", "id_c": 69, "id_p": 4},
  {"nombre": "SAN VICENTE", "id_c": 70, "id_p": 4},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesMoronaSant = [
  {"nombre": "MORONA", "id_c": 165, "id_p": 15},
  {"nombre": "GUALAQUIZA", "id_c": 166, "id_p": 15},
  {"nombre": "LIMÓN INDANZA", "id_c": 167, "id_p": 15},
  {"nombre": "PALORA", "id_c": 168, "id_p": 15},
  {"nombre": "SANTIAGO", "id_c": 169, "id_p": 15},
  {"nombre": "SUCÚA", "id_c": 170, "id_p": 15},
  {"nombre": "HUAMBOYA", "id_c": 171, "id_p": 15},
  {"nombre": "SAN JUAN BOSCO", "id_c": 172, "id_p": 15},
  {"nombre": "TAISHA", "id_c": 173, "id_p": 15},
  {"nombre": "LOGROÑO", "id_c": 174, "id_p": 15},
  {"nombre": "PABLO SEXTO", "id_c": 175, "id_p": 15},
  {"nombre": "TIWINTZA", "id_c": 176, "id_p": 15},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesNapo = [
  {"nombre": "TENA", "id_c": 177, "id_p": 16},
  {"nombre": "ARCHIDONA", "id_c": 178, "id_p": 16},
  {"nombre": "EL CHACO", "id_c": 179, "id_p": 16},
  {"nombre": "QUIJOS", "id_c": 180, "id_p": 16},
  {"nombre": "CARLOS JULIO AROSEMENA TOLA", "id_c": 181, "id_p": 16}, 
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesSucumbios = [
  {"nombre": "LARGO AGRIO", "id_c": 207, "id_p": 21},
  {"nombre": "GONZALO PIZARRO", "id_c": 208, "id_p": 21},
  {"nombre": "PUTUMAYO", "id_c": 209, "id_p": 21},
  {"nombre": "SHUSHUFINDI", "id_c": 210, "id_p": 21},
  {"nombre": "SUCUMBÍOS", "id_c": 211, "id_p": 21},
  {"nombre": "CASCALES", "id_c": 212, "id_p": 21},
  {"nombre": "CUYABENO", "id_c": 213, "id_p": 21},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesPastaza = [
  {"nombre": "PASTAZA", "id_c": 182, "id_p": 17},
  {"nombre": "MERA", "id_c": 183, "id_p": 17},
  {"nombre": "SANTA CLARA", "id_c": 184, "id_p": 17},
  {"nombre": "ARAJUNO", "id_c": 185, "id_p": 17},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesPichincha = [
  {"nombre": "QUITO", "id_c": 26, "id_p": 2},
  {"nombre": "CAYAMBE", "id_c": 27, "id_p": 2},
  {"nombre": "MEJIA", "id_c": 28, "id_p": 2},
  {"nombre": "PEDRO MONCAYO", "id_c": 29, "id_p": 2},
  {"nombre": "RUMIÑAHUI", "id_c": 30, "id_p": 2},
  {"nombre": "SAN MIGUEL DE LOS BANCOS", "id_c": 31, "id_p": 2},
  {"nombre": "PEDO VICENTE MALDONADO", "id_c": 32, "id_p": 2},
  {"nombre": "PUERTO QUITO", "id_c": 33, "id_p": 2},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesSantaElena = [
  {"nombre": "SANTA ELENA", "id_c": 219, "id_p": 24},
  {"nombre": "LA LIBERTAD", "id_c": 220, "id_p": 24},
  {"nombre": "SALINAS", "id_c": 221, "id_p": 24},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesSantoDomin = [
  {"nombre": "SANTO DOMINGO", "id_c": 218, "id_p": 23}
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesFrancOrellana = [
  {"nombre": "ORELLANA", "id_c": 214, "id_p": 22},
  {"nombre": "AGUARICO", "id_c": 215, "id_p": 22},
  {"nombre": "LA JOYA DE LOS SACHAS", "id_c": 216, "id_p": 22},
  {"nombre": "LORETO", "id_c": 217, "id_p": 22}
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaCiudadesTungurahua = [
  {"nombre": "AMBATO", "id_c": 186, "id_p": 18},
  {"nombre": "BAÑOS DE AGUA SANTA", "id_c": 187, "id_p": 18},
  {"nombre": "CEVALLOS", "id_c": 188, "id_p": 18},
  {"nombre": "MOCHA", "id_c": 189, "id_p": 18},
  {"nombre": "PATATE", "id_c": 190, "id_p": 18},
  {"nombre": "QUERO", "id_c": 191, "id_p": 18},
  {"nombre": "SAN PEDRO DE PELILEO", "id_c": 192, "id_p": 18},
  {"nombre": "SANTIAGO DE PÍLLARO", "id_c": 193, "id_p": 18},
  {"nombre": "TISALEO", "id_c": 194, "id_p": 18},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));

List<Map<String, dynamic>> listaZamoraChinchipe = [
  {"nombre": "ZAMORA", "id_c": 195, "id_p": 19},
  {"nombre": "CHINCHIPE", "id_c": 196, "id_p": 19},
  {"nombre": "NANGARITZA", "id_c": 197, "id_p": 19},
  {"nombre": "YACUAMBI", "id_c": 198, "id_p": 19},
  {"nombre": "YANTZAZA (YANZATZA)", "id_c": 199, "id_p": 19},
  {"nombre": "EL PANGUI", "id_c": 200, "id_p": 19},
  {"nombre": "CENTINELA DEL CÓNDOR", "id_c": 201, "id_p": 19},
  {"nombre": "PALANDA", "id_c": 202, "id_p": 19},
  {"nombre": "PAQUISHA", "id_c": 203, "id_p": 19},
]..sort(
    (a, b) => a["nombre"].toLowerCase().compareTo(b["nombre"].toLowerCase()));
