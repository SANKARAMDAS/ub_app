import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_theme.dart';

class DeleteCardPopUp extends StatelessWidget {
  final Function confirm;

  const DeleteCardPopUp({Key? key, required this.confirm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          // height: screenHeight(context) / 5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: GestureDetector(
                        child: Icon(Icons.clear, color: Colors.black45),
                        onTap: () {
                          Navigator.of(context).pop();
                        }),
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('No Bank Account Found.',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              ),
              Text('Please Add Your Bank Account.', style: TextStyle(fontSize: 16)),
              Row(children: [
                _customButton('CANCEL', () {
                  Navigator.of(context).pop();
                }),
                _customButton('CONFIRM', confirm())
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customButton(String title, Function ontap) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.electricBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
                child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18),
            )),
          ),
        ),
      ),
    );
  }
}
