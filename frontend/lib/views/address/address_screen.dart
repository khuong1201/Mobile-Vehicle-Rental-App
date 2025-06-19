import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/views/address/add_address_screen.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';

class AddressScreen extends StatefulWidget {
  final String? name;

  const AddressScreen({super.key, this.name});

  @override
  State<AddressScreen> createState() => _AddressScreen();
}

class _AddressScreen extends State<AddressScreen> {
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInkWell(context, 'assets/images/address/home.svg', 'Home', destination: AddAddressScreen()),
              const SizedBox(height: 28),
              _buildInkWell(context, 'assets/images/address/work.svg', 'Work', destination: AddAddressScreen())
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildInkWell (BuildContext context, pathSvg, String type, {Widget? destination,} ){
  return InkWell(
    onTap: (){
      if(destination != null){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      }
    },
    child: Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(  
            color: Color(0xFFE6E7E9),
            shape: BoxShape.circle,
          ),
          padding:EdgeInsets.all(6),
          child: SvgPicture.asset(pathSvg),
        ),
        const SizedBox(width: 16),
        Text(
          type,
          style: TextStyle(
            color: const Color(0xFF1976D2),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1.29,
          ),
        ),
      ],
    ),
  );
}
