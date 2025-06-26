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
  final GlobalKey<FormState> formKey;

  const VehicleInfomationScreen({
    super.key,
    this.vehicleType,
    required this.onDataChanged,
    required this.formKey,
  });

  @override
  State<VehicleInfomationScreen> createState() => _VehicleInfomationScreenState();
}

class _VehicleInfomationScreenState extends State<VehicleInfomationScreen> {
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
      Provider.of<VehicleViewModel>(context, listen: false).fetchBrands(context);
    });
  }

  void _saveData() {
    final data = {
      'licensePlate': _licensePlateController.text,
      'model': _modelController.text,
      'yearOfManufacture': _yearController.text,
      'location': _locationController.text,
      'description': _descriptionController.text,
      'brand': _selectedBrand?.id ?? '',
      'numberSeats': _numberSeats,
      'fuelType': _typeFuel,
      'fuelConsumption': _fuelConsumption,
      'type': widget.vehicleType,
      
    };

    widget.onDataChanged(data);
  }

  @override
  Widget build(BuildContext context) {
    final brands = Provider.of<VehicleViewModel>(context).brands;

    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
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

            // Brand
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
              itemBuilder: (brand) => Row(
                children: [
                  if (brand.brandImage != null)
                    SvgPicture.network(brand.brandImage!, width: 24, height: 24),
                  const SizedBox(width: 8),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextBodyL(title: 'Year of Manufacture'),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _yearController,
                        hintText: 'Year',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập năm sản xuất';
                          }
                          final year = int.tryParse(value);
                          if (year == null || year < 1900 || year > DateTime.now().year) {
                            return 'Năm sản xuất không hợp lệ';
                          }
                          return null;
                        },
                        onChanged: (_) => _saveData(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                if (_vehicleType == 'car' || _vehicleType == 'coach')
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextBodyL(title: 'Number of Seats'),
                        const SizedBox(height: 8),
                        CustomDropdownButtonFormField(
                          value: _numberSeats,
                          onChanged: (value) {
                            setState(() {
                              _numberSeats == value;
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

            const SizedBox(height: 8),
            CustomTextBodyL(title: 'Fuel Type'),
            const SizedBox(height: 8),
            CustomDropdownButtonFormField(
              value: _typeFuel,
              onChanged: (value) {
                setState(() {
                  _typeFuel = value;
                  _saveData();
                });
              },
              items: ['Gasoline', 'Diesel', 'Electric'],
              hintText: 'Type',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose type';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            CustomTextBodyL(title: 'Location'),
            CustomTextField(
              controller: _locationController,
              hintText: 'Select car location',
              validator: (value) {
                if (_location == null) {
                  return 'Please select location';
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: () async {
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
                icon: Icon(Icons.arrow_forward_ios, size: 18)
              )
            ),
            // GestureDetector(
            //   onTap: () async {
            //     final result = await Navigator.push<Locations?>(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const LocationScreen(),
            //       ),
            //     );
            //     if (result != null) {
            //       setState(() {
            //         _location = result;
                    
            //         _locationController.text = result.toString();
            //         _saveData();
            //       });
            //     }
            //   },
            //   child: AbsorbPointer(
            //     child: CustomTextField(
            //       controller: _locationController,
            //       hintText: 'Select car location',
            //       validator: (value) {
            //         if (_location == null) {
            //           return 'Please select location';
            //         }
            //         return null;
            //       },
            //       suffixIcon: const Icon(Icons.arrow_forward_ios, size: 18),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 16),
            CustomTextBodyL(title: 'Description'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _descriptionController,
              hintText: 'Description about your car',
              onChanged: (_) => _saveData(),
            ),
          ],
        ),
      ),
    );
  }
}
