import 'package:crypto_khabar/profile/feedback_info.dart';
import 'package:crypto_khabar/profile/provider/profile_setting_provider.dart';
import 'package:crypto_khabar/shared/widget/view_utils.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
    final dateTime = DateTime.fromMillisecondsSinceEpoch(info.date);
    final current = DateTime.now();
    final daysDiff = current.difference(dateTime).inDays;
    shouldShowFeedback = daysDiff>15;
    setState(() {

    });
  }


  bool isValidEmail(email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',)
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    if(provider.previousFeedback != null){
      nameController.text = provider.previousFeedback?.name ?? '';
     // emailController.text = provider.previousFeedback.email;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(StringConst.feedback),
        ),
        body: mainWidget(),);
  }

  Widget mainWidget(){
    if(shouldShowFeedback == null){
      return const Center(
          child:Text(StringConst.pleaseWait),
      );
    }
    if(shouldShowFeedback){
      return SingleChildScrollView(
        child: Form(
          key: key,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  StringConst.feedbackTitle,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                buildTextFormField(StringConst.feedbackReview, messageController, 5,
                        (value) {
                      if (value == null || value.isEmpty) {
                        return StringConst.writeFeedbackReview;
                      } else {
                        return null;
                      }
                    }),
                const SizedBox(
                  height: 20,
                ),
                Center(child: ratingWidget()),
                const SizedBox(height: 44,),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 50),),
                    child: const Text(StringConst.sendFeedbackReview),
                    onPressed: () async{
                      if (key.currentState.validate()) {
                        final feedback = FeedbackInfo(
                            email:'',
                            review: messageController.text,
                            rating: provider.rating,
                            date: DateTime.now().millisecondsSinceEpoch,
                        );
                        await provider.shareFeedback(feedback).then((value) {
                          if(mounted) {
                            setState(() {
                            shouldShowFeedback = false;
                          });
                          }
                        });

                        await FirebaseAnalytics.instance.logEvent(name: 'feedback_shared');

                        if(provider.rating >=4){
                          showActionDialog(
                            context,title: StringConst.feedbackReviewRating,
                            content: StringConst.askForRatingMsg,
                            positiveTextButton: StringConst.now,
                            negativeTextButton: StringConst.later,
                            positiveAction: (){
                              try {
                                launch(
                                    'https://play.google.com/store/apps/details?id=com.edgetechapps.crypto_khabar',);
                                Navigator.pop(context);
                                FirebaseAnalytics.instance.logEvent(name: 'rating_dialog');
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
        children: const [
          Text(StringConst.feedbackThanksMsg,style:TextStyle(fontSize: 16),),
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
                      allowHalfRating: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        provider.rating = rating;
                      },
                    ),const SizedBox(
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
        const SizedBox(
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
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
