import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:my_app/calendar/temp_event.dart';
import 'package:my_app/events/create_event.dart';
import 'package:my_app/events/retrievedevent.dart';
import 'package:my_app/events/view_event.dart';
import 'package:my_app/map/map_data.dart';
import 'package:my_app/map/map_widgets.dart';
import 'package:my_app/reviews/review_page.dart';
import 'package:my_app/widgets/bouncing_button.dart';
import 'package:table_calendar/table_calendar.dart';
import '../events/event_widgets.dart';
import '../events/sportevent.dart';

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

var _kEventSource = realEventSource..addAll({kToday: realTodaySource});

class Grr extends StatefulWidget {
  Grr({Key? key, required this.placeId, required this.sportsFacility})
      : super(key: key);
  final String placeId;
  final SportsFacility sportsFacility;
  DateTime submittedDate = DateTime.now();
  @override
  _GrrState createState() => _GrrState();
}

class _GrrState extends State<Grr> {
  late bool loading;
  // late Map<DateTime, List<SportEvent>> grrMap;
  // late List<SportEvent> grrToday;
  Map<DateTime, List<RetrievedEvent>> kEvents = {};

  late final ValueNotifier<List<RetrievedEvent>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = kToday;
  DateTime? _selectedDay = kToday;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    loading = true;
    grrGetData();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  Future grrGetData() async {
    var eventdatasource = EventDataFetcher();
    // final todayData =
    //     await eventdatasource.fetchDayEvent(DateTime.now(), widget.placeId);
    // final eventdata = await eventdatasource.fetchAllEvent(DateTime.now(),
    //     DateTime.now().add(const Duration(days: 7)), widget.placeId);
    await eventdatasource.fetchDayEvent(kToday, widget.placeId);
    await eventdatasource.fetchAllEvent(
        kToday, kToday.add(const Duration(days: 7)), widget.placeId);
    //await Future.delayed(const Duration(seconds: 3), () {});

    setState(() {
      // grrMap = eventdata;
      // grrToday = todayData;
      loading = false;
      _kEventSource = realEventSource
        ..addAll({DateTime.now(): realTodaySource});

      kEvents = LinkedHashMap<DateTime, List<RetrievedEvent>>(
        equals: isSameDay,
        hashCode: getHashCode,
      )..addAll(_kEventSource);
    });

    // print('real event source has ${realEventSource.entries}');
    // print('real today has ${realTodaySource}');
    // print('kEvents has ${kEvents.entries}');
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<RetrievedEvent> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        widget.submittedDate = selectedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (!loading)
        ? Container(
            color: Colors.transparent,
            //margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Column(
              children: [
                TableCalendar<RetrievedEvent>(
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: _onDaySelected,
                  //onRangeSelected: _onRangeSelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
                  child: ValueListenableBuilder<List<RetrievedEvent>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                              vertical: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 1,
                                  color: Colors.grey,
                                  offset: const Offset(0, 1),
                                  blurRadius: 3,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: GestureDetector(
                                    onTap: () {
                                      print("${value[index].name} was tapped");
                                    },
                                    child: Container(
                                      child: ListTile(
                                        title: Text('${value[index].name}'),
                                        subtitle: Text(value[index].toTime()),
                                        leading:
                                            Icon(Icons.event_available_rounded),
                                        trailing: Text(value[index].toCap()),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          print(
                                              'preparing dialog for place ${value[index]} || ${widget.sportsFacility.placeName}');
                                          return ViewEventPopUp(
                                            placeIndex: index,
                                            event: value[index],
                                            SportsFacil: widget.sportsFacility,
                                          );

                                          // Dialog(
                                          //   backgroundColor: Color(0xffE5E8E8),
                                          //   child: ViewEventPopUp(
                                          //     placeIndex: index,
                                          //     event: value[index],
                                          //     SportsFacil:
                                          //         widget.sportsFacility,
                                          //   ),
                                          //   shape: RoundedRectangleBorder(
                                          //       borderRadius: BorderRadius.all(
                                          //           Radius.circular(20.0))),
                                          //);
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.arrow_right_alt_outlined),
                                    color: Colors.black),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : LinearProgressIndicator();
  }
}
