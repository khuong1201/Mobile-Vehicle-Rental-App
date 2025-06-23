import 'package:flutter/material.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/hosting/rentalInfomation/location/location_screen.dart';
import 'package:frontend/views/widgets/custom_dropdown_formfield.dart';
import 'package:frontend/views/widgets/custom_text_body_L.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class VehicleInfomationScreen extends StatefulWidget {
  final String? vehicleType;
  final Function(Map<String, dynamic>) onDataChanged;
  const VehicleInfomationScreen({super.key, this.vehicleType, required this.onDataChanged});

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

  String? _vehicleType;
  Brand? _selectedBrand;
  String? _numberSeats;
  String? _typeFuel;
  String? _fuelConsumption;
  Location? _location;

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
      'yearOfManufacture': int.tryParse(_yearController.text),
      'location': _location?.toJson(),
      'description': _descriptionController.text,
      'brand': _selectedBrand?.brandName,
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
            CustomDropdownButtonFormField(
              value: _selectedBrand?.brandName,
              onChanged: (value) {
                setState(() {
                  _selectedBrand = brands.firstWhere(
                    (b) => b.brandName == value,
                  );
                  _saveData();
                });
              },
              items: brands.map((b) => b.brandName).toList(),
              hintText: 'Choose Car Brand',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select';
                }
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
                if (_vehicleType == 'car' || _vehicleType == 'coach')
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
                              _numberSeats == value;
                              _saveData();
                            });
                          },
                          items: ['4','5','7','9','16','30'],
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
            if (_vehicleType == 'car' || _vehicleType == 'coach')
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
                              _typeFuel == value;
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
                              _numberSeats == value;
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
            CustomTextField(
              hintText: 'Enter the Car Location',
              controller: TextEditingController(text: _location?.address ?? ''),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Location';
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => LocationScreen())
                  );
                }, 
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff2B2B2C),
                  size: 18
                )
              ),
              onChanged: (_) => _saveData(),
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
