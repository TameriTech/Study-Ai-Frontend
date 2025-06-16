
import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final Duration speed;
  final Duration startDelay;
  final TextStyle? style;

  const TypewriterText({
    Key? key,
    required this.text,
    this.speed = const Duration(milliseconds: 50),
    this.startDelay = const Duration(seconds: 2),
    this.style,
  }) : super(key: key);

  @override
  _TypewriterTextState createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = '';
  int _charIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _delayedStart();
  }

  void _delayedStart() async {
    await Future.delayed(widget.startDelay);
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.speed, (timer) {
      if (_charIndex < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_charIndex];
          _charIndex++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style ?? Theme.of(context).textTheme.bodyLarge,
    );
  }
}