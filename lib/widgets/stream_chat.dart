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
  String? searchedText;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);
  final List<Content> chats = [];
  final List<String?> questions = [];

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
                        itemBuilder: (context, index) {
                          return ChatItemWidget(
                            content: chats[index],
                            // question: questions[index]!,
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: chats.length,
                        reverse: false,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      "Enter your search item below !",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
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
              //questions.add(searchedText!);

              controller.clear();
              loading = true;

              try {
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
                              role: "model",
                              parts: [Parts(text: value.output)]));
                        }
                      });
                    },
                    cancelOnError: true,
                    onError: (err) {
                      if (chats.isNotEmpty) {
                        chats.removeLast();
                        // questions.removeLast();
                      }
                      loading = false;
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(const Duration(seconds: 2),
                                () => Navigator.of(context).pop());
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 5,
                              title: Text(
                                "Sorry, an error ocurred!",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                              ),
                            );
                          });
                    });
              } catch (e) {
                debugPrint("ERR:${e.toString()}");
              }
            }
          },
        )
      ],
    );
  }
}

class ChatItemWidget extends StatefulWidget {
  final Content content;
  //final String question;

  const ChatItemWidget({
    super.key,
    required this.content,
    // required this.question
  });

  @override
  ChatItemWidgetState createState() => ChatItemWidgetState();
}

class ChatItemWidgetState extends State<ChatItemWidget> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.content.role == "model"
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
              color: widget.content.role == "model"
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(12),
                  bottomLeft: widget.content.role == "model"
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: widget.content.role == "model"
                      ? const Radius.circular(12)
                      : const Radius.circular(0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withAlpha(70),
                child: Text(
                  widget.content.role == "model" ? "P.A" : "ME",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                widget.content.parts?.lastOrNull?.text ??
                    "Cannot generate data !",
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w300),
              ),
              if (widget.content.role == "model") const Divider(),
              if (widget.content.role == "model")
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                    onPressed: () async {
                      final response = Response(
                        id: DateTime.now().toString(),
                        content: (widget.content.parts?.lastOrNull?.text)!,
                        date: DateTime.now().toString(),
                      );

                      bool responseExist = await Provider.of<DBProvider>(
                              context,
                              listen: false)
                          .checkResponse(response
                              .content); //this method checks whether the DB already has content of that sort stored
                      if (responseExist) {
                        await Provider.of<DBProvider>(context, listen: false)
                            .removeContent(response
                                .content); //removes content from the DB if it exists
                      } else {
                        await Provider.of<DBProvider>(context, listen: false)
                            .addResponse(
                                response); //it adds content to the DB if it doesn't exist
                      }

                      setState(() {
                        isToggled = !isToggled; // Toggle the favorite button
                      });
                    },
                    icon: Icon(isToggled
                        ? Icons.favorite
                        : Icons.favorite_border), // Use the toggled state
                  ),
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(
                              // use to copy text to clipboard
                              text: (widget.content.parts?.lastOrNull?.text)!))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor:
                              Theme.of(context).snackBarTheme.backgroundColor,
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
