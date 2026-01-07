import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/models/posting_objects.dart';
import 'package:airbnb_clone/widgets/calendar_view_ui.dart';
import 'package:airbnb_clone/widgets/show_my_posting_list_tile.dart';
import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  static final String routeName = '/bookingsPageRoute';

  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  List<DateTime> _bookedDates = [];
  List<DateTime> _allBookedDates = [];
  Posting? _selectedPosting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bookedDates = AppConstants.currentUser.getAllBookedDates();
    _allBookedDates = AppConstants.currentUser.getAllBookedDates();
  }

  _selectDate(DateTime date) {}

  List<DateTime> _getSelectedDates() {
    return [];
  }

  _clearSelectedPosting() {
    _bookedDates = _allBookedDates;
    _selectedPosting = null;

    setState(() {
      
    });
  }

  _selectAPosting(Posting posting){
    _selectedPosting = posting;
    _bookedDates = posting.getAllBookedDates();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsetsGeometry.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const <Widget>[
                Text('Sun'),
                Text('Mon'),
                Text('Tue'),
                Text('Wed'),
                Text('Thu'),
                Text('Fri'),
                Text('Sat'),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 25),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.8,
                child: PageView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return CalendarViewUi(
                      monthIndex: index,
                      bookedDates: _bookedDates,
                      selectDate: _selectDate,
                      getSelectedDates: _getSelectedDates,
                    );
                  },
                ),
              ),
            ),
            // filter row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Filter by Posting', style: TextStyle(fontSize: 17)),
                  TextButton(
                    onPressed: _clearSelectedPosting,
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            // postings list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AppConstants.currentUser.myPostings!.length,
              itemBuilder: (context, index){
                final posting = AppConstants.currentUser.myPostings![index];
                final bool isSelected = _selectedPosting == posting;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () => _selectAPosting(posting),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected 
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade600,
                          width: isSelected ? 3.0 : 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ShowMyPostingListTile(posting: posting,),
                    ),
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
