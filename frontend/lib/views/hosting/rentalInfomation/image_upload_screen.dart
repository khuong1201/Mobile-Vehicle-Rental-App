import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/customs_box_image.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  final String? vehicleType;
  final Function(Map<String, dynamic>) onDataChanged;
  final GlobalKey<FormState> formKey;
  const ImageUploadScreen({super.key, this.vehicleType, required this.onDataChanged, required this.formKey});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile? _profilePicture;
  XFile? _frontViewPicture;
  XFile? _backViewPicture;
  XFile? _leftViewPicture;
  XFile? _rightViewPicture;

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        switch (type) {
          case 'profile':
            _profilePicture = image;
            break;
          case 'front':
            _frontViewPicture = image;
            break;
          case 'back':
            _backViewPicture = image;
            break;
          case 'left':
            _leftViewPicture = image;
            break;
          case 'right':
            _rightViewPicture = image;
            break;
        }
      });
      _saveData();
    }
  }

  void _saveData() {  
    final data = {
      'images': {
        'profile': _profilePicture,
        'front': _frontViewPicture,
        'back': _backViewPicture,
        'left': _leftViewPicture,
        'right': _rightViewPicture,
      },
      'type': widget.vehicleType,
    };
    widget.onDataChanged(data);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: CustomBoxImage(
                hintText: 'Take a photo',
                title: 'Profile picture',
                image: _profilePicture,
                onPickImage: () => _pickImage('profile'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomBoxImage(
                    title: 'Front view picture',
                    hintText: 'Take a photo',
                    image: _frontViewPicture,
                    onPickImage: () => _pickImage('front'),
                    validator: (image) => image == null ? 'Image is required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomBoxImage(
                    title: 'Back view picture',
                    hintText: 'Take a photo',
                    image: _backViewPicture,
                    onPickImage: () => _pickImage('back'),
                    validator: (image) => image == null ? 'Image is required' : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomBoxImage(
                    title: 'Left view picture',
                    hintText: 'Take a photo',
                    image: _leftViewPicture,
                    onPickImage: () => _pickImage('left'),
                    validator: (image) => image == null ? 'Image is required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomBoxImage(
                    title: 'Right view picture',
                    hintText: 'Take a photo',
                    image: _rightViewPicture,
                    onPickImage: () => _pickImage('right'),
                    validator: (image) => image == null ? 'Image is required' : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
