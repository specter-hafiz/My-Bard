import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.content,
  });
  final String content;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller = TextEditingController();
    controller.text = widget.content;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.save),
        ),
        appBar: AppBar(
          title: const Text("Edit Response"),
        ),
        body: TextField(
          maxLines: null,
          controller: controller,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
        ));
  }
}
