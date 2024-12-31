import 'dart:convert';
import 'dart:typed_data';
import 'package:abi_praxis_app/src/models/solicitud/soliciutd_credito_model.dart';
import 'package:abi_praxis_app/utils/buttons.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../../../../../utils/pdf/generate_pdf.dart';

class ViewPDF extends StatefulWidget {
  SolicitudCreditoModel solicitud;
  ViewPDF({required this.solicitud, super.key});

  @override
  State<ViewPDF> createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  Uint8List? pdfData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: pdfData == null
                ? const Center(child: CircularProgressIndicator())
                : SfPdfViewer.memory(pdfData!),
          ),
          nextButton(
              onPressed: () async => await generatePdf(widget.solicitud)
                  .then((val) => setState(() => pdfData = base64Decode(val))),
              text: "GENERAR PDF")
        ],
      ),
    );
  }
}
