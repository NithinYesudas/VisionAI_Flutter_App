import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:vision_ai/providers/auth_provider.dart';
import 'package:vision_ai/screens/signup_screen.dart';
import 'package:vision_ai/services/auth_services.dart';

import '../helpers/auth_validators.dart';
import '../helpers/custom_route_animation.dart';
import '../utils/custom_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              spacer(.125),
              Center(
                child: SizedBox(
                  height: mediaQuery.height * .3,
                  width: mediaQuery.width * .7,
                  child: Image.asset(
                    "assets/images/login.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              spacer(.05),
              Text(
                "Welcome Back.!",
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.width * .06),
              ),
              Text(
                "Login to your account and get started.",
                style: GoogleFonts.nunitoSans(
                    color: CustomColors.primaryColor,
                    fontSize: mediaQuery.width * .04),
              ),
              spacer(.03),
              Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * .05),
                    height: mediaQuery.height * .32,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            return AuthValidators.emailValidator(value!);
                          },
                          style: GoogleFonts.nunitoSans(),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: const Icon(
                                Ionicons.mail_outline,
                                color: CustomColors.primaryColor,
                              ),
                              hintText: "Email",
                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          style: GoogleFonts.nunitoSans(),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            return AuthValidators.passwordValidator(value!);
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 5),
                              prefixIcon: const Icon(
                                Ionicons.lock_closed_outline,
                                color: CustomColors.primaryColor,
                              ),
                              hintText: "Password",
                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: mediaQuery.width * .5),
                          child: Text(
                            "Forgot Password?",
                            textAlign: TextAlign.end,
                            style: GoogleFonts.nunitoSans(
                                color: CustomColors.primaryColor,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              bool? isValid = _formKey.currentState?.validate();
                              if (isValid == true) {
                                bool isSuccessful = await AuthServices.login(
                                    _emailController.text,
                                    _passwordController.text,
                                    context);

                                if (isSuccessful) {
                                  showMessage("Login Successful", Colors.green);
                                  checkAuthState();
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showMessage("unsuccessful", Colors.red);
                                }
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: mediaQuery.width * .125,
                                        vertical: mediaQuery.height * .015)),
                                backgroundColor: MaterialStateProperty.all(
                                    CustomColors.lightAccent)),
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Login",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: mediaQuery.width * .04),
                                  )),
                      ],
                    ),
                  )),
              SizedBox(
                height: mediaQuery.height * .05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.nunitoSans(),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            SlidePageRoute(page: const SignUpScreen()),
                          );
                        },
                        child: Text(
                          "Sign-Up",
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w800,
                              color: CustomColors.lightAccent),
                        ))
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget spacer(double height) => SizedBox(
        height: MediaQuery.of(context).size.height * height,
      );

  void showMessage(String message, Color color) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: color,
      ));

  void checkAuthState() {
    Provider.of<AuthProvider>(context, listen: false).checkAuthState();
  }
}
