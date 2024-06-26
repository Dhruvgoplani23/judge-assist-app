import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';
import '../../../data/models/Judge.dart';
import '../../../domain/entities/Event.dart';
import '../../providers/event_provider.dart';

class AddJudge extends StatefulWidget {
  final Event event;
  const AddJudge({super.key, required this.event});

  @override
  State<AddJudge> createState() => _AddJudgeState();
}

class _AddJudgeState extends State<AddJudge> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double sh = MediaQuery.of(context).size.height;
    double sw = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Judge",
            style: kTitle,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: sh * 0.5,
              width: sw * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: const Color(0xFF1D1D2F),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: sw * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.pending_outlined,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: EdgeInsets.zero,
                        labelText: "Judge Name",
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: sw * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.pending_outlined,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: EdgeInsets.zero,
                        labelText: "Judge Email",
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: sh * 0.05,
                    width: sw * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.pink,
                    ),
                    child: TextButton(
                      onPressed: () async {
                        Judge judge = Judge(nameController.text,
                            emailController.text, widget.event.id);
                        Judge addedJuge = await Provider.of<EventListModel>(
                          context,
                          listen: false,
                        ).addJudge(judge);

                        // Show the alert dialog with the generated password
                        bool flag = false;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFF1D1D2F),
                              title: const Text('Password'),
                              content: Row(
                                children: [
                                  Text(
                                    'ID : ${addedJuge.id}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'password : ${addedJuge.password}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      flag = true;
                                    });

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );

                        // Close the screen after adding the judge
                        // if(flag){
                        //   Navigator.pop(context);
                        // }
                        //
                      },
                      child: Text(
                        "Add",
                        style: kButtonStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
