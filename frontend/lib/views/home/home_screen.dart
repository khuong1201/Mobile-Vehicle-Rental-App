import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../login/widgets/custom_text_form_field.dart';
import '../login/widgets/custom_Svg_icon.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration:BoxDecoration(
              gradient: LinearGradient(
                colors:[
                  Color(0xff1976D2),
                  Color(0xffFFFFFF)
                ],
                begin: Alignment.topCenter,
                end:Alignment.bottomCenter,
              )
            ),
            child: Column(
              children: [
                SizedBox(height: 50,),
                Container(
                  padding:EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFEEFEF),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            '',                   //import anh gg
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => 
                              Image.asset(
                                'assets/images/home/error.png',
                                fit: BoxFit.contain,
                              ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Column(
                        children: [
                          Text(
                            'Welcome, Linda!', //import ten tu google
                            style: TextStyle(
                              color: const Color(0xFFF7F7F8),
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          //dropdown
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        icon: SvgPicture.asset('assets/images/home/notification.svg'),
                        onPressed:(){}
                      )
                    ],
                  ),
                ),
                Container(
                  margin:EdgeInsets.all(16),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFFFFF)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: CustomTextField(
                          controller: _searchController,
                          hintText: "Search",
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 36),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgIconTextButton(
                              assetPath: 'assets/images/home/car.svg',
                              width: 32,
                              height: 32,
                              label: 'Car',
                              onPressed: () {},
                            ),
                            SvgIconTextButton(
                              assetPath: 'assets/images/home/coach.svg',
                              width: 32,
                              height: 32,
                              label: 'Coach',
                              onPressed: () {},
                            ),
                            SvgIconTextButton(
                              assetPath: 'assets/images/home/motorbike.svg',
                              width: 32,
                              height: 32,
                              label: 'Motorbike',
                              onPressed: () {},
                            ),
                            SvgIconTextButton(
                              assetPath: 'assets/images/home/bike.svg',
                              width: 32,
                              height: 32,
                              label: 'Bike',
                              onPressed: () {},
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ]
            )
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: double.infinity,
            width: double.infinity,
            color: Color(0xffF2F2F2),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                ]
              )
            )
          ),    
        ],
      ),
    );
  }
}
