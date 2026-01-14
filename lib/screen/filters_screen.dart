import 'package:booker/ui_components/appDrop_down.dart';

import 'package:booker/ui_components/app_text_form_field.dart';
import 'package:flutter/material.dart';

import '../bloc/home/home_event.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});
  

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final minController = TextEditingController();
  final maxController = TextEditingController();
  int? selectedRoomsNumber;
  int? selectedBathroomsNumber;
  final cityController = TextEditingController();
  final governorateController = TextEditingController();
  final minSpaceController = TextEditingController();
  final maxSpaceController = TextEditingController();
  RangeValues priceRange = const RangeValues(0, 10000000);
  RangeValues spaceRange = const RangeValues(10, 300);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop(
              FilterApartments(
                bathrooms: selectedBathroomsNumber,
                rooms: selectedRoomsNumber,
                maxPrice: priceRange.end.round(),
                minPrice: priceRange.start.round(),
                city: cityController.text.isEmpty ? null : cityController.text,
                governorate: governorateController.text.isEmpty
                    ? null
                    : governorateController.text,
                maxSpace: spaceRange.end.round(),
                minSpace: spaceRange.start.round(),
              ),
            );
          },
          child: const Text('Apply'),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(127, 86, 217, 1), // موف

          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Filters",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
         // title: const Text('Filters')
          
          ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            spacing: 16,
            children: [
              ...priceFilter(),
              ...spaceFilter(),
              roomsFilter(),
              locationFilter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget locationFilter() => Row(
    spacing: 8,
    children: [
      Expanded(
        child: AppTextFormField(controller: cityController, label: 'City'),
      ),
      Expanded(
        child: AppTextFormField(
          controller: governorateController,
          label: 'Governorate',
        ),
      ),
    ],
  );
  Widget roomsFilter() => Row(
    spacing: 8,
    children: [
      Expanded(
        child: AppDropDown(
          items: <int?>[1, 2, 3, 4, 5, 6],
          label: 'Number of Rooms',
          selectedItem: selectedRoomsNumber,
          onChanged: (number) {
            setState(() {
              selectedRoomsNumber = number;
            });
          },
        ),
      ),
      Expanded(
        child: AppDropDown(
          items: <int?>[1, 2, 3],
          label: 'Number of Bathrooms',
          selectedItem: selectedBathroomsNumber,
          onChanged: (number) {
            setState(() {
              selectedBathroomsNumber = number;
            });
          },
        ),
      ),
    ],
  );

  List<Widget> priceFilter() => [
    const Text('Price range', style: TextStyle(fontWeight: FontWeight.w500)),
    RangeSlider(
      values: priceRange,
      min: 0,
      max: 10000000,
      divisions: 40,
      labels: RangeLabels(
        priceRange.start.round().toString(),
        priceRange.end.round().toString(),
      ),
      onChanged: (r) {
        setState(() {
          priceRange = r;
          minController.text = priceRange.start.round().toString();
          maxController.text = priceRange.end.round().toString();
        });
      },
    ),
    Row(
      spacing: 8,
      children: [
        Expanded(
          child: AppTextFormField(
            keyboardType: TextInputType.number,
            controller: minController,
            label: 'Minimum Price',
            onChanged: (v) {
              final val = double.tryParse(v) ?? priceRange.start;
              setState(() {
                priceRange = RangeValues(
                  val.clamp(0, priceRange.end),
                  priceRange.end,
                );
              });
            },
          ),
        ),
        Expanded(
          child: AppTextFormField(
            keyboardType: TextInputType.number,
            controller: maxController,
            label: 'Maximum Price',
            onChanged: (v) {
              final val = double.tryParse(v) ?? priceRange.end;
              setState(() {
                priceRange = RangeValues(
                  priceRange.start,
                  val.clamp(priceRange.start, 10000000),
                );
              });
            },
          ),
        ),
      ],
    ),
  ];

  List<Widget> spaceFilter() => [
    const Text('Space range', style: TextStyle(fontWeight: FontWeight.w500)),
    RangeSlider(
      values: spaceRange,
      min: 0,
      max: 300,
      divisions: 30,
      labels: RangeLabels(
        spaceRange.start.round().toString(),
        spaceRange.end.round().toString(),
      ),
      onChanged: (r) {
        setState(() {
          spaceRange = r;
          minSpaceController.text = spaceRange.start.round().toString();
          maxSpaceController.text = spaceRange.end.round().toString();
        });
      },
    ),
    Row(
      spacing: 8,
      children: [
        Expanded(
          child: AppTextFormField(
            keyboardType: TextInputType.number,
            controller: minSpaceController,
            label: 'Minimum Space',
            onChanged: (v) {
              final val = double.tryParse(v) ?? spaceRange.start;
              setState(() {
                spaceRange = RangeValues(
                  val.clamp(0, spaceRange.end),
                  spaceRange.end,
                );
              });
            },
          ),
        ),
        Expanded(
          child: AppTextFormField(
            keyboardType: TextInputType.number,
            controller: maxSpaceController,
            label: 'Maximum Space',
            onChanged: (v) {
              final val = double.tryParse(v) ?? spaceRange.end;
              setState(() {
                spaceRange = RangeValues(
                  spaceRange.start,
                  val.clamp(spaceRange.start, 300),
                );
              });
            },
          ),
        ),
      ],
    ),
  ];
}