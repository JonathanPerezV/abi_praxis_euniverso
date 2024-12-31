import 'dart:convert';

import 'package:abi_praxis_app/src/models/solicitud/soliciutd_credito_model.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String> generatePdf(SolicitudCreditoModel solicitud) async {
  // Crear el documento PDF
  final PdfDocument document = PdfDocument();

  // Crear página
  final PdfPage page = document.pages.add();

  // Cargar la imagen desde los activos
  ByteData imageData = await rootBundle.load('assets/eu.png');
  Uint8List imageBytes = imageData.buffer.asUint8List();

  // Crear una imagen PDF
  PdfBitmap image = PdfBitmap(imageBytes);
  page.graphics.drawImage(
    image,
    const Rect.fromLTWH(0, 30, 180, 25),
  );

  var map = jsonDecode(solicitud.datosPersonales);
  var titularMap = map["datos"];

  drawDatosTitularWithBorders(page, titularMap, 0, 60);

  var mapB = jsonDecode(solicitud.datosBeneficiario);
  var beneficiarioMap = mapB["beneficiario"];

  drawDatosBeneficiarioWithBorders(page, beneficiarioMap, 0, 195);

  var mapS = jsonDecode(solicitud.datosSuscripcion);
  var sucricpcionMap = mapS["plan_suscripciones"];

  drawDatosPlan(page, sucricpcionMap, 0, 430);

  /*
  // Dibujar la sección "Plan de Suscripción"
  page.graphics.drawString("Plan de Suscripción", font,
      bounds: Rect.fromLTWH(startX, startY, 500, 20));
  startY += 30;

  const planMap = {
    "plan": null,
    "pago": null,
    "informacion_adicional": null,
  };

  column = 0;
  for (var entry in planMap.entries) {
    drawBox(page.graphics, entry.key, entry.value, startX + column * boxWidth,
        startY, boxWidth, boxHeight);
    column++;
  }
 */
  // Guardar y mostrar el PDF
  List<int> bytes = document.saveSync();
  document.dispose();

  // Guardar como archivo temporal y visualizar
  return base64Encode(bytes);
}

void drawDatosTitularWithBorders(PdfPage page, Map<String, dynamic> titularMap,
    double startX, double startY) {
  final PdfGraphics graphics = page.graphics;

  // Dimensiones de la tabla
  double cellWidth = 170; // Ancho de cada celda
  double titleHeight = 20; // Altura para los títulos
  double valueHeight = 30; // Altura para los valores
  double tableWidth = 3 * cellWidth; // Ancho total de la tabla

  // Dibujar cabecera de la tabla
  final PdfBrush headerBrush = PdfBrushes.lightGray;
  final PdfPen borderPen = PdfPens.gray;

  graphics.drawRectangle(
    bounds: Rect.fromLTWH(startX, startY, tableWidth, titleHeight),
    brush: headerBrush,
    pen: borderPen,
  );
  graphics.drawString(
    "Datos del titular",
    PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(startX, startY, tableWidth, titleHeight),
    format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle),
  );

  // Ajustar posición para las filas
  startY += titleHeight;

  // Dibujar contenido de la tabla
  int column = 0;
  int row = 0;

  const titularNames = {
    "nombres": "Nombres",
    "apellidos": "Apellidos",
    "celular1": "Celular 1",
    "celular2": "Celular 2",
    "telefono": "Teléfono",
    "correo": "Correo",
  };

  for (var entry in titularMap.entries) {
    String displayName = titularNames[entry.key] ?? entry.key;
    double currentX = startX + (column * cellWidth);
    double currentY = startY + (row * (titleHeight + valueHeight));

    // Dibujar título (clave)
    graphics.drawRectangle(
      bounds: Rect.fromLTWH(currentX, currentY, cellWidth, titleHeight),
      brush: PdfBrushes.lightBlue,
      pen: borderPen,
    );
    graphics.drawString(
      displayName,
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      bounds:
          Rect.fromLTWH(currentX + 5, currentY, cellWidth - 10, titleHeight),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle),
    );

    // Dibujar valor
    graphics.drawRectangle(
      bounds: Rect.fromLTWH(
          currentX, currentY + titleHeight, cellWidth, valueHeight),
      brush: PdfBrushes.lightGray,
      pen: borderPen,
    );
    graphics.drawString(
      entry.value ?? 'Indefinido',
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(
          currentX + 5, currentY + titleHeight, cellWidth - 10, valueHeight),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle),
    );

    // Mover a la siguiente celda
    column++;
    if (column == 3) {
      column = 0;
      row++;
    }
  }
}

void drawDatosBeneficiarioWithBorders(PdfPage page,
    Map<String, dynamic> beneficiarioMap, double startX, double startY) {
  final PdfGraphics graphics = page.graphics;

  // Dimensiones de la tabla
  double cellWidth = 170; // Ancho de cada celda
  double titleHeight = 20; // Altura para los títulos
  double valueHeight = 30; // Altura para los valores
  double tableWidth = 3 * cellWidth; // Ancho total de la tabla

  // Dibujar cabecera de la tabla
  final PdfBrush headerBrush = PdfBrushes.lightGray;
  final PdfPen borderPen = PdfPens.gray;

  graphics.drawRectangle(
    bounds: Rect.fromLTWH(startX, startY, tableWidth, titleHeight),
    brush: headerBrush,
    pen: borderPen,
  );
  // Título general
  graphics.drawString(
    "Datos del beneficiario",
    PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(startX, startY, tableWidth, titleHeight),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.center,
      lineAlignment: PdfVerticalAlignment.middle,
    ),
  );

  // Ajustar posición para las filas
  startY += titleHeight;

  // Fila 1: Títulos de los primeros 3 datos
  final List<String> firstRowTitles = ["Nombres", "Apellidos", "Celular 1"];
  for (int i = 0; i < 3; i++) {
    double currentX = startX + (i * cellWidth);
    graphics.drawRectangle(
      bounds: Rect.fromLTWH(currentX, startY, cellWidth, titleHeight),
      brush: PdfBrushes.lightBlue,
      pen: borderPen,
    );
    graphics.drawString(
      firstRowTitles[i],
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(currentX + 5, startY, cellWidth - 10, titleHeight),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
  }

  // Fila 2: Datos de los primeros 3
  startY += titleHeight;
  final List<String> firstRowValues = [
    beneficiarioMap["nombres"] ?? 'Indefinido',
    beneficiarioMap["apellidos"] ?? 'Indefinido',
    beneficiarioMap["celular1"] ?? 'Indefinido'
  ];
  for (int i = 0; i < 3; i++) {
    double currentX = startX + (i * cellWidth);
    graphics.drawRectangle(
      bounds: Rect.fromLTWH(currentX, startY, cellWidth, valueHeight),
      brush: PdfBrushes.lightGray,
      pen: borderPen,
    );
    graphics.drawString(
      firstRowValues[i],
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(currentX + 5, startY, cellWidth - 10, valueHeight),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
  }

  // Fila 3: Títulos de los siguientes 3 datos
  startY += valueHeight;
  final List<String> secondRowTitles = [
    "Celular 2",
    "Tipo Identificación",
    "Número Identificación"
  ];
  for (int i = 0; i < 3; i++) {
    double currentX = startX + (i * cellWidth);
    graphics.drawRectangle(
      bounds: Rect.fromLTWH(currentX, startY, cellWidth, titleHeight),
      brush: PdfBrushes.lightBlue,
      pen: borderPen,
    );
    graphics.drawString(
      secondRowTitles[i],
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(currentX + 5, startY, cellWidth - 10, titleHeight),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
  }

  // Fila 4: Datos de los siguientes 3
  startY += titleHeight;
  final List<String> secondRowValues = [
    beneficiarioMap["celular2"] ?? 'Indefinido',
    beneficiarioMap["tipo_identificacion"] ?? 'Indefinido',
    beneficiarioMap["numero_identificacion"] ?? 'Indefinido'
  ];
  for (int i = 0; i < 3; i++) {
    double currentX = startX + (i * cellWidth);
    graphics.drawRectangle(
      bounds: Rect.fromLTWH(currentX, startY, cellWidth, valueHeight),
      brush: PdfBrushes.lightGray,
      pen: borderPen,
    );
    graphics.drawString(
      secondRowValues[i],
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(currentX + 5, startY, cellWidth - 10, valueHeight),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
  }

  // Fila 5: Título "Dirección de entrega"
  startY += valueHeight;
  graphics.drawRectangle(
    bounds: Rect.fromLTWH(startX, startY, tableWidth, titleHeight),
    brush: PdfBrushes.lightBlue,
    pen: borderPen,
  );
  graphics.drawString(
    "Dirección de entrega",
    PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(startX + 5, startY, tableWidth - 10, titleHeight),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.left,
      lineAlignment: PdfVerticalAlignment.middle,
    ),
  );

  // Fila 6: Dirección de entrega
  startY += titleHeight;
  graphics.drawRectangle(
    bounds: Rect.fromLTWH(startX, startY, tableWidth, valueHeight),
    brush: PdfBrushes.lightGray,
    pen: borderPen,
  );
  graphics.drawString(
    beneficiarioMap["direccion_entrega"] ?? 'Indefinido',
    PdfStandardFont(PdfFontFamily.helvetica, 10),
    bounds: Rect.fromLTWH(startX + 5, startY, tableWidth - 10, valueHeight),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.left,
      lineAlignment: PdfVerticalAlignment.middle,
    ),
  );

  // Fila 7: Títulos de latitud y longitud
  startY += valueHeight;
  final List<String> lastRowTitles = ["Latitud", "Longitud"];
  for (int i = 0; i < 2; i++) {
    double currentX = startX + (i * (tableWidth / 2));
    graphics.drawRectangle(
      bounds: Rect.fromLTWH(currentX, startY, tableWidth / 2, titleHeight),
      brush: PdfBrushes.lightBlue,
      pen: borderPen,
    );
    graphics.drawString(
      lastRowTitles[i],
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(
          currentX + 5, startY, (tableWidth / 2) - 10, titleHeight),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
  }

  // Fila 8: Datos de latitud y longitud
  startY += titleHeight;
  final List<String> lastRowValues = [
    beneficiarioMap["latitud"] ?? 'Indefinido',
    beneficiarioMap["longitud"] ?? 'Indefinido'
  ];
  for (int i = 0; i < 2; i++) {
    double currentX = startX + (i * (tableWidth / 2));
    graphics.drawRectangle(
      bounds: Rect.fromLTWH(currentX, startY, tableWidth / 2, valueHeight),
      brush: PdfBrushes.lightGray,
      pen: borderPen,
    );
    graphics.drawString(
      lastRowValues[i],
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(
          currentX + 5, startY, (tableWidth / 2) - 10, valueHeight),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
  }
}

void drawDatosPlan(
    PdfPage page, Map<String, dynamic> planMap, double startX, double startY) {
  final PdfGraphics graphics = page.graphics;

  // Dibujar la tabla con dos filas (cada una dividida en 2 columnas)
  double cellWidth = 255; // Ancho de cada celda
  double titleHeight = 20; // Altura de las celdas de título
  double valueHeight = 30; // Altura de las celdas de valor
  double tableWidth = 2 * cellWidth; // Ancho total de la tabla (2 columnas)

  // Dibujar cabecera de la tabla
  final PdfBrush headerBrush = PdfBrushes.lightGray;
  final PdfPen borderPen = PdfPens.gray;

  graphics.drawRectangle(
    bounds: Rect.fromLTWH(startX, startY, tableWidth, titleHeight),
    brush: headerBrush,
    pen: borderPen,
  );
  // Título general de la sección
  graphics.drawString(
    "Datos del Plan",
    PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(startX, startY, 3 * 170, 20),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.center,
      lineAlignment: PdfVerticalAlignment.middle,
    ),
  );

  // Ajustar la posición después del título
  startY += 20;

  // Primer fila: Títulos y valores de los primeros dos elementos
  List<MapEntry<String, dynamic>> entries = planMap.entries.toList();
  int column = 0;
  for (int i = 0; i < 2; i++) {
    String displayName = entries[i].key; // Obtener el título
    String displayValue = entries[i].value ?? 'Indefinido'; // Obtener el valor

    if (displayName != "id_pago" && displayName != "id_plan") {
      // Dibujar título
      graphics.drawRectangle(
        bounds: Rect.fromLTWH(
            startX + (column * cellWidth), startY, cellWidth * 2, titleHeight),
        brush: PdfBrushes.lightBlue,
        pen: PdfPens.gray,
      );
      graphics.drawString(
        displayName,
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(startX + (column * cellWidth) + 5, startY,
            cellWidth - 10, titleHeight),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );

      // Dibujar valor
      graphics.drawRectangle(
        bounds: Rect.fromLTWH(startX + (column * cellWidth),
            startY + titleHeight, cellWidth * 2, valueHeight),
        brush: PdfBrushes.lightGray,
        pen: PdfPens.gray,
      );
      graphics.drawString(
        displayValue,
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: Rect.fromLTWH(startX + (column * cellWidth) + 5,
            startY + titleHeight, cellWidth - 10, valueHeight),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );

      column++;
    }
  }

  // Ajustar la posición para la siguiente fila
  startY += titleHeight + valueHeight;

  // Segunda fila: Títulos y valores de los siguientes dos elementos
  column = 0;
  for (int i = 2; i < 4; i++) {
    String displayName = entries[i].key; // Obtener el título

    if (displayName != "id_plan" && displayName != "id_pago") {
      String displayValue =
          entries[i].value ?? 'Indefinido'; // Obtener el valor

      // Dibujar título
      graphics.drawRectangle(
        bounds: Rect.fromLTWH(
            startX + (column * cellWidth), startY, cellWidth * 2, titleHeight),
        brush: PdfBrushes.lightBlue,
        pen: PdfPens.gray,
      );
      graphics.drawString(
        displayName,
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(startX + (column * cellWidth) + 5, startY,
            cellWidth - 10, titleHeight),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );

      // Dibujar valor
      graphics.drawRectangle(
        bounds: Rect.fromLTWH(startX + (column * cellWidth),
            startY + titleHeight, cellWidth * 2, valueHeight),
        brush: PdfBrushes.lightGray,
        pen: PdfPens.gray,
      );
      graphics.drawString(
        displayValue,
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: Rect.fromLTWH(startX + (column * cellWidth) + 5,
            startY + titleHeight, cellWidth - 10, valueHeight),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );

      column++;
    }
  }

  // Ajustar la posición para la siguiente fila
  startY += titleHeight + valueHeight;

  // Tercer fila: Un solo campo con título "Información adicional"
  graphics.drawRectangle(
    bounds: Rect.fromLTWH(startX, startY, tableWidth, titleHeight),
    brush: PdfBrushes.lightBlue,
    pen: PdfPens.gray,
  );
  graphics.drawString(
    "Información adicional",
    PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(startX + 5, startY, tableWidth - 10, titleHeight),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.left,
      lineAlignment: PdfVerticalAlignment.middle,
    ),
  );

  // Ajustar la posición para la siguiente fila
  startY += titleHeight;

  // Cuarta fila: El valor de "Información adicional"
  graphics.drawRectangle(
    bounds: Rect.fromLTWH(startX, startY, tableWidth, valueHeight),
    brush: PdfBrushes.lightGray,
    pen: PdfPens.gray,
  );
  graphics.drawString(
    planMap["informacion_adicional"] ?? 'Indefinido',
    PdfStandardFont(PdfFontFamily.helvetica, 10),
    bounds: Rect.fromLTWH(startX + 5, startY, tableWidth - 10, valueHeight),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.left,
      lineAlignment: PdfVerticalAlignment.middle,
    ),
  );
}
