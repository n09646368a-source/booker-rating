import 'dart:io';
import 'package:booker/bloc/add_apartment/add_apartment_bloc.dart';
import 'package:booker/service/add_apartment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:booker/bloc/add_apartment/add_apartment_event.dart';
import 'package:booker/bloc/add_apartment/add_apartment_state.dart';

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({super.key});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final cityController = TextEditingController();
  final governorateController = TextEditingController();
  final rentPriceController = TextEditingController();
  final spaceController = TextEditingController();
  final roomsController = TextEditingController();
  final floorController = TextEditingController();
  final bathroomsController = TextEditingController();

  File? imageFile;

  Future<void> pickImage({required ImageSource source}) async {
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null) {
        setState(() {
          imageFile = File(picked.path);
        });
      }
    } catch (e) {
      print("❌ Image picking failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to pick image")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApartmentBloc(repository: ApartmentRepository()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(127, 86, 217, 1), // موف
          centerTitle: true,
          leading: BackButton(color: Colors.white), // النص بالنص
          title: const Text(
            "Add Apartment",
style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.w600,
              color: Colors.white,
              
              ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<ApartmentBloc, ApartmentState>(
            listener: (context, state) {
              if (state is ApartmentSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Apartment added successfully"),
                  ),
                );

                // 🔥 أهم تعديل: رجوع قيمة true للـ Home Screen
                Navigator.pop(context, true);
              }

              if (state is ApartmentError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("❌ Error: ${state.message}")),
                );
              }
            },
            builder: (context, state) {
              if (state is ApartmentLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Row 1: City + Governorate
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: cityController,
                            decoration: const InputDecoration(
                              labelText: "City",
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Enter city" : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: governorateController,
                            decoration: const InputDecoration(
                              labelText: "Governorate",
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Enter governorate" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row 2: Rooms + Floor
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: roomsController,
                            decoration: const InputDecoration(
                              labelText: "Rooms",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? "Enter rooms" : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: floorController,
                            decoration: const InputDecoration(
                              labelText: "Floor",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? "Enter floor" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row 3: Bathrooms + Space
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: bathroomsController,
                            decoration: const InputDecoration(
                              labelText: "Bathrooms",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? "Enter bathrooms" : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: spaceController,
                            decoration: const InputDecoration(
                              labelText: "Space (m²)",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? "Enter space" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row 4: Rent Price
                    TextFormField(
                      controller: rentPriceController,
                      decoration: const InputDecoration(
                        labelText: "Rent Price",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? "Enter rent price" : null,
                    ),
                    const SizedBox(height: 16),

                    // Image Picker + Preview
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () =>
                              pickImage(source: ImageSource.gallery),
                          icon: const Icon(Icons.photo),
                          label: const Text("Gallery"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () =>
                              pickImage(source: ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Camera"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (imageFile != null)
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.file(imageFile!, fit: BoxFit.cover),
                      ),

                    const SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(127, 86, 217, 1),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            imageFile != null) {
                          context.read<ApartmentBloc>().add(
                            SubmitApartment(
                              city: cityController.text,
                              governorate: governorateController.text,
                              rentPrice: rentPriceController.text,
                              apartmentSpace: spaceController.text,
                              rooms: roomsController.text,
                              floor: floorController.text,
                              bathrooms: bathroomsController.text,
                              apartmentImage: imageFile!,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "❌ Please fill all fields and pick an image",
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Add Apartment",
                        style: TextStyle(
                          color: Colors.white, // النص أبيض
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
