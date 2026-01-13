import 'dart:ui';

import 'package:booker/bloc/booking_bloc/booking_bloc_bloc.dart';
import 'package:booker/bloc/booking_bloc/booking_bloc_evevt.dart';
import 'package:booker/bloc/booking_bloc/booking_bloc_state.dart';
import 'package:booker/model/apartment_model.dart';
import 'package:booker/model/profile_responce_model.dart';
import 'package:booker/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectDateScreen extends StatefulWidget {
  final ApartmentModel model;
  final ProfileResponceModel profile;

  const SelectDateScreen({
    super.key,
    required this.model,
    required this.profile,
  });

  @override
  State<SelectDateScreen> createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;

  bool isSelectingStart = true;
  CalendarFormat calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Processing booking...")),
          );
        }

        if (state is BookingSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReviewSummaryScreen(
                model: widget.model,
                profile: widget.profile,
                startDate: startDate!,
                endDate: endDate!,
                totalPrice: state.totalPrice,
                numberOfDays: state.numberOfDays,
              ),
            ),
          );
        }

        if (state is BookingError) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "This apartment is already booked for the selected dates.",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 4),
    ),
  );
}
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Select Rent Dates"),
          backgroundColor: const Color(0xFF7F56D9),
          centerTitle: true,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Choose Rent Period",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              TableCalendar(
                focusedDay: focusedDay,
                firstDay: DateTime.now(),
                lastDay: DateTime(2100),
                calendarFormat: calendarFormat,

                onFormatChanged: (format) =>
                    setState(() => calendarFormat = format),

                onPageChanged: (newFocusedDay) =>
                    setState(() => focusedDay = newFocusedDay),

                selectedDayPredicate: (day) =>
                    isSameDay(day, startDate) || isSameDay(day, endDate),

                onDaySelected: (selectedDay, newFocusedDay) {
                  setState(() {
                    focusedDay = newFocusedDay;

                    if (isSelectingStart) {
                      startDate = selectedDay;
                      if (endDate != null && endDate!.isBefore(startDate!)) {
                        endDate = null;
                      }
                    } else {
                      if (startDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Select start date first")),
                        );
                        return;
                      }

                      if (selectedDay.isBefore(startDate!)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "End date must be after start date")),
                        );
                        return;
                      }

                      endDate = selectedDay;
                    }
                  });
                },

                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF7F56D9),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _dateBox(
                "Start Date",
                startDate,
                isSelectingStart,
                () => setState(() => isSelectingStart = true),
              ),

              const SizedBox(height: 12),

              _dateBox(
                "End Date",
                endDate,
                !isSelectingStart,
                () => setState(() => isSelectingStart = false),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (startDate != null && endDate != null) {
                      context.read<BookingBloc>().add(
                            SendBookingEvent(
                              apartmentId: widget.model.id,
                              startDate:
                                  "${startDate!.year}-${startDate!.month}-${startDate!.day}",
                              endDate:
                                  "${endDate!.year}-${endDate!.month}-${endDate!.day}",
                            ),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select both dates"),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F56D9),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateBox(
    String label,
    DateTime? date,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive ? const Color(0xFF7F56D9) : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.date_range),
            const SizedBox(width: 8),
            Text(
              date != null
                  ? "$label: ${date.day}/${date.month}/${date.year}"
                  : "Choose $label",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
class ReviewSummaryScreen extends StatelessWidget {
  final ApartmentModel model;
  final ProfileResponceModel profile;
  final DateTime startDate;
  final DateTime endDate;
  final int totalPrice;
  final int numberOfDays;

  const ReviewSummaryScreen({
    super.key,
    required this.model,
    required this.profile,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.numberOfDays,
  });

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Summary"),
        backgroundColor: const Color(0xFF7F56D9),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCard(
              title: "Property Details",
              children: [
                _infoRow("Location", "${model.city}, ${model.governorate}"),
                _infoRow("Price per day", "${model.rentPrice} SYP"),
                _infoRow("Start Date", _formatDate(startDate)),
                _infoRow("End Date", _formatDate(endDate)),
                _infoRow("Days", numberOfDays.toString()),
              ],
            ),

            const SizedBox(height: 20),

            _buildCard(
              title: "User Information",
              children: [
                _infoRow("Name", "${profile.firstName} ${profile.lastName}"),
                _infoRow("Date of Birth", profile.dateOfBirth),
                _infoRow("User ID", profile.userId.toString()),
              ],
            ),

            const SizedBox(height: 20),

            _buildCard(
              title: "Payment Summary",
              children: [
                _infoRow("Total Price", "$totalPrice SYP"),
                const SizedBox(height: 4),
                const Text(
                  "This price is calculated by the server.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const Spacer(),

          SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF7F56D9),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: const Text(
      "Done",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7F56D9),
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
