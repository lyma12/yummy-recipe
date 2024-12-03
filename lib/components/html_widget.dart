import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HtmlWidget extends StatelessWidget {
  final String htmlData;

  const HtmlWidget({
    super.key,
    required this.htmlData,
  });

  @override
  Widget build(BuildContext context) {
    final textSpans = _parseHtmlToTextSpans(htmlData);

    return RichText(
      text: TextSpan(
        children: textSpans,
        style: DefaultTextStyle.of(context).style,
      ),
    );
  }

  List<TextSpan> _parseHtmlToTextSpans(String html) {
    final List<TextSpan> spans = [];
    final RegExp exp = RegExp(
      r'(<b>(.*?)<\/b>)|(<a href="(.*?)">(.*?)<\/a>)|(.*?)(?=<b>|<a|$)',
      dotAll: true,
    );
    final matches = exp.allMatches(html);

    for (final match in matches) {
      if (match.group(2) != null) {
        // Text inside <b> tags
        spans.add(TextSpan(
          text: match.group(2),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(4) != null) {
        // Text inside <a> tags
        spans.add(TextSpan(
          text: match.group(5),
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              final url = match.group(4);
              Utilities.launchInWebView(Uri.parse(url ?? ""));
            },
        ));
      } else if (match.group(0) != null &&
          match.group(2) == null &&
          match.group(4) == null) {
        // Regular text
        spans.add(TextSpan(text: match.group(0)));
      }
    }

    return spans;
  }
}
