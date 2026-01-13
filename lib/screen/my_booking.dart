import 'package:booker/service/booking_server.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:booker/model/booking_model.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color primaryColor = const Color(0xFF7F56D9);

  late BookingServer bookingServer;

  List<BookingModel> upcoming = [];
  List<BookingModel> completed = [];
  List<BookingModel> cancelled = [];

  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // السيرفر ما عاد يحتاج token
    bookingServer = BookingServer(dio: Dio());
    loadBookings();
  }

  Future<void> loadBookings() async {
    setState(() {
      loading = true;
      error = false;
    });

    try {
      final data = await bookingServer.getMyReservations();

      final activeList = (data["active_reservations"] as List)
          .map((e) => BookingModel.fromJson(e))
          .toList();

      final cancelledList = (data["cancelled_reservations"] as List)
          .map((e) => BookingModel.fromJson(e))
          .toList();

      final allList = (data["all_reservations"] as List)
          .map((e) => BookingModel.fromJson(e))
          .toList();

      setState(() {
        upcoming = activeList;
        cancelled = cancelledList;
        completed = allList
            .where((b) => b.status.toLowerCase() == "completed")
            .toList();
        loading = false;
        error = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget bookingCard(BookingModel item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.image,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "${item.startDate} - ${item.endDate}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.status,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildList(List<BookingModel> data) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Failed to load bookings"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: loadBookings,
              child: const Text("Retry"),
            )
          ],
        ),
      );
    }

    if (data.isEmpty) {
      return const Center(child: Text("No bookings found"));
    }

    return RefreshIndicator(
      onRefresh: loadBookings,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => bookingCard(data[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF7F56D9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "My Booking",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black54,
              indicator: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              tabs: const [
                Tab(text: "Upcoming"),
                Tab(text: "Completed"),
                Tab(text: "Cancelled"),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildList(upcoming),
                buildList(completed),
                buildList(cancelled),
              ],
            ),
          ),
        ],
      ),
    );
  }
}