import 'package:booker/screen/appartment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:booker/model/apartment_model.dart';
import 'package:booker/service/favorites_service.dart';

class ApartmentWidget extends StatefulWidget {
  final ApartmentModel model;

  const ApartmentWidget({super.key, required this.model});

  @override
  State<ApartmentWidget> createState() => _ApartmentWidgetState();
}

class _ApartmentWidgetState extends State<ApartmentWidget> {
  bool? isFavorited;
  bool isLoading = false;
  final FavoritesService _favoritesService = FavoritesService();

  @override
  void initState() {
    super.initState();
    // Initialize favorite state from the service's cached favorites
    _initializeFavoriteState();
  }

  Future<void> _initializeFavoriteState() async {
    try {
      final favorites = await _favoritesService.fetchFavorites();
      final isFav = favorites.any((apt) => apt.id == widget.model.id);
      setState(() {
        isFavorited = isFav;
      });
    } catch (e) {
      // If fetch fails, default to not favorited
      setState(() {
        isFavorited = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (isFavorited == true) {
        await _favoritesService.removeFavorite(widget.model.id);
      } else {
        await _favoritesService.addFavorite(widget.model.id);
      }
      setState(() {
        isFavorited = !isFavorited!;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("🔍 رابط الصورة المستلم من الـ API: ${widget.model.imageUrl}");

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ApartmentDetailsScreen(apartmentId: widget.model.id),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.model.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Image.asset('assets/placeholder.png'),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/placeholder.png'),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: isFavorited == null ? null : _toggleFavorite,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              isFavorited == null
                                  ? (Icons.hourglass_empty)
                                  : (isFavorited!
                                        ? Icons.favorite
                                        : Icons.favorite_border),
                              color: isFavorited == null
                                  ? null
                                  : isFavorited!
                                  ? Colors.red
                                  : Colors.grey,
                              size: 24,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ID: ${widget.model.id}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    "${widget.model.city}, ${widget.model.governorate}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${widget.model.rentPrice} SYP",
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
