import 'dart:ui';
import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:catalyst/core/widgets/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: kToolbarHeight + 49, // ارتفاع ال header
              decoration: BoxDecoration(
                color: AppColors.color1,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: SvgPicture.asset(
            Assets.appbar2,
            height: MediaQuery.of(context).size.height * 0.117,
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent, // عشان ياخد لون الـ Container
          elevation: 0,
          centerTitle: centerTitle,
          leading: leading,
          title: CustomText(
            text: title ?? '',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          actions: actions,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}
