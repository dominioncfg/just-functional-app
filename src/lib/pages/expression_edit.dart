import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class ExpressionEditPage extends StatelessWidget {
  static const String route = "/edit";
  const ExpressionEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEditing = ModalRoute.of(context)!.settings.arguments != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Expression" : "Create Expression"),
      ),
      body: const SafeArea(
        child: ExpressionEdit(),
      ),
    );
  }
}
