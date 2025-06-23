import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/location_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final locationVM = Provider.of<LocationViewModel>(context, listen: false);
    locationVM.fetchProvinces();

    _searchController.addListener(() {
      locationVM.searchProvinces(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationVM = Provider.of<LocationViewModel>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xffFCFCFC),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xff1976D2),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      controller: _searchController,
                      hintText: 'Tìm kiếm tỉnh/thành phố',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.search, color: Colors.grey),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                locationVM.searchProvinces('');
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            if (locationVM.isLoadingProvinces)
              const Center(child: CircularProgressIndicator())
            else if (locationVM.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  locationVM.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (locationVM.provinces.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Không có tỉnh/thành phố nào để hiển thị',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: locationVM.provinces.length,
                  separatorBuilder: (_, __) => const Divider(color: Color(0xffD5D7DB), height: 1),
                  itemBuilder: (context, index) {
                    final province = locationVM.provinces[index];
                    return ListTile(
                      title: Text(
                        province['name'] ?? 'Không xác định',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        _searchController.text = province['name'] ?? '';
                        Navigator.pop(context, province);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
