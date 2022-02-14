import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:urbanledger/Models/rewards.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_profile_image.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/ReferAFriend/rewards_provider.dart';

class Rewards extends StatefulWidget {
  Rewards({Key? key}) : super(key: key);

  @override
  _RewardsState createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  final GlobalKey<State> key = GlobalKey<State>();
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    getRew();
    // _searchController.dispose();
    // filteredList = fullList;
    super.initState();
  }

  // List fullList = rewards.rewards!.data![i];
  // List  rewards.rewards! = List();

  void searchOperation(String searchText) {
    // rewards.rewards!.clear();
    // if (_searchController !=  null){
    //   for(int i =0; i< rewards.rewards!.data!.length; i++){
    //     String data = rewards.rewards!.data![i];
    //     if(data.toLowerCase().contains(searchText.toLowerCase())){
    //      rewards.rewards.add(data);
    //     }
    //   }
    // }
    //  rewards.rewards!.data! =
    //     fullList.where((i) => i.toLowerCase().contains(inputString)).toList();
    // setState(() {});
  }

  getRew() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await Provider.of<RewardsProvider>(context, listen: false)
        .getRewards()
        ?.then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      _foundUsers = value!.data;
    });
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<RewardsDetails>? results = [];
  List<RewardsDetails>? _foundUsers = [];
  void _runFilter(String enteredKeyword) {
    List<RewardsDetails>? results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results =
          Provider.of<RewardsProvider>(context, listen: false).rewards?.data;
    } else {
      results = Provider.of<RewardsProvider>(context, listen: false)
          .rewards
          ?.data!
          .where((user) =>
              '${user.referCustomerData!.firstName!.toLowerCase()} ${user.referCustomerData!.lastName!.toLowerCase()}'
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    if (mounted) {
      setState(() {
        _foundUsers = results;
      });
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
        elevation: 0,
        title: Text('Rewards'),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            // onPressed: () => Navigator.of(context)..pop(),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.popAndPushNamed(
              //     context, AppRoutes.myProfileScreenRoute);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
            ),
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 20, top: 15, bottom: 15),
        //     child: GestureDetector(
        //       child: Image.asset(AppAssets.helpIcon, height: 10),
        //       onTap: () {},
        //     ),
        //   ),
        // ],
      ),
      body: Container(
        child: Consumer<RewardsProvider>(
          builder: (context, rewards, _) {
            return RefreshIndicator(
                onRefresh: () async {
                  await getRew();
                  debugPrint('qqw : '+MediaQuery.of(context).size.height.toString());
                },
                child: isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(color: AppTheme.electricBlue,),
                      )
                    : Column(
                        children: [
                          Container(
                            height: deviceHeight < 890
                                ? deviceHeight * 0.33
                                : deviceHeight * 0.27,
                            // height: deviceHeight*0.27,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topCenter,
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  alignment: Alignment.topCenter,
                                  decoration: BoxDecoration(
                                    color: Color(0xfff2f1f6),
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image:
                                          AssetImage(AppAssets.referralBGImage),
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                                // Positioned(
                                //   // bottom: -10,
                                //     left:0,
                                //     right:0,
                                //     child: appBarWidget),
                                appBarWidget
                              ],
                            ),
                          ),
                          // MediaQuery.of(context).size.height < 890
                          // ? SizedBox(
                          //   height: MediaQuery.of(context).size.height * 0.012,
                          // ): Container(),
                          // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          rewards.rewards != null &&
                                  rewards.rewards!.data!.length != 0
                              ? searChWidget
                              : Container(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.014,
                          ),
                          rewards.rewards != null &&
                                  rewards.rewards!.data!.length != 0
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Friends Joined (${(rewards.rewards != null && rewards.rewards?.data != null) && rewards.rewards!.data!.isNotEmpty ? rewards.rewards?.data!.length.toString() : 0})'
                                            .toString(),
                                        style: TextStyle(
                                            color: Color(0xff666666),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      rewards.rewards != null &&
                                              rewards.rewards!.data!.length != 0
                                          ? inviteButton
                                          : Container(),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 10,
                                ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.014,
                          ),
                          rewards.rewards != null &&
                                  rewards.rewards?.data != null &&
                                  rewards.rewards?.data?.isNotEmpty != null &&
                                  rewards.rewards!.data!.length != 0
                              ? Expanded(
                                  child: _foundUsers!.length > 0
                                      ? Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.042),
                                          child: ListView.builder(
                                            itemCount: _foundUsers?.length,
                                            itemBuilder: (context, int index) {
                                              RewardsDetails? re =
                                                  _foundUsers?[index];
                                              return rewards.rewards!.data!
                                                          .length ==
                                                      0
                                                  ? Container(
                                                      // empty condition img
                                                      // margin: EdgeInsets.symmetric(
                                                      //     horizontal: MediaQuery.of(context)
                                                      //             .size
                                                      //             .width *
                                                      //         0.2),
                                                      // child: Image.asset(
                                                      //     AppAssets.rewardClipArt),

                                                      )
                                                  : Container(
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: ListTile(
                                                          onTap:
                                                              re?.firstPayment ??
                                                                      false ==
                                                                          true
                                                                  ? () {}
                                                                  : () async {
                                                                      // debugPrint(re.customerId.toString());
                                                                      //  debugPrint(re.referId);
                                                                      CustomLoadingDialog.showLoadingDialog(
                                                                          context,
                                                                          key);
                                                                      await rewards
                                                                          .triggerNotification(
                                                                              '${re?.referId}')
                                                                          .then(
                                                                              (value) {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        '$value'
                                                                            .showSnackBar(context);
                                                                      });
                                                                    },
                                                          dense: true,
                                                          leading:
                                                              CustomProfileImage(
                                                            mobileNo:
                                                                '${re?.referCustomerData!.mobileNo.toString()}',
                                                            name:
                                                                '${re?.referCustomerData!.firstName} ${re?.referCustomerData!.lastName}',
                                                          ),
                                                          title: Text(
                                                            '${re?.referCustomerData!.firstName} ${re?.referCustomerData!.lastName}',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          subtitle:
                                                              re?.firstPayment ??
                                                                      false ==
                                                                          true
                                                                  ? Text(
                                                                      'Earned Rewards',
                                                                      style:
                                                                          TextStyle(
                                                                        color: AppTheme
                                                                            .greenColor,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      'Remind your friend about first transaction',
                                                                      style:
                                                                          TextStyle(
                                                                        color: AppTheme
                                                                            .electricBlue,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
                                                          trailing: Container(
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    radius: 22,
                                                                    child: Image
                                                                        .asset(
                                                                      re?.firstPayment ??
                                                                              false == true
                                                                          ? 'assets/icons/referafriend/Your reward screen icon-02.png'
                                                                          : 'assets/icons/referafriend/Your reward screen icon-03.png',
                                                                    )),
                                                                SizedBox(
                                                                    width: 10),
                                                                re?.firstPayment ??
                                                                        false ==
                                                                            true
                                                                    ? RichText(
                                                                        text: TextSpan(
                                                                            children: [
                                                                              TextSpan(
                                                                                text: '$currencyAED ',
                                                                                style: TextStyle(
                                                                                  color: AppTheme.electricBlue,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 18,
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                text: '${re?.referralAmount.toString()}',
                                                                                style: TextStyle(
                                                                                  color: AppTheme.electricBlue,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 20,
                                                                                ),
                                                                              )
                                                                            ]),
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                              // : Container(
                                              //     padding: EdgeInsets.symmetric(
                                              //         vertical: 10.0, horizontal: 22),
                                              //     child: Column(
                                              //       crossAxisAlignment:
                                              //           CrossAxisAlignment.start,
                                              //       children: [
                                              //         InkWell(
                                              //           onTap: re.firstPayment == true
                                              //               ? () {}
                                              //               : () async {
                                              //                 debugPrint(re.customerId.toString());
                                              //                 // debugPrint(refer_);
                                              //                   // await rewards
                                              //                   //     .triggerNotification(
                                              //                   //         '${re.customerId}')
                                              //                   //     .then((value) {
                                              //                   //   '$value'.showSnackBar(
                                              //                   //       context);
                                              //                   // });
                                              //                 },
                                              //           child: Container(
                                              //             decoration: BoxDecoration(
                                              //               color: Colors.white,
                                              //               borderRadius:
                                              //                   BorderRadius.only(
                                              //                 topLeft:
                                              //                     Radius.circular(10),
                                              //                 topRight:
                                              //                     Radius.circular(10),
                                              //                 bottomLeft:
                                              //                     Radius.circular(10),
                                              //                 bottomRight:
                                              //                     Radius.circular(10),
                                              //               ),
                                              //             ),
                                              //             child: Padding(
                                              //               padding:
                                              //                   EdgeInsets.all(8.0),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .spaceBetween, // spacebe
                                              //                 children: [
                                              //                   CustomProfileImage(
                                              //                     mobileNo:
                                              //                         '${re.referCustomerData!.mobileNo.toString()}',
                                              //                     name: '${re.referCustomerData!.firstName}' +
                                              //                         '${re.referCustomerData!.lastName}',
                                              //                   ),
                                              //                   Column(
                                              //                     crossAxisAlignment:
                                              //                         CrossAxisAlignment
                                              //                             .start,
                                              //                     children: [
                                              //                       Text(
                                              //                         '${re.referCustomerData!.firstName}' +
                                              //                             '${re.referCustomerData!.lastName}',
                                              //                         style: TextStyle(
                                              //                           color: Colors
                                              //                               .black,
                                              //                           fontWeight:
                                              //                               FontWeight
                                              //                                   .w500,
                                              //                           fontSize: 18,
                                              //                         ),
                                              //                       ),
                                              //                       SizedBox(
                                              //                         height: 5,
                                              //                       ),
                                              //                       re.firstPayment ==
                                              //                               true
                                              //                           ? Text(
                                              //                               'Earned Rewards',
                                              //                               style:
                                              //                                   TextStyle(
                                              //                                 color: AppTheme
                                              //                                     .greenColor,
                                              //                                 fontWeight:
                                              //                                     FontWeight
                                              //                                         .w400,
                                              //                                 fontSize:
                                              //                                     14,
                                              //                               ),
                                              //                             )
                                              //                           : Text(
                                              //                               'Remind your friend about first transaction',
                                              //                               style:
                                              //                                   TextStyle(
                                              //                                 color: AppTheme
                                              //                                     .electricBlue,
                                              //                                 fontWeight:
                                              //                                     FontWeight
                                              //                                         .w400,
                                              //                                 fontSize:
                                              //                                     14,
                                              //                               ),
                                              //                             ),
                                              //                     ],
                                              //                   ),
                                              //                   CircleAvatar(
                                              //                     backgroundColor:
                                              //                         Colors.white,
                                              //                     radius: 22,
                                              //                     child: Image.asset(
                                              //                       'assets/icons/referafriend/Your reward screen icon-02.png',
                                              //                     ),
                                              //                   ),
                                              //                   re.firstPayment == true
                                              //                       ? Row(
                                              //                           children: [
                                              //                             Text(
                                              //                               '${re.currency.toString()}',
                                              //                               style:
                                              //                                   TextStyle(
                                              //                                 color: AppTheme
                                              //                                     .electricBlue,
                                              //                                 fontWeight:
                                              //                                     FontWeight
                                              //                                         .bold,
                                              //                                 fontSize:
                                              //                                     18,
                                              //                               ),
                                              //                             ),
                                              //                             SizedBox(
                                              //                               width: 5,
                                              //                             ),
                                              //                             Text(
                                              //                               '${re.referralAmount.toString()}',
                                              //                               style:
                                              //                                   TextStyle(
                                              //                                 color: AppTheme
                                              //                                     .electricBlue,
                                              //                                 fontWeight:
                                              //                                     FontWeight
                                              //                                         .bold,
                                              //                                 fontSize:
                                              //                                     20,
                                              //                               ),
                                              //                             ),
                                              //                           ],
                                              //                         )
                                              //                       : Container(),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   );
                                            },
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            'No results found',
                                            style: TextStyle(fontSize: 24),
                                          ),
                                        ),
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15),
                                        child: Image.asset(AppAssets.rewardClipArt)),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 6),
                                        child: Text('No referral rewards',
                                            style: TextStyle(
                                              color: Color(0xff666666),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            )),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 6),
                                        child: Text(
                                            "Let's invite your first referral",
                                            style: TextStyle(
                                              color: AppTheme.coolGrey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                            )),
                                      ),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: inviteButton),
                                    ],
                                  ),
                                ),
                        ],
                      ));
          },
        ),
      ),
    );
  }

  Widget get inviteButton => Container(
        width: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppTheme.electricBlue,
          border: Border.all(
            color: AppTheme.electricBlue,
            width: 0.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 3,
                ),
                GestureDetector(
                  onTap: () async {
                    CustomLoadingDialog.showLoadingDialog(context, key);
                    String message =
                        await repository.rewardsApi.getReferalMessage();
                    if (message.isNotEmpty) {
                      Navigator.of(context).pop();
                      await Share.share(
                        '$message \n${Repository().hiveQueries.userData.referral_link}',
                      );
                    }
                  },
                  child: FittedBox(
                    child: Text(
                      '\tInvite',
                      style: TextStyle(
                          color: AppTheme.justWhite,
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w500, //FontWeight.w500
                          fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(width: 3),
                Image.asset(
                  'assets/icons/Invite-01.png',
                  height: 18,
                  color: AppTheme.justWhite,
                  width: 22,
                ),
              ]),
        ),
      );

  Widget get appBarWidget => Container(
        child: Column(children: [
          Container(
            child: Image.asset(
              'assets/icons/referafriend/Your Rewards ICON-02.png',
              width: MediaQuery.of(context).size.width * 0.12,
              // height: MediaQuery.of(context).size.height * 0.06,
            ),
          ),
          SizedBox(height: 
          MediaQuery.of(context).size.height * 0.016),
          rewPenWidget,
          SizedBox(height: 
          MediaQuery.of(context).size.height * 0.022),
          gesTureWidget,
        ]),
      );

  Widget get rewPenWidget => Container(
        width: MediaQuery.of(context).size.width * 0.9,
        // height: deviceHeight * 0.12,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), offset: Offset(0, 7))
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: IntrinsicHeight(
                  child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Rewards',
                              style: TextStyle(
                                  color: AppTheme.greyish,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    'AED ',
                                    style: TextStyle(
                                        color: AppTheme.brownishGrey,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                ),
                                SizedBox(width: 2),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    // '${Provider.of<RewardsProvider>(context, listen: false).rewards != null ?
                                    //  Provider.of<RewardsProvider>(context, listen: false).rewards!.totalRewardAmt : 00}',
                                    Provider.of<RewardsProvider>(context,
                                                        listen: false)
                                                    .rewards !=
                                                null &&
                                            Provider.of<RewardsProvider>(
                                                        context,
                                                        listen: false)
                                                    .rewards!
                                                    .totalRewardAmt!
                                                    .toInt() !=
                                                0
                                        ? '${Provider.of<RewardsProvider>(context, listen: false).rewards!.totalRewardAmt.toString()}'
                                        : '00',

                                    style: TextStyle(
                                        color: Provider.of<RewardsProvider>(
                                                            context,
                                                            listen: false)
                                                        .rewards !=
                                                    null &&
                                                Provider.of<RewardsProvider>(
                                                            context,
                                                            listen: false)
                                                        .rewards!
                                                        .totalRewardAmt!
                                                        .toInt() !=
                                                    0
                                            ? AppTheme.electricBlue
                                            : AppTheme.coolGrey,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 26),
                                  ),
                                ),
                                // Provider.of<RewardsProvider>(context, listen: false).rewards?.totalPendingAmt!.toInt() != 0
                                //  ? '${Provider.of<RewardsProvider>(context, listen: false).rewards?.totalPendingAmt.toString()} ': '00',
                                //   style: TextStyle(
                                //       // ignore: unrelated_type_equality_checks
                                //       color: Provider.of<RewardsProvider>(context, listen: false).rewards?.totalPendingAmt!.toInt() != 0
                                //  ?  AppTheme.electricBlue : AppTheme.coolGrey,
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 26),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, right: 8),
                      child: CircleAvatar(
                          radius: 15,
                          child: Image.asset(
                              'assets/icons/referafriend/Your reward screen icon-04.png')),
                    )
                  ],
                ),
              ),
            ),
            VerticalDivider(
                      color: AppTheme.brownishGrey,
                      indent: 10,
                      endIndent: 10,
                    ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Pending',
                              style: TextStyle(
                                  color: AppTheme.greyish,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    'AED ',
                                    style: TextStyle(
                                        color: AppTheme.brownishGrey,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                ),
                                SizedBox(width: 2),
                                Text(
                                  // '${Provider.of<RewardsProvider>(context, listen: false).rewards != null ?
                                  //  Provider.of<RewardsProvider>(context, listen: false).rewards!.totalRewardAmt : 00}',
                                  Provider.of<RewardsProvider>(context,
                                                      listen: false)
                                                  .rewards !=
                                              null &&
                                          Provider.of<RewardsProvider>(context,
                                                      listen: false)
                                                  .rewards
                                                  ?.totalPendingAmt!
                                                  .toInt() !=
                                              0
                                      ? '${Provider.of<RewardsProvider>(context, listen: false).rewards?.totalPendingAmt.toString()}'
                                      : '00',
                                  style: TextStyle(
                                      color: Provider.of<RewardsProvider>(
                                                          context,
                                                          listen: false)
                                                      .rewards !=
                                                  null &&
                                              Provider.of<RewardsProvider>(
                                                          context,
                                                          listen: false)
                                                      .rewards
                                                      ?.totalPendingAmt!
                                                      .toInt() !=
                                                  0
                                          ? AppTheme.electricBlue
                                          : AppTheme.coolGrey,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 26),
                                ),
                                // Provider.of<RewardsProvider>(context, listen: false).rewards?.totalPendingAmt!.toInt() != 0
                                //  ? '${Provider.of<RewardsProvider>(context, listen: false).rewards?.totalPendingAmt.toString()} ': '00',
                                //   style: TextStyle(
                                //       // ignore: unrelated_type_equality_checks
                                //       color: Provider.of<RewardsProvider>(context, listen: false).rewards?.totalPendingAmt!.toInt() != 0
                                //  ?  AppTheme.electricBlue : AppTheme.coolGrey,
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 26),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, right: 8),
                      child: CircleAvatar(
                          radius: 15,
                          child: Image.asset(
                              'assets/icons/referafriend/Your reward screen icon-05.png')),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),

        ),
      );

  Widget get gesTureWidget => Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(
                    text: Repository()
                        .hiveQueries
                        .userData
                        .referral_code
                        .toString()))
                .then((result) {
              'Referral Code Copied Successfully!'.showSnackBar(context);
            });
          },
          child: Container(
            // margin: EdgeInsets.symmetric(
            //     horizontal: MediaQuery.of(context).size.width * 0.05),
            // height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 5.0,
                    offset: Offset(0, 5))
              ],
            ),

            child: DottedBorder(
              color: Colors.orange,
              radius: Radius.circular(50),
              dashPattern: [5, 5, 5, 5],
              borderType: BorderType.RRect,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Your referral code',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Image.asset(
                            'assets/icons/referafriend/copy icon-02.png',
                            height: 24,
                            width: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                                text: Repository()
                                    .hiveQueries
                                    .userData
                                    .referral_code
                                    .toString()))
                            .then((result) {
                          'Referral Code Copied Successfully!'
                              .showSnackBar(context);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 3, bottom: 3, right: 5),
                        padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0xfff06d4a), Color(0xfff2964a)],
                          ),
                        ),
                        child: Text(
                          "${Repository().hiveQueries.userData.referral_code.toString().toUpperCase()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );

  Widget get searChWidget => Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child:
            // rewards.rewards != null ?
            Card(
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
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                SizedBox(width: 10),
                Container(
                  width: screenWidth(context) * 0.7,
                  child: TextFormField(
                    // textAlignVertical: TextAlignVertical.center,
                    // controller: _searchController,
                    onChanged: (value) => _runFilter(value),
                    style: TextStyle(
                      fontSize: 17,
                      color: AppTheme.brownishGrey,
                    ),
                    cursorColor: AppTheme.brownishGrey,
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.only(top: 15),
                        border: InputBorder.none,
                        hintText: 'Search Customer ',
                        hintStyle: TextStyle(
                            color: Color(0xffb6b6b6),
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        ),
        // : Card(),
      );
}
