import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NocamScreen extends StatefulWidget {
  const NocamScreen({super.key});

  @override
  State<NocamScreen> createState() => _NocamScreenState();
}

class _NocamScreenState extends State<NocamScreen> {
  File? selectedMedia;
  Uint8List? selectedMediaBytes;
  String recognizedText = '';
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Text Recognition"),
      ),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        child: const Icon(Icons.folder),
        heroTag: 'file_manager',
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        if (kIsWeb) {
          // On web, use bytes
          if (file.bytes != null) {
            setState(() {
              selectedMediaBytes = file.bytes;
              isProcessing = true;
            });
            print('Selected file: ${file.name}');
            String? text = await _extractTextFromBytes(file.bytes!);
            setState(() {
              recognizedText = text ?? '';
              isProcessing = false;
            });
            _showTitleInputDialog();
          } else {
            _showErrorDialog("File bytes are null.");
          }
        } else {
          // On mobile/desktop, use path
          if (file.path != null) {
            setState(() {
              selectedMedia = File(file.path!);
              isProcessing = true;
            });
            print('Selected file: ${file.path}');
            String? text = await _extractText(selectedMedia!);
            setState(() {
              recognizedText = text ?? '';
              isProcessing = false;
            });
            _showTitleInputDialog();
          } else {
            _showErrorDialog("File path is null.");
          }
        }
      } else {
        _showErrorDialog("No file selected.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred while picking the file: $e");
    }
  }

  Widget _buildUI() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _imageView(),
        _extractTextView(),
      ],
    );
  }

  Widget _imageView() {
    if (selectedMedia == null && selectedMediaBytes == null) {
      return const Center(
        child: Text("Pick an image for text recognition."),
      );
    }
    if (kIsWeb && selectedMediaBytes != null) {
      return Center(
        child: Image.memory(
          selectedMediaBytes!,
          width: 200,
        ),
      );
    } else if (selectedMedia != null) {
      return Center(
        child: Image.file(
          selectedMedia!,
          width: 200,
        ),
      );
    }
    return const Center(
      child: Text("No image available."),
    );
  }

  Widget _extractTextView() {
    if (isProcessing) {
      return const CircularProgressIndicator();
    }
    if (selectedMedia == null && selectedMediaBytes == null) {
      return const Center(
        child: Text("No result."),
      );
    }
    return Text(
      recognizedText,
      style: const TextStyle(
        fontSize: 25,
      ),
    );
  }

  Future<String?> _extractText(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(file.path);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();
    print('Recognized text: $text');
    return text;
  }

  Future<String?> _extractTextFromBytes(Uint8List bytes) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(200, 200),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.yuv420,
        bytesPerRow: 200,
      ),
    );
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();
    print('Recognized text: $text');
    return text;
  }

  void _showTitleInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        return AlertDialog(
          title: const Text("Save Text Recognition Result"),
          content: TextField(
            onChanged: (value) {
              title = value;
            },
            decoration: const InputDecoration(hintText: "Enter a title"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveResult(title, recognizedText);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _saveResult(String title, String text) {
    // Implement your save logic here
    // For example, save the title and text to a database or local storage
    print('Saved result: Title: $title, Text: $text');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}