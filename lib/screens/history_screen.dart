import 'package:flutter/material.dart';
import 'package:my_pa/provider/db_provider.dart';
import 'package:my_pa/widgets/response_item.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
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
