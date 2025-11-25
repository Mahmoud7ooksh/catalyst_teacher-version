import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:catalyst/core/utils/assets.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  /// ===== الفكتورات العلوية (طبقات فوق بعض) =====
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      SvgPicture.asset(
                        Assets.vector1,
                        width: width,
                        fit: BoxFit.cover,
                      ),
                      SvgPicture.asset(
                        Assets.vector2,
                        width: width,
                        fit: BoxFit.cover,
                      ),
                      SvgPicture.asset(
                        Assets.vector3,
                        width: width,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),

                  /// ===== المحتوى =====
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: child,
                    ),
                  ),

                  /// ===== الفكتور السفلي =====
                  SvgPicture.asset(
                    Assets.vector4,
                    width: width,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
