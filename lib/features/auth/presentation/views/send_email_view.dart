import 'package:catalyst/core/utils/assets.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/auth/presentation/cubit/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:catalyst/features/auth/presentation/widgets/auth_background.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SendEmailView extends StatelessWidget {
  const SendEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: AuthBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.email),
            const SizedBox(height: 20),
            const CustomText(
              text: 'Check Your Email',
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            const CustomText(
              text:
                  'We have sent a link to your email. Please check your inbox and click the link to reset your password.',
            ),
            const SizedBox(height: 20),
            const CustomText(
              text:
                  'Did not receive the email?\nYou can resend it by clicking the button below.',
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Resend',
              onPressed: () {
                context.read<ForgetPasswordCubit>().forgotPassword();
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Go to Login',
              onPressed: () {
                GoRouter.of(context).go(Routs.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
