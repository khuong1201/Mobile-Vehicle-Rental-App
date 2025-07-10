import 'package:flutter/material.dart';
import 'package:frontend/views/myAcount/driver_license_screen.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_text_body_m_sb.dart';
import 'package:provider/provider.dart';
import 'package:frontend/viewmodels/user/user_license_viewmodel.dart';

class DriverLicenseListScreen extends StatefulWidget {
  const DriverLicenseListScreen({super.key});

  @override
  State<DriverLicenseListScreen> createState() =>
      _DriverLicenseListScreenState();
}

class _DriverLicenseListScreenState extends State<DriverLicenseListScreen> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<UserLicenseViewModel>(context, listen: false);
    vm.loadUserLicenseFromProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        backgroundColor: const Color(0xff1976D2),
        title: 'All Driver Licenses',
        textColor: const Color(0xffFFFFFF),
        height: 80,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Consumer<UserLicenseViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.licenses.isEmpty) {
              return const Center(child: Text("No licenses found."));
            }

            return ListView.builder(
              itemCount: vm.licenses.length,
              itemBuilder: (context, index) {
                final license = vm.licenses[index];
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DriverLicenseScreen(license: license),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 9,
                              offset: Offset(0, 3),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 190,
                              height: 125,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    license.frontImage.isNotEmpty
                                        ? license.frontImage
                                        : 'https://via.placeholder.com/150',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextBodyMsb(
                                    title: license.classLicense,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: ShapeDecoration(
                                          color:
                                              license.status.toLowerCase() ==
                                                      'approved'
                                                  ? const Color(0xFF4CAF50)
                                                  : license.status
                                                          .toLowerCase() ==
                                                      'pending'
                                                  ? const Color(0xFFFFC107)
                                                  : Colors.red,
                                          shape: OvalBorder(),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        license.status,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.29,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Type: ${license.typeDriverLicense}',
                                    style: TextStyle(
                                      color: const Color(0xFF2B2B2C),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'License Number: ${license.licenseNumber}',
                                    style: TextStyle(
                                      color: const Color(0xFF2B2B2C),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: Colors.grey),
                        onSelected: (value) async {
                          if (value == 'delete') {
                            final vm = Provider.of<UserLicenseViewModel>(
                              context,
                              listen: false,
                            );
                            final success = await vm.deleteDriverLicense(licenseId: license.licenseId);

                            if (!success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    vm.errorMessage ?? 'Xoá thất bại',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Xoá'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: CustomButton(
          title: 'Create',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DriverLicenseScreen()),
            );
          },
        ),
      ),
    );
  }
}
