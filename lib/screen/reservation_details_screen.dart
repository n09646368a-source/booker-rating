import 'package:booker/screen/update_reservation_screen.dart';
import 'package:booker/service/details_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reservation_bloc/reservation_bloc.dart';
import '../bloc/reservation_bloc/reservation_event.dart';
import '../model/reservation_model.dart';

class ReservationDetailsScreen extends StatelessWidget {
  final ReservationModel reservation;

  const ReservationDetailsScreen({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F56D9),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Reservation Details",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔵 أيقونة الشقة
           /* Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.home, size: 60, color: Colors.purple),
              ),
            ),*/
            FutureBuilder(
  future: ApartmentDetails().fetchApartmentDetails(reservation.apartmentId),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.purple),
        ),
      );
    }

    final details = snapshot.data!;
    final imageUrl = details.apartment.imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
       // height: 150,
        width: double.infinity,
       // fit: BoxFit.cover,
        placeholder: (_, __) => Image.asset("assets/placeholder.png"),
        errorWidget: (_, __, ___) => Image.asset("assets/placeholder.png"),
      ),
    );
  },
),

            const SizedBox(height: 20),

            Text(
              "Apartment #${reservation.apartmentId}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            infoRow("Start Date", reservation.startDate),
            infoRow("End Date", reservation.endDate),
            infoRow("Daily Price", "${reservation.dailyPrice}"),
            infoRow("Total Price", "${reservation.totalPrice}"),
            infoRow("Days", "${reservation.numberOfDays}"),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF7F56D9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                reservation.getStatusLabel(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            const Spacer(),

            // 🔥 الأزرار تظهر فقط إذا كان الحجز Upcoming
            if (reservation.getStatusLabel() == "Upcoming") ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ReservationBloc>().add(
                          CancelReservationEvent(reservation.id),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<ReservationBloc>(),
                              child: UpdateReservationScreen(reservation: reservation),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F56D9),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Update", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}