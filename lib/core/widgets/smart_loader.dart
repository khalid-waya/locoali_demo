import 'package:flutter/material.dart';
import 'dart:async';

/// A simplified loading indicator that only appears when loading takes longer than a threshold.
///
/// This widget shows a circular progress indicator only if the loading process
/// takes longer than the specified threshold duration (default is 300ms).
class SmartLoader extends StatefulWidget {
  /// The widget to display.
  final Widget child;

  /// The threshold duration after which to show the loading indicator.
  /// Default is 300 milliseconds.
  final Duration thresholdDuration;

  /// The color of the circular progress indicator.
  final Color? indicatorColor;

  /// The size of the circular progress indicator.
  final double indicatorSize;

  /// The background color of the loading overlay.
  final Color? backgroundColor;

  const SmartLoader({
    Key? key,
    required this.child,
    this.thresholdDuration = const Duration(milliseconds: 300),
    this.indicatorColor,
    this.indicatorSize = 40.0,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<SmartLoader> createState() => _SmartLoaderState();
}

class _SmartLoaderState extends State<SmartLoader> {
  bool _showLoader = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Start a timer with the threshold duration
    _timer = Timer(widget.thresholdDuration, () {
      if (mounted) {
        setState(() {
          _showLoader = true;
        });
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
    return Stack(
      children: [
        // The main content
        widget.child,

        // The loading indicator (only shown if loading takes longer than threshold)
        if (_showLoader)
          Container(
            color: widget.backgroundColor ?? Colors.black.withOpacity(0.3),
            child: Center(
              child: SizedBox(
                height: widget.indicatorSize,
                width: widget.indicatorSize,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.indicatorColor ?? Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
