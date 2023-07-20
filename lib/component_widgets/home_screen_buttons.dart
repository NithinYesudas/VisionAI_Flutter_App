import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenButton extends StatelessWidget {
  HomeScreenButton(
      {required this.imageUrl,
      required this.onPressed,
      required this.title,
      super.key});

  final String imageUrl, title;
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: mediaQuery.height*.1,
              child: Image.asset("assets/images/$imageUrl",fit: BoxFit.cover,
                  ),
            ),
            SizedBox(
              height: mediaQuery.height * .02,
            ),
            Text(title,
                style: GoogleFonts.nunitoSans(
                    fontSize: mediaQuery.width * .04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))
          ],
        ),
      ),
    );
  }
}
