import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:abi_praxis_app/src/models/solicitud/soliciutd_credito_model.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String> generatePdf(SolicitudCreditoModel solicitud) async {
  var titulo = "";

  // Decodificar los datos
  Map<String, dynamic> datosPersonales = jsonDecode(solicitud.datosPersonales);
  Map<String, dynamic> datosConyuge = jsonDecode(solicitud.datosConyuge);
  Map<String, dynamic> datosGarante = jsonDecode(solicitud.datosGarante);
  Map<String, dynamic> referencias = jsonDecode(solicitud.refPersonales);
  Map<String, dynamic> refEconomicas = jsonDecode(solicitud.refEconomicas);
  Map<String, dynamic> solicitudProducto = jsonDecode(solicitud.solicitudProd);

  // Crear el documento PDF
  final PdfDocument document = PdfDocument();
  PdfPage page = document.pages.add();
  double currentYPosition = 0;

  // Cargar la imagen desde los activos
  ByteData imageData = await rootBundle.load('assets/amibank.png');
  Uint8List imageBytes = imageData.buffer.asUint8List();

  // Crear una imagen PDF
  PdfBitmap image = PdfBitmap(imageBytes);

  // Obtener la primera página del documento

  // Dibujar la imagen en la página
  page.graphics.drawImage(
    image,
    const Rect.fromLTWH(125, 0, 275,
        75), // Cambia las coordenadas y dimensiones según sea necesario
  );

  currentYPosition += 60;

  // Dibujar texto debajo de la imagen
  String text = "SOLICITUD DE CRÉDITO";
  PdfFont font =
      PdfStandardFont(PdfFontFamily.helvetica, 25, style: PdfFontStyle.bold);

  page.graphics.drawString(
    text,
    font,
    bounds: Rect.fromLTWH(125, currentYPosition + 25, 350,
        100), // Dibujar en la posición Y calculada
  );

  currentYPosition += 40;

  // Crear fuentes
  final PdfFont titleFont =
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 8);

  // Definir el tamaño de las celdas y el espaciado

  final double maxPageHeight =
      page.getClientSize().height - 50; // 50 es el margen inferior

  int distancia = 25;

  // Función para agregar contenido a la página
  void addGroupedRow(List<String> titles, Map<String, dynamic> section) {
    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 2); // Definir cuántas columnas por sección
    grid.headers.add(1);

    List<List<String>> pairedData = [];
    List<String> tempRow = [];
    section.forEach((key, value) {
      tempRow.add("$key: ${value ?? "---"}");
      if (tempRow.length == 2) {
        pairedData.add(tempRow);
        tempRow = [];
      }
    });

    if (tempRow.isNotEmpty) {
      pairedData.add(tempRow); // Añadir fila con un único dato si sobra
    }

    PdfGridRow row;
    PdfGridRow header;

    for (var rowData in pairedData) {
      PdfGridRow row = grid.rows.add();
      header = grid.headers[0];
      header.cells[0].value = titles[0];
      header.style = PdfGridCellStyle(font: titleFont);
      titulo = titles[0];
      row.cells[0].value = rowData[0];
      row.cells[1].value =
          rowData.length > 1 ? rowData[1] : ""; // Celda vacía si no hay dato
    }

    // Dibujar las celdas
    // for (var s = 0; s < section.length; s++) {
    for (var entry in section.entries) {
      row = grid.rows.add();
      section.forEach((key, value) {
        row.cells[0].value = "${entry.key}: \n${entry.value ?? "---"}";
      });
    }

    grid.style = PdfGridStyle(
      font: contentFont,
      cellPadding: PdfPaddings(left: 1, right: 1, top: 1, bottom: 1),
    );

    // Dibujar la tabla en la página actual
    final result = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, currentYPosition += distancia, page.getClientSize().width, 0));

    // Si la tabla se dibuja correctamente, actualizamos la posición
    if (result != null) {
      // Sumar el valor de bounds.bottom para actualizar la posición Y
      currentYPosition += result.bounds.bottom - 75;

      // Si la posición Y supera el límite de la página, crear una nueva página

      if (currentYPosition > maxPageHeight ||
          (titulo.contains("Actividad Económica Principal") ||
              titulo.contains("Actividad Económica Secundaria") ||
              titulo.contains("Situación económica"))) {
        // Crear nueva página
        page = document.pages.add(); // Crear nueva página
        currentYPosition = 20; // Reiniciar la posición Y para la nueva página

        // **NO volvemos a dibujar la tabla aquí**, solo actualizamos la posición de Y para continuar
        // Después de la creación de la nueva página, la tabla no se vuelve a dibujar, solo se continúa con el siguiente bloque de contenido.
      } else {
        // Si no se supera el límite de la página, solo ajustamos la posición Y
        currentYPosition += 20; // Ajuste de espacio adicional entre cuadros
      }
    }
    //}
  }

  // Agregar los datos agrupados según tu especificación
  addGroupedRow(["Datos Personales"], datosPersonales['datos']);
  addGroupedRow(["Nacimiento"], datosPersonales["nacimiento"]);
  addGroupedRow(["Identificación"], datosPersonales["identificacion"]);
  addGroupedRow(["Residencia"], datosPersonales["residencia"]);
  addGroupedRow(["Educación"], datosPersonales["educacion"]);
  addGroupedRow(["Actividad Económica Principal"],
      datosPersonales["actividad_principal"]);
  addGroupedRow(["Actividad Económica Secundaria"],
      datosPersonales["actividad_secundaria"]);
  addGroupedRow(["Situación económica"], datosPersonales["economia"]);
  addGroupedRow(["Estado civil"], datosPersonales["estado_civil"]);
  // Puedes seguir agregando más secciones
  //  *DATOS DEL CONYUGE
  addGroupedRow(["Datos personales cónyuge"], datosConyuge["datos"]);
  addGroupedRow(["Nacimiento Cónyuge"], datosConyuge["nacimiento"]);
  addGroupedRow(["Identificación Cónyuge"], datosConyuge["identificacion"]);
  addGroupedRow(["Educación Cónyuge"], datosConyuge["educacion"]);
  addGroupedRow(["Actividad Económica Principal Cónyuge"],
      datosConyuge['actividad_principal']);
  addGroupedRow(["Estado civil Cónyuge"], datosConyuge["estado_civil"]);
  // *DATOS DEL GARANTE
  addGroupedRow(["Datos Personales Garante"], datosGarante['datos']);
  addGroupedRow(["Nacimiento  Garante"], datosGarante["nacimiento"]);
  addGroupedRow(["Identificación  Garante"], datosGarante["identificacion"]);
  addGroupedRow(["Residencia  Garante"], datosGarante["residencia"]);
  addGroupedRow(["Educación  Garante"], datosGarante["educacion"]);
  addGroupedRow(["Actividad Económica Principal Garante"],
      datosGarante["actividad_principal"]);
  addGroupedRow(["Actividad Económica Secundaria Garante"],
      datosGarante["actividad_secundaria"]);
  addGroupedRow(["Situación económica Garante"], datosGarante["economia"]);
  addGroupedRow(["Estado civil  Garante"], datosGarante["estado_civil"]);
  //*REFERENCIAS PERSONALES
  addGroupedRow(
      ["Referencia Personal 1"], referencias["referencias"]['referencia_1']);
  addGroupedRow(
      ["Referencia Personal 2"], referencias["referencias"]['referencia_2']);
  //* REFERENCIAS ECONOMICAS
  addGroupedRow(["Referencia Bancaria"], refEconomicas['datos_bancarios']);
  addGroupedRow(["Referencia Proveedor"], refEconomicas['proveedor']);
  //*SOLICITUD DE PRODUCTO

  addGroupedRow(["Solicitud de Producto"], solicitudProducto['solicitud']);

  // Guardar PDF
  List<int> bytes = document.saveSync();
  document.dispose();

  // Codificar a base64
  return base64Encode(bytes);
}


 /* CÓDIGO FUNCIONAL
import 'dart:convert';
import 'dart:ui';

import 'package:abi_praxis_app/src/models/solicitud/soliciutd_credito_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String> generatePdf(SolicitudCreditoModel solicitud) async {
  var titulo = "";

  // Decodificar los datos
  Map<String, dynamic> datosPersonales = jsonDecode(solicitud.datosPersonales);
  Map<String, dynamic> datosConyuge = jsonDecode(solicitud.datosConyuge);
  Map<String, dynamic> datosGarante = jsonDecode(solicitud.datosGarante);
  Map<String, dynamic> referencias = jsonDecode(solicitud.refPersonales);
  Map<String, dynamic> refEconomicas = jsonDecode(solicitud.refEconomicas);
  Map<String, dynamic> solicitudProducto = jsonDecode(solicitud.solicitudProd);

  // Crear el documento PDF
  final PdfDocument document = PdfDocument();
  PdfPage page = document.pages.add();
  double currentYPosition = 0;

  // Crear fuentes
  final PdfFont titleFont =
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 8);

  // Definir el tamaño de las celdas y el espaciado

  final double maxPageHeight =
      page.getClientSize().height - 50; // 50 es el margen inferior

  // Función para agregar contenido a la página
  void addGroupedRow(List<String> titles, List<Map<String, dynamic>> sections) {
    PdfGrid grid = PdfGrid();
    grid.columns
        .add(count: titles.length); // Definir cuántas columnas por sección
    grid.headers.add(sections.length);

    PdfGridRow row;
    PdfGridRow header;

    // Dibujar los encabezados de la tabla
    for (var i = 0; i < titles.length; i++) {
      header = grid.headers[i];
      header.cells[i].value = titles[i].toUpperCase();
      header.style = PdfGridCellStyle(font: titleFont);

      titulo = titles[i];
    }

    // Dibujar las celdas
    for (var s = 0; s < sections.length; s++) {
      for (var entry in sections[s].entries) {
        row = grid.rows.add();
        sections[s].forEach((key, value) {
          row.cells[s].value = "${entry.key}: \n${entry.value ?? "---"}";
        });
      }

      grid.style = PdfGridStyle(
        font: contentFont,
        cellPadding: PdfPaddings(left: 5, right: 5, top: 5, bottom: 5),
      );

      // Dibujar la tabla en la página actual
      final result = grid.draw(
          page: page,
          bounds: Rect.fromLTWH(
              0, currentYPosition, page.getClientSize().width, 0));

      // Si la tabla se dibuja correctamente, actualizamos la posición
      if (result != null) {
        // Sumar el valor de bounds.bottom para actualizar la posición Y
        currentYPosition += result.bounds.bottom;

        // Si la posición Y supera el límite de la página, crear una nueva página

        if (currentYPosition > maxPageHeight ||
            (titulo.contains("Actividad Económica Principal") ||
                titulo.contains("Actividad Económica Secundaria") ||
                titulo.contains("Situación económica"))) {
          // Crear nueva página
          page = document.pages.add(); // Crear nueva página
          currentYPosition = 0; // Reiniciar la posición Y para la nueva página

          //NO volvemos a dibujar la tabla aquí**, solo actualizamos la posición de Y para continuar
          // Después de la creación de la nueva página, la tabla no se vuelve a dibujar, solo se continúa con el siguiente bloque de contenido.
        } else {
          // Si no se supera el límite de la página, solo ajustamos la posición Y
          currentYPosition += 20; // Ajuste de espacio adicional entre cuadros
        }
      }
    }
  }

  // Agregar los datos agrupados según tu especificación
  addGroupedRow(["Datos Personales"], [datosPersonales['datos']]);
  addGroupedRow(["Nacimiento"], [datosPersonales["nacimiento"]]);
  addGroupedRow(["Identificación"], [datosPersonales["identificacion"]]);
  addGroupedRow(["Residencia"], [datosPersonales["residencia"]]);
  addGroupedRow(["Educación"], [datosPersonales["educacion"]]);
  addGroupedRow(["Actividad Económica Principal"],
      [datosPersonales["actividad_principal"]]);
  addGroupedRow(["Actividad Económica Secundaria"],
      [datosPersonales["actividad_secundaria"]]);
  addGroupedRow(["Situación económica"], [datosPersonales["economia"]]);
  addGroupedRow(["Estado civil"], [datosPersonales["estado_civil"]]);
  // Puedes seguir agregando más secciones
  // **DATOS DEL CONYUGE
  addGroupedRow(["Datos personales cónyuge"], [datosConyuge["datos"]]);
  addGroupedRow(["Nacimiento Cónyuge"], [datosConyuge["nacimiento"]]);
  addGroupedRow(["Identificación Cónyuge"], [datosConyuge["identificacion"]]);
  addGroupedRow(["Educación Cónyuge"], [datosConyuge["educacion"]]);
  addGroupedRow(["Actividad Económica Principal Cónyuge"],
      [datosConyuge['actividad_principal']]);
  addGroupedRow(["Estado civil Cónyuge"], [datosConyuge["estado_civil"]]);
  // **DATOS DEL GARANTE
  addGroupedRow(["Datos Personales Garante"], [datosGarante['datos']]);
  addGroupedRow(["Nacimiento  Garante"], [datosGarante["nacimiento"]]);
  addGroupedRow(["Identificación  Garante"], [datosGarante["identificacion"]]);
  addGroupedRow(["Residencia  Garante"], [datosGarante["residencia"]]);
  addGroupedRow(["Educación  Garante"], [datosGarante["educacion"]]);
  addGroupedRow(["Actividad Económica Principal Garante"],
      [datosGarante["actividad_principal"]]);
  addGroupedRow(["Actividad Económica Secundaria Garante"],
      [datosGarante["actividad_secundaria"]]);
  addGroupedRow(["Situación económica Garante"], [datosGarante["economia"]]);
  addGroupedRow(["Estado civil  Garante"], [datosGarante["estado_civil"]]);
  // **REFERENCIAS PERSONALES
  addGroupedRow(
      ["Referencia Personal 1"], [referencias["referencias"]['referencia_1']]);
  addGroupedRow(
      ["Referencia Personal 2"], [referencias["referencias"]['referencia_2']]);
  // **REFERENCIAS ECONOMICAS
  addGroupedRow(["Referencia Bancaria"], [refEconomicas['datos_bancarios']]);
  addGroupedRow(["Referencia Proveedor"], [refEconomicas['proveedor']]);
  // **SOLICITUD DE PRODUCTO

  addGroupedRow(["Solicitud de Producto"], [solicitudProducto['solicitud']]);

  // Guardar PDF
  List<int> bytes = document.saveSync();
  document.dispose();

  // Codificar a base64
  return base64Encode(bytes);
} */


