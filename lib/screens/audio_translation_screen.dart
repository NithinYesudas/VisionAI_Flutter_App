import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:vision_ai/screens/video_screen.dart';
import 'package:vision_ai/services/data_services.dart';
import 'package:vision_ai/services/translation_services.dart';
import 'package:vision_ai/utils/custom_colors.dart';

class AudioTranslationScreen extends StatefulWidget {
  AudioTranslationScreen({super.key});

  static String routeName = "audio_translation_screen";

  @override
  State<AudioTranslationScreen> createState() => _AudioTranslationScreenState();
}

class _AudioTranslationScreenState extends State<AudioTranslationScreen> with TickerProviderStateMixin {
  String _value = "ml";

  XFile? videoFile;
  bool _isLoading = false;
  bool _isSuccess = false;
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
                Navigator.of(context).pop();
              },
              icon: Icon(
                Ionicons.close_circle_outline,
                color: Colors.black,
                size: mediaQuery.width * .08,
              )),
          title: Text(
            "Audio Translator",
            style: GoogleFonts.nunitoSans(
                color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
          height: mediaQuery.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                CustomColors.lightAccent.withOpacity(.25),
                Colors.white
              ])),
          child: _isSuccess
              ? Align(
            alignment: Alignment.center,
            child: Lottie.asset("assets/lottie/translate.json",
                width: mediaQuery.width,
                height: mediaQuery.height * .4,
                fit: BoxFit.cover,
                controller: controller, onLoaded: (composition) {
                  controller
                    ..duration = composition.duration
                    ..forward();
                }),
          )
              : Column(children: [
            SizedBox(
              height: mediaQuery.height * .2,
            ),
            SizedBox(
                height: mediaQuery.height * .15,
                child: Image.asset(
                  "assets/images/audio.png",
                  fit: BoxFit.fitHeight,
                )),
            SizedBox(
              height: mediaQuery.height * .05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .05),
              child: Text(
                "Seamless Communication: Your Essential Audio Translator App.",
                style: GoogleFonts.nunitoSans(
                    fontSize: mediaQuery.width * .04,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: mediaQuery.height * .05,
            ),
            InkWell(
              onTap: () async {
                videoFile =
                    await ImagePicker().pickVideo(source: ImageSource.gallery);
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.grey[200],
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: mediaQuery.height * .03,
                        horizontal: mediaQuery.width * .15),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/video.png",
                          height: mediaQuery.height * .1,
                          width: mediaQuery.width * .25,
                        ),
                        SizedBox(
                          height: mediaQuery.height * .02,
                        ),
                        Text(
                          "Select Video",
                          style: GoogleFonts.nunitoSans(
                              fontSize: mediaQuery.width * .045,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.height * .025,
                  horizontal: mediaQuery.width * .1),
              child: FutureBuilder(
                  future: DataServices().getLanguages(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      final languages = snapshot.data;

                      return DropdownButtonFormField(
                        style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: mediaQuery.width * .04),
                        decoration: InputDecoration(
                            floatingLabelStyle: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 5),
                            prefixIcon: const Icon(
                              Ionicons.language_sharp,
                              color: CustomColors.primaryColor,
                            ),
                            hintText: "Language",
                            hintStyle: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none)),
                        value: _value,
                        items: [
                          ...?languages
                              ?.map((e) => DropdownMenuItem(
                                    value: e["id"] as String,
                                    child: Text(e["name"]),
                                  ))
                              .toList()
                        ],
                        onChanged: (value) {
                          _value = value!;
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
            SizedBox(
              height: mediaQuery.height * .025,
            ),
            ElevatedButton(
              onPressed: () async {
                if(videoFile==null){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a video"),backgroundColor: Colors.red,));
                  return;
                }
                setState(() {
                  _isLoading = true;
                });
                final result = await TranslationServices()
                    .getTranslatedAudio(videoFile!.path, _value);
                if (result != null) {
                  setState(() {
                    _isLoading = false;
                    _isSuccess = true;
                  });
                  await Future.delayed(const Duration(seconds: 1,milliseconds: 500));
                  nextPage(result);
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
              child:_isLoading?const CircularProgressIndicator(strokeWidth: 2,color: Colors.white,): Text(
                "Translate Audio",
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600,
                    fontSize: mediaQuery.width * .05),
              ),
            ),
          ]),
        ));
  }

  void nextPage(String path) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VideoPlayerWidget(
                  videoPath: path,
                )));
  }
}
