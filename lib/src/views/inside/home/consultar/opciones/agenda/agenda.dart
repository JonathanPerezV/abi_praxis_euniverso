import 'dart:io';
import 'package:abi_praxis_app/utils/list/lista_agenda.dart';
import 'package:abi_praxis_app/utils/textFields/input_text_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:abi_praxis_app/main.dart';
import 'package:abi_praxis_app/src/controller/dataBase/operations.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/agenda/agregar_calendario.dart';
import 'package:abi_praxis_app/src/views/inside/home/consultar/opciones/agenda/tabs/info_evento.dart';
import 'package:abi_praxis_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis_app/utils/app_bar.dart';
import 'package:abi_praxis_app/utils/deviders/divider.dart';
import 'package:abi_praxis_app/utils/flushbar.dart';
import 'package:abi_praxis_app/utils/header.dart';
import 'package:abi_praxis_app/utils/icons/abi_praxis_icons.dart';
import 'package:abi_praxis_app/utils/loading.dart';
import 'package:abi_praxis_app/utils/selectFile/select_file.dart';
import 'package:mobkit_calendar/mobkit_calendar.dart';
import '../../../../../../models/calendarEvento/calendar_model.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _MyAppState();
}

class _MyAppState extends State<Agenda> {
  final sckey = GlobalKey<ScaffoldState>();

  bool dayCalendar = false;
  bool weekCalendar = true;
  bool monthCalendar = false;
  bool searching = false;

  bool loading = false;
  final ScrollController _scrollController = ScrollController();
  DateTime tiempoActualCalendario = DateTime.now();
  List<CalendarModel> events = [];
  List<CalendarModel> _searchList = [];

  final file = SeleccionArchivos();
  final _searchController = TextEditingController();

  MobkitCalendarConfigModel getConfig(
      MobkitCalendarViewType mobkitCalendarViewType) {
    return MobkitCalendarConfigModel(
      weeklyTopWidgetSize:
          mobkitCalendarViewType == MobkitCalendarViewType.weekly ? 55 : null,
      borderRadius: mobkitCalendarViewType == MobkitCalendarViewType.weekly
          ? BorderRadius.circular(100)
          : const BorderRadius.all(Radius.circular(10)),
      cellConfig: CalendarCellConfigModel(
        eventLineHeight: 500,
        disabledStyle: CalendarCellStyle(
          textStyle:
              TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.5)),
          color: Colors.transparent,
        ),
        enabledStyle: CalendarCellStyle(
          textStyle: const TextStyle(fontSize: 16, color: Colors.black),
          border: Border.all(color: Colors.black.withOpacity(0.2), width: 0),
        ),
        selectedStyle: CalendarCellStyle(
          color: const Color.fromRGBO(82, 123, 189, 1),
          textStyle: const TextStyle(fontSize: 17, color: Colors.white),
          border: Border.all(color: Colors.black, width: 0),
        ),
        currentStyle: CalendarCellStyle(
          border: const Border(
              bottom: BorderSide(color: Colors.blue),
              left: BorderSide(color: Colors.blue),
              right: BorderSide(color: Colors.blue),
              top: BorderSide(color: Colors.blue)),
          textStyle: const TextStyle(color: Colors.lightBlue),
        ),
      ),
      calendarPopupConfigModel: CalendarPopupConfigModel(
        popUpBoxDecoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        popUpOpacity: true,
        animateDuration: 200,
        verticalPadding: 30,
        popupSpace: 20,
        popupHeight: MediaQuery.of(context).size.height * 0.6,
        popupWidth: MediaQuery.of(context).size.width,
        viewportFraction: 0.9,
      ),
      topBarConfig: CalendarTopBarConfigModel(
        isVisibleHeaderWidget:
            mobkitCalendarViewType == MobkitCalendarViewType.monthly ||
                mobkitCalendarViewType == MobkitCalendarViewType.agenda,
        isVisibleTitleWidget: true,
        isVisibleMonthBar: false,
        isVisibleYearBar: false,
        isVisibleWeekDaysBar: true,
        weekDaysStyle: const TextStyle(fontSize: 17, color: Colors.black),
      ),
      weekDaysBarBorderColor: Colors.transparent,
      locale: "es",
      disableOffDays: true,
      disableWeekendsDays: false,
      monthBetweenPadding: 20,
      primaryColor: Colors.lightBlue,
      showEventLineMaxCountText: false,
      showEventPointMaxCountText: false,
      popupEnable: mobkitCalendarViewType == MobkitCalendarViewType.monthly
          ? true
          : false,
    );
  }

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  List<MobkitCalendarAppointmentModel> eventList = [];

  void getEvents() async {
    setState(() {
      eventList.clear();
    });
    final db = Operations();

    final res = await db.obtenerAgendas();

    if (res.isNotEmpty) {
      setState(() => events = res);
      setState(() => _searchList = events);

      List<MobkitCalendarAppointmentModel> tempEventList = [];

      for (var evento in events) {
        var date = DateTime.parse(evento.fechaReunion);
        var firstTime = evento.horaInicio.split(":");
        var lastTime = evento.horaFin.split(":");

        tempEventList.add(MobkitCalendarAppointmentModel(
            nativeEventId: evento.idAgenda.toString(),
            title: evento.nombres,
            color: /*evento.estado != 0
                  ? Colors.red
                  :*/
                const Color.fromRGBO(82, 123, 189, 1),
            appointmentStartDate: DateTime(date.year, date.month, date.day,
                int.parse(firstTime[0]), int.parse(firstTime[1])),
            appointmentEndDate: DateTime(date.year, date.month, date.day,
                int.parse(lastTime[0]), int.parse(lastTime[1])),
            isAllDay: false,
            detail:
                """${categorias.where((e) => e.idCategoria == evento.categoriaProducto).toList()[0].nombreCategoria} | ${productos.where((e) => e.idProducto == evento.producto).toList()[0].nombreProducto}""",
            recurrenceModel: null));
      }

      tempEventList.sort(
          (a, b) => a.appointmentStartDate.compareTo(b.appointmentStartDate));

      await Future.delayed(const Duration(seconds: 1));

      setState(() => eventList = tempEventList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        //onTap: () => FocusScope.of(context).unfocus(),
        child: /*Consumer<FormProvider>(builder: (context, form, child) {
        return */
            Scaffold(
                backgroundColor: Colors.white,
                key: sckey,
                appBar: MyAppBar(key: sckey).myAppBar(context: context),
                drawer: DrawerMenu(inicio: false),
                floatingActionButton: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  backgroundColor: Colors.black,
                  onPressed: () async => await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => EventEditingPage(
                                eventList: eventList,
                              ))).then((_) => getEvents()),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                body: options())
        //}),
        );
  }

  Widget options() => Column(
        children: [
          header("Agenda", AbiPraxis.agenda, context: context),
          buscador(),
          Expanded(
            child: loading
                ? loadingWidget(text: "Consultando...")
                : Stack(
                    children: [
                      //eventListContainer(),
                      weekCalendar
                          ? weekCalendarWidget()
                          : monthCalendarWidget(),
                      if (searching) eventListContainer(),
                    ],
                  ),
          )
        ],
      );

  Widget eventListContainer() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: double.infinity,
      child: Material(
          //borderRadius: BorderRadius.circular(15),
          elevation: 4,
          child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _searchList.length,
              itemBuilder: (ctx, i) {
                var date = DateTime.parse(_searchList[i].fechaReunion);
                /*var firstTime = _searchList[i].horaInicio.split(":");
                var lastTime = _searchList[i].horaFin.split(":");*/

                return InkWell(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => InfoEvento(
                                    idEvento: _searchList[i].idAgenda!)))
                        .then((_) => getEvents());
                  },
                  child: Card(
                    margin: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    child: Row(
                      children: [
                        Container(
                          width: 5,
                          height: 50,
                          color: const Color.fromRGBO(82, 123, 189, 1),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                width: double.infinity,
                                child: Text(
                                  _searchList[i].nombres ?? "",
                                  //style: TextStyle(fontSize: 10),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Text(
                                        productos
                                            .where((e) =>
                                                e.idProducto ==
                                                _searchList[i].producto!)
                                            .toList()[0]
                                            .nombreProducto,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 5),
                                    Container(
                                        width: 3,
                                        height: 15,
                                        color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text("${date.day}/${date.month}")
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        /*IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {},
                        )*/
                      ],
                    ),
                  ),
                );
              })),
    );
  }

  Widget weekCalendarWidget() => MobkitCalendarWidget(
      minDate: DateTime(2020),
      key: UniqueKey(),
      config: getConfig(MobkitCalendarViewType.weekly),
      dateRangeChanged: (datetime) => null,
      weeklyViewWidget: (Map<DateTime, List<MobkitCalendarAppointmentModel>>
              val) =>
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: val.length,
              itemBuilder: (BuildContext context, int index) {
                DateTime dateTime = val.keys.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Center(
                                child: Text(
                                  dateTime.day.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              " de ${DateFormat("MMMM", "es").format(dateTime)}",
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${DateFormat("EEEE", "es").format(dateTime)} ",
                              style: const TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        val[dateTime]!.isNotEmpty
                            ? SizedBox(
                                height: val[dateTime]!.length * 90,
                                child: ListView.builder(
                                  itemCount: val[dateTime]!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return FutureBuilder(
                                        future: validarLlegada(int.parse(
                                            val[dateTime]![index]
                                                .nativeEventId!)),
                                        builder: (context, snapshot) {
                                          bool foto = false;
                                          bool cancelado = false;
                                          Color color = Colors.grey;
                                          Color colorBorder =
                                              Colors.grey.shade200;
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            color = Colors.grey;
                                            colorBorder = Colors.grey.shade200;
                                          } else if (snapshot.hasError) {
                                            color = Colors.grey;
                                            colorBorder = Colors.grey.shade200;
                                          } else if (!snapshot.hasData) {
                                            color = Colors.grey;
                                            colorBorder = Colors.grey.shade200;
                                          } else if (snapshot.hasData &&
                                              snapshot.data!["llegada"] == 1) {
                                            color = Colors.green;
                                            colorBorder = Colors.green.shade200;
                                          }
                                          if (snapshot.data!["estado"] == 0) {
                                            cancelado = false;
                                          } else {
                                            cancelado = true;
                                          }

                                          if (snapshot.data!["foto"] == "") {
                                            foto = false;
                                          } else {
                                            foto = true;
                                          }

                                          return Slidable(
                                            enabled:
                                                snapshot.data!["estado"] == 0
                                                    ? true
                                                    : false,
                                            key: UniqueKey(),
                                            endActionPane: ActionPane(
                                              motion: const BehindMotion(),
                                              children: [
                                                const SizedBox(width: 5),
                                                CustomSlidableAction(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  backgroundColor: !validateDate(
                                                          val[dateTime]![index]
                                                              .appointmentEndDate,
                                                          showMessage: false)
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                  onPressed: foto
                                                      ? null
                                                      : (_) async {
                                                          final res = validateDate(
                                                              val[dateTime]![
                                                                      index]
                                                                  .appointmentEndDate,
                                                              showMessage:
                                                                  true);
                                                          if (!res) {
                                                            takePhoto(int.parse(
                                                                val[dateTime]![
                                                                        index]
                                                                    .nativeEventId!));
                                                          }
                                                        },
                                                  padding: EdgeInsets.zero,
                                                  foregroundColor: Colors.white,
                                                  child: Icon(
                                                      foto
                                                          ? Icons
                                                              .check_circle_rounded
                                                          : Icons
                                                              .camera_alt_outlined,
                                                      size: 30),
                                                ),
                                                const SizedBox(width: 5),
                                                CustomSlidableAction(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  backgroundColor: !validateDate(
                                                          val[dateTime]![index]
                                                              .appointmentEndDate,
                                                          showMessage: false)
                                                      ? Colors.red
                                                      : Colors.grey,
                                                  onPressed: (_) async {
                                                    final res = validateDate(
                                                        val[dateTime]![index]
                                                            .appointmentEndDate,
                                                        showMessage: true);

                                                    if (!res) {
                                                      Platform.isAndroid
                                                          ? cancelarReunionAnd(
                                                              int.parse(
                                                                  val[dateTime]![
                                                                          index]
                                                                      .nativeEventId!))
                                                          : cancelarReunionIos(
                                                              int.parse(
                                                                  val[dateTime]![
                                                                          index]
                                                                      .nativeEventId!));
                                                    }
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  foregroundColor: Colors.white,
                                                  child: const Icon(
                                                    Icons.delete_outline,
                                                    size: 30,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () => onTapEvent(
                                                  val[dateTime]![index]),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: double.infinity,
                                                    height: 85,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: getColor(val[
                                                          dateTime]![index]),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child: Text(
                                                                  val[dateTime]![
                                                                              index]
                                                                          .title ??
                                                                      "",
                                                                  style: TextStyle(
                                                                      decoration: cancelado
                                                                          ? TextDecoration
                                                                              .lineThrough
                                                                          : null,
                                                                      decorationColor: cancelado
                                                                          ? Colors
                                                                              .black
                                                                          : null,
                                                                      decorationStyle: cancelado
                                                                          ? TextDecorationStyle
                                                                              .solid
                                                                          : null,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Text(
                                                                    "${DateFormat("HH:mm").format(val[dateTime]![index].appointmentStartDate)} - ${DateFormat("HH:mm").format(val[dateTime]![index].appointmentEndDate)}",
                                                                    style: TextStyle(
                                                                        decoration: cancelado
                                                                            ? TextDecoration
                                                                                .lineThrough
                                                                            : null,
                                                                        decorationColor: cancelado
                                                                            ? Colors
                                                                                .black
                                                                            : null,
                                                                        decorationStyle: cancelado
                                                                            ? TextDecorationStyle
                                                                                .solid
                                                                            : null,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            14),
                                                                  )),
                                                              SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child: Text(
                                                                  val[dateTime]![
                                                                          index]
                                                                      .detail,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      decoration: cancelado
                                                                          ? TextDecoration
                                                                              .lineThrough
                                                                          : null,
                                                                      decorationColor: cancelado
                                                                          ? Colors
                                                                              .black
                                                                          : null,
                                                                      decorationStyle: cancelado
                                                                          ? TextDecorationStyle
                                                                              .solid
                                                                          : null,
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          17),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        if (snapshot.data![
                                                                "estado"] ==
                                                            0)
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 10),
                                                            decoration: BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      blurRadius:
                                                                          4,
                                                                      spreadRadius:
                                                                          2,
                                                                      color:
                                                                          colorBorder)
                                                                ],
                                                                color: color,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                            child: IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  final res = validateDate(
                                                                      val[dateTime]![
                                                                              index]
                                                                          .appointmentEndDate,
                                                                      showMessage:
                                                                          true);

                                                                  if (!res) {
                                                                    Platform.isAndroid
                                                                        ? agendaLlegadaAnd(int.parse(val[dateTime]![index]
                                                                            .nativeEventId!))
                                                                        : agendaLlegadaIos(
                                                                            int.parse(val[dateTime]![index].nativeEventId!));
                                                                  }
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.flag,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                ),
                              )
                            : Column(
                                children: [
                                  const SizedBox(height: 5),
                                  Container(
                                    margin: const EdgeInsets.only(left: 45),
                                    child: const Text("Sin eventos"),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              )
                      ]),
                );

                // : Container();
              },
            ),
          ),
      titleWidget:
          (List<MobkitCalendarAppointmentModel> models, DateTime datetime) =>
              Column(
                children: [
                  titleWidget(
                    datetime: datetime,
                  ),
                  //selectMonth(dateTime: datetime),
                  const SizedBox(height: 10)
                ],
              ),
      onSelectionChange:
          (List<MobkitCalendarAppointmentModel> models, DateTime date) {
        if (date.isBefore(DateTime.now()) && !date.isSameDay(DateTime.now())) {
          scaffoldMessenger(
              context, "No puede agendar reuniones en fechas anteriores.",
              icon: const Icon(Icons.error, color: Colors.red));
        } else {
          /*Platform.isAndroid
                ? andAlert.alertaAgregarEvento(context, date, () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => EventEditingPage(
                                  startDate: date,
                                  eventList: eventList,
                                )));
                  })
                : iosAlert.alertaAgregarEvento(context, date, () {
                    Navigator.pop(context);*/
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => EventEditingPage(
                        startDate: date,
                        eventList: eventList,
                      )));
          //});
        }
      },
      eventTap: (event) => onTapEvent(event),
      onDateChanged: (DateTime datetime) {
        setState(() => tiempoActualCalendario = datetime);
      },
      mobkitCalendarController: MobkitCalendarController(
          viewType: MobkitCalendarViewType.weekly,
          appointmentList: eventList.isNotEmpty
              ? eventList
              : [], // Asegúrate de que no sea nulo
          calendarDateTime: tiempoActualCalendario,
          selectedDateTime: tiempoActualCalendario));

  Color getColor(MobkitCalendarAppointmentModel val) {
    //todo SI EL DÍA ES DIFERENTE AL ACTUAL Y ES MENOR QUE SE PONGA GRIS CASO CONTRARIO MANTENER AZUL
    //todo SI LA HORA ES MENOR A LA HORA ACTUAL Y ESTAMOS EN EL MISMO DÍA O DÍAS ANTERIORES ENTONCES QUE SEA GRIS

    DateTime fechaInicioEvento = val.appointmentStartDate;
    DateTime fechaFinEvento = val.appointmentEndDate;
    //final horaFinEvento = DateFormat("HH:mm").format(val.appointmentEndDate);

    debugPrint("Fecha inicio evento: $fechaInicioEvento");
    debugPrint("Fecha fin evento: $fechaFinEvento");

    if (DateTime.now().isAfter(fechaFinEvento)) {
      return Colors.grey;
    } else {
      return val.color!;
    }
  }

  Widget monthCalendarWidget() => MobkitCalendarWidget(
        minDate: DateTime(2020),
        key: UniqueKey(),
        config: getConfig(MobkitCalendarViewType.monthly),
        dateRangeChanged: (datetime) => null,
        onSelectionChange:
            (List<MobkitCalendarAppointmentModel> models, DateTime date) =>
                null,
        eventTap: (event) => onTapEvent(event),
        titleWidget: (models, datetime) => Column(
          children: [
            titleWidget(
              datetime: datetime,
            ),
            //selectMonth(dateTime: datetime),
            const SizedBox(height: 10)
          ],
        ),
        onPopupWidget:
            (List<MobkitCalendarAppointmentModel> models, DateTime datetime) =>
                onPopupWidget(
          datetime: datetime,
          models: models,
        ),
        onDateChanged: (DateTime datetime) {
          setState(() => tiempoActualCalendario = datetime);
        },
        mobkitCalendarController: MobkitCalendarController(
          viewType: MobkitCalendarViewType.monthly,
          calendarDateTime: tiempoActualCalendario,
          selectedDateTime: tiempoActualCalendario,
          appointmentList: eventList.isNotEmpty ? eventList : [],
        ),
      );

  Widget titleWidget({
    required DateTime datetime,
  }) =>
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: [
            Text(
              DateFormat("MMMM yyyy", "es").format(datetime),
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: divider(false)),
            PopupMenuButton(
                icon: const Icon(Icons.more_vert_rounded),
                itemBuilder: (itemBuilder) {
                  List<PopupMenuEntry> list = [];
                  /*list.add(PopupMenuItem(
                    child: Text("Día"),
                    onTap: () {
                      setState(() {
                        dayCalendar = true;
                        weekCalendar = false;
                        monthCalendar = false;
                      });
                    },
                  ));*/
                  list.add(PopupMenuItem(
                    child: const Text("Semana"),
                    onTap: () {
                      setState(() {
                        dayCalendar = false;
                        weekCalendar = true;
                        monthCalendar = false;
                      });
                    },
                  ));
                  list.add(PopupMenuItem(
                    child: const Text("Mes"),
                    onTap: () {
                      setState(() {
                        dayCalendar = false;
                        weekCalendar = false;
                        monthCalendar = true;
                      });
                    },
                  ));
                  return list;
                })
          ],
        ),
      );

  Widget onPopupWidget(
      {required List<MobkitCalendarAppointmentModel> models,
      required DateTime datetime}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
      child: models.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    DateFormat("EEE, MMMM d", "es").format(datetime),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: models.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          onTapEvent(models[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1, vertical: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  color: models[index].color,
                                  width: 2,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        "${models[index].title!} (${DateFormat("HH:mm").format(models[index].appointmentStartDate)} - ${DateFormat("HH:mm").format(models[index].appointmentEndDate)})",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        models[index].detail,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    DateFormat("EEE, MMMM d").format(datetime),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ],
            ),
    );
  }

  ///
  ///0: NO HA LLEGADO
  ///1: LLEGÓ
  ///
  Future<Map<String, dynamic>> validarLlegada(int idAgenda) async {
    final data = (await op.obtenerAgenda(idAgenda));

    if (data != null) {
      if (data.asistio != "") {
        return {
          "llegada": 1,
          "estado": data.estado,
          "foto": data.fotoReferencia
        };
      } else {
        return {
          "llegada": 0,
          "estado": data.estado,
          "foto": data.fotoReferencia
        };
      }
    } else {
      return {};
    }
  }

  void onTapEvent(MobkitCalendarAppointmentModel event) async {
    await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    InfoEvento(idEvento: int.parse(event.nativeEventId!))))
        .then((_) => getEvents());
  }

  Future<void> takePhoto(int idAgenda) async {
    final currentPosition = _scrollController.position.pixels;
    setState(() => loading = true);
    final res = await file.selectOrCaptureImage(ImageSource.camera, context);

    if (res != null) {
      debugPrint("resultado: $res");

      final bytes = await File(res).readAsBytes();

      final up = await op.actualizarFotoReunion(bytes.toString(), idAgenda);

      if (up == 1) {
        getEvents();
        setState(() {
          _scrollController.animateTo(currentPosition,
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear);
        });
        scaffoldMessenger(context, "Foto cargada",
            icon: const Icon(Icons.check, color: Colors.green));
      } else {
        scaffoldMessenger(context, "No se pudo cargar la foto",
            icon: const Icon(Icons.check, color: Colors.red));
      }
    }
    setState(() => loading = false);
  }

  void agendaLlegadaAnd(int idAgenda) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text("Reunión"),
            content: const Text(
                "Al pulsar en 'Llegué' usted confirmará que acabó de llegar al lugar de reunión."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () => actualizarLLegada(idAgenda),
                  child: const Text("Llegué")),
            ],
          );
        });
  }

  void agendaLlegadaIos(int idAgenda) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Reunión"),
            content: const Text(
                "Al pulsar en 'Llegué' usted confirmará que acabó de llegar al lugar de reunión."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () => actualizarLLegada(idAgenda),
                  child: const Text("Llegué")),
            ],
          );
        });
  }

  void cancelarReunionIos(int idAgenda) async {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Cancelar evento"),
            content: const Text("¿Está seguro que desea cancelar el evento?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final cscroll = _scrollController.position;
                    setState(() => loading = true);
                    final res = await op.actualizarEstadoReunion(1, idAgenda);

                    if (res == 1) {
                      getEvents();
                      _scrollController.animateTo(cscroll.pixels,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
                      scaffoldMessenger(context, "Reunión cancelada",
                          icon: const Icon(
                            Icons.check,
                            color: Colors.green,
                          ));
                    } else {
                      scaffoldMessenger(
                          context, "No se pudo cancelar la reunión",
                          icon: const Icon(
                            Icons.error,
                            color: Colors.red,
                          ));
                    }
                    setState(() => loading = false);
                  },
                  child: const Text("Si")),
            ],
          );
        });
  }

  void cancelarReunionAnd(int idAgenda) async {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: const Text("Cancelar evento"),
            content: const Text("¿Está seguro que desea cancelar el evento?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final cscroll = _scrollController.position;
                    setState(() => loading = true);
                    final res = await op.actualizarEstadoReunion(1, idAgenda);

                    if (res == 1) {
                      getEvents();
                      _scrollController.animateTo(cscroll.pixels,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
                      scaffoldMessenger(context, "Reunión cancelada",
                          icon: const Icon(
                            Icons.check,
                            color: Colors.green,
                          ));
                    } else {
                      scaffoldMessenger(
                          context, "No se pudo cancelar la reunión",
                          icon: const Icon(
                            Icons.error,
                            color: Colors.red,
                          ));
                    }
                    setState(() => loading = false);
                  },
                  child: const Text("Si")),
            ],
          );
        });
  }

  Future<void> actualizarLLegada(int idAgenda) async {
    Navigator.pop(context);

    double currentScrollPosition = _scrollController.position.pixels;

    setState(() => loading = true);
    final res = await op.actualizarLlegadaAgenda(idAgenda);

    if (res == 1) {
      scaffoldMessenger(context, "Hora y lugar guardados correctamente",
          icon: const Icon(Icons.check, color: Colors.green));
    } else {
      scaffoldMessenger(context, "Ocurrió un error",
          icon: const Icon(Icons.error, color: Colors.red));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(currentScrollPosition,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate);
    });
    setState(() => loading = false);
  }

  Widget buscador() {
    return Container(
      width: double.infinity,
      height: 50,
      color: const Color.fromRGBO(224, 225, 219, 1),
      child: InputTextFields(
        suffixIcon: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              buildSearchList("");
              setState(() => _searchController.clear());
              setState(() => searching = false);
            },
            icon: const Icon(Icons.clear)),
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() => searching = true);
            buildSearchList(value);
          } else {
            setState(() => _searchController.clear());
            setState(() => searching = false);
          }
        },
        inputBorder: InputBorder.none,
        nombreCampo: "Buscar",
        icon: const Icon(Icons.search),
        padding: EdgeInsets.zero,
        placeHolder: "Buscar evento",
        controlador: _searchController,
      ),
    );
  }

  bool validateDate(DateTime fechaFin, {required bool showMessage}) {
    if (DateTime.now().isAfter(fechaFin)) {
      if (showMessage) {
        scaffoldMessenger(context,
            "No se puede actualizar un evento anterior a la fecha actual.",
            icon: const Icon(Icons.error, color: Colors.red), seconds: 3);
      }

      return true;
    } else {
      return false;
    }
  }

  void buildSearchList(String text) {
    if (text != "") {
      final list = events
          .where((e) =>
              e.nombres!.toLowerCase().contains(text.toLowerCase()) ||
              productos
                  .where((i) => i.idProducto == e.producto)
                  .toList()[0]
                  .nombreProducto
                  .contains(text.toLowerCase()))
          .toList();
      if (list.isNotEmpty) {
        setState(() => _searchList = list);
      } else {
        setState(() => searching = false);
      }
    } else {
      setState(() => _searchList = events);
    }
  }
}
