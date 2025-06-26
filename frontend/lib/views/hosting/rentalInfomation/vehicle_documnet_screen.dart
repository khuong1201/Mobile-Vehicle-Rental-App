import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/customs_box_image.dart';
import 'package:image_picker/image_picker.dart';

class DocumentScreen extends StatefulWidget {
  final String? vehicleType;
  final Function(Map<String, dynamic>) onDataChanged;
  final GlobalKey<FormState> formKey;
  const DocumentScreen({
    super.key,
    this.vehicleType,
    required this.onDataChanged,
    required this.formKey,
  });

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile? _documentPicture;

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _documentPicture = image;
      });
      _saveData();
    }
  }

  void _saveData() {
    final data = {
      'imagesRegistration':
          _documentPicture != null ? {'document': _documentPicture} : {},
      'type': widget.vehicleType,
    };
    widget.onDataChanged(data);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Registration',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomBoxImage(
              title: 'dockument',
              hintText: 'Take a photo',
              image: _documentPicture,
              onPickImage: () => _pickImage('document'),
              validator: (image) => image == null ? 'Image is required' : null,
            ),
          ),
        ],
      ),
    );
  }
}
