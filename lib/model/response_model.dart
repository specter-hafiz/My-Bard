class Response {
  final String id;
  final String content;
  final String date;
  final String question;

  Response({
    required this.id,
    required this.content,
    required this.date,
    required this.question,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "date": date,
      "question": question,
    };
  }
}
