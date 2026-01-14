import 'package:booker/bloc/home/home_event.dart';
import 'package:booker/bloc/home/home_state.dart';
import 'package:booker/bloc/reservation_bloc/reservation_bloc.dart';
import 'package:booker/bloc/show_profile_bloc/show_profile_bloc.dart';
import 'package:booker/screen/filters_screen.dart';
import 'package:booker/screen/my_reservations_screen.dart';
import 'package:booker/service/bookingreservation_server.dart';
import 'package:booker/service/home_service.dart';
import 'package:booker/service/show_profile_service.dart';
import 'package:booker/ui_components/apartment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../bloc/home/home_bloc.dart';

import '../screen/add_apartment_screen.dart';
import '../screen/favorites_screen.dart';
import '../screen/notifications_screen.dart';
import '../screen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeBloc(service: ApartmentService())..add(const LoadApartments()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  final bloc = context.read<HomeBloc>();
                  if (state is HomeLoading || state is HomeInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is HomeLoaded) {
                    final apartments = state.apartments;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/logo.png', height: 32),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Booker',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications_none,
                                  size: 28,
                                ),
                                color: const Color(0xFF7F56D9),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const NotificationsScreen(),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      currentIndex = 0;
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search property...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.purple,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.filter_list),
                                onPressed: () async {
                                  // فتح صفحة الفلتر، وانتظار العودة إلى هذه الصفحة لإرسال معلومات الفلترة
                                  final event = await Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (context) => FiltersScreen(),
                                        ),
                                      );
                                  if (event != null) {
                                    bloc.add(event);
                                  }

                                  //bloc.add(event);
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: apartments.isEmpty
                              ? const Center(
                                  child: Text(
                                    "There are no apartments available at the moment",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        childAspectRatio: 0.75,
                                      ),
                                  itemCount: apartments.length,
                                  itemBuilder: (context, index) {
                                    return ApartmentWidget(
                                      model: apartments[index],
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  }

                  if (state is HomeError) {
                    return Center(
                      child: Text(
                        "An error occurred while loading the apartments:\n${state.message}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) async {
                setState(() {
                  currentIndex = index;
                });

                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  ).then((_) {
                    setState(() {
                      currentIndex = 0;
                    });
                    // ignore: use_build_context_synchronously
                    context.read<HomeBloc>().add(const LoadApartments());
                  });
                }

                if (index == 2) {
                  final refresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddApartmentScreen(),
                    ),
                  );

                  if (refresh == true) {
                    context.read<HomeBloc>().add(const LoadApartments());
                  }

                  setState(() {
                    currentIndex = 0;
                  });
                }

                if (index == 3) {
                  final token = await getToken();

                  if (token == null || token.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Token not found")),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => ReservationBloc(
                          server: ReservationServer(
                            Dio(BaseOptions(baseUrl: "http://127.0.0.1:8000")),
                          ),
                          token: token,
                        ),
                        child: const MyReservationsScreen(),
                      ),
                    ),
                  ).then((_) {
                    setState(() {
                      currentIndex = 0;
                    });
                  });
                }

                if (index == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) =>
                            UserProfileBloc(server: UserProfileServer()),
                        child: const ProfileScreen(),
                      ),
                    ),
                  ).then((_) {
                    setState(() {
                      currentIndex = 0;
                    });
                  });
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(
                    Icons.home,
                    color: Color.fromRGBO(127, 86, 217, 1),
                  ),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(
                    Icons.favorite,
                    color: Color.fromRGBO(127, 86, 217, 1),
                  ),
                  label: 'Favorites',
                ),
                NavigationDestination(
                  icon: Icon(Icons.add_circle_outline),
                  selectedIcon: Icon(
                    Icons.add_circle,
                    color: Color.fromRGBO(127, 86, 217, 1),
                  ),
                  label: 'Add',
                ),
                NavigationDestination(
                  icon: Icon(Icons.book_outlined),
                  selectedIcon: Icon(
                    Icons.book,
                    color: Color.fromRGBO(127, 86, 217, 1),
                  ),
                  label: 'My Books',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(
                    Icons.person,
                    color: Color.fromRGBO(127, 86, 217, 1),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
