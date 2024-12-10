import 'package:flutter/material.dart';

/*void flushBarGlobal(BuildContext context, String? mensaje, Icon? icon,
    {Widget? trailing, int? seconds}) {
  Flushbar(
    backgroundColor: Colors.grey.shade900,
    mainButton: trailing,
    duration: Duration(seconds: seconds ?? 2),
    margin: const EdgeInsets.only(bottom: 45, left: 15, right: 15),
    icon: icon,
    message: mensaje,
    messageColor: Colors.white,
    flushbarPosition: FlushbarPosition.BOTTOM,
    borderRadius: BorderRadius.circular(100),
  ).show(context);
}*/

Future<void> scaffoldMessenger(BuildContext context, String title,
    {Icon? icon, int? seconds, Widget? trailing}) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: seconds ?? 3),
      content: Row(
        children: [
          icon ?? const Icon(Icons.warning, color: Colors.yellow),
          const SizedBox(width: 10),
          Expanded(child: Text(title)),
          trailing ?? Container()
        ],
      ),
      //backgroundColor: Colors.black,
      showCloseIcon: trailing != null ? false : true,
      closeIconColor: Colors.white));
}
