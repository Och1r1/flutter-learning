import 'package:airbnb_clone/constants/app_constants.dart';
import 'package:airbnb_clone/models/posting_objects.dart';
import 'package:airbnb_clone/pages/guest/view_posting_page.dart';
import 'package:airbnb_clone/widgets/grid_widget_ui.dart';
import 'package:flutter/material.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(25, 0, 25, 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsetsGeometry.only(top: 5),
              child: Text(
                'Upcoming trip',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.only(top: 15, bottom: 25),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: AppConstants.currentUser.getUpcomingTrips().length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Booking currentBooking = AppConstants.currentUser
                        .getUpcomingTrips()[index];
                    return Padding(
                      padding: const EdgeInsetsGeometry.only(right: 15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: InkResponse(
                          enableFeedback: true,
                          child: GridWidgetUi(booking: currentBooking),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewPostingPage(
                                  posting: currentBooking.posting!,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Text(
              'Previous Trips',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),

            Padding(
              padding: EdgeInsetsGeometry.only(top: 15, bottom: 25),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: AppConstants.currentUser.getPreviousTrips().length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Booking currentBooking = AppConstants.currentUser
                        .getPreviousTrips()[index];
                    return Padding(
                      padding: const EdgeInsetsGeometry.only(right: 15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: InkResponse(
                          enableFeedback: true,
                          child: GridWidgetUi(booking: currentBooking),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewPostingPage(
                                  posting: currentBooking.posting!,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
