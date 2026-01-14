import 'package:booker/screen/appartment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:booker/model/apartment_model.dart';

class ApartmentWidget extends StatelessWidget {
  final ApartmentModel model;

  const ApartmentWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    print("🔍 رابط الصورة المستلم من الـ API: ${model.imageUrl}");

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ApartmentDetailsScreen(apartmentId: model.id),
            //builder: (_) => ApartmentDetailsScreen(apartmentId: model.id),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: model.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Image.asset('assets/placeholder.png'),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/placeholder.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID: ${model.id}", style: const TextStyle(fontSize: 12)),
                  Text(
                    "${model.city}, ${model.governorate}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${model.rentPrice} SYP",
                    style: const TextStyle(color: Colors.purple),
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

