import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Search extends StatelessWidget {
  Search({Key? key}) : super(key: key);

  final browser = InAppBrowser();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            color: Colors.grey,
            size: 28.0,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Enter token name or token contract address',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                border: InputBorder.none,
              ),
              onSubmitted: (input) {
                browser.openUrlRequest(
                  urlRequest: URLRequest(url: Uri.parse(input)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
