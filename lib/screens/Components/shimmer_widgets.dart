import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:urbanledger/Utility/app_services.dart';

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(50)),
          ),
          title: Container(
            height: 20,
            width: MediaQuery.of(context).size.width * 0.7,
            // margin:
            //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(0)),
          ),
          subtitle: Container(
            height: 20,
            // width: double.infinity,
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(0)),
          ),
        ),
      ),
    );
  }
}

class ShimmerListTile5 extends StatelessWidget {
  const ShimmerListTile5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(50)),
          ),
          title: Container(
            height: 20,
            width: MediaQuery.of(context).size.width * 0.7,
            // margin:
            //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(0)),
          ),
        ),
      ),
    );
  }
}

class ShimmerListTile3 extends StatelessWidget {
  const ShimmerListTile3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: ListTile(
          title: Container(
            height: 20,
            width: MediaQuery.of(context).size.width * 0.7,
            // margin:
            //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(0)),
          ),
          subtitle: Container(
            height: 20,
            // width: double.infinity,
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(0)),
          ),
        ),
      ),
    );
  }
}

class ShimmerListTile2 extends StatelessWidget {
  const ShimmerListTile2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 120.0,
      child: Shimmer.fromColors(
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: ListView(
          children: [
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width * 0.7,
              // margin:
              //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.7),
              decoration: BoxDecoration(
                  color: AppTheme.greyish,
                  borderRadius: BorderRadius.circular(0)),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Shimmer.fromColors(
                    // period: Duration(milliseconds: 1500),
                    direction: ShimmerDirection.ltr,
                    baseColor: AppTheme.baseColor,
                    highlightColor: AppTheme.highlightColor,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          // margin:
                          //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppTheme.greyish,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Container(
                          height: 20,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppTheme.greyish,
                              borderRadius: BorderRadius.circular(0)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Shimmer.fromColors(
                    // period: Duration(milliseconds: 1500),
                    direction: ShimmerDirection.ltr,
                    baseColor: AppTheme.baseColor,
                    highlightColor: AppTheme.highlightColor,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          // margin:
                          //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppTheme.greyish,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Container(
                          height: 20,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppTheme.greyish,
                              borderRadius: BorderRadius.circular(0)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Shimmer.fromColors(
                    // period: Duration(milliseconds: 1500),
                    direction: ShimmerDirection.ltr,
                    baseColor: AppTheme.baseColor,
                    highlightColor: AppTheme.highlightColor,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          // margin:
                          //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppTheme.greyish,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Container(
                          height: 20,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppTheme.greyish,
                              borderRadius: BorderRadius.circular(0)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class shimmerPayLoading1 extends StatelessWidget {
  const shimmerPayLoading1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        // physics: NeverScrollableScrollPhysics(),
        // scrollDirection: Axis.vertical,
        children: [
          Align(alignment: Alignment.centerLeft, child: ShimmerText()),
          SizedBox(height: 5),
          Row(
            children: [
              ShimmerAvatarWithName(),
              ShimmerAvatarWithName(),
              ShimmerAvatarWithName(),
              ShimmerAvatarWithName(),
            ],
          ),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     ShimmerSquareTab(),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     ShimmerSquareTab()
          //   ],
          // ),
          SizedBox(height: 15),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          ShimmerButton(),
          SizedBox(height: 15),
          ShimmerText(),
          SizedBox(height: 15),
          ShimmerListTile(),
          ShimmerListTile(), ShimmerListTile(),
          ShimmerListTile(),
          ShimmerListTile(),
          ShimmerListTile(), ShimmerListTile(),
          ShimmerListTile(),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class shimmerPayLoading extends StatelessWidget {
  const shimmerPayLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        // physics: NeverScrollableScrollPhysics(),
        // scrollDirection: Axis.vertical,
        children: [
          Align(alignment: Alignment.centerLeft, child: ShimmerText()),
          SizedBox(height: 5),
          Row(
            children: [
              ShimmerAvatarWithName(),
              ShimmerAvatarWithName(),
              ShimmerAvatarWithName(),
              ShimmerAvatarWithName(),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerSquareTab(),
              SizedBox(
                width: 10,
              ),
              ShimmerSquareTab()
            ],
          ),
          SizedBox(height: 15),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          ShimmerButton(),
          SizedBox(height: 15),
          ShimmerText(),
          SizedBox(height: 15),
          ShimmerListTile(),
          ShimmerListTile(), ShimmerListTile(),
          ShimmerListTile(),
          ShimmerListTile(),
          ShimmerListTile(), ShimmerListTile(),
          ShimmerListTile(),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class ShimerAvatarWithNameContainer extends StatelessWidget {
  const ShimerAvatarWithNameContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 150.0,
      child: Shimmer.fromColors(
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: ListView(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerText3(),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerAvatarWithName(),
                ShimmerAvatarWithName(),
                ShimmerAvatarWithName(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerText extends StatelessWidget {
  const ShimmerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 50.0,
      child: Shimmer.fromColors(
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: ListTile(
          // leading: Container(
          //   height: 50,
          //   width: 50,
          //   decoration: BoxDecoration(
          //       color: AppTheme.greyish,
          //       borderRadius: BorderRadius.circular(50)),
          // ),
          dense: true,
          title: Container(
            height: 20,
            // width: 100,
            margin:
                EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.5),
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(0)),
          ),
          subtitle: Container(
            height: 20,
            // width: 100,
            margin:
                EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(0)),
          ),
        ),
      ),
    );
  }
}

class ShimmerText2 extends StatelessWidget {
  const ShimmerText2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.0,
      height: 50.0,
      child: Shimmer.fromColors(
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: ListTile(
          // leading: Container(
          //   height: 50,
          //   width: 50,
          //   decoration: BoxDecoration(
          //       color: AppTheme.greyish,
          //       borderRadius: BorderRadius.circular(50)),
          // ),
          dense: true,
          // title: Container(
          //   height: 20,
          //   // width: 100,
          //   margin: EdgeInsets.only(
          //       right: MediaQuery.of(context).size.width * 0.5),
          //   decoration: BoxDecoration(
          //       color: AppTheme.greyish,
          //       borderRadius: BorderRadius.circular(0)),
          // ),
          subtitle: Container(
            height: 20,
            // width: 100,
            margin:
                EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(0)),
          ),
        ),
      ),
    );
  }
}

class ShimmerText3 extends StatelessWidget {
  const ShimmerText3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240.0,
      height: 50.0,
      child: Shimmer.fromColors(
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: ListTile(
          // leading: Container(
          //   height: 50,
          //   width: 50,
          //   decoration: BoxDecoration(
          //       color: AppTheme.greyish,
          //       borderRadius: BorderRadius.circular(50)),
          // ),
          dense: true,
          // title: Container(
          //   height: 20,
          //   // width: 100,
          //   margin: EdgeInsets.only(
          //       right: MediaQuery.of(context).size.width * 0.5),
          //   decoration: BoxDecoration(
          //       color: AppTheme.greyish,
          //       borderRadius: BorderRadius.circular(0)),
          // ),
          subtitle: Container(
            height: 20,
            // width: 100,
            margin:
                EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(0)),
          ),
        ),
      ),
    );
  }
}

class ShimmerButton extends StatelessWidget {
  const ShimmerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.0,
      child: Shimmer.fromColors(
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: ListTile(
          dense: true,
          title: Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.8,
            // margin:
            //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(0)),
          ),
        ),
      ),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110.0,
      child: Shimmer.fromColors(
        // period: Duration(milliseconds: 1500),
        direction: ShimmerDirection.ltr,
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: ListTile(
          dense: true,
          title: Container(
            height: 70,
            width: MediaQuery.of(context).size.width * 0.8,
            // margin:
            //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppTheme.greyish,
                borderRadius: BorderRadius.circular(0)),
          ),
        ),
      ),
    );
  }
}

class ShimmerAvatarWithName extends StatelessWidget {
  const ShimmerAvatarWithName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.0,
      height: 110.0,
      child: Shimmer.fromColors(
        // period: Duration(milliseconds: 1500),
        direction: ShimmerDirection.ltr,
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 60,
              width: 60,
              // margin:
              //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppTheme.greyish,
                  borderRadius: BorderRadius.circular(50)),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 20,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppTheme.greyish,
                  borderRadius: BorderRadius.circular(0)),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerAvatarWithName2 extends StatelessWidget {
  const ShimmerAvatarWithName2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.0,
      height: 110.0,
      child: Shimmer.fromColors(
        // period: Duration(milliseconds: 1500),
        direction: ShimmerDirection.ltr,
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 60,
              width: 60,
              // margin:
              //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppTheme.greyish,
                  borderRadius: BorderRadius.circular(50)),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 20,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppTheme.greyish,
                  borderRadius: BorderRadius.circular(0)),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerSquareTab extends StatelessWidget {
  const ShimmerSquareTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.0,
      height: 120.0,
      child: Shimmer.fromColors(
        // period: Duration(milliseconds: 1500),
        direction: ShimmerDirection.ltr,
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 90,
              width: 90,
              // margin:
              //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppTheme.greyish,
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 20,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppTheme.greyish,
                  borderRadius: BorderRadius.circular(0)),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerTicket extends StatelessWidget {
  const ShimmerTicket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 280.0,
      child: Shimmer.fromColors(
        // period: Duration(milliseconds: 1500),
        direction: ShimmerDirection.ltr,
        baseColor: AppTheme.baseColor,
        highlightColor: AppTheme.highlightColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 270,
              width: MediaQuery.of(context).size.width * 0.8,
              // margin:
              //     EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppTheme.greyish,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }
}
