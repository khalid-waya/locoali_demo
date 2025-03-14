import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/device_constraints.dart';

/// A SizedBox widget that provides responsive dimensions that scale with screen size
/// but cap at iPad Air dimensions for larger screens.
class ResponsiveSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;

  /// Creates a responsive sized box.
  ///
  /// The [width] and [height] will be scaled according to screen size,
  /// but will be capped for screens larger than iPad Air.
  const ResponsiveSizedBox({
    super.key,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null
          ? DeviceBreakpoints.getResponsiveDimension(context, width!)
          : null,
      height: height != null
          ? DeviceBreakpoints.getResponsiveDimension(context, height!)
          : null,
      child: child,
    );
  }

  /// Creates a responsive sized box with the given height.
  factory ResponsiveSizedBox.height(double height, {Key? key}) {
    return ResponsiveSizedBox(
      key: key,
      height: height,
    );
  }

  /// Creates a responsive sized box with the given width.
  factory ResponsiveSizedBox.width(double width, {Key? key}) {
    return ResponsiveSizedBox(
      key: key,
      width: width,
    );
  }

  /// Creates a responsive sized box with a square dimension.
  factory ResponsiveSizedBox.square(double dimension,
      {Key? key, Widget? child}) {
    return ResponsiveSizedBox(
      key: key,
      width: dimension,
      height: dimension,
      child: child,
    );
  }

  /// Creates a responsive sized box that will expand to fill the available space.
  static const ResponsiveSizedBox expand = ResponsiveSizedBox(
    width: double.infinity,
    height: double.infinity,
  );
}

/// Extension method for easier usage with any widget
extension ResponsiveSizedBoxExtension on Widget {
  Widget withResponsiveSpacing({
    double? width,
    double? height,
  }) {
    return ResponsiveSizedBox(
      width: width,
      height: height,
      child: this,
    );
  }
}
