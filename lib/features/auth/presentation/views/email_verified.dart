import 'package:catalyst/core/utils/assets.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/auth/presentation/widgets/auth_background.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:catalyst/core/utils/routs.dart';

class EmailVerifiedView extends StatelessWidget {
  const EmailVerifiedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: AuthBackground(
        child: Column(
          children: [
            SvgPicture.asset(Assets.verified),
            const SizedBox(height: 20),
            const CustomText(
              text: 'Email Verified',
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            const CustomText(
              text:
                  'Your email has been verified successfully. You can now log in to your account.',
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Login',
              onPressed: () {
                GoRouter.of(context).push(Routs.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
