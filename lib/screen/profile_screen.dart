import 'package:booker/bloc/show_profile_bloc/show_profile_bloc.dart';
import 'package:booker/bloc/show_profile_bloc/show_profile_event.dart';
import 'package:booker/bloc/show_profile_bloc/show_profile_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserProfileBloc>().add(LoadUserProfileEvent());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F56D9),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserProfileError) {
            return Center(child: Text(state.message));
          }

          if (state is UserProfileLoaded) {
            final p = state.profile;

            return Column(
              children: [
                const SizedBox(height: 30),

               Center(
  child: ClipOval(
    child: CachedNetworkImage(
      imageUrl: p.personalImage ?? "",
      width: 90,
      height: 90,
      fit: BoxFit.cover,
      placeholder: (_, __) => Image.asset("assets/placeholder.png"),
      errorWidget: (_, __, ___) => Image.asset("assets/placeholder.png"),
    ),
  ),
),

                const SizedBox(height: 12),
                Text(
                  p.fullName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      buildTile(Icons.edit, "Edit Profile", () {}),
                      buildTile(Icons.language, "Language", () {}),
                      buildTile(Icons.brightness_6, "Theme", () {}),
                      buildTile(Icons.logout, "Logout", () {}),
                      buildTile(Icons.verified_user, "Approval Requests", () {}),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget buildTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF7F56D9)),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}