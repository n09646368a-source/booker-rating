import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/favorites/favorites_state.dart';
import '../service/favorites_service.dart';
import '../ui_components/apartment_widget.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesBloc>(
      create: (_) =>
          FavoritesBloc(service: FavoritesService())
            ..add(const LoadFavorites()),
      child: Scaffold(
        appBar: AppBar(title: Text('Favorites')),
        body: SafeArea(
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final bloc = context.read<FavoritesBloc>();
              if (state is FavoritesLoading || state is FavoritesInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is FavoritesLoaded) {
                final apartments = state.apartments;

                return Expanded(
                  child: apartments.isEmpty
                      ? const Center(
                          child: Text(
                            " You don't have favorites at the moment  ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                          itemCount: apartments.length,
                          itemBuilder: (context, index) {
                            return ApartmentWidget(model: apartments[index]);
                          },
                        ),
                );
              }

              if (state is FavoritesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Text(
                        "An error occurred while loading the favorites:\n${state.message}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          bloc.add(const LoadFavorites());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
