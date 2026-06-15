import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoshMeshLogoMark extends StatelessWidget {
  final double size;
  const NoshMeshLogoMark({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo_mark.svg',
      width: size,
      height: size,
    );
  }
}

class NoshMeshWordmark extends StatelessWidget {
  final double height;
  const NoshMeshWordmark({super.key, this.height = 40});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NoshMeshLogoMark(size: height),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: height * 0.55,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            children: [
              const TextSpan(
                text: 'Nosh',
                style: TextStyle(color: Color(0xFFe8390e)),
              ),
              TextSpan(
                text: 'Mesh',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF1a1a1a),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
