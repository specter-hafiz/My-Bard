import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_pa/provider/db_provider.dart';
import 'package:my_pa/screens/detail_screen.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> historyResponse = [];

  @override
  Widget build(BuildContext context) {
    {
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: const Text("History"),
        ),
        body: FutureBuilder(
            future: Provider.of<DBProvider>(context).responsesList(),
            builder: (context, snapshot) {
              final responses = snapshot.data;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: responses!.length,
                    itemBuilder: (context, index) {
                      return ResponseItem(
                        id: responses[index].id,
                        content: responses[index].content,
                        question: responses[index].question,
                        date: responses[index].date,
                      );
                    });
              }

              return Center(
                child: Text(
                  "No response(s) added yet!\nTap 🤍 on any generated response to add!",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              );
            }),
      );
    }
  }
}

class ResponseItem extends StatelessWidget {
  const ResponseItem({
    super.key,
    required this.id,
    required this.content,
    required this.question,
    required this.date,
  });

  final String id;
  final String content;
  final String question;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                id: id,
                content: content,
                question: question,
              ),
            ),
          );
        },
        isThreeLine: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                question,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: IconButton(
                  onPressed: () {
                    Provider.of<DBProvider>(context, listen: false)
                        .deleteResponse(id);
                  },
                  icon: const Icon(Icons.delete_outlined)),
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(DateFormat.yMEd().format(DateTime.parse(date))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
