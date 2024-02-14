import 'package:flutter/material.dart';

import 'package:my_pa/provider/db_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.content,
    required this.id,
  });
  final String content;
  final String id;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
    controller.text = widget.content;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            title: const Text("Edit Response"),
            actions: [
              IconButton(
                onPressed: () async {
                  if (widget.content == controller.text) {
                    Navigator.of(context).pop();
                    return;
                  }
                  if (controller.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("You can't save an empty text")));
                    return;
                  }
                  await Future.value(
                          Provider.of<DBProvider>(context, listen: false)
                              .editResponse(widget.id, controller.text))
                      .then((_) {
                    Navigator.of(context).pop();
                  });
                },
                icon: const Icon(Icons.check_outlined),
              ),
              IconButton(
                onPressed: () async {
                  controller.text.isEmpty
                      ? null
                      : await Share.share(controller.text);
                  ;
                },
                icon: const Icon(Icons.share_outlined),
              ),
            ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: null,
              controller: controller,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 18),
            ),
          ),
        ));
  }
}
