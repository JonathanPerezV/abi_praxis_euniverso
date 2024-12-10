import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:flutter/material.dart';

Widget expansionTile(BuildContext context,
    {required Widget children,
    required String title,
    required Function(bool)? func,
    required ExpansionTileController expController,
    required bool enabled,
    bool? validateFields,
    Color? color,
    Color? containerColor,
    Color? expandColorContainer,
    Icon? icon,
    Icon? leading,
    GlobalKey? key}) {
  return Container(
    decoration: BoxDecoration(
        color: containerColor ?? Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15)),
    margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: GestureDetector(
        onTap: () {
          if (!enabled) {
            /*flushBarGlobal(
                context,
                "Campos inhabilitados, antes de continuar busque un prospecto.",
                const Icon(Icons.warning, color: Colors.yellow),
                seconds: 3);*/
            scaffoldMessenger(context,
                "Campos inhabilitados, antes de continuar busque un prospecto.",
                icon: const Icon(Icons.warning, color: Colors.yellow),
                seconds: 3);
          }
        },
        child: ExpansionTile(
          key: key,
          tilePadding:
              leading == null ? const EdgeInsets.only(right: 15) : null,
          enabled: enabled,
          maintainState: true,
          controller: expController,
          backgroundColor: Colors.white,
          trailing: icon, leading: leading,
          //collapsedBackgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          //collapsedTextColor: Colors.grey.shade600,
          title: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: expandColorContainer ?? Colors.grey.shade300),
            padding: func != null
                ? leading == null
                    ? const EdgeInsets.all(8)
                    : null
                : null,
            child: Row(
              children: [
                if (color != null)
                  Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade700),
                          color: color,
                          borderRadius: BorderRadius.circular(25))),
                if (color != null || leading == null) const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
          ),
          onExpansionChanged: func,
          children: [children],
        ),
      ),
    ),
  );
}
