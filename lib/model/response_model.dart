class Response {
  final String id;
  final String content;
  final String date;

  Response({
    required this.id,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "date": date,
    };
  }
}
