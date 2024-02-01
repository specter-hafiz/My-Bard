import 'package:flutter/material.dart';
import 'package:my_pa/provider/db_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.content,
    required this.id,
    required this.question,
  });
  final String content;
  final String id;
  final String question;

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
        appBar: AppBar(title: const Text("Edit Response"), actions: [
          IconButton(
            onPressed: () async {
              if (widget.content == controller.text) {
                Navigator.of(context).pop();
                return;
              }
              await Future.value(Provider.of<DBProvider>(context, listen: false)
                      .editResponse(widget.id, controller.text))
                  .then((_) {
                Navigator.of(context).pop();
              });
            },
            icon: const Icon(Icons.check_outlined),
          ),
          IconButton(
            onPressed: () async {
              await Share.share(controller.text);
            },
            icon: const Icon(Icons.share_outlined),
          ),
        ]),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.tealAccent,
                child: Text("Question:\n${widget.question}"),
              ),
              Container(color: Colors.amber, child: const Text("Response:")),
              TextField(
                maxLines: null,
                controller: controller,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ],
          ),
        ));
  }
}
