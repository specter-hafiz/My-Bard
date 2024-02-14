import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_pa/provider/db_provider.dart';
import 'package:my_pa/screens/detail_screen.dart';
import 'package:provider/provider.dart';

class ResponseItem extends StatelessWidget {
  const ResponseItem({
    super.key,
    required this.id,
    required this.content,
    required this.date,
  });

  final String id;
  final String content;

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
              ),
            ),
          );
        },
        isThreeLine: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
                onPressed: () {
                  Provider.of<DBProvider>(context, listen: false)
                      .removeContent(content);
                },
                icon: const Icon(Icons.delete_outlined))
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(DateFormat.yMEd().format(DateTime.parse(date))),
          ],
        ),
      ),
    );
  }
}
