import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/events/event_repository.dart';
import 'package:my_app/events/sportevent.dart';

final repository = EventRepository();
final Map<DateTime, List<SportEvent>> realEventSource = {};
List<SportEvent> realTodaySource = [];

// List<DateTime> daysInRange(DateTime first, DateTime last) {
//   final dayCount = last.difference(first).inDays + 1;
//   return List.generate(
//     dayCount, //length of list -- ie. number of days in range
//     (index) => DateTime.utc(first.year, first.month, first.day + index),
//   );
// }

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3,
    kToday.day); //Sets first day to be 3 months earler
final kLastDay = DateTime(kToday.year, kToday.month + 3,
    kToday.day); //Sets last day to be 3 months later

class EventDataFetcher {
  Future fetchDayEvent(DateTime day, String place) async {
    DateTime curDay = DateTime(day.year, day.month, day.day);
    DateTime nextDay =
        DateTime(day.year, day.month, day.day).add(const Duration(hours: 24));
    Timestamp timestamp1 = Timestamp.fromDate(curDay);
    Timestamp timestamp2 = Timestamp.fromDate(nextDay);

    List res = [];
    List<SportEvent> gamelist = [];
    await repository.collection
        .where("placeId", isEqualTo: place)
        .where("start", isGreaterThanOrEqualTo: timestamp1)
        .where("start", isLessThan: timestamp2)
        .get()
        .then((value) {
      res = value.docs;
    });
    for (DocumentSnapshot event in res) {
      Timestamp _startTS = event.get("start");
      DateTime _start = _startTS.toDate();
      Timestamp _endTS = event.get("end");
      DateTime _end = _endTS.toDate();
      SportEvent ge = SportEvent(event.get("name"), _start, _end,
          event.get("maxCap"), event.get("curCap"), event.get("placeId"));
      gamelist.add(ge);
    }

    // print(
    //     'fetchDayEvent: fetched ${gamelist.length} events for ${place} from DB! C:');
    return gamelist;
  }

  Future fetchAllEvent(DateTime start, DateTime end, String place) async {
    realEventSource.clear();
    Map<DateTime, List<SportEvent>> grrMap = <DateTime, List<SportEvent>>{};
    final dayCount = end.difference(start).inDays;

    DateTime curDay = start;
    realTodaySource = await fetchDayEvent(curDay, place);

    for (int i = 0; i <= dayCount; i++) {
      curDay = curDay.add(const Duration(days: 1));
      List<SportEvent> dayEvents = await fetchDayEvent(curDay, place);
      grrMap[curDay] = dayEvents;
      realEventSource[curDay] = dayEvents;
    }
    //print('finished fetching ${realEventSource.length + 1} entries!');

    return grrMap;
  }
}
