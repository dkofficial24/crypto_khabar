import 'package:crypto_khabar/profile/feedback_info.dart';
import 'package:crypto_khabar/profile/provider/profile_setting_provider.dart';
import 'package:crypto_khabar/shared/widget/view_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  ProfileSettingProvider provider;
  TextEditingController nameController = TextEditingController();
  //TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final key = GlobalKey<FormState>();
  bool shouldShowFeedback;

  @override
  void initState() {
    provider = ProfileSettingProvider();
    provider.getUserDetails().then((feedback) {
      setState(() {
        provider.previousFeedback = feedback;
      });
      loadStatus(feedback);
    }).onError((error, stackTrace) {
      setState(() {
        shouldShowFeedback = true;
      });
    });
    super.initState();
  }

  loadStatus(FeedbackInfo info){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(info.date);
    DateTime current = DateTime.now();
    int daysDiff = current.difference(dateTime).inDays;
    shouldShowFeedback = daysDiff>15;
    setState(() {

    });
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
     // emailController.text = provider.previousFeedback.email;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("फीडबैक"),
        ),
        body: mainWidget());
  }

  Widget mainWidget(){
    if(shouldShowFeedback == null){
      return Center(
          child:Text("Please wait..")
      );
    }
    if(shouldShowFeedback){
      return SingleChildScrollView(
        child: Form(
          key: key,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "क्रिप्टो खबर ऐप्प को बेहतर बनाने के लिए सुझाव दें",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                buildTextFormField("रिव्यु", messageController, 5,
                        (value) {
                      if (value == null || value.isEmpty) {
                        return "कृप्या रिव्यु लिखें";
                      } else {
                        return null;
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                ratingWidget(),
                SizedBox(height: 44,),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 50)),
                    child: Text("भेजे"),
                    onPressed: () async{
                      if (key.currentState.validate()) {
                        FeedbackInfo feedback = FeedbackInfo(
                            name:"User",
                            email:"",
                            review: messageController.text,
                            rating: provider.rating,
                            date: DateTime.now().millisecondsSinceEpoch
                        );
                        await provider.shareFeedback(feedback).then((value) {
                          if(mounted)
                          setState(() {
                            shouldShowFeedback = false;
                          });
                        });

                        FirebaseAnalytics.instance.logEvent(name: "feedback_shared");

                        if(provider.rating >=4){
                          showActionDialog(
                            context,title: "रेटिंग",
                            content: "कृपया क्रिप्टो खबर को प्ले स्टोर पर रेटिंग दें ",
                            positiveTextButton: "अभी",
                            negativeTextButton: "बाद में",
                            positiveAction: (){
                              try {
                                launch(
                                    "https://play.google.com/store/apps/details?id=com.edgetechapps.crypto_khabar");
                                Navigator.pop(context);
                                FirebaseAnalytics.instance.logEvent(name: "rating_dialog");
                              }catch(e){}
                            },
                          );
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("आपने फ़ीडबैक सबमिट कर दिया है,धन्यवाद",style:TextStyle(fontSize: 16),),
        ],
      ),
    );

  }

  Widget ratingWidget() {

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
