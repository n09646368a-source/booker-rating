import 'dart:io';
import 'package:booker/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:booker/bloc/profile_bloc/profile_bloc.dart';
import 'package:booker/bloc/profile_bloc/profile_event.dart';
import 'package:booker/bloc/profile_bloc/profile_state.dart';
import 'package:booker/service/profil_auth_service.dart';

class FillProfile extends StatefulWidget {
  @override
  State<FillProfile> createState() => _FillProfileState();
}

class _FillProfileState extends State<FillProfile> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  File? personalImage;
  File? idImage;

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final formatted =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      setState(() {
        dateOfBirthController.text = formatted;
      });
    }
  }

  Future<void> pickImage(bool isPersonal) async {
    final picker = ImagePicker();

    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Image Source"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = path.basename(pickedFile.path);
        final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

        setState(() {
          if (isPersonal) {
            personalImage = savedImage;
          } else {
            idImage = savedImage;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyProfileBloc(ProfileRepository()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF7F56D9),
          centerTitle:true,
          automaticallyImplyLeading: false,  
         /* leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),*/
          title: const Text(
            "Fill Your Profile",
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.w600,
              color: Colors.white,
              
              ),
          ),
        ),
        body: BlocConsumer<VerifyProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile saved successfully")),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            }

            if (state is ProfileFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 49),

                    // صورة شخصية
                    InkWell(
                      onTap: () => pickImage(true),
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF7F56D9),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade300,
                              child: personalImage == null
                                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                                  : ClipOval(
                                      child: Image.file(
                                        personalImage!,
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: const Icon(Icons.add, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 61),

                    buildTextField("First Name", firstNameController),
                    const SizedBox(height: 21),
                    buildTextField("Last Name", lastNameController),
                    const SizedBox(height: 21),

                    InkWell(
                      onTap: pickDate,
                      child: IgnorePointer(
                        child: buildTextField("Date of birth", dateOfBirthController),
                      ),
                    ),

                    const SizedBox(height: 21),

                    // صورة الهوية
                    InkWell(
                      onTap: () => pickImage(false),
                      child: Container(
                        width: 327,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF7F56D9), width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: idImage == null
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Icon(Icons.camera_alt, size: 20, color: Colors.grey),
                                  ),
                                  Text(
                                    "Add ID Image",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  idImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 63),

                    // زر Continue
                    InkWell(
                      onTap: () {
                        if (firstNameController.text.isEmpty ||
                            lastNameController.text.isEmpty ||
                            dateOfBirthController.text.isEmpty ||
                            personalImage == null ||
                            idImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please fill all fields")),
                          );
                          return;
                        }

                        context.read<VerifyProfileBloc>().add(
                          SubmitProfileEvent(
                            firstName: firstNameController.text.trim(),
                            lastName: lastNameController.text.trim(),
                            dateOfBirth: dateOfBirthController.text.trim(),
                            personalImage: personalImage!,
                            idImage: idImage!,
                          ),
                        );
                      },
                      child: Container(
                        width: 327,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFF7F56D9),
                        ),
                        child: Center(
                          child: state is ProfileLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Continue",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller) {
    return SizedBox(
      width: 327,
      height: 50,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF7F56D9), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF7F56D9), width: 2),
          ),
        ),
      ),
    );
  }
}