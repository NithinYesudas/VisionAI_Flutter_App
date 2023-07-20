import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/custom_colors.dart';
class ContentDisplayScreen extends StatelessWidget {
  const ContentDisplayScreen({super.key, required this.title, required this.imageUrl, required this.text});
final String title, imageUrl, text;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return  Scaffold(
    extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            icon: Icon(
              Ionicons.close_circle_outline,
              color: Colors.black,
              size: mediaQuery.width * .08,
            )),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:  Text("Generated $title",style: GoogleFonts.nunitoSans(
            color: Colors.black, fontWeight: FontWeight.w700
        ),),
      ),
      body:  Container(
        height: mediaQuery.height,
        width: mediaQuery.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  CustomColors.lightAccent.withOpacity(.25),
                  Colors.white
                ])),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: mediaQuery.height * .15,
              ),
              SizedBox(
                height: mediaQuery.height * .2,
                width: mediaQuery.width * .4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset("assets/images/$imageUrl",
                      fit: BoxFit.fitHeight),
                ),
              ),
              SizedBox(height: mediaQuery.height * .02,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("You can click on the copy icon to copy the text to your clipboard",style: GoogleFonts.nunitoSans(
                    color: Colors.black, fontWeight: FontWeight.w500,fontSize: mediaQuery.width*.045
                ),),
              ),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                margin: EdgeInsets.symmetric(horizontal: mediaQuery.width*.05,vertical: mediaQuery.height*.02),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Copy Text: ",style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600,fontSize: mediaQuery.width*.04),),
                          IconButton(onPressed: ()async{
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Text Copied"),backgroundColor: Colors.green,));
                            await Clipboard.setData(ClipboardData(text: text));

                          }, icon: const Icon(Icons.copy_rounded,color: CustomColors.primaryColor,)),
                        ],
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: mediaQuery.width*.05,vertical: mediaQuery.height*.02),
                        child: SelectableText(text,style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600,fontSize: mediaQuery.width*.04),),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
