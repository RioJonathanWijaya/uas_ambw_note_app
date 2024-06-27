import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/boxes.dart';
import 'package:note_app/model/pin.dart';
import 'package:note_app/note.dart';

class pinView extends StatelessWidget {
  const pinView({super.key});

  void addPin(String pin) {
    pinbox.put('pin', pin);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController pinController = TextEditingController();
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Input PIN",
                style: GoogleFonts.montserrat(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "If you don't have PIN, automatically create a new pin!",
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: pinController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'PIN',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    final pin = pinController.text;
                    if (pinbox.isEmpty) {
                      print("masuk empty");
                      addPin(pin);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Success"),
                              content: const Text("New Pin Added!"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const notesView()));
                                    },
                                    child: const Text("Next"))
                              ],
                            );
                          });
                    } else {
                      print("masuk sini");
                      print(pinbox.get('pin'));
                      print(pinbox.get('pin').runtimeType);
                      if (pin == pinbox.get('pin')) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const notesView()));
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Invalid PIN"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Close"))
                                ],
                              );
                            });
                      }
                    }
                  },
                  child: Text(
                    'Enter',
                    style: GoogleFonts.montserrat(
                        color: Color(0xFF379777), fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF4CE14)))
            ],
          ),
        ),
      ),
    );
  }
}
