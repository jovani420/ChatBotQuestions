import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gemini_questions/model/model_gemini.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TextEditingController promptController = TextEditingController();
  static const key = 'AIzaSyC4RPeIBPNvemxexH6N8zDHPpP4j6dIxx8';

  final List<ModelMessage> prompt = [];
 
  final model = GenerativeModel(model: "gemini-2.0-flash", apiKey: key);

  Future<void> sendMessage(int count) async {
    final message = promptController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      promptController.clear();
      prompt.add(
        ModelMessage(isPrompt: true, message: message, time: DateTime.now()),
      );
    });

    try {
      final content = [Content.text(message)];
      final response = await model.generateContent(content);
      setState(() {
        prompt.add(
          ModelMessage(
            isPrompt: false,
            message: response.text ?? "Sin respuesta",
            time: DateTime.now(),
          ),
        );
      });
    } catch (e) {
      setState(() {
        prompt.add(
          ModelMessage(
            isPrompt: false,
            message: "Error al procesar la respuesta",
            time: DateTime.now(),
          ),
        );
      });
    }
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          backgroundColor: Colors.blue[100],
          title: const Text("Chat bot AI"),
          centerTitle: true,
          elevation: 9,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: prompt.length,
                itemBuilder: (context, index) {
                  final message = prompt[index];
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(vertical: 15).copyWith(
                      left: message.isPrompt ? 80 : 15,
                      right: message.isPrompt ? 15 : 80,
                    ),
                    decoration: BoxDecoration(
                      color: message.isPrompt ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft:
                            message.isPrompt
                                ? const Radius.circular(20)
                                : Radius.zero,
                        bottomRight:
                            message.isPrompt
                                ? Radius.zero
                                : const Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.message,
                          style: TextStyle(
                            fontWeight:
                                message.isPrompt
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            fontSize: 18,
                            color:
                                message.isPrompt ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat('hh:mm a').format(message.time),
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                message.isPrompt ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 8,
                bottom: 10,
                left: 10,
                top: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: promptController,
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Ingrese su conversación",
                      ),
                      onSubmitted: (_) => sendMessage(count),
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      count++;
                      sendMessage(count);
                    },
                    child: const CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.send, color: Colors.white, size: 29),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
