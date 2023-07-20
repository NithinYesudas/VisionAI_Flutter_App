import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:vision_ai/helpers/custom_route_animation.dart';
import 'package:vision_ai/screens/content_display_screen.dart';

import '../utils/custom_colors.dart';

class HashTagDescriptionScreen extends StatefulWidget {
  const HashTagDescriptionScreen(
      {required this.title,
      required this.onPressed,
      required this.imageUrl,
      required this.text,
      super.key});

  static const routeName = "hashtag_description_screen";
  final String title, imageUrl, text;
  final Function onPressed;

  @override
  State<HashTagDescriptionScreen> createState() =>
      _HashTagDescriptionScreenState();
}

class _HashTagDescriptionScreenState extends State<HashTagDescriptionScreen>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
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
          "${widget.title} Generator",
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
              _isSuccess?Colors.white:  CustomColors.lightAccent.withOpacity(.25),
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
                      height: mediaQuery.height * .2,
                      width: mediaQuery.width * .4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset("assets/images/${widget.imageUrl}",
                            fit: BoxFit.fitHeight),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * .05,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width * .05),
                      child: Text(
                        widget.text,
                        style: GoogleFonts.nunitoSans(
                            fontSize: mediaQuery.width * .04,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height * .04,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * .04,
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
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_titleController.text.isEmpty || _titleController.text.length < 5) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Please enter a valid title"),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }
                        setState(() {
                          _isLoading = true;
                        });
                        final result =
                            await widget.onPressed(_titleController.text);
                        setState(() {
                          _isLoading = false;
                          _isSuccess = true;
                        });
                        await Future.delayed(const Duration(seconds: 2));
                        nextPage(result);
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
                              backgroundColor: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              "Generate ${widget.title}",
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
          title: widget.title,
          text: result,
          imageUrl: widget.imageUrl,
        )));
  }
}
