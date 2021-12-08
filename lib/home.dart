import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handong_chapel_app/qt.dart';
import 'package:provider/provider.dart';
import 'src/authentication.dart';
import 'package:lottie/lottie.dart';
import 'qna.dart';
import 'main.dart';
import 'message.dart';
import 'maps.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _userStream =
  FirebaseFirestore.instance.collection('guestBook').snapshots();
  var login;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String url = "";

  Future<UserCredential> googleSingIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult = await _auth.signInWithCredential(credential);
    final user = authResult.user;

    setState(() {
      url = user!.photoURL.toString();
    });

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void googleSignOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _userStream,
        builder: (context, snapshot) {
          return Consumer<ApplicationState>(
            builder: (context, appState, _) => appState.loginState !=
                ApplicationLoginState.loggedIn
                ? Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    child: ClipOval(
                        clipper: MyClipper(),
                        child: Lottie.asset(
                          'assets/church.json',
                          fit: BoxFit.fill,
                        )),
                  ),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        googleSingIn();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 30,
                          child: Text('Login')),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF4A90E2),
                          padding: EdgeInsets.all(10),
                          textStyle: TextStyle(
                              fontSize: 20, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )
                : Scaffold(
              bottomNavigationBar: BottomAppBar(
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.question_answer),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Consumer<ApplicationState>(
                                          builder: (context, appState,
                                              snapshot) =>
                                              qtPage(
                                                addMessage: (message) =>
                                                    appState
                                                        .addMessageToGuestBook(
                                                        message),
                                                messages: appState
                                                    .guestBookMessages,
                                              ))));
                        }),
                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.audiotrack),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Consumer<ApplicationState>(
                              builder: (context, appState,
                                  snapshot) =>
                                  messagePage(
                                    messageOfTheDay: appState
                                        .messageOfTheDay,
                                  ))));
                        }),

                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.wb_incandescent),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Consumer<
                                      ApplicationState>(
                                      builder: (context, appState,
                                          snapshot) =>
                                          QnAPage(
                                            addQuestionToQuestionBook:
                                                (question) => appState
                                                .addQuestionToQuestionBook(
                                                question),
                                            answerQuestion: (documentId,
                                                answer) =>
                                                appState.answerQuestion(
                                                    documentId, answer),
                                            questions:
                                            appState.questionsItem,
                                            pastors: appState.pastorItem,
                                          ))));
                        }),
                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.map),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Consumer<
                                      ApplicationState>(
                                      builder: (context, appState,
                                          snapshot) =>
                                      googleMapsPage(
                                            addLocation:
                                                (locationId, latitude, longitude, geopoint) => appState
                                                .addLocations( locationId, latitude, longitude, geopoint),
                                            locations:
                                            appState.locationsItem,
                                          ))));
                        }),
                  ],
                ),
              ),
              body: LayoutBuilder(
                builder: (context, constraints) => ListView(
                  children: [

                    const SizedBox(height: 50),
                    Center(
                        child: Text(
                            'Welcome ' +
                                FirebaseAuth
                                    .instance.currentUser!.displayName
                                    .toString(),
                            style: TextStyle(fontSize: 20))),
                    const SizedBox(height: 50),

                    if (url == "" || url == null)
                      Container()
                    else
                      AspectRatio(
                          aspectRatio: 19 / 4, child: Image.network(url)),
                    const SizedBox(height: 50),

                    const Divider(
                      height: 50,
                      thickness: 1,
                      indent: 8,
                      endIndent: 8,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 50),
                    Container(
                        alignment: Alignment.center,
                        child: const Text(
                            'Visit our websites!',
                            style: TextStyle(
                              fontSize: 20,
                            ))),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              child: GestureDetector(
                                onTap: () async {
                                  const _url =
                                      'https://church.handong.edu';
                                  if (await canLaunch(_url)) {
                                    await launch(_url);
                                  } else {
                                    throw 'Could not launch $_url';
                                  }
                                },
                                child: Image.asset(
                                  "assets/1.png",
                                  fit: BoxFit.fitHeight,
                                ),
                                // child: Image.network(
                                //     'http://m.church.handong.edu/user/saveDir/board/www63/124_1539403179_0.jpg',
                                //     fit: BoxFit.fitHeight),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: const Text('한동대학교',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ))),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              child: GestureDetector(
                                onTap: () async {
                                  const _url =
                                      'https://www.handonginternationalcongregation.com';
                                  if (await canLaunch(_url)) {
                                    await launch(_url);
                                  } else {
                                    throw 'Could not launch $_url';
                                  }
                                },
                                child: Image.asset(
                                  "assets/2.png",
                                  fit: BoxFit.fitHeight,
                                ),
                                // child: Image.network(
                                //     'https://scontent.ficn4-1.fna.fbcdn.net/v/t31.18172-8/12771894_585494918264191_6301636233324504744_o.jpg?_nc_cat=101&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=c9eH0vtqVGwAX_yt3hz&_nc_ht=scontent.ficn4-1.fna&oh=d3a86ac401bfb094dbec1df419c7b05e&oe=61BF6A08',
                                //     fit: BoxFit.fitHeight),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: const Text('HIC',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ))),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Center(

                      child: Container(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            googleSignOut();
                          },
                          child: Text('Logout'),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF4A90E2),
                              padding: EdgeInsets.all(10),
                              textStyle: TextStyle(
                                  fontSize: 20, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

String simpleTypePromotion(String? nullableString) {
  if (nullableString == null) return "this variable is null";
  return nullableString; // 가능!
}
class MyClipper extends CustomClipper<Rect> {
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, 300, 220);
  }

  bool shouldReclip(oldClipper) {
    return false;
  }
}
