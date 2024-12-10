import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../src/controller/provider/form_state.dart';

class MyAppBar {
  GlobalKey<ScaffoldState> key;

  MyAppBar({required this.key});

  ThemeData themeData = ThemeData();

  AppBar myAppBar({bool? back,required BuildContext context}) => AppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0,
        backgroundColor: Colors.white, //themeData.scaffoldBackgroundColor,
        title: SizedBox(
          width: 90,
          child: Image.asset('assets/abi_praxis_logo.png'),
        ),
        centerTitle: true,
        leading: back != null && back
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  var form = Provider.of<FormProvider>(context, listen: false);
                  form.limpiarDatos();
                  Navigator.pop(context);
                },
              )
            : IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  var form = Provider.of<FormProvider>(context, listen: false);
                  form.limpiarDatos();
                  key.currentState!.openDrawer();
                },
              ),
      );

  SliverAppBar mySliverAppBar({required Widget widgethide}) => SliverAppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0,
        backgroundColor: Colors.white, //themeData.scaffoldBackgroundColor,
        title: SizedBox(
          width: 90,
          child: Image.asset('assets/abi_praxis_logo.png'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => key.currentState!.openDrawer(),
        ),
        floating: true,
        pinned: true,
        snap: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(93),
          child: widgethide,
        ),
      );
}
