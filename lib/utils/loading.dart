import 'package:abi_praxis_app/src/controller/provider/loading_provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

Widget loadingWidget({String? text}) {
  return Container(
    color: const Color.fromRGBO(0, 0, 0, 50),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white, size: 65),
          Text(
            text ?? "Cargando...",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          )
        ],
      ),
    ),
  );
}

Widget loadingWithBarProgress() {
  return Consumer<LoadingProvider>(builder: (context, load, child) {
    double progress = (load.currentNumber / load.maxNumber).clamp(0.0, 1.0);

    return Container(
      color: const Color.fromRGBO(0, 0, 0, 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white, size: 65),
            const SizedBox(height: 15),
            Container(
              //margin: EdgeInsets.only(left: 25, right: 25),
              child: const Text(
                "Esto puede tardar unos minutos. Por favor no salga de esta pantalla, ni cierre la aplicación.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 35),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color.fromRGBO(108, 108, 108, 0.769),
                ),
                margin: const EdgeInsets.only(left: 15, right: 15),
                height: 20,
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.green,
                          ),
                          width: progress * MediaQuery.of(context).size.width,
                        )),
                    Center(
                      child: Text(
                          "SINCRONIZANDO... ${(progress * 100).toStringAsFixed(0)}% ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17)),
                    ),
                  ],
                )),
            const SizedBox(height: 15),
            Text(
              "Tiempo aproximado: ${(((load.maxNumber - load.currentNumber) * 10) / 60).toStringAsFixed(0)} min ",
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  });
}
