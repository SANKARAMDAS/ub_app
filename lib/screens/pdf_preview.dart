import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String path;

  PdfPreviewScreen({required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: PdfViewer.openFile(path),
    ));
  }
}
