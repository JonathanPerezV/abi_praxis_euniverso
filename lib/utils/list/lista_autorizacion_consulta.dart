List<Map<String, dynamic>> get listaActividades => _actividadesSRI;
List<Map<String, dynamic>> get listaSectorE => _listaSectorE;
List<Map<String, dynamic>> get listaRelacionLab => _listaRelacionLab;
List<Map<String, dynamic>> get listaFuente => _listaFuente;
List<Map<String, dynamic>> get listaPlazo => _listaPlazo;

List<Map<String, dynamic>> _actividadesSRI = [
  {
    "nombre": "Cultivo de trigo",
    "cod": "002001001",
  },
  {
    "nombre": "Cultivo de otros cereales n.c.pc.",
    "cod": "002001009",
  },
  {
    "nombre": "Cultivo de maíz suave",
    "cod": "002001009",
  },
  {
    "nombre": "Cultivo de maíz duro",
    "cod": "002001003",
  },
  {
    "nombre": "Cultivo de cebada",
    "cod": "2001005",
  },
  {
    "nombre": "Cultivo de avena",
    "cod": "002001006",
  },
  {
    "nombre": "Cultivo de frejol",
    "cod": "004001007",
  },
  {
    "nombre": "Cultivo de arveja",
    "cod": "004001009",
  },
  {
    "nombre": "Cultivo de lenteja",
    "cod": "004001010",
  },
  {
    "nombre": "Cultivo de haba",
    "cod": "004001008",
  },
  {
    "nombre": "Cultivo de soya",
    "cod": "004002002",
  },
  {
    "nombre": "Cultivo de maní",
    "cod": "004002003",
  },
  {
    "nombre": "Cultivo de otras oleaginosas n.c.p.",
    "cod": "004002006",
  },
  {
    "nombre": "Cultivo de arroz con cáscara(no incluye pilado)",
    "cod": "002001004",
  },
  {
    "nombre": "Cultivo de Brócoli",
    "cod": "004001004",
  },
  {
    "nombre": "Cultivo de otros vegetales y melones n.c.p.",
    "cod": "004001014",
  },
  {
    "nombre": "Cultivo de lechuga",
    "cod": "004001005",
  },
  {
    "nombre": "Cultivo de tomate",
    "cod": "004001006",
  },
  {
    "nombre": "Cultivo de sandía",
    "cod": "004001012",
  },
  {
    "nombre": "Cultivo de cebolla blanca y colorada",
    "cod": "004001011",
  },
  {
    "nombre": "Cultivo de papa",
    "cod": "004001001",
  },
  {
    "nombre": "Cultivo de yuca",
    "cod": "004001002",
  },
  {
    "nombre": "Cultivo de otros tubérculos y raíces",
    "cod": "004001003",
  },
  {
    "nombre": "Cultivo de otros vegetales y melones n.c.p.",
    "cod": "",
  },
  {
    "nombre": "Cultivo de caña de azúcar",
    "cod": "004002007",
  },
  {
    "nombre": "Cultivo de tabaco en rama",
    "cod": "004002008",
  },
  {
    "nombre": "Cultivo de algodón en rama",
    "cod": "004002009",
  },
  {
    "nombre": "Cultivo de otros productos agrícolas n.c.p.",
    "cod": "004002019",
  },
  {
    "nombre": "Cultivo de abacá",
    "cod": "004002010",
  },
  {
    "nombre": "Cultivo de pasto y plantas forrajeras",
    "cod": "4002011",
  },
  {
    "nombre": "Cultivo de rosas",
    "cod": "003001001",
  },
  {
    "nombre": "Cultivo de gypsophilas",
    "cod": "003001002",
  },
  {
    "nombre": "Cultivo de claveles",
    "cod": "003001003",
  },
  {
    "nombre": "Cultivo de otras flores",
    "cod": "003001004",
  },
  {
    "nombre": "Cultivo de banano y plátano",
    "cod": "001001001",
  },
  {
    "nombre": "Cultivo de mango",
    "cod": "004001016",
  },
  {
    "nombre": "Cultivo de maracuyá",
    "cod": "004001020",
  },
  {
    "nombre": "Cultivo de piña",
    "cod": "004001018",
  },
  {
    "nombre": "Cultivo de papaya",
    "cod": "004001017",
  },
  {
    "nombre": "Cultivo de aguacate",
    "cod": "004001015",
  },
  {
    "nombre": "Cultivo de frutas cítricas",
    "cod": "004001023",
  },
  {
    "nombre": "Cultivo de manzana",
    "cod": "4001022",
  },
  {
    "nombre": "Cultivo de otras frutas n.c.p",
    "cod": "004001029",
  },
  {
    "nombre": "Cultivo de mora",
    "cod": "004001021",
  },
  {
    "nombre": "Cultivo de tomate de árbol",
    "cod": "004001019",
  },
  {
    "nombre": "Cultivo de palma africana",
    "cod": "004002001",
  },
  {
    "nombre":
        "Cultivo de café(cereza, sin tostar, no descafeinado- incluye pilado -)",
    "cod": "001001002",
  },
  {
    "nombre": "Cultivo de cacao(en grano, crudo o tostado)",
    "cod": "001001003",
  },
  {
    "nombre": "Cultivo de pimiento",
    "cod": "004001013",
  },
  {
    "nombre": "Cría de ganado vacuno",
    "cod": "005001001",
  },
  {
    "nombre": "Producción de leche cruda o fresca de cualquier tipo",
    "cod": "005001009",
  },
  {
    "nombre": "Cría de caballos y otros equinos",
    "cod": "5001003",
  },
  {
    "nombre": "Cría de ovejas y cabras",
    "cod": "005001002",
  },
  {
    "nombre": "Producción de lana",
    "cod": "005001012",
  },
  {
    "nombre": "Cría de cerdos",
    "cod": "005001004",
  },
  {
    "nombre": "Cría de pollos(incluye gallinas)",
    "cod": "005001006",
  },
  {
    "nombre": "Cría de otras aves de corral",
    "cod": "005001007",
  },
  {
    "nombre": "Producción de huevos",
    "cod": "005001010",
  },
  {
    "nombre": "Cría de conejos y cuyes",
    "cod": "005001005",
  },
  {
    "nombre": "Producción de otros productos de animales ncp",
    "cod": "005001019",
  },
  {
    "nombre": "Producción de otros productos comestibles de animales",
    "cod": "005001011",
  },
  {
    "nombre": "Cría de otros animales vivos",
    "cod": "005001008",
  },
  {
    "nombre": "Servicios relacionados con la agricultura",
    "cod": "004003001",
  },
  {
    "nombre": "Extracción de madera",
    "cod": "006001001",
  },
  {
    "nombre": "Recolección de productos forestales diferentes a la madera",
    "cod": "006001002",
  },
  {
    "nombre": "Servicios de apoyo a la silvicultura",
    "cod": "006001009",
  },
  {
    "nombre": "Pesca de atún",
    "cod": "008001001",
  },
  {
    "nombre": "Servicios relacionados con pesca",
    "cod": "008003001",
  },
  {
    "nombre": "Cría de otros productos acuáticos ncp",
    "cod": "008002003",
  },
  {
    "nombre": "Pesca comercial excepto atún",
    "cod": "008001002",
  },
  {
    "nombre": "Pesca de otros productos acuáticos ncp",
    "cod": "008001003",
  },
  {
    "nombre": "Acuicultura y pesca de camarón",
    "cod": "007001001",
  },
  {
    "nombre": "Cría de tilapia",
    "cod": "008002001",
  },
  {
    "nombre": "Extracción de petróleo y gas natural",
    "cod": "009001001",
  },
  {
    "nombre": "Explotación de otros minerales metalíferos",
    "cod": "010001003",
  },
  {
    "nombre": "Explotación de minerales de cobre y sus concentrados",
    "cod": "010001002",
  },
  {
    "nombre": "Explotación de minerales de metales preciosos",
    "cod": "010001001",
  },
  {
    "nombre": "Extracción de piedra, arena y arcilla",
    "cod": "010002001",
  },
  {
    "nombre": "Explotación de otras minas y canteras ncp",
    "cod": "010002002",
  },
  {
    "nombre": "Actividades de apoyo a al extracción de petróleo y gas natural",
    "cod": "009002001",
  },
  {
    "nombre": "Servicios relacionados con la minería(excepto petróleo)",
    "cod": "010003001",
  },
  {
    "nombre":
        "Producción, procesamiento y conservación de carne y productos cárnicos",
    "cod": "011001001",
  },
  {
    "nombre": "Elaboración y conservación de camarón",
    "cod": "012001001",
  },
  {
    "nombre":
        "Elaboración de pescado y otros productos acuáticos elaborados excepto harina de pescado",
    "cod": "013001001",
  },
  {
    "nombre": "Elaboración de conservas de atún",
    "cod": "013002001",
  },
  {
    "nombre": "Elaboración de conservas de otras especies acuáticas",
    "cod": "013002002",
  },
  {
    "nombre": "Producción de harina de pescado comestible",
    "cod": "013001002",
  },
  {
    "nombre": "Elaboración de aceites y grasas de origen vegetal y animal",
    "cod": "014001001",
  },
  {
    "nombre": "Elaboración de leche fresca líquida",
    "cod": "015001001",
  },
  {
    "nombre": "Elaboración de otros productos lácteos",
    "cod": "015001002",
  },
  {
    "nombre":
        "Producción de harinas vegetales, sémolas, almidones y otros productos: glucosa(dextrosa) y jarabe de glucosa, fructosa y otros jarabes del azúcar",
    "cod": "016001002",
  },
  {
    "nombre": "Producción de arroz(pilado, blanqueado y pulido)",
    "cod": "016001001",
  },
  {
    "nombre": "Elaboración de almidones y productos elaborados de almidón",
    "cod": "016001003",
  },
  {
    "nombre": "Elaboración de productos de la panadería y pastelería",
    "cod": "016002001",
  },
  {
    "nombre": "Elaboración y refinación de azúcar",
    "cod": "017001001",
  },
  {
    "nombre": "Elaboración de cacao, chocolate y productos de confitería",
    "cod": "018001001",
  },
  {
    "nombre": "Elaboración de fideos, pastas de fideo y otros productos",
    "cod": "016003001",
  },
  {
    "nombre": "Elaboración de café",
    "cod": "019002001",
  },
  {
    "nombre": "Elaboración de otros productos alimenticios diversos",
    "cod": "019003001",
  },
  {
    "nombre": "Elaboración de alimento para animales",
    "cod": "019001001",
  },
  {
    "nombre": "Elaboración de otras bebidas alcohólicas",
    "cod": "020001009",
  },
  {
    "nombre": "Elaboración de cerveza y bebidas de malta",
    "cod": "020001001",
  },
  {
    "nombre": "Elaboración de bebidas no alcohólicas",
    "cod": "020002001",
  },
  {
    "nombre": "Elaboración de productos de tabaco",
    "cod": "020003001",
  },
  {
    "nombre": "Fabricación de hilos, hilados; tejidos y confecciones",
    "cod": "021001001",
  },
  {
    "nombre":
        "Fabricación de prendas de vestir y tejidos de ganchillo(incluso de cuero y piel)",
    "cod": "021002001",
  },
  {
    "nombre": "Curtido y adobo de cueros; adobo y teñido de pieles",
    "cod": "021003001",
  },
  {
    "nombre":
        "Fabricación de maletas, bolsos de mano y artículos de talabartería y guarnicionería",
    "cod": "021003002",
  },
  {
    "nombre": "Fabriación de calzado de cualquier material",
    "cod": "021003003",
  },
  {
    "nombre": "Aserradores y cepilladura de madera",
    "cod": "022001001",
  },
  {
    "nombre":
        "Fabricación de hojas de madera para enchapado y paneles a base de madera",
    "cod": "022001002",
  },
  {
    "nombre":
        "Fabricación de partes y piezas de carpintería para edificios y construcciones",
    "cod": "022001003",
  },
  {
    "nombre":
        "Elaboración de recipientes de madera y de otros productos de madera; fabricación de artículos de corcho, paja y materiales transables",
    "cod": "022001009",
  },
  {
    "nombre": "Fabricación de papel y productos de papel",
    "cod": "023001002",
  },
  {
    "nombre":
        "Fabricación de productos refinados de petróleo y de otros productos",
    "cod": "024001001",
  },
  {
    "nombre":
        "Fabricación de sustancias químicas básicas, excepto abonos y plaguicidas; plásticos y cauchos primarios",
    "cod": "025001002",
  },
  {
    "nombre":
        "Fabricación de pinturas, barnices y productos de revestimiento similares, tintas de imprenta y masillas",
    "cod": "025002001",
  },
  {
    "nombre":
        "Fabricación de jabones y detergentes, preparados para limpiar y pulir, perfumes y preparados de tocador",
    "cod": "025002002",
  },
  {
    "nombre": "Fabricación de otros productos químicos ncp",
    "cod": "025002009",
  },
  {
    "nombre":
        "Fabricación de productos farmacéuticos, sustancias químicas medicinales y de productos botánicos",
    "cod": "025002003",
  },
  {
    "nombre": "Fabricación de productos de caucho",
    "cod": "026001001",
  },
  {
    "nombre": "Fabricación de productos de plático",
    "cod": "026002001",
  },
  {
    "nombre": "Fabricación de vidrio y productos de vidrio",
    "cod": "027001001",
  },
  {
    "nombre":
        "Fabricación de productos de cerámica y porcelana; productos refractarios",
    "cod": "027001002",
  },
  {
    "nombre":
        "Fabricación de cemento, cal y yeso; y fabricación de artículos de hormigón, cemento y yeso",
    "cod": "027002001",
  },
  {
    "nombre": "Fabricación de otros productos minerales no metálicos ncp",
    "cod": "027002009",
  },
  {
    "nombre": "Industrias básicas de hierro y acero básicos",
    "cod": "028001001",
  },
  {
    "nombre": "Fabricación de productos de metales preciosos(excepto joyas)",
    "cod": "028001002",
  },
  {
    "nombre": "Fabricación de productos de otros metales(excepto preciosos)",
    "cod": "028001009",
  },
  {
    "nombre": "Fabricación de otros productos de metal ncp",
    "cod": "028002002",
  },
  {
    "nombre": "Fabricación de productos metálicos para uso estructural",
    "cod": "028002001",
  },
  {
    "nombre": "Fabricación de otros productos de metal ncp",
    "cod": "028002009",
  },
  {
    "nombre":
        "Fabricación de los productos informáticos, electrónicos y ópticos",
    "cod": "029001001",
  },
  {
    "nombre": "Fabricación de equipo eléctrico(excepto de uso doméstico)",
    "cod": "029001003",
  },
  {
    "nombre": "Fabricación de aparatos de uso doméstico",
    "cod": "029001002",
  },
  {
    "nombre": "Fabricación de maquinaria y equipo ncp",
    "cod": "029001005",
  },
  {
    "nombre": "Fabricación de equipo de oficina(excepto computadoras)",
    "cod": "029001004",
  },
  {
    "nombre": "Fabricación de vehícolos automores",
    "cod": "030001001",
  },
  {
    "nombre": "Fabricación de otros tipos de equipo de transporte",
    "cod": "030001002",
  },
  {
    "nombre": "Fabricación de muebles de cualquier material",
    "cod": "031001001",
  },
  {
    "nombre": "Fabricación de joyas y artículos conexos",
    "cod": "032001001",
  },
  {
    "nombre": "Fabricación de instrumentos musicales",
    "cod": "032001002",
  },
  {
    "nombre": "Fabricación de artículos de deporte",
    "cod": "032001003",
  },
  {
    "nombre": "Fabricación de juegos y juguetes",
    "cod": "032001004",
  },
  {
    "nombre": "Fabricación de instrumentos y suministros médicos y dentales",
    "cod": "032001005",
  },
  {
    "nombre": "Servicios de reparación e instalación de maquinaria y equipo",
    "cod": "032001010",
  },
  {
    "nombre": "Generación, captación y distribución de energía eléctrica",
    "cod": "033001001",
  },
  {
    "nombre": "Captación, depuración y distribución de agua y saneamiento",
    "cod": "033002001",
  },
  {
    "nombre": "Construcción de edificios",
    "cod": "034001001",
  },
  {
    "nombre": "Ingeniería civil",
    "cod": "034001002",
  },
  {
    "nombre": "Actividades especializadas de la construcción",
    "cod": "034001003",
  },
  {
    "nombre": "Comercio vehículos automotores y motocicletas",
    "cod": "035001001",
  },
  {
    "nombre":
        "Servicios de reparación y mantenimiento de vehículos de motor y motocicletas",
    "cod": "035004001",
  },
  {
    "nombre":
        "Comercio de partes, piezas y accesorios de vehículos automotres y motocicletas",
    "cod": "035001002",
  },
  {
    "nombre": "Comercio al por mayor de cereales",
    "cod": "035003004",
  },
  {
    "nombre": "Comercio al por mayor de flores",
    "cod": "035003005",
  },
  {
    "nombre": "Comercio al por mayor de animales vivos y sus productos",
    "cod": "035003007",
  },
  {
    "nombre": "Comercio al por mayor de banano y plátano",
    "cod": "035003001",
  },
  {
    "nombre": "Comercio al por mayor de otros productos agrícolas",
    "cod": "035003006",
  },
  {
    "nombre": "Comercio al por mayor de café(cereza y café pilado)",
    "cod": "035003002",
  },
  {
    "nombre": "Comercio al por mayor de café tostado molido y soluble",
    "cod": "035003019",
  },
  {
    "nombre": "Comercio al por mayor de leche procesada y productos lácteos",
    "cod": "035003014",
  },
  {
    "nombre": "Comercio al por mayor de productos cárnicos",
    "cod": "035003010",
  },
  {
    "nombre":
        "Comercio al por mayor de camarón, pescado y productos de la acuicultura(fresco o refrigerado)",
    "cod": "035003008",
  },
  {
    "nombre":
        "Comercio al por mayor de camarón congelado, otros procesos y exp",
    "cod": "035003011",
  },
  {
    "nombre":
        "Comercio al por mayor de pescado congelado, seco y salado y otros productos de pesca y acuicultura y conservas de productos acuáticos",
    "cod": "035003012",
  },
  {
    "nombre": "Comercio al por mayor de harina de pescado",
    "cod": "035003013",
  },
  {
    "nombre": "Comercio al por mayor de azúcar y sus productos",
    "cod": "035003017",
  },
  {
    "nombre":
        "Comercio al pro mayor de productos de molinería, panadería, fideos y pastas",
    "cod": "035003016",
  },
  {
    "nombre": "Comercio al por mayor de bebidas no alcohólicas",
    "cod": "035003023",
  },
  {
    "nombre": "Comercio al por mayor de cigarrillos y productos del tabaco",
    "cod": "035003024",
  },
  {
    "nombre": "Comercio al por mayor de alimentos para animales",
    "cod": "035003020",
  },
  {
    "nombre":
        "Comercio al por mayor de otros productos alimenticios diversos(incluye jugos de frutas y vegetales y sus conservas)",
    "cod": "035003021",
  },
  {
    "nombre":
        "Comercio al por mayor de hilos, hilados, tejidos, telas y confecciones con materiales textiles(excepto prendas de vestir)",
    "cod": "035003026",
  },
  {
    "nombre": "Comercio al por mayor de prendas de vestir",
    "cod": "035003025",
  },
  {
    "nombre": "Comercio al por mayor de calzado",
    "cod": "035003028",
  },
  {
    "nombre":
        "Comercio al por mayor de cuero y productos de cuero(excepto prendas de vestir)",
    "cod": "035003027",
  },
  {
    "nombre": "Comercio al por mayor de electrodomésticos",
    "cod": "035003038",
  },
  {
    "nombre":
        "Comercio al por mayor de productos químicos(excepto farmacéuticos)",
    "cod": "035003033",
  },
  {
    "nombre": "Comercio al por mayor de productos farmacéuticos",
    "cod": "035003032",
  },
  {
    "nombre":
        "Comercio al por mayor de papel y cartón y productos de papel y cartón",
    "cod": "035003030",
  },
  {
    "nombre":
        "Comercio al por mayor de productos editoriales, imprentas y otros",
    "cod": "035003031",
  },
  {
    "nombre": "Comercio al por mayor de productos cerámicos(incluye ceramicos)",
    "cod": "035003036",
  },
  {
    "nombre": "Comercio al por mayor de equipos de computación",
    "cod": "035003039",
  },
  {
    "nombre": "Comercio al por mayor de otra maquinaria y equipo",
    "cod": "035003040",
  },
  {
    "nombre":
        "Comercio al por mayor de productos metálicos(incluye oro refinado y otros metales preciosos), excluye joyerías",
    "cod": "035003037",
  },
  {
    "nombre":
        "Comercio al por mayor de productos de la madera aserrada, descortezada, tableros, paneles, hojas de madera, cajas, cajones y obras de madera para edificios",
    "cod": "035003029",
  },
  {
    "nombre": "Comercio al por mayor de madera sin elaborar",
    "cod": "035003009",
  },
  {
    "nombre": "Comercio al por mayor de productos de caucho(incluye llantas)",
    "cod": "035003034",
  },
  {
    "nombre": "Comercio al por mayor de productos plásticos",
    "cod": "035003035",
  },
  {
    "nombre":
        "Comercio al por menor de alimentos(incluye productos agrícolas e industrializados)",
    "cod": "035002001",
  },
  {
    "nombre":
        "Comercio al por menor de combustibles y lubricantes(gasolineras y distribución de gas)",
    "cod": "035002005",
  },
  {
    "nombre": "Comercio al por menor de equipos de computación",
    "cod": "035002011",
  },
  {
    "nombre": "Comercio al por menor de electrodomésticos",
    "cod": "035002010",
  },
  {
    "nombre": "Comercio al por menor de ferretería",
    "cod": "035002009",
  },
  {
    "nombre":
        "Comercio al por menor de muebles en general(excluye muebles para uso médico)",
    "cod": "035002013",
  },
  {
    "nombre":
        "Comercio al por menos de libros, periódicos, revistas y artículos de papelería",
    "cod": "035002006",
  },
  {
    "nombre": "Comercio al por menor de prendas de vestir(boutique)",
    "cod": "035002003",
  },
  {
    "nombre": "Comercio al por menor de calzado",
    "cod": "035002004",
  },
  {
    "nombre": "Comercio al por menos de productos farmacéuticos(farmacias)",
    "cod": "035002007",
  },
  {
    "nombre": "Comercio al por menor de equipos médicos",
    "cod": "035002012",
  },
  {
    "nombre":
        "Elaboración de ramilletes, coronas, arreglos florales y artículos similares",
    "cod": "003001005",
  },
  {
    "nombre":
        "Comercio al por menor de fertilizantes, plaguicidas y fungicidas",
    "cod": "035002008",
  },
  {
    "nombre": "Comercio al por menor de bebidas y tabaco",
    "cod": "035002002",
  },
  {
    "nombre": "Comercio al por menor de otros productos",
    "cod": "035002014",
  },
  {
    "nombre": "Comercio al por menor de otros productos n.c.p",
    "cod": "035002019",
  },
  {
    "nombre": "Transporte de pasajeros por vía terrestre",
    "cod": "037001001",
  },
  {
    "nombre": "Transporte de carga por vía terrestre",
    "cod": "037001002",
  },
  {
    "nombre": "Transporte de pasajeros por vía acuática",
    "cod": "037001003",
  },
  {
    "nombre": "Transporte de carga por vía acuática",
    "cod": "037001004",
  },
  {
    "nombre": "Transporte de pasajeros por vía aérea",
    "cod": "037001005",
  },
  {
    "nombre": "Transporte de carga por vía aérea",
    "cod": "037001006",
  },
  {
    "nombre": "Depósito y almacenaje",
    "cod": "037001007",
  },
  {
    "nombre": "Actividades complementarias de transporte",
    "cod": "037001008",
  },
  {
    "nombre": "Actividades postales y de correo",
    "cod": "038001001",
  },
  {
    "nombre": "Servicio de alojamiento",
    "cod": "036001001",
  },
  {
    "nombre":
        "Servicios de alimentos, bebidas y otros servicios de comidas móviles",
    "cod": "036002001",
  },
  {
    "nombre":
        "Abastecimiento de eventos y otras actividades de servicio de comidas",
    "cod": "036002002",
  },
  {
    "nombre": "Actividades vinculadas al abastecimiento de bebidas",
    "cod": "036002003"
  },
  {
    "nombre":
        "Actividades de producción de películas, de video, de programas de televisión, grabación y publicación de música y sonido",
    "cod": "038002003",
  },
  {
    "nombre":
        "Actividades de programación y distribución de radio y transmisión de televisión",
    "cod": "038002004",
  },
  {
    "nombre": "Telecomunicaciones",
    "cod": "038002001",
  },
  {
    "nombre": "Servicios de informática y servicios conexos",
    "cod": "038002002",
  },
  {
    "nombre":
        "Actividades de bancos, Actividades de sociedades financieras y Actividades de instituciones financieras públicas respectivamente",
    "cod": "39001001",
  },
  {
    "nombre": "Actividades de Cooperativas",
    "cod": "039001003",
  },
  {
    "nombre": "Actividades de Mutualistas",
    "cod": "039001004",
  },
  {
    "nombre": "Actividades de Almaceneras",
    "cod": "039001007",
  },
  {
    "nombre": "Actividades de Tarjetas de Crédito",
    "cod": "039001008",
  },
  {
    "nombre": "Actividades de Casas de Cambio",
    "cod": "039001006",
  },
  {
    "nombre": "Otras actividades financieras",
    "cod": "039001010",
  },
  {
    "nombre": "Seguros(de vida y generales) y reaseguros",
    "cod": "040001004",
  },
  {
    "nombre":
        "Actividades auxiliares de seguros(incluye las actividades de peritos de seguros y asesores productores de seguros)",
    "cod": "040001005",
  },
  {
    "nombre": "Actividades inmobiliarias",
    "cod": "041001001",
  },
  {
    "nombre": "Activiades jurídicas y de contabilidad",
    "cod": "042001002",
  },
  {
    "nombre": "Actividades de administración de empresas y consultoría",
    "cod": "042001003",
  },
  {
    "nombre": "Actividades de arquitectura e ingeniería",
    "cod": "042001004",
  },
  {
    "nombre": "Investigación y desarrollo científico",
    "cod": "042001001",
  },
  {
    "nombre":
        "Servicios de concersión de licencias para el derecho de uso de ac",
    "cod": "042001016",
  },
  {
    "nombre": "Publicidad e investigación de mercados",
    "cod": "042001005",
  },
  {
    "nombre": "Otras actividades profesionales, científicas y técnicas",
    "cod": "042001009",
  },
  {
    "nombre": "Actividades veterinarias",
    "cod": "042001010",
  },
  {
    "nombre": "Actividades de alquiler y arrendamiento(excepto inmobiliarias)",
    "cod": "042001014",
  },
  {
    "nombre": "Actividades de agencias de empleo",
    "cod": "042001011",
  },
  {
    "nombre":
        "Actividades de agencias de viajes, operadores turísticos y servicios de reserva",
    "cod": "042001015",
  },
  {
    "nombre": "Actividades de seguridad e investigación",
    "cod": "042001012",
  },
  {
    "nombre": "Actividades de servicios a edificios y paisajes",
    "cod": "042001013",
  },
  {
    "nombre": "Otros servicios empresariales",
    "cod": "042001019",
  },
  {
    "nombre": "Adm pública, defensa; planes seg social obligatoria",
    "cod": "043001001",
  },
  {
    "nombre": "Enseñanza pre primaria y primaria",
    "cod": "044001001",
  },
  {
    "nombre": "Enseñanza secundaria",
    "cod": "044001002",
  },
  {
    "nombre": "Enseñanza superior",
    "cod": "044001003",
  },
  {
    "nombre": "Enseñanza de postgrado",
    "cod": "044001004",
  },
  {
    "nombre": "Otros tipos de enseñanza",
    "cod": "044001009",
  },
  {
    "nombre": "Actividades de hospitales",
    "cod": "045001001",
  },
  {
    "nombre": "Actividades de médicos y odontólogos",
    "cod": "045001002",
  },
  {
    "nombre": "Otras actividades relacionadas con la salud humana",
    "cod": "045001003",
  },
  {
    "nombre":
        "Instituciones residenciales de cuidado; y servicios sociales sin alojamiento",
    "cod": "045001004",
  },
  {
    "nombre": "Artes, entretenimiento y recreación",
    "cod": "046001001",
  },
  {
    "nombre": "Actividades de asociaciones u organizaciones",
    "cod": "046001002",
  },
  {
    "nombre":
        "Reparación de computadoras y enseres de uso personal o doméstico",
    "cod": "046001003",
  },
  {
    "nombre": "Otras actividades de servicios",
    "cod": "046001009",
  },
  {
    "nombre": "Hogares privados con servicio doméstico",
    "cod": "047001001",
  },
  {
    "nombre": "Jubilado",
    "cod": "S01001001",
  },
  {
    "nombre": "Estudiante",
    "cod": "S02001001",
  },
  {
    "nombre": "Ama de casa",
    "cod": "S03001001",
  },
  {
    "nombre": "Empleado Público",
    "cod": "S04001001",
  },
  {
    "nombre": "Empleado Privado",
    "cod": "S05001001",
  },
];

List<Map<String, dynamic>> _listaSectorE = [
  {"nombre": "Comercio", "id": 1},
  {"nombre": "Servicios", "id": 2},
  {"nombre": "Producción", "id": 3},
  {"nombre": "Agropecuario", "id": 4}
];

List<Map<String, dynamic>> _listaRelacionLab = [
  {"nombre": "Independiente", "id": 1},
  {"nombre": "Dependiente", "id": 2},
  {"nombre": "Otros", "id": 3}
];

List<Map<String, dynamic>> _listaFuente = [
  {"nombre": "Promoción del asesor de crédito", "id": 1},
  {"nombre": "Medios de publicidad", "id": 2},
  {"nombre": "Referido por cliente", "id": 3},
  {"nombre": "Charla informativa", "id": 4},
  {"nombre": "Perifonea", "id": 5},
  {"nombre": "Taller productivo", "id": 6}
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
