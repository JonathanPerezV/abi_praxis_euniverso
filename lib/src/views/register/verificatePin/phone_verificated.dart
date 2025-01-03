import 'package:flutter/material.dart';
import 'package:abi_praxis_app/utils/buttons.dart';
import 'package:abi_praxis_app/utils/footer.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';

import '../../../../utils/deviders/divider.dart';
import '../../../models/usuario/persona_model.dart';

class PhoneVerificated extends StatefulWidget {
  bool updateUser;
  PersonaModel? usuario;
  PhoneVerificated({super.key, this.usuario, required this.updateUser});

  @override
  State<PhoneVerificated> createState() => _PhoneVerificatedState();
}

class _PhoneVerificatedState extends State<PhoneVerificated> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: options(),
        persistentFooterButtons: [footerBaadal()],
      );

  Widget options() => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 170,
                height: 60,
                child: Image.asset("assets/abi_praxis_logo.png"),
              ),
            ),
            const SizedBox(height: 10),
            divider(true),
            Row(
              children: [
                const SizedBox(width: 10),
                IconButton(
                    onPressed: () {
                      if (widget.updateUser) {
                        Navigator.pop(context, true);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                const Row(children: [
                  Icon(AbiPraxis.codigo_de_verificacion),
                  SizedBox(width: 5),
                  Text(
                    "Código de verificación",
                    style: TextStyle(fontSize: 23.5),
                  )
                ])
              ],
            ),
            divider(true),
            const SizedBox(height: 60),
            Center(
                child: Column(
              children: [
                SizedBox(
                  width: 110,
                  child: Image.asset("assets/validated.png"),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.yellow.shade400,
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      "TELÉFONO VERIFICADO",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                button()
              ],
            ))
          ],
        ),
      );

  Widget button() => nextButton(
      onPressed: () {
        if (widget.updateUser) {
          Navigator.pop(context, true);
          Navigator.pop(context, true);
        } else {}
      },
      width: 250,
      text: "CONTINUAR",
      fontSize: 25);
}
