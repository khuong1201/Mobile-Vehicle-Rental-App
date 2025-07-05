import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/location/location_for_vehicle.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/hosting/rentalInfomation/location/location_screen.dart';
import 'package:frontend/views/widgets/custom_dropdown_formfield.dart';
import 'package:frontend/views/widgets/custom_text_body_l.dart';
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
  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _vehicleType;
  Brand? _selectedBrand;
  String? _numberSeats;
  String? _typeFuel;
  String? _transMission;
  LocationForVehicle? _locationForVehicle;

  @override
  void initState() {
    super.initState();
    _vehicleType = widget.vehicleType;
    Future.microtask(() {
      Provider.of<VehicleViewModel>(context, listen: false).fetchBrands(context);
    });
  }

  void _saveData() {
    Map<String, dynamic>? locationData;
  locationData = LocationForVehicle(
    address: _locationController.text.toString(),
    lat: 0.0,
    lng: 0.0,
  ).toJson();
    final data = {
      'licensePlate': _licensePlateController.text,
      'vehicleName': _vehicleNameController.text,
      'yearOfManufacture': _yearController.text,
      'location': locationData,
      'description': _descriptionController.text,
      'brand': _selectedBrand?.id ?? '',
      'numberSeats': _numberSeats,
      'fuelType': _typeFuel.toString(),
      'type': widget.vehicleType,
      'transmission': _transMission
      
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
            CustomTextBodyL(title: 'Vehicle name'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _vehicleNameController,
              hintText: 'Enter vehicle name ',
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
                if (_vehicleType == 'car' || _vehicleType == 'coach')
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
            if (_vehicleType == 'car' || _vehicleType == 'coach')
              const SizedBox(height: 16),
            if (_vehicleType == 'car' || _vehicleType == 'coach')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextBodyL(title: 'Drivetrain'),
                  const SizedBox(height: 8),
                  CustomDropdownButtonFormField(
                    value: _transMission,
                    onChanged: (value) {
                      setState(() {
                        _transMission = value;
                        _saveData();
                      });
                    },
                    items: ['Manual', 'Automatic'],
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
              const SizedBox(height: 16),
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
                if (_locationForVehicle == null) {
                  return 'Please select location';
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: () async {
                final result = await Navigator.push<LocationForVehicle?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationScreen(),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _locationController.text = result.address;
                    _locationForVehicle = result;
                    //_locationController.text = result.toString();
                    _saveData();
                  });
                }
              },
                icon: Icon(Icons.arrow_forward_ios, size: 18)
              )
            ),
            const SizedBox(height: 16),
            CustomTextBodyL(title: 'Description'),
            const SizedBox(height: 8),
            CustomTextField(
              maxline: 5,
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
