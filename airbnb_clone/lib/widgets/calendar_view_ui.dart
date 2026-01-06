import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/models/posting_objects.dart';
import 'package:airbnb_clone/models/user_objects.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CalendarViewUi extends StatefulWidget {
  final int? monthIndex;
  final List<DateTime>? bookedDates;
  final Function? selectDate;
  final Function? getSelectedDates;

  const CalendarViewUi({super.key, this.monthIndex, this.bookedDates, this.selectDate, this.getSelectedDates});

  @override
  State<CalendarViewUi> createState() => _CalendarViewUiState();
}

class _CalendarViewUiState extends State<CalendarViewUi> {

  List<DateTime> _selectedDates = [];
  List<MonthTileUi> _monthTiles = [];
  int? _currentMonthInt;
  int? _currentYearInt;

  _setUpMonthTiles() {
    setState(() {
      _monthTiles = [];
      int daysInMonth = AppConstants.daysInMonthsMap![_currentMonthInt]!;
      DateTime firstDayOfMonth = DateTime(_currentYearInt!, _currentMonthInt!, 1);
      int firstWeekOfMonth = firstDayOfMonth.weekday;

      if (firstWeekOfMonth != 7){
        for(int i = 0; i < firstWeekOfMonth; i++){
          _monthTiles.add(MonthTileUi(dateTime: null,));
        }
      }

      for(int i = 1; i <= daysInMonth; i++){
        DateTime date = DateTime(_currentYearInt!, _currentMonthInt!, i);
        _monthTiles.add(MonthTileUi(dateTime: date,));
      }

    });
  }

  _selectDate(DateTime date){
    if(_selectedDates.contains(date)){
      _selectedDates.remove(date);
    }else{
      _selectedDates.add(date);

      widget.selectDate!(date);
    }

    setState(() {
        
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentMonthInt = (DateTime.now().month + widget.monthIndex!) % 12;
    if(_currentMonthInt == 0){
      _currentMonthInt = 12;
    }

    _currentYearInt = DateTime.now().year;
    if(_currentMonthInt! < DateTime.now().month){
      _currentYearInt = _currentYearInt! + 1;
    }

    _selectedDates.addAll(widget.getSelectedDates!());
    _selectedDates.sort();

    _setUpMonthTiles();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: AutoSizeText(
              " ${AppConstants.monthsDictionaryMap[_currentMonthInt]} - $_currentYearInt",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          GridView.builder(
            itemCount: _monthTiles.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1 / 1,
            ), 
            itemBuilder: (context, index) {
              final monthTile = _monthTiles[index];
              if (monthTile.dateTime == null){
                return const SizedBox();
              }

              DateTime today = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              );

              bool isSelected = _selectedDates.contains(monthTile.dateTime);
              bool isPast = monthTile.dateTime!.isBefore(today);
              bool isBooked = widget.bookedDates!.contains(monthTile.dateTime);

              // past or booked disabled grey
              if( isPast || isBooked) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "${monthTile.dateTime!.day}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              }

              // selected date -> airbnb pink
              if( isSelected ) {
                return GestureDetector(
                  onTap: () {
                    _selectDate(monthTile.dateTime!);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5a5f),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "${monthTile.dateTime!.day}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }
              // future available - white bg with dark text

              return GestureDetector(
                  onTap: () {
                    _selectDate(monthTile.dateTime!);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "${monthTile.dateTime!.day}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
            }
          ),
        ],
      ),
    );
  }



}

class MonthTileUi extends StatelessWidget {
  final DateTime? dateTime;

  const MonthTileUi({super.key, this.dateTime});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      dateTime == null ? "" : dateTime!.day.toString(),
    );
  }
}