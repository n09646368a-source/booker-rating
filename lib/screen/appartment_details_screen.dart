import 'package:booker/bloc/booking_bloc/booking_bloc_bloc.dart';
import 'package:booker/service/details_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:booker/bloc/apartment_details/apartment_details_bloc.dart';
import 'package:booker/bloc/apartment_details/apartment_details_event.dart';
import 'package:booker/bloc/apartment_details/apartment_details_state.dart';
import 'package:booker/service/profil_auth_service.dart';
import 'package:booker/screen/rent_screen.dart';
import 'package:booker/service/booking_server.dart';
import 'package:dio/dio.dart';

class ApartmentDetailsScreen extends StatelessWidget {
  final int apartmentId;
  const ApartmentDetailsScreen({super.key, required this.apartmentId});

  static const Color mainColor = Color.fromRGBO(127, 86, 217, 1);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ApartmentDetailsBloc(ApartmentDetails())
            ..add(LoadApartmentDetails(apartmentId)),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Apartment Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<ApartmentDetailsBloc, ApartmentDetailsState>(
          builder: (context, state) {
            if (state is ApartmentDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ApartmentDetailsFailure) {
              return Center(child: Text("Error: ${state.error}"));
            }
            if (state is ApartmentDetailsSuccess) {
              final model = state.details;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: model.apartment.imageUrl,
                      placeholder: (_, __) =>
                          Image.asset("assets/placeholder.png"),
                      errorWidget: (_, __, ___) =>
                          Image.asset("assets/placeholder.png"),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      "${model.apartment.city}, ${model.apartment.governorate}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "${model.apartment.rentPrice} SYP / month",
                      style: const TextStyle(
                        fontSize: 18,
                        color: mainColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoItem(Icons.bed, "${model.apartment.rooms} Beds"),
                        _infoItem(
                          Icons.bathtub,
                          "${model.apartment.bathrooms} Baths",
                        ),
                        _infoItem(
                          Icons.square_foot,
                          "${model.apartment.apartmentSpace} sqft",
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: CachedNetworkImage(
                            imageUrl: model.profile.personalImage ?? "",
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            model.profile.fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _circleIcon(
                          icon: Icons.phone,
                          color: Colors.green,
                          onTap: () {
                            print(model.owner.phoneNumber);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final repo = ProfileRepository();
                          final profile = await repo.loadProfile();

                          if (profile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill your profile first"),
                              ),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => BookingBloc(
                                  bookingServer: BookingServer(dio: Dio()),
                                ),
                                child: SelectDateScreen(
                                  model: model.apartment,
                                  profile: profile,
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Rent Now",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: mainColor, size: 20),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }

  Widget _circleIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
