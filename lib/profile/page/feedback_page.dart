import 'package:crypto_khabar/profile/feedback_info.dart';
import 'package:crypto_khabar/profile/provider/profile_setting_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  ProfileSettingProvider provider;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    provider = ProfileSettingProvider();
    provider.getUserDetails().then((feedback) {
      setState(() {
        provider.previousFeedback = feedback;
      });
    });
    super.initState();
  }

  bool isValidEmail(email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    if(provider.previousFeedback != null){
      nameController.text = provider.previousFeedback?.name ?? "";
      emailController.text = provider.previousFeedback.email;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("फीडबैक"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: key,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Text(
                    "अपने सुझाव हमारे साथ शेयर करे",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  buildTextFormField('नाम', nameController, 1, null),
                  buildTextFormField("ईमेल", emailController, 1, (value) {
                    if (value == null || value.isEmpty) {
                      return "कृपया ईमेल डालें ";
                    } else {
                      bool isvalid = isValidEmail(emailController.text);
                      if (isvalid) {
                        return null;
                      } else {
                        return "सही ईमेल डालें";
                      }
                    }
                  }),
                  buildTextFormField("रिव्यु", messageController, 5,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return "कृपया रिव्यु लिखें";
                    } else {
                      return null;
                    }
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  ratingWidget(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50)),
                    child: Text("भेजे"),
                    onPressed: () {
                      if (key.currentState.validate()) {
                        FeedbackInfo feedback = FeedbackInfo(
                          name:nameController.text,
                          email:emailController.text,
                          review: messageController.text,
                          rating: provider.rating
                        );
                        provider.shareFeedback(feedback);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget ratingWidget() {
    if(provider.previousFeedback == null || provider.previousFeedback.rating != -1){
      return Container();
    }
    return Column(
                  children: [
                    RatingBar.builder(
                      initialRating: 5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        provider.rating = rating;
                      },
                    ),SizedBox(
                      height: 20,
                    ),
                  ],
                );
  }

  Widget buildTextFormField(text, controller, int maxLine, validate) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          child: TextFormField(
            validator: validate,
            maxLines: maxLine,
            controller: controller,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
