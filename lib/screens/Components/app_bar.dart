import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_theme.dart';

//height 192
class AppBarSmall extends CustomPainter{
  
  @override
  void paint(Canvas canvas, Size size) {
    
    

  Paint paint_0 = new Paint()
      ..color = AppTheme.brownishGrey
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
     
         
    Path path_0 = Path();
    path_0.moveTo(0,size.height*0.5164835);
    path_0.lineTo(0,0);
    path_0.lineTo(size.width,0);
    path_0.lineTo(size.width,size.height*0.5164835);
    path_0.quadraticBezierTo(size.width*0.8001243,size.height*0.6918315,size.width*0.5114920,size.height*0.7018315);
    path_0.cubicTo(size.width*0.5070515,size.height*0.7018315,size.width*0.5053819,size.height*0.7018315,size.width*0.5009414,size.height*0.7018315);
    path_0.quadraticBezierTo(size.width*0.2416163,size.height*0.7061538,size.width*0.0001421,size.height*0.5180952);

    canvas.drawPath(path_0, paint_0);
  

  Paint paint_1 = new Paint()
      ..color = AppTheme.electricBlue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
     
         
    Path path_1 = Path();
    path_1.moveTo(0,size.height*0.5128205);
    path_1.lineTo(0,0);
    path_1.lineTo(size.width,0);
    path_1.lineTo(size.width,size.height*0.5128205);
    path_1.quadraticBezierTo(size.width*0.8037300,size.height*0.6493407,size.width*0.5150977,size.height*0.6593407);
    path_1.cubicTo(size.width*0.5106572,size.height*0.6593407,size.width*0.5017762,size.height*0.6593407,size.width*0.4973357,size.height*0.6593407);
    path_1.quadraticBezierTo(size.width*0.2380107,size.height*0.6636630,size.width*0.0001421,size.height*0.5126007);

    canvas.drawPath(path_1, paint_1);
  
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}

class AppBarLarge extends CustomPainter{
  
  @override
  void paint(Canvas canvas, Size size) {
    
    

  Paint paint_0 = new Paint()
      ..color = AppTheme.brownishGrey
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
     
         
    Path path_0 = Path();
    path_0.moveTo(0,0);
    path_0.lineTo(size.width,0);
    path_0.lineTo(size.width,size.height*0.8703535);
    path_0.quadraticBezierTo(size.width*0.7968561,size.height*0.9885606,size.width*0.5148668,size.height);
    path_0.cubicTo(size.width*0.5121936,size.height,size.width*0.5068472,size.height,size.width*0.5041741,size.height);
    path_0.quadraticBezierTo(size.width*0.2069805,size.height*0.9922222,size.width*0.0003375,size.height*0.8724495);
    path_0.lineTo(size.width*0.0006394,size.height*0.0012879);

    canvas.drawPath(path_0, paint_0);
  

  Paint paint_1 = new Paint()
      // ..color = Color.fromARGB(255, 33, 150, 243)
      ..color = AppTheme.electricBlue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
     
         
    Path path_1 = Path();
    path_1.moveTo(0,0);
    path_1.lineTo(size.width,0);
    path_1.lineTo(size.width,size.height*0.8721465);
    path_1.quadraticBezierTo(size.width*0.7675488,size.height*0.9702525,size.width*0.5119183,size.height*0.9734596);
    path_1.cubicTo(size.width*0.5085080,size.height*0.9734596,size.width*0.5031616,size.height*0.9734596,size.width*0.4997513,size.height*0.9734596);
    path_1.quadraticBezierTo(size.width*0.1970693,size.height*0.9592424,size.width*0.0003375,size.height*0.8724495);
    path_1.lineTo(size.width*0.0006394,size.height*0.0012879);

    canvas.drawPath(path_1, paint_1);
  
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}

class AppBarMedium extends CustomPainter{
  
  @override
  void paint(Canvas canvas, Size size) {
    
    

  Paint paint_0 = new Paint()
      ..color = AppTheme.brownishGrey
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
     
         
    Path path_0 = Path();
    path_0.moveTo(size.width*0.0002842,size.height*0.0010989);
    path_0.lineTo(size.width,size.height*0.0015385);
    path_0.lineTo(size.width,size.height*0.8108425);
    path_0.quadraticBezierTo(size.width*0.8129307,size.height*0.9783516,size.width*0.5030906,size.height);
    path_0.cubicTo(size.width*0.5004263,size.height,size.width*0.4950977,size.height,size.width*0.4924334,size.height);
    path_0.quadraticBezierTo(size.width*0.2077798,size.height*0.9868864,size.width*0.0003552,size.height*0.8156777);
    path_0.lineTo(size.width*0.0005329,size.height*0.0015385);

    canvas.drawPath(path_0, paint_0);
  

  Paint paint_1 = new Paint()
      ..color = AppTheme.electricBlue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
     
         
    Path path_1 = Path();
    path_1.moveTo(size.width*0.0002842,size.height*0.0010989);
    path_1.lineTo(size.width,size.height*0.0015385);
    path_1.lineTo(size.width,size.height*0.8108425);
    path_1.quadraticBezierTo(size.width*0.7767496,size.height*0.9586813,size.width*0.5022025,size.height*0.9578755);
    path_1.cubicTo(size.width*0.4995382,size.height*0.9578755,size.width*0.4942096,size.height*0.9578755,size.width*0.4915453,size.height*0.9578755);
    path_1.quadraticBezierTo(size.width*0.2541918,size.height*0.9598901,size.width*0.0003552,size.height*0.8156777);
    path_1.lineTo(size.width*0.0005329,size.height*0.0015385);

    canvas.drawPath(path_1, paint_1);
  
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}