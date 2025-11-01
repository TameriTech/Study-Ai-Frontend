
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../l10n/app_localizations.dart';


class ExpandableMarkdown extends StatefulWidget {
  final String markdown;
  final int trimLines;

  const ExpandableMarkdown({
    Key? key,
    required this.markdown,
    this.trimLines = 10,
  }) : super(key: key);

  @override
  _ExpandableMarkdownState createState() => _ExpandableMarkdownState();
}

class _ExpandableMarkdownState extends State<ExpandableMarkdown> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: widget.markdown,
          style: const TextStyle(fontSize: 14),
        );

        final tp = TextPainter(
          text: textSpan,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = tp.didExceedMaxLines;

        return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownBody(
                data: isExpanded || !isOverflowing
                    ? widget.markdown
                    : _truncateMarkdown(widget.markdown, widget.trimLines),
              ),
              if (isOverflowing)
                GestureDetector(
                  onTap: () => setState(() => isExpanded = !isExpanded),
                  child: Text(
                    isExpanded ? "...${AppLocalizations.of(context).read_less}" : "...${AppLocalizations.of(context).read_more}",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  String _truncateMarkdown(String markdown, int lines) {
    final linesList = markdown.split('\n');
    if (linesList.length <= lines) return markdown;
    return linesList.take(lines).join('\n') + '...';
  }
}