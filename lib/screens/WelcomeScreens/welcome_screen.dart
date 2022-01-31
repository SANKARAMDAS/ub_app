import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/Components/ul_logo_widget.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController animation;

  late Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: Duration(seconds: 3),);
    _fadeInFadeOut = Tween<double>(begin: 0.2, end: 1.0).animate(animation);

    animation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        animation.reverse();
      }
      else if(status == AnimationStatus.dismissed){
        animation.forward();
      }
    });
    animation.forward();
  }

  // late final AnimationController _controller = AnimationController(
  //   duration: const Duration(seconds: 2),
  //   vsync: this,
  // )..repeat(reverse: true);
  // late final Animation<double> _animation = CurvedAnimation(
  //   parent: _controller,
  //   curve: Curves.elasticOut,
  // );

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Image.asset(AppAssets.backgroundImage),
        // SizedBox(height: 20),
        (deviceHeight * 0.10).heightBox,
        // ULLogoWidget(
        //   height: 80,
        // ),
        Image.asset(AppAssets.portraitLogo, width: MediaQuery.of(context).size.width*0.4),
        (deviceHeight * 0.05).heightBox,
        CustomText(
          'Change the way you\nmanage your Business',
          size: (23),
          color: AppTheme.coolGrey,
          bold: FontWeight.w500,
          centerAlign: true,
        ),
        (deviceHeight * 0.20).heightBox.flexible,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AppTheme.electricBlue,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.loginRoute, arguments: true);
            },
            child: CustomText(
              'Sign up with phone number',
              size: (18),
              color: Colors.white, 
              bold: FontWeight.w500,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          // margin: EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(15),
              side: BorderSide(color: AppTheme.electricBlue, width: 2),
              primary: AppTheme.whiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.loginRoute, arguments: false);
              // Navigator.of(context).pushNamed(AppRoutes.myProfileScreenRoute);
            },
            child: CustomText(
              'Login',
              color: AppTheme.electricBlue,
              size: (18),
              bold: FontWeight.w500,
            ),
          ),
        ),
      ]),
    );
  }}
