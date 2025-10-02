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
  late final UserLicenseViewModel _vm;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ Lưu reference context an toàn tại đây
    _vm = Provider.of<UserLicenseViewModel>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    // ✅ Dời load dữ liệu vào postFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _vm.loadUserLicenseFromProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        backgroundColor: const Color(0xff1976D2),
        title: 'All Driver Licenses',
        textColor: Colors.white,
        height: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<UserLicenseViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.licenses.isEmpty) {
              return const Center(child: Text("No licenses found."));
            }

            return RefreshIndicator(
              onRefresh: () async {
                await vm.loadUserLicenseFromProfile();
              },
              child: ListView.builder(
                itemCount: vm.licenses.length,
                itemBuilder: (context, index) {
                  final license = vm.licenses[index];
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!context.mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DriverLicenseScreen(license: license),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 9,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 140,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      license.frontImage.isNotEmpty
                                          ? license.frontImage
                                          : 'https://via.placeholder.com/150',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextBodyMsb(
                                      title: 'Class: ${license.classLicense}',
                                    ),
                                    const SizedBox(height: 8),
                                    Text('Type: ${license.typeDriverLicense}'),
                                    Text('Number: ${license.licenseNumber}'),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: license.status == 'approved'
                                                ? Colors.green
                                                : license.status == 'pending'
                                                    ? Colors.amber
                                                    : Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          license.status,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
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
                          icon: const Icon(Icons.more_vert, color: Colors.grey),
                          onSelected: (value) async {
                            if (value == 'delete') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Confirm delete'),
                                  content: const Text(
                                      'Are you sure you want to delete this license?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, true),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                final success = await _vm.deleteDriverLicense(
                                  licenseId: license.licenseId,
                                );

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: success
                                        ? Colors.green
                                        : Colors.redAccent,
                                    content: Text(
                                      success
                                          ? 'License deleted successfully'
                                          : (_vm.errorMessage ??
                                              'Delete failed'),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        child: CustomButton(
          title: 'Create',
          onPressed: () {
            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DriverLicenseScreen()),
            );
          },
        ),
      ),
    );
  }
}