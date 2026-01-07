import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/utils/assets.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/core/utils/vlidation.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/auth/presentation/cubit/register%20cubit/register_cubit.dart';
import 'package:catalyst/features/auth/presentation/cubit/register%20cubit/register_state.dart';
import 'package:catalyst/features/auth/presentation/widgets/auth_background.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:catalyst/core/widgets/custom_textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: BlocListener<RegisterCubit, RegisterCubitState>(
        listener: (context, state) {
          if (state is RegisterCubitSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.successMessage)));
            GoRouter.of(context).go(
              Routs.login,
              extra: context.read<RegisterCubit>().emailController.text,
            );
          } else if (state is RegisterCubitError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        child: Stack(
          children: [
            AuthBackground(
              child: Form(
                key: _formKey,
                autovalidateMode: autoValidate,
                child: Column(
                  children: [
                    SvgPicture.asset(Assets.catalyst, fit: BoxFit.cover),
                    const SizedBox(height: 60),

                    // ============= textfields ===========
                    CustomTextformfield(
                      controller: context.read<RegisterCubit>().nameController,
                      label: 'Full name',
                      icon: CupertinoIcons.person,
                      validator: Validation.validateName,
                    ),
                    const SizedBox(height: 20),
                    CustomTextformfield(
                      controller: context
                          .read<RegisterCubit>()
                          .userNameController,
                      label: 'Username',
                      icon: CupertinoIcons.lock,
                      validator: Validation.validatePassword,
                    ),
                    const SizedBox(height: 20),

                    CustomTextformfield(
                      controller: context.read<RegisterCubit>().emailController,
                      label: 'Email',
                      icon: CupertinoIcons.mail,
                      validator: Validation.validateEmail,
                    ),
                    const SizedBox(height: 20),

                    CustomTextformfield(
                      controller: context
                          .read<RegisterCubit>()
                          .passwordController,
                      label: 'Password',
                      icon: CupertinoIcons.lock,
                      validator: Validation.validatePassword,
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),

                    CustomTextformfield(
                      controller: context
                          .read<RegisterCubit>()
                          .confirmPasswordController,
                      label: 'Confirm Password',
                      icon: CupertinoIcons.lock,
                      isPassword: true,
                      validator: (value) => Validation.validateConfirmPassword(
                        value,
                        context.read<RegisterCubit>().passwordController.text,
                      ),
                    ),

                    const SizedBox(height: 50),

                    /// Sign Up button
                    CustomButton(
                      text: 'SIGN UP',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<RegisterCubit>().signUp();
                        } else {
                          setState(() {
                            autoValidate = AutovalidateMode.always;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    /// Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(
                          text: 'Already have an account?',
                          color: AppColors.text,
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.color2,
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            GoRouter.of(context).go(Routs.login);
                          },
                          child: CustomText(
                            text: 'LOGIN',
                            color: AppColors.color2,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ===== loading =====
            BlocBuilder<RegisterCubit, RegisterCubitState>(
              builder: (context, state) {
                if (state is RegisterCubitLoading) {
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
