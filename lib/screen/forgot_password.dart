import 'package:booker/bloc/forgot-password/reset_password/reset_password_bloc.dart';
import 'package:booker/bloc/forgot-password/reset_password/reset_password_event.dart';
import 'package:booker/bloc/forgot-password/reset_password/reset_password_state.dart';
import 'package:booker/bloc/forgot-password/send_otp/send_otp_bloc.dart';
import 'package:booker/bloc/forgot-password/send_otp/send_otp_event.dart';
import 'package:booker/bloc/forgot-password/send_otp/send_otp_state.dart';
import 'package:booker/bloc/forgot-password/verify_reset/verify_reset_bloc.dart';
import 'package:booker/bloc/forgot-password/verify_reset/verify_reset_event.dart';
import 'package:booker/bloc/forgot-password/verify_reset/verify_reset_state.dart';
import 'package:booker/service/forget_password_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterPhoneScreen extends StatefulWidget {
  @override
  State<EnterPhoneScreen> createState() => _EnterPhoneScreenState();
}

class _EnterPhoneScreenState extends State<EnterPhoneScreen> {
  final phoneController = TextEditingController();
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SendOtpBloc(ForgetPasswordService()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF7F56D9),
          title: Text(
            "Forgot Password",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                  errorText: isError ? "Invalid phone number" : null,
                ),
              ),
              SizedBox(height: 20),

              BlocConsumer<SendOtpBloc, SendOtpState>(
                listener: (context, state) {
                  if (state is SendOtpSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VerifyResetScreen(phone: phoneController.text),
                      ),
                    );
                  } else if (state is SendOtpError) {
                    setState(() => isError = true);
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() => isError = false);

                      context.read<SendOtpBloc>().add(
                        SendOtpPressed(phoneController.text),
                      );
                    },
                    child: state is SendOtpLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Send Code"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerifyResetScreen extends StatefulWidget {
  final String phone;

  const VerifyResetScreen({super.key, required this.phone});

  @override
  State<VerifyResetScreen> createState() => _VerifyResetScreenState();
}

class _VerifyResetScreenState extends State<VerifyResetScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController otpController = TextEditingController();

  bool isError = false;

  late AnimationController shakeController;
  late Animation<double> offsetAnimation;

  @override
  void initState() {
    super.initState();

    shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    offsetAnimation = Tween(
      begin: 0.0,
      end: 20.0,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(shakeController);
  }

  @override
  void dispose() {
    otpController.dispose();
    shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyResetBloc(ForgetPasswordService()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Verify Code")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text("📱 phone_number : ${widget.phone}"),
              const SizedBox(height: 20),

              AnimatedBuilder(
                animation: shakeController,
                builder: (context, child) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: offsetAnimation.value.abs(),
                    ),
                    child: TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: " Enter the verification code ",
                        border: const OutlineInputBorder(),
                        errorText: isError ? " The code is incorrect " : null,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              BlocConsumer<VerifyResetBloc, VerifyResetState>(
                listener: (context, state) {
                  if (state is VerifyResetSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ResetPasswordScreen(phone: widget.phone),
                      ),
                    );
                  } else if (state is VerifyResetError) {
                    setState(() => isError = true);
                    shakeController.forward(from: 0);

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is VerifyResetLoading
                        ? null
                        : () {
                            setState(() => isError = false);

                            context.read<VerifyResetBloc>().add(
                              VerifyResetCodePressed(
                                widget.phone,
                                otpController.text,
                              ),
                            );
                          },
                    child: state is VerifyResetLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Check"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//شاشة ادخال الباسورد الجديد
class ResetPasswordScreen extends StatefulWidget {
  final String phone;
  ResetPasswordScreen({required this.phone});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passController = TextEditingController();
  final confirmController = TextEditingController();
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordBloc(ForgetPasswordService()),
      child: Scaffold(
        appBar: AppBar(title: Text("Reset Password")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                  errorText: isError ? "Passwords do not match" : null,
                ),
              ),
              SizedBox(height: 20),

              BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
                listener: (context, state) {
                  if (state is ResetPasswordSuccess) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));

                    Navigator.popUntil(context, (route) => route.isFirst);
                  } else if (state is ResetPasswordError) {
                    setState(() => isError = true);
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() => isError = false);

                      if (passController.text != confirmController.text) {
                        setState(() => isError = true);
                        return;
                      }

                      context.read<ResetPasswordBloc>().add(
                        ResetPasswordPressed(
                          widget.phone,
                          passController.text,
                          confirmController.text,
                        ),
                      );
                    },
                    child: state is ResetPasswordLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Reset Password"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
