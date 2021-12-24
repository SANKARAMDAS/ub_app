import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';

class CustomSearchBar extends StatefulWidget {
  TextFormField CtextFormField;
  Widget Suffix;

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();

  CustomSearchBar({required this.CtextFormField, required this.Suffix});
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        elevation: 3,
        child: Container(
          // width: MediaQuery.of(context).size.width * 0.92,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Image.asset(
                  AppAssets.searchIcon,
                  color: AppTheme.brownishGrey,
                  height: 20,
                  scale: 1.4,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: screenWidth(context) * 0.7,
                child: widget.CtextFormField,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // GestureDetector(
                  //   child: Padding(
                  //     padding: EdgeInsets.only(right: 15.0),
                  //     child: Image.asset(
                  //       AppAssets.filterIcon,
                  //       color: AppTheme.brownishGrey,
                  //       height: 18,
                  //       // scale: 1.5,
                  //     ),
                  //   ),
                  //   onTap: () async {
                  //     await filterBottomSheet;
                  //     setState(() {
                  //       hideFilterString = false;
                  //     });
                  //   },
                  // ),
                  // Positioned(
                  //   right: 14,
                  //   top: -3,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(25),
                  //     child: Container(
                  //       color: AppTheme.tomato,
                  //       height: 9,
                  //       width: 9,
                  //     ),
                  //   ),
                  // ),
                  widget.Suffix,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
