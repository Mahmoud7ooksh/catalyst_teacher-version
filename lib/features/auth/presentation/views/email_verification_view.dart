import 'package:catalyst/core/utils/assets.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/auth/presentation/cubit/email%20verification%20cubit/email_verification_cubit.dart';
import 'package:catalyst/features/auth/presentation/widgets/auth_background.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class EmailVerificationView extends StatelessWidget {
  final String email;
  const EmailVerificationView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: BlocListener<EmailVerificationCubit, EmailVerificationState>(
        listener: (context, state) {
          if (state is EmailVerificationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is EmailVerificationFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errMessage)));
          }
        },
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
                    'We have sent a verification code to your email. Please check your inbox and enter the code to verify your email address.',
              ),
              const SizedBox(height: 20),
              const CustomText(
                text:
                    'Did not receive the email?\nYou can resend it by clicking the button below.',
              ),
              const SizedBox(height: 20),
              BlocBuilder<EmailVerificationCubit, EmailVerificationState>(
                builder: (context, state) {
                  if (state is EmailVerificationLoading) {
                    return const CircularProgressIndicator();
                  }
                  return CustomButton(
                    text: 'Resend',
                    onPressed: () {
                      context
                          .read<EmailVerificationCubit>()
                          .resendVerificationEmail(email);
                    },
                  );
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
      ),
    );
  }
}
