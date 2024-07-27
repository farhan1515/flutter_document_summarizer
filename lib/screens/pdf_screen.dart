import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_document_summarizer/api/summary_service.dart';
import 'package:flutter_document_summarizer/screens/preview_screen.dart';
import 'package:flutter_document_summarizer/screens/summary_screen.dart';


class PdfScreen extends StatefulWidget {
  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  final SummaryService _summaryService = SummaryService();
  PlatformFile? file;
  double summaryLength = 0.5;
  double detailLevel = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Document Summarizer")),
        elevation: 5,
        actions: [IconButton(onPressed: () async {
          //await signOut();
        }, icon: Icon(Icons.logout))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: pickFile, child: Text("Select File")),
                SizedBox(
                  height: 20,
                ),
                if (file != null) ...[
                  selectedFile(context),
                  SizedBox(
                    height: 40,
                  ),
                  summaryLevelSlider(),
                  SizedBox(height: 20,),
                  detailLevelSlider(),
                  SizedBox(height: 20,),
                  summarizeButton(context)
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton summarizeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (file != null && file!.bytes != null) {
          try {
            final summary = await _summaryService.summarizeDocument(
              file!,
              summaryLength,
              detailLevel.toInt(),
            );

            if (context.mounted) {
              Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => SummaryScreen(
                  summary: summary, filename: file!.name))
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e'))
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File bytes are null.'))
          );
        }
      }, child: Text('Summarize'),
    );
  }

  Column summaryLevelSlider() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Summary Length',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 10,
            ),
            Chip(
              label: Text(
                summaryLength.toStringAsPrecision(2),
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
        Slider(
            min: 0.1,
            max: 1,
            value: summaryLength,
            label: summaryLength.toStringAsPrecision(2),
            onChanged: (double value) {
              setState(() {
                summaryLength = value;
              });
            })
      ],
    );
  }

  Column detailLevelSlider() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Detail Level',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 10,
            ),
            Chip(
              label: Text(
                detailLevel.toStringAsPrecision(2),
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
        Slider(
            min: 1,
            max: 5,
            divisions: 4,
            value: detailLevel,
            label: detailLevel.toStringAsPrecision(2),
            onChanged: (double value) {
              setState(() {
                detailLevel = value;
              });
            })
      ],
    );
  }

  Row selectedFile(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text("Selected File : ${file!.name}")),
        SizedBox(
          width: 20,
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewScreen(file: file!),
              ),
            );
          },
          child: Text('Preview'),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                file = null;
              });
            },
            icon: const Icon(Icons.cancel))
      ],
    );
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt'],
    );
    if (result != null) {
      setState(() {
        file = result.files.single;
      });
    }
  }
}