import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:vision_ai/component_widgets/home_screen_buttons.dart';
import 'package:vision_ai/helpers/custom_route_animation.dart';
import 'package:vision_ai/screens/audio_translation_screen.dart';
import 'package:vision_ai/screens/hashtag_description_screen.dart';
import 'package:vision_ai/screens/script_generator_screen.dart';
import 'package:vision_ai/services/data_services.dart';
import 'package:vision_ai/utils/custom_colors.dart';

import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Ionicons.log_out_outline,color: CustomColors.primaryColor,),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text(
                        "Are you sure you want to logout?",
                        style: GoogleFonts.nunitoSans(),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "No",
                              style:
                              GoogleFonts.nunitoSans(color: Colors.green),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Provider.of<AuthProvider>(context, listen: false)
                                  .logout();
                            },
                            child: Text(
                              "Yes",
                              style: GoogleFonts.nunitoSans(color: Colors.red),
                            )),

                      ],
                    );
                  });
            },
          )
        ],
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: mediaQuery.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/home.png"),
          fit: BoxFit.cover,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: mediaQuery.height * .3,
              child: Lottie.asset("assets/lottie/ai.json"),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: mediaQuery.width * .1),
              child: Text(
                "Welcome to Vision-AI.!",
                style: GoogleFonts.nunitoSans(
                    fontSize: mediaQuery.width * .06,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            Expanded(
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width * .05,
                    vertical: mediaQuery.height * .05),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: mediaQuery.height * .015,
                    mainAxisExtent: mediaQuery.height * .27,
                    crossAxisSpacing: mediaQuery.width * .03,
                    crossAxisCount: 2),
                children: [
                  HomeScreenButton(
                      imageUrl: "audio.png",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AudioTranslationScreen.routeName);
                      },
                      title: "Audio Translator"),
                  HomeScreenButton(
                      imageUrl: "hash.png",
                      onPressed: () {
                        Navigator.push(
                            context,
                            SlidePageRoute(
                                page: HashTagDescriptionScreen(
                              onPressed: (title) async {
                                try {
                                  final result =
                                      await DataServices().getHashTags(title);
                                  return result;
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())));
                                }
                              },
                              title: "Hashtag ",
                              imageUrl: 'hash.png',
                              text:
                                  'Unleash Trending Tags: AI-Powered Hashtag Generator for Maximum Visibility.',
                            )));
                      },
                      title: "Hashtag Generator"),
                  HomeScreenButton(
                      imageUrl: "script.png",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, ScriptGenerationScreen.routeName);
                      },
                      title: "Script Generator"),
                  HomeScreenButton(
                      imageUrl: "desc.png",
                      onPressed: () {
                        Navigator.push(
                            context,
                            SlidePageRoute(
                                page: HashTagDescriptionScreen(
                              onPressed: (title) async {
                                try {
                                  final result = await DataServices()
                                      .getDescription(title);
                                  return result;
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())));
                                }
                              },
                              title: "Description ",
                              imageUrl: 'desc.png',
                              text:
                                  'Elevate Your Content: AI-Driven Description Generator for Captivating Descriptions.',
                            )));
                      },
                      title: "Description \nGenerator"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
