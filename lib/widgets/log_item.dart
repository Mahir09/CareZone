import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/providers/logbook_provider.dart';

class LogItem extends StatefulWidget {
  final String id;
  final String title;
  final DateTime day;

  const LogItem(this.id, this.title, this.day);

  @override
  State<LogItem> createState() => _LogItemState();
}

class _LogItemState extends State<LogItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(widget.id),
      onDismissed: (direction) {
        setState(() {
          try {
            Provider.of<LogBookProvider>(context, listen: false)
                .deleteLogItem(widget.id);
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("${widget.title} Removed From Log Book")));
          } catch (error) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Deleting failed'),
              ),
            );
          }
        });
      },
      background: Container(color: Colors.red),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              DateFormat('EEEE').format(widget.day),
              style: TextStyle(fontSize: 12),
            ),
          ), //FIX this
        ),
      ),
    );
  }
}
