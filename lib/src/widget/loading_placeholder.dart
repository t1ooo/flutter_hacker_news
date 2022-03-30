import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({Key? key, this.height=100}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        color: Colors.white,
      ),
    );
  }
}
