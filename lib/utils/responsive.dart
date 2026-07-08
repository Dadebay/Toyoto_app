import 'package:flutter/widgets.dart';

/// iPad/tablet vs phone layout breakpoint, based on the shortest side so it
/// holds regardless of orientation.
extension Responsive on BuildContext {
  bool get isTablet => MediaQuery.sizeOf(this).shortestSide >= 600;
}
