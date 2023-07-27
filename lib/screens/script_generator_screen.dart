import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:vision_ai/providers/auth_provider.dart';
import 'package:vision_ai/services/data_services.dart';

import '../helpers/custom_route_animation.dart';
import '../utils/custom_colors.dart';
import 'content_display_screen.dart';

class ScriptGenerationScreen extends StatefulWidget {
  ScriptGenerationScreen({super.key});

  static const routeName = "script_generation_screen";

  @override
  State<ScriptGenerationScreen> createState() => _ScriptGenerationScreenState();
}

class _ScriptGenerationScreenState extends State<ScriptGenerationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();

  int _value = 1;
  bool _isSuccess = false;
  bool _isLoading = false;
  late final AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Ionicons.close_circle_outline,
              color: Colors.black,
              size: mediaQuery.width * .08,
            )),
        title: Text(
          "Script Generator",
          style: GoogleFonts.nunitoSans(
              color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.height,
          width: mediaQuery.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                _isSuccess
                    ? Colors.white
                    : CustomColors.lightAccent.withOpacity(.25),
                Colors.white
              ])),
          child: _isSuccess
              ? Align(
                  alignment: Alignment.center,
                  child: Lottie.asset("assets/lottie/success.json",
                      width: mediaQuery.width,
                      height: mediaQuery.height * .4,
                      fit: BoxFit.cover,
                      controller: controller, onLoaded: (composition) {
                    controller
                      ..duration = composition.duration
                      ..forward();
                  }),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: mediaQuery.height * .2,
                    ),
                    SizedBox(
                      height: mediaQuery.height * .15,
                      child: Image.asset(
                        "assets/images/script.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * .05,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width * .05),
                      child: Text(
                        "Unlock Your Storytelling Potential: AI-Driven Script Generator for Compelling 2 to 3-Minute Scripts..",
                        style: GoogleFonts.nunitoSans(
                            fontSize: mediaQuery.width * .04,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * .05,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * .015,
                          horizontal: mediaQuery.width * .1),
                      child: TextField(
                        controller: _titleController,
                        style: GoogleFonts.nunitoSans(),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 5),
                            prefixIcon: const Icon(
                              Ionicons.text,
                              color: CustomColors.primaryColor,
                            ),
                            hintText: "Title",
                            hintStyle: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                            fillColor: Colors.white,
                            filled: true,
                            helperText: "Enter Video Title",
                            helperStyle: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * .015,
                          horizontal: mediaQuery.width * .1),
                      child: DropdownButtonFormField(
                        style: GoogleFonts.nunitoSans(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                            helperText: "Select Video Duration",
                            helperStyle: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            floatingLabelStyle: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 5),
                            prefixIcon: const Icon(
                              Ionicons.time,
                              color: CustomColors.primaryColor,
                            ),
                            hintText: "Duration",
                            hintStyle: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none)),
                        value: _value,
                        items: const [
                          DropdownMenuItem(
                            value: 1,
                            child: Text("1 Min"),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text("2 Min"),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text("3 Min"),
                          ),
                        ],
                        onChanged: (value) {
                          _value = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * .03,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_titleController.text.isEmpty || _titleController.text.length < 5) {

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Please Enter a valid Title"),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          final result = await DataServices().getScript(
                              _titleController.text, _value.toString());
                          setState(() {
                            _isSuccess = true;
                            _isLoading = false;
                          });
                          await Future.delayed(const Duration(seconds: 2));
                          nextPage(result);
                        }catch(e){
                          ScaffoldMessenger.of(context)
                              .showSnackBar( SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ));

                        }



                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: mediaQuery.height * .02,
                              horizontal: mediaQuery.width * .1),
                          backgroundColor: CustomColors.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              "Generate Script",
                              style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: mediaQuery.width * .05),
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void nextPage(String result) {
    Navigator.push(
        context,
        SlidePageRoute(
            page: ContentDisplayScreen(
              title: "Script",
              text: result,
              imageUrl: "script.png",
            )));
  }
}
