import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'camera_view.dart';
import 'text_detector_painter.dart';

class TextDetectorView extends StatefulWidget {
  const TextDetectorView({Key? key, required this.addMessage})
      : super(key: key);

  final FutureOr<void> Function(String message) addMessage;
  @override
  _TextDetectorViewState createState() => _TextDetectorViewState();
}

class _TextDetectorViewState extends State<TextDetectorView> {
  TextDetector textDetector = GoogleMlKit.vision.textDetector();
  bool isBusy = false;
  CustomPaint? customPaint;
  TextEditingController imageText = TextEditingController();


  @override
  void dispose() async {
    super.dispose();
    await textDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Text Detector',
      customPaint: customPaint,
      addMessage: widget.addMessage,
      onImage: (inputImage, imageText) {
        processImage(inputImage, imageText);
      },
    );
  }

  Future<void> processImage(InputImage inputImage, TextEditingController processedText) async {
    if (isBusy) return;
    isBusy = true;
    final recognisedText = await textDetector.processImage(inputImage);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = TextDetectorPainter(
          recognisedText,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {
        processedText.text = recognisedText.text;
      });
    }
  }
}
