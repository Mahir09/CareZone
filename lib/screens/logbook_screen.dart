import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/logbook_provider.dart';
import '../widgets/log_item.dart';

class LogbookScreen extends StatefulWidget {
  static const routeName = '/logbook';

  @override
  _LogbookScreenState createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen> {
  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() => _isLoading = true);
      await Provider.of<LogBookProvider>(context, listen: false)
          .fetchAndSetLogItems();
      setState(() => _isLoading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logs = Provider.of<LogBookProvider>(context);
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (ctx, i) => LogItem(
                  logs.items[i].id, logs.items[i].title, logs.items[i].day),
              itemCount: logs.medCount,
            ),
    );
  }
}
