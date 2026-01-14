import 'package:booker/model/apartment_details_model.dart';
import 'package:booker/screen/reservation_details_screen.dart';
import 'package:booker/service/details_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reservation_bloc/reservation_bloc.dart';
import '../bloc/reservation_bloc/reservation_event.dart';
import '../bloc/reservation_bloc/reservation_state.dart';
import '../model/reservation_model.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    context.read<ReservationBloc>().add(LoadReservationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F56D9),
        centerTitle: true,
        leading: BackButton(color: Colors.white),
        title: const Text(
          "My Booking",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "active_reservations"),
            Tab(text: "cancelled_reservations"),
            Tab(text: "all_reservations"),
          ],
        ),
      ),

      body: BlocBuilder<ReservationBloc, ReservationState>(
        builder: (context, state) {
          if (state is ReservationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReservationError) {
            return Center(child: Text(state.message));
          }

          if (state is ReservationLoaded) {
            return TabBarView(
              controller: tabController,
              children: [
                buildList(state.active, "No active reservations"),
                buildList(state.cancelled, "No cancelled reservations"),
                buildList(state.all, "No reservations"),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget buildList(List<ReservationModel> list, String emptyMessage) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return buildCard(list[index], context);
      },
    );
  }

  Widget buildCard(ReservationModel r, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: context.read<ReservationBloc>(),
      child: ReservationDetailsScreen(reservation: r),
    ),
  ),
);
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔵 الأيقونة على اليسار
          /*Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.home, size: 35, color: Colors.purple),
          ),*/
          FutureBuilder(
  future: ApartmentDetails().fetchApartmentDetails(r.apartmentId),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final details = snapshot.data as ApartmentDetailsModel;
    final imageUrl = details.apartment.imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        placeholder: (_, __) => Image.asset("assets/placeholder.png"),
        errorWidget: (_, __, ___) => Image.asset("assets/placeholder.png"),
      ),
    );
  },
),


          const SizedBox(width: 16),

          // 🔵 النصوص على اليمين
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Apartment #${r.apartmentId}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text("${r.startDate} → ${r.endDate}"),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7F56D9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    r.getStatusLabel(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}