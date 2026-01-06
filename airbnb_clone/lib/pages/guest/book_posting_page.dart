import 'package:airbnb_clone/models/posting_objects.dart';
import 'package:airbnb_clone/widgets/calendar_view_ui.dart';
import 'package:flutter/material.dart';

class BookPostingPage extends StatefulWidget {
  static final String routeName = '/bookPostingPageRoute';
  final Posting? posting;

  const BookPostingPage({super.key, this.posting});

  @override
  State<BookPostingPage> createState() => _BookPostingPageState();
}

class _BookPostingPageState extends State<BookPostingPage> {
  Posting? _posting;
  List<CalendarViewUi> _calendarWidgets = [];
  List<DateTime> _bookedDates = [];
  List<DateTime> _selectedDates = [];

  _buildCalendarWidget() {
    for (int i = 0; i < 12; i++) {
      _calendarWidgets.add(
        CalendarViewUi(
          monthIndex: i,
          bookedDates: _bookedDates,
          selectDate: _selectDate,
          getSelectedDates: _getSelectedDates,
        ),
      );
    }

    setState(() {});
  }

  _loadBookedDates(){
    _buildCalendarWidget();
  }

  _selectDate(DateTime date) {
    if (_selectedDates.contains(date)) {
      _selectedDates.remove(date);
    } else {
      _selectedDates.add(date);
    }

    _selectedDates.sort();

    setState(() {});
  }

  _getSelectedDates() {
    return _selectedDates;
  }

  //_makeBookingForPropertyListing() async {

  //}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _posting = widget.posting;

    _loadBookedDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book ${_posting!.name}")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Sun'),
                Text('Mon'),
                Text('Tue'),
                Text('Wed'),
                Text('Thu'),
                Text('Fri'),
                Text('Sat'),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: (_calendarWidgets.isEmpty)
                  ? Container()
                  : PageView.builder(
                    itemCount: _calendarWidgets.length,
                    itemBuilder: (context, index){
                      return _calendarWidgets[index];
                    }
                  ),
            ),

            MaterialButton(
              onPressed: () {
                
              },
              minWidth: double.infinity,
              height: MediaQuery.of(context).size.height / 16,
              color: Colors.green,
              child: const Text('Book Now', style: TextStyle(fontSize: 20),),
            ),
          ],
        ),
      ),
    );
  }
}
