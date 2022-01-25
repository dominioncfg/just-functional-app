import 'package:flutter/material.dart';

import 'pages.dart';
import '../widgets/widgets.dart';

class ExpressionListPage extends StatelessWidget {
  static const route = "/";
  final String title;
  const ExpressionListPage({Key? key, required this.title}) : super(key: key);

  void _showCreateExpression(BuildContext ctx) async {
    await Navigator.of(ctx).pushNamed(ExpressionEditPage.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Column(
          children: const [
            Expanded(
              child: ExpressionList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateExpression(context),
        tooltip: 'Create Expression',
        child: const Icon(Icons.add),
      ),
    );
  }
}
