import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/utils/assets.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/core/utils/vlidation.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/auth/presentation/cubit/login%20cubit/login_cubit.dart';
import 'package:catalyst/features/auth/presentation/widgets/auth_background.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:catalyst/core/widgets/custom_textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: BlocListener<LoginCubit, LoginCubitState>(
        listener: (context, state) {
          if (state is LoginCubitError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is LoginCubitSuccess) {
            if (state.isConfirmed) {
              GoRouter.of(context).go(Routs.root);
            } else {
              GoRouter.of(context).push(
                Routs.emailVerification,
                extra: context.read<LoginCubit>().emailController.text,
              );
            }
          }
        },
        child: Stack(
          children: [
            AuthBackground(
              child: Form(
                key: _formKey,
                autovalidateMode: autoValidateMode,
                child: Column(
                  // ===== textfields =====
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(Assets.catalyst, fit: BoxFit.cover),
                    const SizedBox(height: 60),
                    CustomTextformfield(
                      controller: context.read<LoginCubit>().emailController,
                      label: 'Email',
                      icon: CupertinoIcons.mail,
                      validator: Validation.validateEmail,
                    ),
                    const SizedBox(height: 20),
                    CustomTextformfield(
                      controller: context.read<LoginCubit>().passwordController,
                      label: 'Password',
                      icon: CupertinoIcons.lock,
                      validator: Validation.validatePassword,
                      isPassword: true,
                    ),

                    // ===== forget password =====
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          GoRouter.of(context).push(Routs.forgetPassword);
                        },
                        child: CustomText(
                          text: 'Forgot Password?',
                          color: AppColors.color2,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 55),

                    // ===== login button =====
                    CustomButton(
                      text: 'LOGIN',
                      onPressed: () {
                        autoValidateMode = AutovalidateMode.always;
                        setState(() {});

                        // Validate form before submitting
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginCubit>().login();
                        }
                      },
                    ),
                    const SizedBox(height: 15),

                    // ===== don't have an account =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(
                          text: 'Don\'t have an account?',
                          color: AppColors.text,
                          fontSize: 14,
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).push(Routs.register);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.color2,
                            padding: EdgeInsets.zero,
                          ),
                          child: const CustomText(
                            text: 'SIGN UP',
                            color: AppColors.color2,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<LoginCubit, LoginCubitState>(
              builder: (context, state) {
                if (state is LoginCubitLoading) {
                  return Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
