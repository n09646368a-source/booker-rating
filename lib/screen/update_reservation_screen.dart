import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reservation_bloc/reservation_bloc.dart';
import '../bloc/reservation_bloc/reservation_event.dart';
import '../model/reservation_model.dart';

class UpdateReservationScreen extends StatefulWidget {
  final ReservationModel reservation;

  const UpdateReservationScreen({super.key, required this.reservation});

  @override
  State<UpdateReservationScreen> createState() => _UpdateReservationScreenState();
}

class _UpdateReservationScreenState extends State<UpdateReservationScreen> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.parse(widget.reservation.startDate);
    endDate = DateTime.parse(widget.reservation.endDate);
  }

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;

        // إذا تاريخ البداية صار أكبر من النهاية، نعدّل النهاية تلقائيًا
        if (endDate.isBefore(startDate)) {
          endDate = startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: startDate.add(const Duration(days: 1)),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F56D9),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Update Reservation",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose new dates",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // 🔵 تاريخ البداية
            GestureDetector(
              onTap: pickStartDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Start Date", style: TextStyle(fontSize: 16)),
                    Text(
                      "${startDate.year}-${startDate.month}-${startDate.day}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔵 تاريخ النهاية
            GestureDetector(
              onTap: pickEndDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("End Date", style: TextStyle(fontSize: 16)),
                    Text(
                      "${endDate.year}-${endDate.month}-${endDate.day}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // 🔥 زر التحديث
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<ReservationBloc>().add(
                    UpdateReservationEvent(
                      id: widget.reservation.id,
                      startDate: "${startDate.year}-${startDate.month}-${startDate.day}",
                      endDate: "${endDate.year}-${endDate.month}-${endDate.day}",
                    ),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F56D9),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Update Reservation",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}