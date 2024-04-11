import 'package:flutter/material.dart';
import 'package:img_to_text/function_and_stuff/functions.dart';
import 'package:flutter_share/flutter_share.dart';

TextEditingController TextScanController = TextEditingController();

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    TextScanController.text = text;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('OCR Result')),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
        child: Center(child: Column(
          children: [
            Flexible(
              child: SingleChildScrollView(
                  child: TextFormField(
                    maxLines: 20,
                    controller: TextScanController,
              
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 5),
              child: GestureDetector(
                onTap: () async{
                  print(TextScanController.text.toString());
                  try{
                    share(TextScanController.text.toString());
                  }catch(e){
                    Snack_Message(context, e.toString());
                  }


                },
                child: const Icon(Icons.share, size: 35),
              ),
            )
          ],
        )),
      ),
      bottomNavigationBar: bottomDevName(),
    );
  }

  Future<void> share(text) async {
    await FlutterShare.share(
        title: 'Text Scan',
        text: text,
    );
  }

}