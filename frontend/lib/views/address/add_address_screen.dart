import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/views/address/address_detail_screen.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddAddressScreen();
}

class _AddAddressScreen extends State<AddAddressScreen> {
  final TextEditingController _address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        backgroundColor: Color(0xff1976D2),
        title: 'Address',
        textColor: Color(0xffFFFFFF),
        height: 80,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xffFCFCFC),
        padding: EdgeInsetsDirectional.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                controller: _address,
                hintText: 'Input your address',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SvgPicture.asset('assets/images/address/address1.svg'),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:EdgeInsets.symmetric(horizontal: 16),
                height: 400,
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute( builder: (context) => AddressDetailScreen()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE6E7E9),
                                ),
                                padding:EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                child: SvgPicture.asset(
                                  'assets/images/address/address2.svg',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '123 National Highway 1A',
                                      style: TextStyle(
                                        color: const Color(0xFF1976D2),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        height: 1.29,
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                    Text(
                                      '1km · Dong Hoa Commune, Trang Bom District, Dong Nai, 76000, Vietnam',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: const Color(0xFF555658),
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
