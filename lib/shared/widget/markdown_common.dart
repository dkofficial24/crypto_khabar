import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownView extends StatelessWidget {
  final String data;
  final ScrollController controller;

  const MarkdownView(this.data, this.controller);

  @override
  Widget build(BuildContext context) {
    return Markdown(
      controller: controller,
      data: data,
      styleSheet: MarkdownStyleSheet(p: GoogleFonts.hind(fontSize: 16)),
      shrinkWrap: true,
      onTapLink: (txt, href, title) {
        try {
          launch(href);
        } catch (e) {
          print("$e");
        }
      },
      imageBuilder: (Uri uri, String title, String alt) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.ImagePreviewer,
                arguments: uri.toString() ?? '');
          },
          child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  uri.toString() ?? '',
                  fit: BoxFit.fitWidth,
                  errorBuilder: (ctx, obj, stack) {
                    return Container(
                        child: Image.asset(
                      "assets/images/placeholder.png",
                      fit: BoxFit.fitWidth,
                    ));
                  },
                ),
              )),
        );
      },
    );
  }
}
