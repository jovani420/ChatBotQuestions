class ModelMessage {
   bool isPrompt = false;
   String message = '';
  final DateTime time;
  

  ModelMessage({
    required this.isPrompt,
    required this.message,
    required this.time,
  });
}
