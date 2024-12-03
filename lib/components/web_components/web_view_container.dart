import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  const WebViewContainer({
    super.key,
    required this.uri,
    this.onUrlChanged,
  });

  final String uri;
  final ValueChanged<String>? onUrlChanged;

  @override
  State<StatefulWidget> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  var loadingPercentage = 0;
  late final WebViewController controller;
  late ValueChanged<String> onUrlChanged;
  @override
  void initState() {
    onUrlChanged = widget.onUrlChanged ?? (_){};
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          if (mounted) {
            setState(() {
              loadingPercentage = 0;
            });
            onUrlChanged(url);
          }
        },
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              loadingPercentage = progress;
            });
          }
        },
        onPageFinished: (url) {
          if (mounted) {
            setState(() {
              loadingPercentage = 100;
            });
            onUrlChanged(url);
          }
        },
      ))
      ..loadRequest(Uri.parse(widget.uri));
  }
  Future<void> _goBack() async {
    if (await controller.canGoBack()) {
      await controller.goBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Stack(
        children: [
          WebViewWidget(controller: controller),
          ElevatedButton(
            onPressed: _goBack,
            child: const Icon(Icons.arrow_circle_left),
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100,
            ),
        ],
      ),
    );
  }
}
