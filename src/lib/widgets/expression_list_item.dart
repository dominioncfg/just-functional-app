import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../pages/pages.dart';
import '../providers/expressions.dart';

class ExpressionListItem extends StatelessWidget {
  final Expression expression;
  ExpressionListItem({required this.expression})
      : super(key: Key(expression.id.toString()));

  Future<void> _removeItem(BuildContext context) async {
    var expressionsData = Provider.of<Expressions>(context, listen: false);
    await expressionsData.deleteById(expression.id);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(expression.id.toString()),
      direction: DismissDirection.endToStart,
      background: Card(
        color: Theme.of(context).errorColor,
        elevation: 3,
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 8,
        ),
        child: Container(
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          padding: const EdgeInsets.only(right: 20),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text(
              'Do you want to remove the expression?',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        await _removeItem(context);
      },
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(ExpressionDetailsPage.route, arguments: expression.id),
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 8,
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  expression.initials,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
            title: Text(
              expression.name,
              style: Theme.of(context).textTheme.headline6,
            ),
            subtitle: Text(
              '$expression',
            ),
          ),
        ),
      ),
    );
  }
}
