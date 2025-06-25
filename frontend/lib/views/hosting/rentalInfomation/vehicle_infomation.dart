import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/location/location.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/hosting/rentalInfomation/location/location_screen.dart';
import 'package:frontend/views/widgets/custom_dropdown_formfield.dart';
import 'package:frontend/views/widgets/custom_text_body_L.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class VehicleInfomationScreen extends StatefulWidget {
  final String? vehicleType;
  final Function(Map<String, dynamic>) onDataChanged;
  const VehicleInfomationScreen({
    super.key,
    this.vehicleType,
    required this.onDataChanged,
  });

  @override
  State<VehicleInfomationScreen> createState() =>
      _VehicleInfomationScreenState();
}

class _VehicleInfomationScreenState extends State<VehicleInfomationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _vehicleType;
  Brand? _selectedBrand;
  String? _numberSeats;
  String? _typeFuel;
  String? _fuelConsumption;
  Locations? _location;

  @override
  void initState() {
    super.initState();
    _vehicleType = widget.vehicleType;
    Future.microtask(() {
      Provider.of<VehicleViewModel>(
        context,
        listen: false,
      ).fetchBrands(context);
    });
  }

  void _saveData() {
    final data = {
      'licensePlate': _licensePlateController.text,
      'model': _modelController.text,
      'yearOfManufacture': _yearController.text,
      'location': _location?.toJson(),
      'description': _descriptionController.text,
      'brand': _selectedBrand?.id ?? '',
      'numberSeats': _numberSeats,
      'fuelType': _typeFuel,
      'fuelConsumption': _fuelConsumption,
      'vehicleType': widget.vehicleType ?? 'vehicle',
      
    };
    widget.onDataChanged(data);
  }

  @override
  Widget build(BuildContext context) {
    final brands = Provider.of<VehicleViewModel>(context).brands;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextBodyL(title: 'License Plate'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _licensePlateController,
              hintText: 'Enter License Plate',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter License Plate';
                }
                return null;
              },
              onChanged: (_) => _saveData(),
            ),
            const SizedBox(height: 16),
            CustomTextBodyL(title: 'Brand'),
            const SizedBox(height: 8),
            CustomDropdownButtonFormField<Brand>(
              value: _selectedBrand,
              onChanged: (value) {
                setState(() {
                  _selectedBrand = value;
                  _saveData();
                });
              },
              items: brands,
              hintText: 'Choose Car Brand',
              itemBuilder:
                  (brand) => Row(
                    children: [
                      if (brand.brandImage != null)
                        SvgPicture.network(brand.brandImage!, width: 24, height: 24),
                      SizedBox(width: 8),
                      Text(brand.brandName),
                    ],
                  ),
              validator: (value) {
                if (value == null) return 'Please select';
                return null;
              },
            ),

            const SizedBox(height: 16),
            CustomTextBodyL(title: 'Model'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _modelController,
              hintText: 'Enter Model',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Model';
                }
                return null;
              },
              onChanged: (_) => _saveData(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextBodyL(title: 'Year of Manufacture'),
                      const SizedBox(height: 8),
                      CustomTextField(
                        keyboardType: TextInputType.numberWithOptions(),
                        hintText: 'Year',
                        controller: _yearController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter year';
                          }
                          return null;
                        },
                        onChanged: (_) => _saveData(),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24),
                if (_vehicleType == 'Car' || _vehicleType == 'Coach')
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextBodyL(title: 'Numbers of Seats'),
                        const SizedBox(height: 8),
                        CustomDropdownButtonFormField(
                          value: _numberSeats,
                          onChanged: (value) {
                            setState(() {
                              _numberSeats = value;
                              _saveData();
                            });
                          },
                          items: ['4', '5', '7', '9', '16', '30'],
                          hintText: 'Number',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please choose number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextBodyL(title: 'Drivetrain'),
            const SizedBox(height: 16),
            if (_vehicleType == 'Car' || _vehicleType == 'Coach')
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextBodyL(title: 'Fuel'),
                        const SizedBox(height: 8),
                        CustomDropdownButtonFormField(
                          value: _typeFuel,
                          onChanged: (value) {
                            setState(() {
                              _typeFuel = value;
                              _saveData();
                            });
                          },
                          items: [],
                          hintText: 'Type',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please choose type';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextBodyL(title: 'Fuel Consumption'),
                        const SizedBox(height: 8),
                        CustomDropdownButtonFormField(
                          value: _fuelConsumption,
                          onChanged: (value) {
                            setState(() {
                              _numberSeats = value;
                              _saveData();
                            });
                          },
                          items: [],
                          hintText: 'L/km',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter number seats';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            CustomTextBodyL(title: 'Car Location'),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push<Locations?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationScreen(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    _location = result;
                    _locationController.text = result.toString();
                    _saveData();
                  });
                }
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  hintText: 'Select car location',
                  controller: _locationController,
                  suffixIcon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Color(0xff2B2B2C),
                  ),
                  validator: (value) {
                    if (_location == null) {
                      return 'Please select location';
                    }
                    return null;
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),
            CustomTextBodyL(title: 'Description'),
            CustomTextField(
              hintText: 'Enter the description of your car',
              controller: _descriptionController,
              onChanged: (_) => _saveData(),
            ),
          ],
        ),
      ),
    );
  }
}
