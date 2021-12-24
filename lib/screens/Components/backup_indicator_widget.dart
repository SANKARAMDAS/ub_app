import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_assets.dart';

class BackupIndicatorWidget extends StatelessWidget {
  final bool isConnected;
  const BackupIndicatorWidget({
    Key? key,
    required this.isConnected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  isConnected
                      ? AppAssets.backupIcon
                      : AppAssets.notBackedupIcon,
                  height: 35,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  isConnected ? 'Entry is backed up' : 'Entry is not backed up',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color(0xff666666), fontSize: 18),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
