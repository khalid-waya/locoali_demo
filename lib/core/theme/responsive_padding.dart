import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/device_constraints.dart';

/// A widget that provides responsive padding that scales with screen size
/// but caps at iPad Air dimensions for larger screens.
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? horizontal;
  final double? vertical;
  final double? all;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  /// Creates a responsive padding widget.
  ///
  /// You can either provide a complete [padding] object,
  /// or specify individual dimensions using [horizontal], [vertical], [all],
  /// [left], [top], [right], or [bottom].
  const ResponsivePadding({
    super.key,
    required this.child,
    this.padding,
    this.horizontal,
    this.vertical,
    this.all,
    this.left,
    this.top,
    this.right,
    this.bottom,
  }) : assert(
          (padding != null) ||
              (horizontal != null ||
                  vertical != null ||
                  all != null ||
                  left != null ||
                  top != null ||
                  right != null ||
                  bottom != null),
          'Either padding or at least one dimension must be specified',
        );

  @override
  Widget build(BuildContext context) {
    // If a complete padding object is provided, scale it
    if (padding != null) {
      return Padding(
        padding: _getScaledPadding(context, padding!),
        child: child,
      );
    }

    // Otherwise, build padding from individual dimensions
    final double allValue = all ?? 0.0;

    final double leftValue = left ?? horizontal ?? allValue;
    final double rightValue = right ?? horizontal ?? allValue;
    final double topValue = top ?? vertical ?? allValue;
    final double bottomValue = bottom ?? vertical ?? allValue;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        DeviceBreakpoints.getResponsiveDimension(context, leftValue),
        DeviceBreakpoints.getResponsiveDimension(context, topValue),
        DeviceBreakpoints.getResponsiveDimension(context, rightValue),
        DeviceBreakpoints.getResponsiveDimension(context, bottomValue),
      ),
      child: child,
    );
  }

  /// Scales each dimension of the padding according to screen size
  EdgeInsetsGeometry _getScaledPadding(
      BuildContext context, EdgeInsetsGeometry padding) {
    if (padding is EdgeInsets) {
      return EdgeInsets.fromLTRB(
        DeviceBreakpoints.getResponsiveDimension(context, padding.left),
        DeviceBreakpoints.getResponsiveDimension(context, padding.top),
        DeviceBreakpoints.getResponsiveDimension(context, padding.right),
        DeviceBreakpoints.getResponsiveDimension(context, padding.bottom),
      );
    } else {
      // For other types of EdgeInsetsGeometry, we can't easily scale them
      // So we'll just return the original
      return padding;
    }
  }
}

/// Extension method for easier usage with any widget
extension ResponsivePaddingExtension on Widget {
  Widget withResponsivePadding({
    EdgeInsetsGeometry? padding,
    double? horizontal,
    double? vertical,
    double? all,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return ResponsivePadding(
      padding: padding,
      horizontal: horizontal,
      vertical: vertical,
      all: all,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: this,
    );
  }
}
