import 'package:flutter/material.dart';
import 'package:flutter_document_summarizer/api/summary_service.dart';


class SummaryScreen extends StatelessWidget {
  final String summary;
  final String filename;

  SummaryScreen({
    Key? key,
    required this.summary,
    required this.filename,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                summary,
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () async {
                  final summaryService = SummaryService();
                  //await summaryService.storeSummary(summary, filename);
                },
                child: Text("Save Summary"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}