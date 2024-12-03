import 'dart:io';
import 'package:easy_pdf_viewer/src/zoomable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A class to represent PDF page
/// [imgPath], path of the image (pdf page)
/// [num], page number
/// [onZoomChanged], function called when zoom is changed
/// [zoomSteps], number of zoom steps on double tap
/// [minScale] minimum zoom scale
/// [maxScale] maximum zoom scale
/// [panLimit] limit for pan
class PDFPage extends StatefulWidget {
  final String? imgPath;
  final int num;
  final Function(double)? onZoomChanged;
  final int zoomSteps;
  final double minScale;
  final double maxScale;
  final double panLimit;
  final Alignment alignment;
  final BoxFit? fit;
  PDFPage(
    this.imgPath,
    this.num, {
    this.onZoomChanged,
    this.zoomSteps = 3,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.panLimit = 1.0,
    this.fit,
    this.alignment = Alignment.center,
  });

  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  late ImageProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repaint();
  }

  @override
  void didUpdateWidget(PDFPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imgPath != widget.imgPath) {
      _repaint();
    }
  }

  void _repaint() {
    provider = FileImage(File(widget.imgPath!));
    final resolver = provider.resolve(createLocalImageConfiguration(context));
    resolver.addListener(ImageStreamListener((imgInfo, alreadyPainted) {
      if (mounted && !alreadyPainted) setState(() {});
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: null,
      child: ZoomableWidget(
        onZoomChanged: widget.onZoomChanged,
        zoomSteps: widget.zoomSteps,
        minScale: widget.minScale,
        panLimit: widget.panLimit,
        maxScale: widget.maxScale,
        child: Image(
          image: provider,
          alignment: widget.alignment,
          fit: widget.fit,
        ),
      ),
    );
  }
}
