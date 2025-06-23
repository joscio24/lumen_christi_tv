import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LiveStreamPage extends StatefulWidget {
  @override
  _LiveStreamPageState createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  late InAppWebViewController _webViewController;
  late InAppWebView _webView = InAppWebView();

  @override
  void initState() {
    super.initState();
    _webView = InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(
            'https://peertube.mesnumeriques.fr/videos/embed/0cc54dae-4250-4d54-b490-ae57fc063e66?autoplay=1&warningTitle=0&peertubeLink=0'),
      ),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          javaScriptEnabled: true,
        ),
      ),
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      onLoadStart: (controller, url) {
        print("Page started loading: $url");
      },
      onLoadStop: (controller, url) {
        print("Page finished loading: $url");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Feed"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _webView, // Embed the InAppWebView widget here
            ),
          ],
        ),
      ),
    );
  }
}
