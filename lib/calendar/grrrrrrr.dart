import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:my_app/calendar/temp_event.dart';
import 'package:table_calendar/table_calendar.dart';
import '../events/sportevent.dart';

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

var _kEventSource = realEventSource..addAll({DateTime.now(): realTodaySource});

class Grr extends StatefulWidget {
  const Grr({Key? key}) : super(key: key);

  @override
  _GrrState createState() => _GrrState();
}

class _GrrState extends State<Grr> {
  late bool loading;
  late Map<DateTime, List<SportEvent>> grrMap;
  late List<SportEvent> grrToday;
  Map<DateTime, List<SportEvent>> kEvents = {};

  late final ValueNotifier<List<SportEvent>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
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
    final todayData = await eventdatasource.fetchDayEvent(DateTime.now());
    final eventdata = await eventdatasource.fetchAllEvent(
        DateTime.now(), DateTime.now().add(const Duration(days: 7)));

    //await Future.delayed(const Duration(seconds: 3), () {});
    setState(() {
      grrMap = eventdata;
      grrToday = todayData;
      loading = false;
      kEvents = LinkedHashMap<DateTime, List<SportEvent>>(
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

  List<SportEvent> _getEventsForDay(DateTime day) {
    // Implementation example
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
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (!loading)
        ? Container(
            color: Colors.transparent,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Column(
              children: [
                TableCalendar<SportEvent>(
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
                  child: ValueListenableBuilder<List<SportEvent>>(
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
                              border: Border.all(),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
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
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                            Icons.add_circle_outline_rounded),
                                        color: Colors.red),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                          Icons.remove_circle_outline_rounded),
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
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
        : Container(color: Colors.amber);

    return (!loading)
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
            ),
            body: Container(
              color: Colors.blue,
              height: 100,
              child: TextButton(
                child: Text(
                  'check',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  print('grrMap has ${grrMap.length} items');
                  print('realEventSource has ${realEventSource.length} items');
                  realEventSource.forEach((key, value) {
                    print(key);
                    print(value);
                  });
                },
              ),
            ),
          )
        : LinearProgressIndicator();
  }
}
