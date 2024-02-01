import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:lottie/lottie.dart';
import 'package:my_pa/model/response_model.dart';
import 'package:my_pa/provider/db_provider.dart';
import 'package:my_pa/widgets/chat_input_box.dart';
import 'package:provider/provider.dart';

class StreamChat extends StatefulWidget {
  const StreamChat({super.key});

  @override
  State<StreamChat> createState() => _StreamChatState();
}

class _StreamChatState extends State<StreamChat> {
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  bool _loading = false;
  String? searchedText, result;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);
  final List<Content> chats = [];
  String question = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: chats.isNotEmpty
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      reverse: true,
                      child: ListView.builder(
                        itemBuilder: chatItem,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: chats.length,
                        reverse: false,
                      ),
                    ),
                  )
                : const Center(
                    child: Text("Search something !"),
                  )),
        if (loading)
          Align(
              alignment: Alignment.bottomLeft,
              child: Lottie.asset("assets/loading.json", width: 100)),
        ChatInputBox(
          controller: controller,
          onSend: () async {
            if (controller.text.isNotEmpty) {
              searchedText = controller.text;
              chats.add(
                  Content(role: "user", parts: [Parts(text: searchedText)]));

              controller.clear();
              loading = true;
              gemini.streamChat(chats).listen(
                  (value) {
                    loading = false;
                    setState(() {
                      if (chats.isNotEmpty &&
                          (chats.last.role == value.content?.role)) {
                        chats.last.parts?.last.text =
                            "${chats.last.parts?.last.text}${value.output}";
                      } else {
                        chats.add(Content(
                            role: "model", parts: [Parts(text: value.output)]));
                      }
                    });
                  },
                  cancelOnError: true,
                  onError: (err) {
                    loading = false;
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 2),
                              () => Navigator.of(context).pop());
                          return const AlertDialog(
                            title: Text("An error ocurred!"),
                          );
                        });
                  });
            }
          },
        )
      ],
    );
  }

  bool ontap = false;
  Widget chatItem(BuildContext context, int index) {
    final Content content = chats[index];
    return Column(
      crossAxisAlignment: content.role == "model"
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
              color:
                  content.role == "model" ? Colors.blue.shade800 : Colors.green,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(12),
                  bottomLeft: content.role == "model"
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: content.role == "model"
                      ? const Radius.circular(12)
                      : const Radius.circular(0))),
          child: Column(
            crossAxisAlignment: content.role == "model"
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(content.role == "model" ? "P.A" : "ME"),
              Text(
                content.parts?.lastOrNull?.text ?? "Cannot generate data !",
                textAlign: TextAlign.start,
              ),
              if (content.role == "model") const Divider(),
              if (content.role == "model")
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                    onPressed: () async {
                      final response = Response(
                          id: DateTime.now().toString(),
                          content: (content.parts?.lastOrNull?.text)!,
                          date: DateTime.now().toString(),
                          question: question);

                      await Future.value(
                              Provider.of<DBProvider>(context, listen: false)
                                  .addResponse(response))
                          .then((_) {
                        setState(() {
                          if (ontap) {
                            ontap = false;
                          } else {
                            ontap = true;
                          }
                        });
                      });
                    },
                    icon: Icon(ontap
                        ? Icons.favorite_outlined
                        : Icons.favorite_border),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(
                              text: (content.parts?.lastOrNull?.text)!))
                          .then((_) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Text copied"),
                          duration: Duration(
                            milliseconds: 500,
                          ),
                        ));
                      });
                    },
                    icon: const Icon(Icons.copy_outlined),
                  ),
                ])
            ],
          ),
        ),
      ],
    );
  }
}
