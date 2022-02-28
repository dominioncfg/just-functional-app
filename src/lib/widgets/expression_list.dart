import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import '../providers/providers.dart';

class ExpressionList extends StatelessWidget {
  const ExpressionList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Expressions>(context, listen: false)
          .fetchAndSetExistingExpression(),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<Expressions>(builder: (_, expressionsData, __) {
                  final expressions = expressionsData.expressions;
                  return expressions.isNotEmpty
                      ? ListView.builder(
                          itemBuilder: (ctx, ind) {
                            var expression = expressions[ind];
                            return ExpressionListItem(
                              expression: expression,
                            );
                          },
                          itemCount: expressions.length,
                        )
                      : const _EmptyExpressionList();
                }),
    );
  }
}

class _EmptyExpressionList extends StatelessWidget {
  const _EmptyExpressionList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Welcome to'),
          Text(
            'Just Functional',
            style: Theme.of(context).textTheme.headline5,
          ),
          const Text('create an expression to start!')
        ],
      ),
    );
  }
}
