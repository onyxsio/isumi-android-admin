import 'package:flutter/material.dart';
import 'package:onyxsio/onyxsio.dart';
import 'cubit/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Let’s Get Started 😁',
                style: TxtStyle.h14B,
              ),
              SizedBox(height: 5.w),
              Text(
                "Sign up or login in to sell more products",
                textAlign: TextAlign.center,
                style: TxtStyle.b5,
              ),
              SizedBox(height: 20.w),
              // _EmailInput(),
              TextBox(
                controller: email,
                type: TXT.email,
                hintText: 'email',
              ),
              SizedBox(height: 6.w),
              // _PasswordInput(),
              TextBox(
                controller: password,
                type: TXT.password,
                hintText: 'password',
              ),
              SizedBox(height: 6.w),
              Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).pushNamed('/ForgotPassPage'),
                    child: Text(
                      "I don't remember the password ?",
                      textAlign: TextAlign.end,
                      style: TxtStyle.h6,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.w),
              _LoginButton(),
              SizedBox(height: 6.w),
              // Row(
              //   children: const [
              //     Expanded(child: Divider(thickness: 2)),
              //     SizedBox(width: 10),
              //     Text(' OR '),
              //     SizedBox(width: 10),
              //     Expanded(child: Divider(thickness: 2)),
              //   ],
              // ),
              // const SizedBox(height: 12),
              // const SizedBox(height: 12),
              _SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

// class _EmailInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // final theme = Theme.of(context);
//     return BlocBuilder<LoginCubit, LoginState>(
//       buildWhen: (previous, current) => previous.email != current.email,
//       builder: (context, state) {
//         return Container(
//           padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
//           // height: 54,
//           // padding: const EdgeInsets.symmetric(horizontal: 20),
//           decoration: BoxDeco.textbox(state.email.invalid),

//           // decoration: BoxDecoration(
//           //   // color: whiteColor,
//           //   border: Border.all(
//           //       width: 1,
//           //       color: state.email.invalid ? Colors.red : Colors.grey),
//           //   borderRadius: BorderRadius.circular(16),
//           // ),
//           child: Center(
//             child: TextFormField(
//               maxLines: 1,
//               keyboardType: TextInputType.emailAddress,
//               controller: email,
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.zero,
//                 hintText: 'email',
//                 border: InputBorder.none,
//                 helperText: '',
//                 errorText:
//                     state.email.invalid ? 'invalid email address format' : null,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _PasswordInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return BlocBuilder<LoginCubit, LoginState>(
//       buildWhen: (previous, current) => previous.password != current.password,
//       builder: (context, state) {
//         return Container(
//           height: 54,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           decoration: BoxDecoration(
//             // color: whiteColor,
//             // border: Border.all(
//             border: Border.all(
//                 width: 1,
//                 color: state.password.invalid ? Colors.red : Colors.grey),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Center(
//             child: TextField(
//               obscureText: true,
//               controller: password,
//               decoration: InputDecoration(
//                 hintText: 'password',
//                 contentPadding: EdgeInsets.zero,
//                 border: InputBorder.none,
//                 helperText: '',
//                 errorText: state.password.invalid ? 'invalid password' : null,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : MainButton(
                onTap: () {
                  context.read<LoginCubit>().emailChanged(email.text);
                  context.read<LoginCubit>().passwordChanged(password.text);
                  //       // if (state.status.isValidated) {

                  context.read<LoginCubit>().logInWithCredentials();
                  //
                },
                text: 'Get Started');
        // : InkWell(
        //     onTap: () {
        //       context.read<LoginCubit>().emailChanged(email.text);
        //       context.read<LoginCubit>().passwordChanged(password.text);
        //       // if (state.status.i@gmail@sValidated) {

        //       context.read<LoginCubit>().logInWithCredentials();
        //       // }
        //     },
        //     child: Container(
        //         height: 54,
        //         padding: const EdgeInsets.symmetric(horizontal: 20),
        //         decoration: BoxDecoration(
        //           color: Colors.blue,
        //           borderRadius: BorderRadius.circular(16),
        //         ),
        //         child: Center(
        //             child: Text(
        //           'Get Started',
        //           // style: TextStyles.btnB.copyWith(color: whiteColor),
        //         ))),
        //   );
      },
    );
  }
}

// class _GoogleLoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return InkWell(
//       key: const Key('loginForm_googleLogin_raisedButton'),
//       child: Container(
//         height: 54,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//           color: whiteColor,
//           border: Border.all(width: 1, color: theme.btnBorderColor),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
// SvgPicture.asset(
//   AppIcon.google,
//   height: 30,
// ),
//               const SizedBox(width: 12),
//               Text(
//                 'Continue with Gmail',
//                 style: TextStyles.btn,
//               ),
//             ],
//           ),
//         ),
//       ),

//       // onTap: () => context.read<LoginCubit>().logInWithFacebook(),
//       onTap: () => context.read<LoginCubit>().logInWithGoogle(),
//     );
//   }
// }

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount'),
      onPressed: () => Navigator.of(context)
          .pushNamedAndRemoveUntil('/SignUpPage', (route) => false),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'Not registered yet?',
            style: TxtStyle.b5,
          ),
          TextSpan(
            text: ' Create an Account',
            style: TxtStyle.b5B,
          ),
        ]),
      ),
    );
  }
}
