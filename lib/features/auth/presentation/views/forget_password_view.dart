import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/features/auth/presentation/cubit/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:catalyst/features/auth/presentation/cubit/forget%20password%20cubit/forget_password_state.dart';
import 'package:catalyst/features/auth/presentation/widgets/auth_background.dart';
import 'package:catalyst/features/auth/presentation/widgets/custom_button.dart';
import 'package:catalyst/features/auth/presentation/widgets/custom_textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:catalyst/core/utils/routs.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AutovalidateMode autoValidate = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            GoRouter.of(context).push(Routs.verificationCode);
          }
          if (state is ForgetPasswordFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Opacity(
                opacity: state is ForgetPasswordLoading ? 0.5 : 1,
                child: AuthBackground(
                  child: Column(
                    children: [
                      Spacer(),
                      Form(
                        autovalidateMode: autoValidate,
                        key: _formKey,

                        // ===== email textfield =====
                        child: CustomTextformfield(
                          controller: context
                              .read<ForgetPasswordCubit>()
                              .emailController,
                          label: 'enter your email',
                          icon: CupertinoIcons.mail,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 100),

                      // ===== send button =====
                      CustomButton(
                        text: 'SEND',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<ForgetPasswordCubit>()
                                .forgotPassword();
                          } else {
                            setState(() {
                              autoValidate = AutovalidateMode.onUserInteraction;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 10),

                      Spacer(),
                    ],
                  ),
                ),
              ),

              // ===== back button =====
              Positioned(
                top: 12,
                child: IconButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      size: 30,
                      Icons.arrow_back,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              if (state is ForgetPasswordLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }
}
