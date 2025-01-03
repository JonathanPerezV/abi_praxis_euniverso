import 'package:flutter/material.dart';
import 'package:abi_praxis_app/src/views/inside/home/vendedor/home_page.dart';
import 'package:abi_praxis_app/src/views/inside/school/what_sell/view_category.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/responsive.dart';

import '../../../../utils/buttons.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: options(),
      persistentFooterButtons: [
        SizedBox(
            height: 50,
            child: Center(
                child: Image.asset("assets/byBaadal.png", fit: BoxFit.cover)))
      ],
    );
  }

  Widget options() {
    final rsp = Responsive.of(context);
    return SingleChildScrollView(
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
          divider(false),
          const SizedBox(height: 10),
          Row(
            verticalDirection: VerticalDirection.up,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                    )),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Text(
                  "LA ESCUELA DE NEGOCIOS",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontStyle: FontStyle.normal),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              height: rsp.hp(40),
              child: Image.asset("assets/school/business_school.png")),
          Container(
            width: 300,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: const Text(
              "te ayuda a realizar ventas de una forma más efectiva.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          nextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => ViewCategory())),
              text: "SIGUIENTE",
              fontSize: 25,
              width: 200),
          TextButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => const HomePage()),
                  (route) => false),
              child: const Text(
                "Omitir",
                style: TextStyle(fontSize: 13),
              ))
        ],
      ),
    );
  }
}
