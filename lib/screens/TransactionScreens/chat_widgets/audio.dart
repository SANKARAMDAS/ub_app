// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:urbanledger/Models/customer_model.dart';
// import 'package:urbanledger/Utility/app_assets.dart';
// import 'package:urbanledger/Utility/app_constants.dart';
// import 'package:urbanledger/Utility/app_methods.dart';
// import 'package:urbanledger/Utility/app_theme.dart';
// import 'package:urbanledger/chat_module/data/models/message.dart';
// import 'package:urbanledger/chat_module/data/models/user.dart';
// import 'package:urbanledger/chat_module/utils/dates.dart';
// import 'package:urbanledger/main.dart';
// import 'package:urbanledger/screens/Components/custom_widgets.dart';

// class Audio extends StatefulWidget {
//   final Message controllerData;
//   final int index;
//   final CustomerModel customerModel;
//   final User? myUser;

//   Audio(
//     {
//       required this.controllerData,
//       required this.index,
//       required this.customerModel,
//       required this.myUser
//     }
//   );
//   @override
//   _AudioState createState() => _AudioState();
// }

// class _AudioState extends State<Audio> with SingleTickerProviderStateMixin {
//   String? _isPlaying;
//   Map<String,bool> _isDownload = {};
//   Map<String?,String?>? _isDuration1 = {};
//   Map<String?,String?>? _isDuration2 = {};
//   late AudioPlayer audioPlayer;
//   bool _audio = false;
//   String? path;
//   final format = new DateFormat("hh:mm a");
//   User? myUser;
//   late Animation<double> animation;
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     audioPlayer = AudioPlayer();
//     _animationController = AnimationController(duration: Duration(milliseconds: 1200),vsync: this);
//     final curvedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic);

//     animation = Tween<double>(begin: 0,end: 100).animate(curvedAnimation)..addListener(() {
//       setState(() {
        
//       });
//     });
//     _animationController.repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _audio = false;
//     String audio = widget.controllerData.details.toString().substring(9, 22);
//     // if(message.from == _contactController.widget.myUser?.id)
//     path = '/storage/emulated/0/Android/data/com.urbanledger.app/files';
//     // if(message.from != _contactController.widget.myUser?.id)
//     // path2 =
//     //     '/storage/emulated/0/Android/data/com.urbanledger.app/files/filereader/files/$audio.aac';
//     debugPrint('asdfghj');
//     debugPrint(widget.controllerData.from);
//     // debugPrint(widget.myUser?.id);
//     if (widget.myUser?.id == null) return Container();
//     return Column(
//       children: <Widget>[
//         // renderMessageSendAtDay(widget.controllerData, widget.index),
//         Material(
//           color: Colors.transparent,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: widget.controllerData.from == widget.myUser?.id
//                 ? MainAxisAlignment.end
//                 : MainAxisAlignment.start,
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               // renderMessageSendAt(message, MessagePosition.BEFORE),
//               if (widget.controllerData.from == widget.myUser?.id)
//                 Padding(
//                   padding: EdgeInsets.only(right: 5),
//                   child: Icon(
//                     widget.controllerData.unreadByMe == true
//                         ? Icons.done_all_outlined
//                         : Icons.done,
//                     size: 18,
//                     // color: Theme.of(context).primaryColor,
//                     color: widget.controllerData.unreadByMe == true
//                         ? AppTheme.electricBlue
//                         : AppTheme.brownishGrey,
//                   ),
//                 ),
//               Card(
//                 elevation: 0.5,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(30.0))),
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(4),
//                       child: CircleAvatar(
//                       radius: 20,
//                       backgroundColor: widget.controllerData.from == widget.myUser?.id
//                           ?AppTheme.coolGrey
//                           : AppTheme.carolinaBlue,
//                       child: CustomText(
//                         widget.controllerData.from == widget.myUser?.id
//                           ?getInitials(
//                                 '${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName}',
//                                 '${repository.hiveQueries.userData.mobileNo}'
//                               ).toUpperCase()
//                               :getInitials(
//                                 '${widget.customerModel.name}',
//                                 '${widget.customerModel.mobileNo}'
//                               ).toUpperCase(),
//                           color: AppTheme
//                               .circularAvatarTextColor,
//                           size: 24,
//                         )
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     FutureBuilder<bool>(
//                             future: checkDownload(widget.controllerData.details!),
//                             builder: (context, snapshot) {
//                               return Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Icon(
//                         //   Icons.play_circle_fill_rounded,
//                         //   color: Colors.grey,
//                         //   size: 26,
//                         // ),
//                         // if(_isDownload[message.details] ?? false)
//                         widget.controllerData.from != widget.myUser?.id && snapshot.data == false
//                             ? GestureDetector(
//                                 onTap: () async {
//                                   // debugPrint('yes'+message.details!);
//                                 // debugPrint(path2);
//                                 debugPrint('/storage/emulated/0/Android/data/com.urbanledger.app/files/filereader/files/'+widget.controllerData.details!);
//                                 if (await File('/storage/emulated/0/Android/data/com.urbanledger.app/files/${widget.controllerData.details}').exists()) {
//                                   // if(_isPlaying != message.details){
//                                   //   setState(() {
//                                   //     _isPlaying = message.details;
//                                   //   });
//                                   //   await audioPlayer.play('/storage/emulated/0/Android/data/com.urbanledger.app/files/filereader/files/'+message.details!,
//                                   //     isLocal: true);
//                                   //   debugPrint(_isPlaying.toString()+ 'playing');
//                                   // } else{
//                                   //   await audioPlayer.stop();
//                                   //   setState(() {
//                                   //     _isPlaying = null;
//                                   //   });
//                                   //   debugPrint(_isPlaying.toString()+ 'stop');
//                                   // }
//                                   // debugPrint(audioPlayer.getDuration().toString());
//                                 } 
//                                 else{
//                                   setState(() {
//                                     _isDownload[widget.controllerData.details!] = true;  
//                                   }); 
//                                   repository.ledgerApi.networkAudio(widget.controllerData.details!).whenComplete(() => setState((){_isDownload[widget.controllerData.details!] = false;}) );
//                                 }
//                                 },
                                
//                                 child:(_isDownload[widget.controllerData.details] ?? false)
//                                 ?CircularProgressIndicator(
//                                   backgroundColor: Colors.white)
//                                 : Image.asset(
//                                   AppAssets.downloadAudioIcon,
//                                   width: 24,
//                                 ),
//                               )
//                             : GestureDetector(
//                                 onTap: () async {
//                                   if(_isPlaying != widget.controllerData.details){
//                                     setState(() {
//                                       _isPlaying = widget.controllerData.details;
//                                     });
//                                     if(widget.controllerData.from == '${widget.myUser?.id}')
//                                     {
//                                       audioPlayer.setUrl('$path/'+widget.controllerData.details!.substring(9, 22)+'.aac');
//                                       audioPlayer.play();
//                                       audioPlayer.playerStateStream.listen((state) {
//                                         if (state.playing){
//                                           switch (state.processingState) {
//                                             case ProcessingState.idle: 
//                                             debugPrint('idle');
//                                             break;
//                                             case ProcessingState.loading: 
//                                             debugPrint('loading');
//                                             break;
//                                             case ProcessingState.buffering: 
//                                             debugPrint('buffering');
//                                             break;
//                                             case ProcessingState.ready: 
//                                             debugPrint('ready');
//                                             break;
//                                             case ProcessingState.completed: 
//                                             debugPrint('completed');
//                                               setState((){
//                                                 _isPlaying = null;
//                                               });
//                                             break;
//                                           }
//                                         }
                                        
//                                       });
//                                     } else {
//                                       audioPlayer.setUrl('$path/'+widget.controllerData.details!);
//                                       audioPlayer.play();
//                                       audioPlayer.playerStateStream.listen((state) {
//                                         if (state.playing){
//                                           switch (state.processingState) {
//                                             case ProcessingState.idle: 
//                                             debugPrint('idle');
//                                             break;
//                                             case ProcessingState.loading: 
//                                             debugPrint('loading');
//                                             break;
//                                             case ProcessingState.buffering: 
//                                             debugPrint('buffering');
//                                             break;
//                                             case ProcessingState.ready: 
//                                             debugPrint('ready');
//                                             break;
//                                             case ProcessingState.completed: 
//                                             debugPrint('completed');
//                                               setState((){
//                                                 _isPlaying = null;
//                                               });
//                                             break;
//                                           }
//                                         }
//                                       });
//                                     }
//                                   } else{
//                                     await audioPlayer.stop();
//                                     setState(() {
//                                       _isPlaying = null;
//                                     });
//                                   }
//                                 },
//                                 child: Image.asset(
//                                   _isPlaying == widget.controllerData.details
//                                   ? AppAssets.stopAudioIcon
//                                   : AppAssets.playAudioIcon,
//                                   width: 24,
//                                 )
//                               ),
                            
//                         FutureBuilder<String?>(
//                             future: checkDuration(widget.controllerData.details!),
//                             builder: (context, snapshot1) {
//                               return Visibility(
//                                 visible : snapshot1.data != null,
//                                 child: Text(
//                                   '${snapshot1.data}',
//                                   style: TextStyle(color: AppTheme.greyish, fontSize: 8),
//                                 ),
//                               );
//                             },
//                         )
                        
//                       ],
//                     );
//                     },
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     // Image.asset(
//                     //   'assets/icons/visualization-01.png',
//                     //   height: 22,
//                     //   // width: 110,
//                     // ),
//                     Container(
//                       width: 110,
//                       height: 22,
//                       color: AppTheme.brownishGrey,

//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       messageDate(widget.controllerData.sendAt!),
//                       style: TextStyle(color: AppTheme.greyish, fontSize: 8),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget renderMessageSendAtDay(Message message, int index) {
//   //   if (index == _contactController.selectedChat!.messages!.length - 1) {
//   //     return getLabelDay(message.sendAt);
//   //   }
//   //   final lastMessageSendAt = new DateTime.fromMillisecondsSinceEpoch(
//   //       _contactController.selectedChat!.messages![index + 1].sendAt!);
//   //   final messageSendAt =
//   //       new DateTime.fromMillisecondsSinceEpoch(message.sendAt!);
//   //   final formatter = UtilDates.formatDay;
//   //   String formattedLastMessageSendAt = formatter.format(lastMessageSendAt);
//   //   String formattedMessageSendAt = formatter.format(messageSendAt);
//   //   if (formattedLastMessageSendAt != formattedMessageSendAt) {
//   //     return getLabelDay(message.sendAt);
//   //   }
//   //   return Container();
//   // }

//   Widget getLabelDay(int? milliseconds) {
//     String day = UtilDates.getSendAtDay(milliseconds);
//     return Column(
//       children: <Widget>[
//         SizedBox(
//           height: 4,
//         ),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             color: Color(0xFFC0CBFF),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
//             child: Text(
//               day,
//               style: TextStyle(color: Colors.black, fontSize: 12),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 7,
//         ),
//       ],
//     );
//   }

//   String messageDate(int milliseconds) {
//     DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
//     return format.format(date);
//   }

//   Future<bool> checkDownload(String fileName) async{
//     if(await File('/storage/emulated/0/Android/data/com.urbanledger.app/files/$fileName').exists())
//     {
//       // _isDownload[fileName] = true;
//       return true;
//     }
//     else
//     {
//       return false;
//     }
//   }

//   Future<String?> checkDuration(String message) async {
//     final _player = AudioPlayer();
//     if(await File('/storage/emulated/0/Android/data/com.urbanledger.app/files/$message').exists())
//     {
//       var _duration = await _player.setUrl('/storage/emulated/0/Android/data/com.urbanledger.app/files/$message');
//       _player.dispose();
//       print(_duration!.inSeconds.toString());
//       // final s = _duration.inSeconds.toString();
//       // final m = _duration.inMinutes.toString();
//       String twoDigits(int n) => n.toString().padLeft(2, "0");
//       String twoDigitMinutes = twoDigits(_duration.inMinutes.remainder(60));
//       String twoDigitSeconds = twoDigits(_duration.inSeconds.remainder(60));
//       return "$twoDigitMinutes:$twoDigitSeconds";
//       // return '$m:$s';
//     } else if(await File('/storage/emulated/0/Android/data/com.urbanledger.app/files/'+message.substring(9, 22)+'.aac').exists()) {
//       debugPrint('message'+message);
//         var _duration = await _player.setUrl('/storage/emulated/0/Android/data/com.urbanledger.app/files/'+message.substring(9, 22)+'.aac');
//         _player.dispose();
//         print(_duration!.inSeconds.toString());
//         String twoDigits(int n) => n.toString().padLeft(2, "0");
//         String twoDigitMinutes = twoDigits(_duration.inMinutes.remainder(60));
//         String twoDigitSeconds = twoDigits(_duration.inSeconds.remainder(60));
//         return "$twoDigitMinutes:$twoDigitSeconds";
//     } else{
//         debugPrint('message'+message);
//         var _duration = await _player.setUrl(baseImageUrl+message);
//         _player.dispose();
//         print(_duration!.inSeconds.toString());
//         String twoDigits(int n) => n.toString().padLeft(2, "0");
//         String twoDigitMinutes = twoDigits(_duration.inMinutes.remainder(60));
//         String twoDigitSeconds = twoDigits(_duration.inSeconds.remainder(60));
//         return "$twoDigitMinutes:$twoDigitSeconds";
//     }
//   }
// }
