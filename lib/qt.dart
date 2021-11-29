import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'src/widgets.dart';
import 'main.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ml/text_dector_view.dart';


class qtPage extends StatefulWidget {
  const qtPage({Key? key, required this.addMessage, required this.messages})
      : super(key: key);

  final FutureOr<void> Function(String message) addMessage;
  final List<GuestBookMessage> messages;

  @override
  _qtPageState createState() => _qtPageState();
}

class _qtPageState extends State<qtPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();
  final Stream<QuerySnapshot> _productStream =
      FirebaseFirestore.instance.collection('guestBook').snapshots();



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Chat'),
              elevation:
                  Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(children: [
                    for (var message in widget.messages)
                      message.userId == FirebaseAuth.instance.currentUser!.uid
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 10),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(message.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6)),
                                      const SizedBox(height: 5),
                                      Card(
                                        margin: const EdgeInsets.only(left: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        elevation: 10,
                                        clipBehavior: Clip.antiAlias,
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Text(message.message),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 5.0, left: 15),
                                  child: CircleAvatar(
                                      child: Text(message.name[0])),
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 15.0, left: 5),
                                  child: CircleAvatar(
                                      child: Text(message.name[0])),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(message.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6)),
                                      const SizedBox(height: 5),
                                      Card(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        elevation: 10,
                                        clipBehavior: Clip.antiAlias,
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Text(message.message),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                  ]),
                ),
                const SizedBox(height: 8),
                const Divider(
                  height: 8,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                          ),
                            onPressed: ()  {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TextDetectorView(addMessage: (message) =>
                                          widget.addMessage(
                                              message),)));
                            }),
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: 'Leave a message',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your message to continue';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        StyledButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await widget.addMessage(_controller.text);
                              _controller.clear();
                            }
                          },
                          child: Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        });
  }
}
