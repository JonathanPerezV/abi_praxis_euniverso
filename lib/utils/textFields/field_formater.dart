import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat(
      "#,##0", "en_US"); // Cambia la configuración regional si es necesario

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Elimina cualquier separador de miles antes de formatear
    String newText = newValue.text.replaceAll('.', '').replaceAll(',', '');

    // Aplica el formato con el separador de miles
    String formattedText = _formatter.format(int.parse(newText));

    // Calcula la nueva posición del cursor
    int selectionIndex =
        formattedText.length - (newValue.text.length - newValue.selection.end);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
